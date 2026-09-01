import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/add_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

class CatalogService {
  // --- 1. CSV GENERATOR ---
  static String generateCsvString(List<dynamic> items, int activeIndex) {
    List<List<dynamic>> rows = [];

    if (activeIndex == 0) {
      rows.add(["Product Name", "Price", "Category"]);
      for (var item in items as List<ProductEntity>) {
        rows.add([item.name, item.basePrice, item.category?.name ?? ""]);
      }
    } else if (activeIndex == 1) {
      rows.add(["Add-on Name", "Price"]);
      for (var item in items as List<AddEntity>) {
        rows.add([item.name, item.basePrice]);
      }
    } else {
      rows.add(["Category Name"]);
      for (var item in items as List<CategoryEntity>) {
        rows.add([item.name]);
      }
    }
    return const ListToCsvConverter().convert(rows);
  }

  // --- 2. SAVE TO DEFAULT (Internal App Path) ---
  /// Saves string data (CSV/JSON/TXT) to the app-specific external files folder.
  ///
  /// Returns the [String] path of the saved file or throws an [Exception].
  static Future<String> saveToDefaultDir(String data, String fileName) async {
    try {
      Directory? targetDir;

      if (Platform.isAndroid) {
        final extDir = await getExternalStorageDirectory();
        if (extDir == null) {
          throw Exception("External storage not available");
        }
        targetDir = Directory('${extDir.path}/exports');
      } else {
        // On iOS, we use the standard app documents directory
        final base = await getApplicationDocumentsDirectory();
        targetDir = Directory('${base.path}/${AppStrings.appFolder}');
      }

      // 2. Ensure the directory exists (recursive: true creates parent folders too)
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      // 3. Construct the full file path and write
      final file = File('${targetDir.path}/$fileName');
      await file.writeAsString(data, flush: true);

      return file.path;
    } catch (e) {
      // 4. Emergency Fallback: If public storage fails, save to private app storage
      // This ensures the user doesn't lose their data export even if permissions fail.
      final fallbackBase = await getApplicationDocumentsDirectory();
      final fallbackFile = File('${fallbackBase.path}/$fileName');
      await fallbackFile.writeAsString(data, flush: true);

      return fallbackFile.path;
    }
  }

  // --- 3. SAVE TO CUSTOM DIR (System File Picker) ---
  static Future<String?> saveToCustomDir(String data, String fileName) async {
    final Uint8List bytes = Uint8List.fromList(utf8.encode(data));

    return await FilePicker.platform.saveFile(
      dialogTitle: 'Select where to save your export',
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
  }

  // --- 4. SHARE CSV ---
  static Future<void> shareCsv(String csvData, String fileName) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csvData);

      await Share.shareXFiles([XFile(file.path)], subject: 'Exported $fileName');
    } catch (e) {
      throw "Sharing failed: ${e.toString()}";
    }
  }

  // --- 5. IMPORT FROM CSV ---
  static Future<List<dynamic>> importFromCsv({required int activeIndex}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) return [];

      final file = File(result.files.single.path!);
      final fields = await file
          .openRead()
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      if (fields.isEmpty) return [];
      List<dynamic> importedItems = [];

      for (var i = 1; i < fields.length; i++) {
        final row = fields[i];

        // 1. Skip if the row is physically empty
        if (row.isEmpty) continue;

        // 2. Skip if the primary field (Name) is empty or just whitespace
        // This handles rows that look like: ["", "", ""]
        final String name = row[0].toString().trim();
        if (name.isEmpty) continue;

        if (activeIndex == 0) {
          // PRODUCTS: Requires Name and Price
          final double price = double.tryParse(row[1].toString()) ?? 0.0;
          String? catName = row.length > 2 ? row[2].toString().trim() : null;

          importedItems.add(
            ProductEntity(
              name: name,
              basePrice: price,
              category: (catName?.isNotEmpty ?? false)
                  ? CategoryEntity(name: catName!)
                  : null,
            ),
          );
        } else if (activeIndex == 1) {
          // ADD-ONS: Requires Name and Price
          final double price = double.tryParse(row[1].toString()) ?? 0.0;
          importedItems.add(AddEntity(name: name, basePrice: price));
        } else {
          // CATEGORIES: Requires Name only
          importedItems.add(CategoryEntity(name: name));
        }
      }
      return importedItems;
    } catch (e) {
      throw "Import failed. Check CSV format.";
    }
  }
}
