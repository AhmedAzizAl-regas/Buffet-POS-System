import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'arabic_pdf_helper.dart';
import 'package:buffet_app/core/database/database_service.dart';
import 'package:buffet_app/features/order/data/repositories/order_repository.dart';

class PrintHelper {
  /// Generates and prints a beautiful corporate PDF invoice for a single order.
  static Future<void> printSingleOrder({
    required BuildContext context,
    required WidgetRef ref,
    required int orderId,
    required double totalPrice,
    required String customerName,
    required DateTime createdAt,
    required int status,
    required String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final configs = ref.read(configProvider);
    final cafeteriaName = configs['business_name'] ?? (isArabic ? 'كفتيريا البوفيه المميز' : 'Premium Buffet');

    final String docTitle = isArabic ? 'فاتورة طلب' : 'Order Invoice';
    final String printDateStr = _formatDateTime(DateTime.now(), isArabic);
    final String orderDateStr = _formatDateTime(createdAt, isArabic);

    // Helpers to shape and format text according to RTL/LTR
    String text(String input) {
      if (isArabic) {
        return ArabicPdfHelper.shape(input);
      }
      return input;
    }

    try {
      // 1. Load Fonts for rendering
      final fontRegular = pw.Font.ttf(await rootBundle.load("assets/fonts/Tajawal-Regular.ttf"));
      final fontBold = pw.Font.ttf(await rootBundle.load("assets/fonts/Tajawal-Bold.ttf"));

      // 2. Load Logo (with try-catch safety fallback)
      pw.MemoryImage? logoImage;
      try {
        final logoBytes = await rootBundle.load("assets/icons/logo.png");
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {}

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
          build: (pw.Context pdfContext) {
            // Header Row (Logo Left, Cafeteria Info Right)
            final header = pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                if (logoImage != null)
                  pw.Image(logoImage, width: 65, height: 65)
                else
                  pw.SizedBox(width: 65, height: 65),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      text(cafeteriaName),
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 22,
                        color: PdfColor.fromHex('#E65100'),
                      ),
                    ),
                    pw.Text(
                      text(isArabic ? 'تقرير الفاتورة الفردية للطلب' : 'Corporate Individual Invoice'),
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            );

            // Divider Line
            final divider = pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 12),
              height: 3,
              decoration: const pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [PdfColors.orangeAccent, PdfColors.orange800],
                ),
              ),
            );

            // Invoice Title Banner
            final banner = pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#ECEFF1'),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    text('${isArabic ? "رقم الطلب:" : "Order ID:"} #$orderId'),
                    style: pw.TextStyle(font: fontBold, fontSize: 13),
                  ),
                  pw.Text(
                    text(docTitle),
                    style: pw.TextStyle(font: fontBold, fontSize: 16, color: PdfColor.fromHex('#37474F')),
                  ),
                ],
              ),
            );

            // Metadata Blocks (Invoice Details)
            final String customerDisplay = customerName.trim().isEmpty
                ? (isArabic ? 'عميل كاشير' : 'Walk-in Customer')
                : customerName;

            final String statusLabel = status == 1
                ? (isArabic ? 'مكتمل' : 'Served')
                : (isArabic ? 'قيد الانتظار' : 'Pending');

            final metadata = pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 16),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(text('${isArabic ? "تاريخ الطلب:" : "Order Date:"} $orderDateStr'), style: const pw.TextStyle(fontSize: 10)),
                        pw.SizedBox(height: 4),
                        pw.Text(text('${isArabic ? "تاريخ الطباعة:" : "Print Date:"} $printDateStr'), style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.start : pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(text('${isArabic ? "اسم العميل:" : "Customer:"} $customerDisplay'), style: pw.TextStyle(font: fontBold, fontSize: 10)),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          text('${isArabic ? "حالة الدفع:" : "Payment Status:"} $statusLabel'),
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 10,
                            color: status == 1 ? PdfColors.blue800 : PdfColors.orange900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            // Table Headers & Rows
            final headers = isArabic
                ? ['الإجمالي', 'سعر الوحدة', 'الكمية', 'المنتجات']
                : ['Products', 'Qty', 'Unit Price', 'Total'];

            final currencyArRaw = configs['currency_sign_ar'] ?? configs['currency_sign'] ?? 'ريال';
            final currencyEnRaw = configs['currency_sign_en'] ?? 'YR';
            final String currencyAr = currencyArRaw.contains('.svg') ? 'ريال' : currencyArRaw;
            final String currencyEn = currencyEnRaw.contains('.svg') ? 'YR' : currencyEnRaw;
            final String currencySymbol = isArabic ? currencyAr : currencyEn;

            final tableRows = items.map((item) {
              final name = item['name_at_sale'] as String;
              final qty = item['quantity'] as int;
              // Extract the unit price at sale (price_at_sale)
              final unitPrice = (item['price_at_sale'] as num?)?.toDouble() ?? 0.0;
              
              // Extract additions and sum their prices for row total
              final List<dynamic> addons = item['addons'] as List<dynamic>? ?? [];
              double addonsTotal = 0.0;
              final List<String> productCellLines = [];
              
              productCellLines.add(name);
              
              for (var add in addons) {
                final String addName = add['name_at_sale'] as String;
                final double addPrice = (add['price_at_sale'] as num?)?.toDouble() ?? 0.0;
                addonsTotal += addPrice;
                
                productCellLines.add(
                  isArabic
                      ? '   + $addName (${_formatAmount(addPrice)} $currencySymbol)'
                      : '   + $addName (${_formatAmount(addPrice)} $currencySymbol)'
                );
              }
              
              final String productCellText = productCellLines.join('\n');
              final itemTotal = (qty * unitPrice) + addonsTotal;

              return isArabic
                  ? [
                      text('${_formatAmount(itemTotal)} $currencySymbol'),
                      text('${_formatAmount(unitPrice)} $currencySymbol'),
                      text(qty.toString()),
                      text(productCellText),
                    ]
                  : [
                      text(productCellText),
                      text(qty.toString()),
                      text('${_formatAmount(unitPrice)} $currencySymbol'),
                      text('${_formatAmount(itemTotal)} $currencySymbol'),
                    ];
            }).toList();

            final table = pw.TableHelper.fromTextArray(
              headers: headers.map((h) => text(h)).toList(),
              data: tableRows,
              border: pw.TableBorder.all(color: PdfColor.fromHex('#CFD8DC'), width: 1),
              headerStyle: pw.TextStyle(font: fontBold, color: PdfColors.white, fontSize: 11),
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#E65100')),
              rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            );

            // Invoice Summary Row
            final summary = pw.Container(
              margin: const pw.EdgeInsets.only(top: 24),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (notes != null && notes.trim().isNotEmpty) ...[
                        pw.Text(text(isArabic ? 'الملاحظات:' : 'Notes:'), style: pw.TextStyle(font: fontBold, fontSize: 11)),
                        pw.SizedBox(height: 4),
                        pw.Container(
                          width: 250,
                          child: pw.Text(text(notes), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                        ),
                      ],
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColor.fromHex('#E65100'), width: 2),
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColor.fromHex('#FFF3E0'),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          text(isArabic ? 'المبلغ الإجمالي الخاضع للضريبة' : 'Total Amount Tax Inclusive'),
                          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          text('${_formatAmount(totalPrice)} $currencySymbol'),
                          style: pw.TextStyle(font: fontBold, fontSize: 18, color: PdfColor.fromHex('#E65100')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            // Footer Section
            final footer = pw.Container(
              margin: const pw.EdgeInsets.only(top: 60),
              child: pw.Column(
                children: [
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(text(isArabic ? 'شكراً لتعاملكم معنا' : 'Thank you for your business'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey500)),
                      pw.Text(text(isArabic ? 'نظام البوفيه المميز POS' : 'Premium Buffet POS System'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey500)),
                    ],
                  ),
                ],
              ),
            );

            return pw.Column(
              children: [
                header,
                divider,
                banner,
                metadata,
                table,
                summary,
                pw.Spacer(),
                footer,
              ],
            );
          },
        ),
      );

      // 3. Share or Send to local printer dialog
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'invoice_order_$orderId.pdf',
      );
    } catch (e) {
      Toaster.show(isArabic ? 'حدث خطأ أثناء إعداد الفاتورة' : 'Error generating receipt', isError: true);
    }
  }

  /// Generates and prints a beautiful corporate PDF report containing all loaded orders.
  static Future<void> printAllOrders({
    required BuildContext context,
    required WidgetRef ref,
    required List<Map<String, dynamic>> orders,
  }) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final configs = ref.read(configProvider);
    final cafeteriaName = configs['business_name'] ?? (isArabic ? 'كفتيريا البوفيه المميز' : 'Premium Buffet');

    final String docTitle = isArabic ? 'تقرير سجل الطلبات والمبيعات' : 'Sales & Orders History Report';
    final String printDateStr = _formatDateTime(DateTime.now(), isArabic);

    String text(String input) {
      if (isArabic) {
        return ArabicPdfHelper.shape(input);
      }
      return input;
    }

    try {
      final fontRegular = pw.Font.ttf(await rootBundle.load("assets/fonts/Tajawal-Regular.ttf"));
      final fontBold = pw.Font.ttf(await rootBundle.load("assets/fonts/Tajawal-Bold.ttf"));

      pw.MemoryImage? logoImage;
      try {
        final logoBytes = await rootBundle.load("assets/icons/logo.png");
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {}

      // Calculate totals
      double grandTotal = 0;
      int servedCount = 0;
      int pendingCount = 0;

      for (var o in orders) {
        grandTotal += (o['total_price'] as num).toDouble();
        final int statusInt = o['status'] is int
            ? o['status']
            : (int.tryParse(o['status']?.toString() ?? '0') ?? 0);
        if (statusInt == 1) {
          servedCount++;
        } else {
          pendingCount++;
        }
      }

      // Load Database Service and fetch full details for all orders to display items in summary
      final dbService = ref.read(databaseServiceProvider);
      final repo = OrderRepository(dbService);
      final Map<int, List<Map<String, dynamic>>> orderItemsMap = {};
      for (var o in orders) {
        final int orderId = o['id'] as int;
        try {
          final items = await repo.getOrderFullDetails(orderId);
          orderItemsMap[orderId] = items;
        } catch (_) {}
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
          header: (pw.Context pdfContext) {
            return pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logoImage != null)
                      pw.Image(logoImage, width: 65, height: 65)
                    else
                      pw.SizedBox(width: 65, height: 65),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          text(cafeteriaName),
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 22,
                            color: PdfColor.fromHex('#E65100'),
                          ),
                        ),
                        pw.Text(
                          text(docTitle),
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 10),
                  height: 3,
                  decoration: const pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [PdfColors.orangeAccent, PdfColors.orange800],
                    ),
                  ),
                ),
              ],
            );
          },
          build: (pw.Context pdfContext) {
            final currencyArRaw = configs['currency_sign_ar'] ?? configs['currency_sign'] ?? 'ريال';
            final currencyEnRaw = configs['currency_sign_en'] ?? 'YR';
            final String currencyAr = currencyArRaw.contains('.svg') ? 'ريال' : currencyArRaw;
            final String currencyEn = currencyEnRaw.contains('.svg') ? 'YR' : currencyEnRaw;
            final String currencySymbol = isArabic ? currencyAr : currencyEn;

            // Summary Dashboard Block
            final dashboard = pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
                color: PdfColor.fromHex('#FAFAFA'),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'إجمالي المبيعات' : 'Total Sales'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text('${_formatAmount(grandTotal)} $currencySymbol'), style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.green800)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'الطلبات المكتملة' : 'Served Orders'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text(servedCount.toString()), style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blue800)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'قيد الانتظار' : 'Pending Orders'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text(pendingCount.toString()), style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.orange800)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'تاريخ طباعة التقرير' : 'Report Date'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text(printDateStr), style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.grey800)),
                    ],
                  ),
                ],
              ),
            );

            // Table headers (RTL reversed for Arabic)
            final headers = isArabic
                ? ['الإجمالي', 'الحالة', 'التاريخ', 'المنتجات', 'اسم العميل', 'رقم الطلب']
                : ['Order ID', 'Customer', 'Products', 'Date', 'Status', 'Total'];

            final tableRows = orders.map((o) {
              final int id = o['id'] as int;
              final String? rawName = o['customer_name'];
              final String customerStr = (rawName == null || rawName.trim().isEmpty)
                  ? (isArabic ? 'عميل كاشير' : 'Walk-in')
                  : rawName;

              final DateTime dt = DateTime.parse(o['created_at']);
              final String dateStr = _formatDateTime(dt, isArabic, showSeconds: false);

              final int statusInt = o['status'] is int
                  ? o['status']
                  : (int.tryParse(o['status']?.toString() ?? '0') ?? 0);

              final String statusLabel = statusInt == 1
                  ? (isArabic ? 'مكتمل' : 'Served')
                  : (isArabic ? 'قيد الانتظار' : 'Pending');

              final double price = (o['total_price'] as num).toDouble();

              // Format items sub-list for the multi-line "Products" cell
              final orderItems = orderItemsMap[id] ?? [];
              final List<String> formattedItems = [];
              for (var item in orderItems) {
                final String itemName = item['name_at_sale'] as String;
                final int qty = item['quantity'] as int;
                final double priceAtSale = (item['price_at_sale'] as num?)?.toDouble() ?? 0.0;
                
                // 1. Format the base product name and price
                String productLine = '';
                if (qty > 1) {
                  productLine = isArabic
                      ? '$itemName ($qty × ${_formatAmount(priceAtSale)})'
                      : '$itemName ($qty x ${_formatAmount(priceAtSale)})';
                } else {
                  productLine = isArabic
                      ? '$itemName (${_formatAmount(priceAtSale)})'
                      : '$itemName (${_formatAmount(priceAtSale)})';
                }
                formattedItems.add(productLine);

                // 2. Format its additions (addons) if any exist
                final List<dynamic> addons = item['addons'] as List<dynamic>? ?? [];
                for (var add in addons) {
                  final String addName = add['name_at_sale'] as String;
                  final double addPrice = (add['price_at_sale'] as num?)?.toDouble() ?? 0.0;
                  
                  formattedItems.add(
                    isArabic
                        ? '   + $addName (${_formatAmount(addPrice)})'
                        : '   + $addName (${_formatAmount(addPrice)})'
                  );
                }
              }
              final String itemsCellText = formattedItems.join('\n');

              return isArabic
                  ? [
                      text('${_formatAmount(price)} $currencySymbol'),
                      text(statusLabel),
                      text(dateStr),
                      text(itemsCellText),
                      text(customerStr),
                      text('#$id'),
                    ]
                  : [
                      text('#$id'),
                      text(customerStr),
                      text(itemsCellText),
                      text(dateStr),
                      text(statusLabel),
                      text('${_formatAmount(price)} $currencySymbol'),
                    ];
            }).toList();

            // Set dynamic widths to ensure "Items" has plenty of space and meta-data remains compact
            final columnWidths = isArabic
                ? {
                    0: const pw.FixedColumnWidth(80),   // Total
                    1: const pw.FixedColumnWidth(65),   // Status
                    2: const pw.FixedColumnWidth(110),  // Date
                    3: const pw.FlexColumnWidth(2.5),   // Items
                    4: const pw.FlexColumnWidth(1.5),   // Customer Name
                    5: const pw.FixedColumnWidth(55),   // Order ID
                  }
                : {
                    0: const pw.FixedColumnWidth(55),   // Order ID
                    1: const pw.FlexColumnWidth(1.5),   // Customer Name
                    2: const pw.FlexColumnWidth(2.5),   // Items
                    3: const pw.FixedColumnWidth(110),  // Date
                    4: const pw.FixedColumnWidth(65),   // Status
                    5: const pw.FixedColumnWidth(80),   // Total
                  };

            final table = pw.TableHelper.fromTextArray(
              headers: headers.map((h) => text(h)).toList(),
              data: tableRows,
              columnWidths: columnWidths,
              border: pw.TableBorder.all(color: PdfColor.fromHex('#CFD8DC'), width: 1),
              headerStyle: pw.TextStyle(font: fontBold, color: PdfColors.white, fontSize: 10),
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#37474F')),
              rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellPadding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            );

            return [
              dashboard,
              table,
            ];
          },
          footer: (pw.Context pdfContext) {
            return pw.Column(
              children: [
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      text('${isArabic ? "صفحة" : "Page"} ${pdfContext.pageNumber} ${isArabic ? "من" : "of"} ${pdfContext.pagesCount}'),
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                    ),
                    pw.Text(
                      text(isArabic ? 'مخرجات معتمدة من الإدارة المالية' : 'Official Financial Report Out'),
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'orders_report_$printDateStr.pdf',
      );
    } catch (e) {
      Toaster.show(isArabic ? 'حدث خطأ أثناء طباعة التقرير' : 'Error generating report', isError: true);
    }
  }

  /// Generates and prints a beautiful corporate PDF report containing daily suppliers accounts summary and ledger entries.
  static Future<void> printDailyAccountsReport({
    required BuildContext context,
    required WidgetRef ref,
    required String dateStr,
    required Map<String, double> stats,
    required List<Map<String, dynamic>> transactions,
  }) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final configs = ref.read(configProvider);
    final cafeteriaName = configs['business_name'] ?? (isArabic ? 'كفتيريا البوفيه المميز' : 'Premium Buffet');

    final String docTitle = isArabic ? 'تقرير الحسابات والقيود اليومي' : 'Daily Accounts & Ledger Report';
    final String printDateStr = _formatDateTime(DateTime.now(), isArabic);

    String text(String input) {
      if (isArabic) {
        return ArabicPdfHelper.shape(input);
      }
      return input;
    }

    try {
      final fontRegular = pw.Font.ttf(await rootBundle.load("assets/fonts/Tajawal-Regular.ttf"));
      final fontBold = pw.Font.ttf(await rootBundle.load("assets/fonts/Tajawal-Bold.ttf"));

      pw.MemoryImage? logoImage;
      try {
        final logoBytes = await rootBundle.load("assets/icons/logo.png");
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {}

      final double sales = stats['sales'] ?? 0.0;
      final double credit = stats['credit'] ?? 0.0;
      final double debit = stats['debit'] ?? 0.0;
      final double netProfit = sales - credit;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
          header: (pw.Context pdfContext) {
            return pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logoImage != null)
                      pw.Image(logoImage, width: 65, height: 65)
                    else
                      pw.SizedBox(width: 65, height: 65),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          text(cafeteriaName),
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 22,
                            color: PdfColor.fromHex('#E65100'),
                          ),
                        ),
                        pw.Text(
                          text(docTitle),
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 10),
                  height: 3,
                  decoration: const pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [PdfColors.orangeAccent, PdfColors.orange800],
                    ),
                  ),
                ),
              ],
            );
          },
          build: (pw.Context pdfContext) {
            final currencyArRaw = configs['currency_sign_ar'] ?? configs['currency_sign'] ?? 'ريال';
            final currencyEnRaw = configs['currency_sign_en'] ?? 'YR';
            final String currencyAr = currencyArRaw.contains('.svg') ? 'ريال' : currencyArRaw;
            final String currencyEn = currencyEnRaw.contains('.svg') ? 'YR' : currencyEnRaw;
            final String currencySymbol = isArabic ? currencyAr : currencyEn;

            // Dashboard Block
            final dashboard = pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
                color: PdfColor.fromHex('#FAFAFA'),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'المبيعات اليومية' : 'Daily Sales'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text('${_formatAmount(sales)} $currencySymbol'), style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.blue800)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'المشتريات الآجلة (دائن)' : 'Daily Credit'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text('${_formatAmount(credit)} $currencySymbol'), style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.orange800)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'سداد الموردين (مدين)' : 'Daily Debit'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text('${_formatAmount(debit)} $currencySymbol'), style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.red800)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(text(isArabic ? 'صافي الأرباح اليومية' : 'Net Profit'), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.SizedBox(height: 4),
                      pw.Text(text('${_formatAmount(netProfit)} $currencySymbol'), style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.green800)),
                    ],
                  ),
                ],
              ),
            );

            // Table headers (RTL reversed for Arabic)
            final headers = isArabic
                ? ['البيان / الوصف', 'المبلغ', 'نوع القيد', 'اسم المورد', 'التاريخ والوقت']
                : ['Date & Time', 'Supplier', 'Type', 'Amount', 'Description'];

            final tableRows = transactions.map((t) {
              final String name = t['supplier_name'] ?? '';
              final bool isSales = t['type'] == 'sales';

              final String typeLabel = isSales
                  ? (isArabic ? 'مبيعات نقدية' : 'Cash Sales')
                  : (t['type'] == 'credit'
                      ? (isArabic ? 'دائن (شراء بالآجل)' : 'Credit (Purchase)')
                      : (isArabic ? 'مدين (سداد نقدي)' : 'Debit (Payment)'));

              final double amount = (t['amount'] as num).toDouble();
              
              final String description = isSales
                  ? (isArabic ? 'مبيعات الطلب #${t['id']}' : 'Sales of Order #${t['id']}')
                  : (t['description'] ?? '');
              
              final DateTime dt = DateTime.parse(t['created_at']);
              final String dateDisplay = _formatDateTime(dt, isArabic, showSeconds: false);

              final prefix = isSales ? '+' : (t['type'] == 'credit' ? '+' : '-');

              return isArabic
                  ? [
                      text(description),
                      text('$prefix${_formatAmount(amount)} $currencySymbol'),
                      text(typeLabel),
                      text(name),
                      text(dateDisplay),
                    ]
                  : [
                      text(dateDisplay),
                      text(name),
                      text(typeLabel),
                      text('$prefix${_formatAmount(amount)} $currencySymbol'),
                      text(description),
                    ];
            }).toList();

            final columnWidths = isArabic
                ? {
                    0: const pw.FlexColumnWidth(2.0),   // Description
                    1: const pw.FixedColumnWidth(80),   // Amount
                    2: const pw.FixedColumnWidth(100),  // Type
                    3: const pw.FlexColumnWidth(1.5),   // Supplier Name
                    4: const pw.FixedColumnWidth(110),  // Date
                  }
                : {
                    0: const pw.FixedColumnWidth(110),  // Date
                    1: const pw.FlexColumnWidth(1.5),   // Supplier Name
                    2: const pw.FixedColumnWidth(100),  // Type
                    3: const pw.FixedColumnWidth(80),   // Amount
                    4: const pw.FlexColumnWidth(2.0),   // Description
                  };

            final table = pw.TableHelper.fromTextArray(
              headers: headers.map((h) => text(h)).toList(),
              data: tableRows,
              columnWidths: columnWidths,
              border: pw.TableBorder.all(color: PdfColor.fromHex('#CFD8DC'), width: 1),
              headerStyle: pw.TextStyle(font: fontBold, color: PdfColors.white, fontSize: 10),
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#37474F')),
              rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
              cellAlignment: pw.Alignment.center,
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellPadding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            );

            return [
              dashboard,
              table,
            ];
          },
          footer: (pw.Context pdfContext) {
            return pw.Column(
              children: [
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      text('${isArabic ? "صفحة" : "Page"} ${pdfContext.pageNumber} ${isArabic ? "من" : "of"} ${pdfContext.pagesCount}'),
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                    ),
                    pw.Text(
                      text(isArabic ? 'تقرير حسابات الموردين اليومي المعتمد' : 'Official Supplier Accounts Report'),
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'supplier_accounts_report_$dateStr.pdf',
      );
    } catch (e) {
      Toaster.show(isArabic ? 'حدث خطأ أثناء طباعة التقرير' : 'Error generating report', isError: true);
    }
  }

  static String _formatDateTime(DateTime dateTime, bool isArabic, {bool showSeconds = true}) {
    final datePart = DateFormat('yyyy/MM/dd', 'en').format(dateTime);
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final isPm = hour >= 12;
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final secondsPart = showSeconds ? ':${dateTime.second.toString().padLeft(2, '0')}' : '';

    if (isArabic) {
      final period = isPm ? 'م' : 'ص';
      // Placing period first in Arabic allows the segment-reversal logic in shape()
      // to cleanly reverse them, producing: 'date time period' (with period on the far right).
      return '$period $datePart $displayHour:$minute$secondsPart';
    } else {
      final period = isPm ? 'PM' : 'AM';
      return '$datePart $displayHour:$minute$secondsPart $period';
    }
  }

  static String _formatAmount(double amount) {
    if (amount == amount.toInt()) {
      return NumberFormat('#,###', 'en').format(amount.toInt());
    } else {
      return NumberFormat('#,##0.00', 'en').format(amount);
    }
  }
}
