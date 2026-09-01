// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(name) => "إضافة ${name}";

  static String m1(name) => "+ ${name}";

  static String m2(version) => "إصدار التطبيق: v${version}";

  static String m3(e) => "خطأ في الدفع: ${e}";

  static String m4(name) => "نقرة عادية: فتح ${name}";

  static String m5(title) => "${title} مخصص...";

  static String m6(count) =>
      "${Intl.plural(count, one: 'حذف طلب واحد؟', two: 'حذف طلبين؟', few: 'حذف ${count} طلبات؟', many: 'حذف ${count} طلباً؟', other: 'حذف ${count} طلب؟')}";

  static String m7(count) =>
      "حذف ${count} من العناصر؟ لا يمكن التراجع عن هذا الإجراء.";

  static String m8(count) =>
      "${Intl.plural(count, one: 'تم حذف طلب واحد', two: 'تم حذف طلبين', few: 'تم حذف ${count} طلبات', many: 'تم حذف ${count} طلباً', other: 'تم حذف ${count} طلب')}";

  static String m9(name) => "تعديل ${name}";

  static String m10(name) => "تعديل ${name}";

  static String m11(id) => "تعديل طلب ${id}";

  static String m12(error) => "خطأ: ${error}";

  static String m13(type) => "تصدير ${type}";

  static String m14(error) => "خطأ في الاستيراد: ${error}";

  static String m15(type) => "استيراد ${type}";

  static String m16(count) =>
      "${Intl.plural(count, one: 'صنف واحد', two: 'صنفين', few: '${count} أصناف', many: '${count} صنفاً', other: '${count} صنف')}";

  static String m17(count) =>
      "${Intl.plural(count, zero: 'السلة فارغة', one: 'صنف واحد في السلة', two: 'صنفين في السلة', few: '${count} أصناف في السلة', many: '${count} صنفاً في السلة', other: '${count} صنف في السلة')}";

  static String m18(count) =>
      "${Intl.plural(count, one: 'ساعة واحدة', two: 'ساعتان', other: '${count} ساعة')}";

  static String m19(id) => "طلب رقم ${id}";

  static String m20(index) => "طلب رقم ${index}";

  static String m21(id) => "تم حفظ طلب ${id}!";

  static String m22(orderId) => "تم تقديم طلب ${orderId}";

  static String m23(id) => "تم تحديث طلب ${id} بنجاح";

  static String m24(count) =>
      "${Intl.plural(count, zero: 'لم يتم معالجة أي عناصر', one: 'تمت معالجة عنصر واحد', two: 'تمت معالجة عنصرين', few: 'تمت معالجة ${count} عناصر', many: 'تمت معالجة ${count} عنصراً', other: 'تمت معالجة ${count} عنصر')}";

  static String m25(count) =>
      "${Intl.plural(count, one: 'منتج واحد', two: 'منتجين', few: '${count} منتجات', many: '${count} منتجاً', other: '${count} منتج')}";

  static String m26(count, name) => "${count}x ${name}";

  static String m27(error) => "خطأ في إعادة الضبط: ${error}";

  static String m28(path) => "تم الحفظ في ${path}";

  static String m29(folder) => "تم الحفظ في ${folder}";

  static String m30(count) =>
      "${Intl.plural(count, zero: 'لا يوجد تحديد', one: 'تم تحديد طلب واحد', two: 'تم تحديد طلبين', few: 'تم تحديد ${count} طلبات', many: 'تم تحديد ${count} طلباً', other: 'تم تحديد ${count} طلب')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accounts": MessageLookupByLibrary.simpleMessage("الحسابات"),
    "addAddonsNow": MessageLookupByLibrary.simpleMessage(
      "أضف إضافات جديدة الآن!",
    ),
    "addNewAction": MessageLookupByLibrary.simpleMessage("إضافة إجراء جديد"),
    "addNewCategoriesNow": MessageLookupByLibrary.simpleMessage(
      "أضف تصنيفات جديدة الآن!",
    ),
    "addNewCategory": MessageLookupByLibrary.simpleMessage("إضافة تصنيف جديد"),
    "addNewProduct": MessageLookupByLibrary.simpleMessage("إضافة منتج جديد"),
    "addNewProductsNow": MessageLookupByLibrary.simpleMessage(
      "أضف منتجات جديدة الآن!",
    ),
    "addOrderNotes": MessageLookupByLibrary.simpleMessage(
      "إضافة ملاحظات (اختياري)...",
    ),
    "addProductName": m0,
    "addProductsNow": MessageLookupByLibrary.simpleMessage(
      "أضف منتجات جديدة الآن!",
    ),
    "addSupplier": MessageLookupByLibrary.simpleMessage("إضافة مورد"),
    "addToOrder": MessageLookupByLibrary.simpleMessage("إضافة للطلب"),
    "addTransaction": MessageLookupByLibrary.simpleMessage("إضافة قيد"),
    "addon": MessageLookupByLibrary.simpleMessage("إضافة"),
    "addonName": MessageLookupByLibrary.simpleMessage("اسم الإضافة"),
    "addonPrefix": m1,
    "addons": MessageLookupByLibrary.simpleMessage("الإضافات"),
    "address": MessageLookupByLibrary.simpleMessage("العنوان"),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟ تسجيل الدخول",
    ),
    "amount": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "appLanguage": MessageLookupByLibrary.simpleMessage("لغة التطبيق"),
    "appVersionVersion": m2,
    "applyChanges": MessageLookupByLibrary.simpleMessage("تطبيق التغييرات"),
    "applyLanguage": MessageLookupByLibrary.simpleMessage("تطبيق اللغة"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "authErrorMessage": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء المصادقة. يرجى المحاولة مرة أخرى.",
    ),
    "backupDatabase": MessageLookupByLibrary.simpleMessage(
      "نسخ احتياطي لقاعدة البيانات",
    ),
    "balance": MessageLookupByLibrary.simpleMessage("الرصيد"),
    "basePrice": MessageLookupByLibrary.simpleMessage("السعر الأساسي"),
    "basicDetails": MessageLookupByLibrary.simpleMessage("التفاصيل الأساسية"),
    "bestBuffet": MessageLookupByLibrary.simpleMessage("أفضل كافتيريا"),
    "biometricAuthentication": MessageLookupByLibrary.simpleMessage(
      "المصادقة الحيوية",
    ),
    "biometricsDisabledUsePasscode": MessageLookupByLibrary.simpleMessage(
      "البصمة معطلة. يرجى فتح القفل باستخدام رمز مرور الهاتف.",
    ),
    "biometricsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "البصمة أو رمز الأمان غير متوفر في هذا الجهاز.",
    ),
    "buffetName": MessageLookupByLibrary.simpleMessage("اسم الكافتيريا"),
    "businessInfo": MessageLookupByLibrary.simpleMessage("معلومات العمل"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cannotPauseWhileEditing": MessageLookupByLibrary.simpleMessage(
      "لا يمكن تعليق الطلب أثناء تعديل طلب محفوظ",
    ),
    "cartIsEmpty": MessageLookupByLibrary.simpleMessage("السلة فارغة!"),
    "catExists": MessageLookupByLibrary.simpleMessage("موجود"),
    "catalog": MessageLookupByLibrary.simpleMessage("الكتالوج"),
    "categories": MessageLookupByLibrary.simpleMessage("التصنيفات"),
    "category": MessageLookupByLibrary.simpleMessage("التصنيف"),
    "categoryName": MessageLookupByLibrary.simpleMessage("اسم التصنيف"),
    "checkout": MessageLookupByLibrary.simpleMessage("دفع"),
    "checkoutError": m3,
    "checkoutSummary": MessageLookupByLibrary.simpleMessage("ملخص الدفع"),
    "chooseFolder": MessageLookupByLibrary.simpleMessage("اختر مجلدًا مخصصًا"),
    "clear": MessageLookupByLibrary.simpleMessage("مسح"),
    "clearOrder": MessageLookupByLibrary.simpleMessage("مسح الطلب؟"),
    "clickToOpen": m4,
    "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "completeSale": MessageLookupByLibrary.simpleMessage("إتمام البيع"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmOrder": MessageLookupByLibrary.simpleMessage("تأكيد الطلب"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("تأكيد كلمة السر"),
    "credit": MessageLookupByLibrary.simpleMessage("دائن"),
    "creditPurchase": MessageLookupByLibrary.simpleMessage(
      "دائن (شراء بالآجل)",
    ),
    "currencySign": MessageLookupByLibrary.simpleMessage("رمز العملة"),
    "customT": m5,
    "customerInfo": MessageLookupByLibrary.simpleMessage("معلومات العميل"),
    "customerName": MessageLookupByLibrary.simpleMessage("اسم العميل"),
    "dailyCredit": MessageLookupByLibrary.simpleMessage("إجمالي الدائن اليومي"),
    "dailyDebit": MessageLookupByLibrary.simpleMessage("إجمالي المدين اليومي"),
    "dailySales": MessageLookupByLibrary.simpleMessage("المبيعات اليومية"),
    "dangerousAction": MessageLookupByLibrary.simpleMessage("إجراء خطير!"),
    "darkMode": MessageLookupByLibrary.simpleMessage("الوضع الداكن"),
    "databaseExportedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تصدير قاعدة البيانات بنجاح",
    ),
    "databaseReports": MessageLookupByLibrary.simpleMessage(
      "قاعدة البيانات والتقارير",
    ),
    "date": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "dateFormat": MessageLookupByLibrary.simpleMessage("تنسيق التاريخ"),
    "debit": MessageLookupByLibrary.simpleMessage("مدين"),
    "debitPayment": MessageLookupByLibrary.simpleMessage("مدين (سداد نقدي)"),
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "deleteAll": MessageLookupByLibrary.simpleMessage("حذف الكل"),
    "deleteAllProductsAndHistory": MessageLookupByLibrary.simpleMessage(
      "حذف جميع المنتجات والسجل",
    ),
    "deleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "سيؤدي هذا إلى حذف هذه السجلات نهائياً من قاعدة البيانات.",
    ),
    "deleteItems": MessageLookupByLibrary.simpleMessage("حذف العناصر؟"),
    "deleteOrdersCount": m6,
    "deleteWarning": m7,
    "deletedOrdersMessage": m8,
    "deletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم الحذف بنجاح",
    ),
    "description": MessageLookupByLibrary.simpleMessage("البيان / الوصف"),
    "dismiss": MessageLookupByLibrary.simpleMessage("تجاهل"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "ليس لديك حساب؟ إنشاء حساب",
    ),
    "duplicate": MessageLookupByLibrary.simpleMessage("مكرر"),
    "duplicates": MessageLookupByLibrary.simpleMessage("العناصر المكررة:"),
    "editAddon": m9,
    "editBuffetName": MessageLookupByLibrary.simpleMessage(
      "تعديل اسم الكافتيريا",
    ),
    "editCancelled": MessageLookupByLibrary.simpleMessage("تم إلغاء التعديل"),
    "editCategory": MessageLookupByLibrary.simpleMessage("تعديل التصنيف"),
    "editProduct": MessageLookupByLibrary.simpleMessage("تعديل المنتج"),
    "editProductName": m10,
    "editSupplier": MessageLookupByLibrary.simpleMessage("تعديل مورد"),
    "editingOrder": m11,
    "egChickenBurger": MessageLookupByLibrary.simpleMessage("مثل: برجر دجاج"),
    "egDateFormat": MessageLookupByLibrary.simpleMessage("مثال: yyyy-MM-dd"),
    "egExtraCheese": MessageLookupByLibrary.simpleMessage("مثل: جبنة إضافية"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emailAlreadyRegistered": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني مسجل بالفعل",
    ),
    "emailNotRegistered": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني غير مسجل",
    ),
    "english": MessageLookupByLibrary.simpleMessage("الإنجليزية (English)"),
    "enterBuffetName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم الكافتيريا",
    ),
    "enterCustomerName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم العميل...",
    ),
    "enterName": MessageLookupByLibrary.simpleMessage("أدخل الاسم..."),
    "errorLoadingAddons": MessageLookupByLibrary.simpleMessage(
      "خطأ في تحميل الإضافات",
    ),
    "errorLoadingOrder": MessageLookupByLibrary.simpleMessage(
      "خطأ في تحميل الطلب",
    ),
    "errorOccur": MessageLookupByLibrary.simpleMessage("حدث خطأ"),
    "errorOccurred": m12,
    "exists": MessageLookupByLibrary.simpleMessage("موجود مسبقاً"),
    "exportAccountsReport": MessageLookupByLibrary.simpleMessage(
      "تصدير تقرير الحسابات اليومي",
    ),
    "exportAllDataToAFile": MessageLookupByLibrary.simpleMessage(
      "تصدير كافة البيانات إلى ملف خارجي",
    ),
    "exportCancelled": MessageLookupByLibrary.simpleMessage("تم إلغاء التصدير"),
    "exportFailed": MessageLookupByLibrary.simpleMessage("فشل التصدير"),
    "exportNow": MessageLookupByLibrary.simpleMessage("تصدير الآن"),
    "exportOptions": MessageLookupByLibrary.simpleMessage("خيارات التصدير"),
    "exportOrders": MessageLookupByLibrary.simpleMessage("تصدير الطلبات"),
    "exportType": m13,
    "factoryReset": MessageLookupByLibrary.simpleMessage("إعادة ضبط المصنع"),
    "failedToSaveOrder": MessageLookupByLibrary.simpleMessage(
      "فشل في حفظ الطلب. يرجى المحاولة مرة أخرى.",
    ),
    "fieldRequired": MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
    "free": MessageLookupByLibrary.simpleMessage("مجاني"),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم كامل"),
    "grandTotal": MessageLookupByLibrary.simpleMessage("الإجمالي النهائي"),
    "grant": MessageLookupByLibrary.simpleMessage("منح"),
    "gridView": MessageLookupByLibrary.simpleMessage("عرض الشبكة"),
    "hideSearch": MessageLookupByLibrary.simpleMessage("إخفاء البحث"),
    "identityVerified": MessageLookupByLibrary.simpleMessage(
      "تم التحقق من الهوية",
    ),
    "importAction": MessageLookupByLibrary.simpleMessage("استيراد الآن"),
    "importDatabase": MessageLookupByLibrary.simpleMessage(
      "استيراد قاعدة البيانات؟",
    ),
    "importError": m14,
    "importFailed": MessageLookupByLibrary.simpleMessage("فشل الاستيراد"),
    "importNewDataFromABackupFile": MessageLookupByLibrary.simpleMessage(
      "استيراد بيانات جديدة من ملف نسخة احتياطية",
    ),
    "importPreview": MessageLookupByLibrary.simpleMessage("معاينة الاستيراد"),
    "importRestart": MessageLookupByLibrary.simpleMessage(
      "استيراد وإعادة تشغيل",
    ),
    "importSuccessfulRestarting": MessageLookupByLibrary.simpleMessage(
      "تم الاستيراد بنجاح! جاري إعادة التشغيل...",
    ),
    "importType": m15,
    "incorrectPassword": MessageLookupByLibrary.simpleMessage(
      "كلمة السر غير صحيحة",
    ),
    "invalid": MessageLookupByLibrary.simpleMessage("غير صالح"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "تنسيق البريد الإلكتروني غير صالح",
    ),
    "invalidFileType": MessageLookupByLibrary.simpleMessage(
      "نوع الملف غير صالح",
    ),
    "invalidPattern": MessageLookupByLibrary.simpleMessage("تنسيق غير صالح"),
    "invalidPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "رقم الهاتف غير صالح",
    ),
    "itemCount": m16,
    "items": MessageLookupByLibrary.simpleMessage("الأصناف"),
    "itemsInBasket": m17,
    "ledger": MessageLookupByLibrary.simpleMessage("دفتر القيود المحاسبية"),
    "lightMode": MessageLookupByLibrary.simpleMessage("الوضع الفاتح"),
    "linkedAddons": MessageLookupByLibrary.simpleMessage("الإضافات المرتبطة"),
    "linkedProducts": MessageLookupByLibrary.simpleMessage("المنتجات المرتبطة"),
    "listView": MessageLookupByLibrary.simpleMessage("عرض القائمة"),
    "livePreview": MessageLookupByLibrary.simpleMessage("معاينة مباشرة"),
    "localization": MessageLookupByLibrary.simpleMessage("الإعدادات المحلية"),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الدخول بنجاح",
    ),
    "markAsServed": MessageLookupByLibrary.simpleMessage("تحديد كمكتمل"),
    "netProfit": MessageLookupByLibrary.simpleMessage("صافي الربح"),
    "newAddon": MessageLookupByLibrary.simpleMessage("إضافة جديدة"),
    "newCat": MessageLookupByLibrary.simpleMessage("تصنيف جديد"),
    "newCategory": MessageLookupByLibrary.simpleMessage("تصنيف جديد"),
    "newProduct": MessageLookupByLibrary.simpleMessage("منتج جديد"),
    "newWord": MessageLookupByLibrary.simpleMessage("جديد"),
    "noAddons": MessageLookupByLibrary.simpleMessage("لا توجد إضافات"),
    "noBiometricsRegistered": MessageLookupByLibrary.simpleMessage(
      "لا توجد بصمات مسجلة على هذا الجهاز.",
    ),
    "noCategories": MessageLookupByLibrary.simpleMessage("لا توجد تصنيفات"),
    "noCategory": MessageLookupByLibrary.simpleMessage("بدون تصنيف"),
    "noOrdersFound": MessageLookupByLibrary.simpleMessage("لا توجد طلبات."),
    "noPausedOrders": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات معلقة",
    ),
    "noProducts": MessageLookupByLibrary.simpleMessage("لا توجد منتجات"),
    "noSupplier": MessageLookupByLibrary.simpleMessage("بدون مورد"),
    "noTransactions": MessageLookupByLibrary.simpleMessage(
      "لا توجد قيود مسجلة.",
    ),
    "numHour": m18,
    "numbersFormat": MessageLookupByLibrary.simpleMessage("تنسيق الأرقام"),
    "onboardingGetStarted": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
    "onboardingNext": MessageLookupByLibrary.simpleMessage("التالي"),
    "onboardingSkip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "onboardingSubtitle1": MessageLookupByLibrary.simpleMessage(
      "نظام نقاط البيع الذكي المصمم للسرعة والبساطة. أدر كافتيرياك باحترافية.",
    ),
    "onboardingSubtitle2": MessageLookupByLibrary.simpleMessage(
      "من عملية الدفع إلى سجل الطلبات، احتفظ بسجل كامل لجميع المعاملات مع تقارير مفصّلة.",
    ),
    "onboardingSubtitle3": MessageLookupByLibrary.simpleMessage(
      "أعدّ قائمة منتجاتك، خصّص إعداداتك، وابدأ في استقبال الطلبات خلال دقائق.",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "مرحباً بك في تطبيق الكافتيريا",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage("تتبّع كل طلب"),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage("جاهز للانطلاق!"),
    "orderDeleted": MessageLookupByLibrary.simpleMessage("تم حذف الطلب"),
    "orderHistory": MessageLookupByLibrary.simpleMessage("سجل الطلبات"),
    "orderId": m19,
    "orderIndex": m20,
    "orderLoaded": MessageLookupByLibrary.simpleMessage("تم تحميل الطلب"),
    "orderNotes": MessageLookupByLibrary.simpleMessage("ملاحظات الطلب"),
    "orderPaused": MessageLookupByLibrary.simpleMessage("تم تعليق الطلب"),
    "orderSaved": m21,
    "orderServedSuccess": m22,
    "orderUpdatedSuccessfully": m23,
    "osNotSupported": MessageLookupByLibrary.simpleMessage(
      "نظام التشغيل هذا لا يدعم المصادقة المحلية.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("كلمة السر"),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "يجب أن تكون كلمة السر 6 أحرف على الأقل",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "كلمات السر غير متطابقة",
    ),
    "pauseOrder": MessageLookupByLibrary.simpleMessage("تعليق الطلب"),
    "pausedOrders": MessageLookupByLibrary.simpleMessage("الطلبات المعلقة"),
    "pending": MessageLookupByLibrary.simpleMessage("قيد الانتظار"),
    "permissionDenied": MessageLookupByLibrary.simpleMessage("تم رفض الإذن"),
    "permissionRequired": MessageLookupByLibrary.simpleMessage("الإذن مطلوب"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "plain": MessageLookupByLibrary.simpleMessage("سادة"),
    "pleaseAuthenticateToConfirm": MessageLookupByLibrary.simpleMessage(
      "يرجى المصادقة للتأكد من هويتك",
    ),
    "pleaseSetUpBiometrics": MessageLookupByLibrary.simpleMessage(
      "يرجى إعداد بصمة الوجه أو الأصبع في إعدادات الجهاز.",
    ),
    "posTerminal": MessageLookupByLibrary.simpleMessage("الكاشير"),
    "price": MessageLookupByLibrary.simpleMessage("السعر"),
    "printReport": MessageLookupByLibrary.simpleMessage("طباعة التقرير"),
    "processedItems": m24,
    "product": MessageLookupByLibrary.simpleMessage("منتج"),
    "productCount": m25,
    "productName": MessageLookupByLibrary.simpleMessage("اسم المتتج"),
    "products": MessageLookupByLibrary.simpleMessage("المنتجات"),
    "profits": MessageLookupByLibrary.simpleMessage("الأرباح"),
    "quantity": MessageLookupByLibrary.simpleMessage("الكمية"),
    "quantityLabel": m26,
    "quickNavigation": MessageLookupByLibrary.simpleMessage("التنقل السريع"),
    "registerSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الحساب بنجاح",
    ),
    "removeAllItemsFromTheCart": MessageLookupByLibrary.simpleMessage(
      "هل تريد إزالة جميع الأصناف من السلة؟",
    ),
    "replace": MessageLookupByLibrary.simpleMessage("استبدال"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("استبدال الكل"),
    "required": MessageLookupByLibrary.simpleMessage("مطلوب"),
    "resetAll": MessageLookupByLibrary.simpleMessage("إعادة ضبط"),
    "resetError": m27,
    "resetFailed": MessageLookupByLibrary.simpleMessage("فشل إعادة الضبط"),
    "resetNow": MessageLookupByLibrary.simpleMessage("إعادة الضبط الآن"),
    "resetSettings": MessageLookupByLibrary.simpleMessage(
      "إعادة ضبط الإعدادات؟",
    ),
    "resetToDefault": MessageLookupByLibrary.simpleMessage(
      "إعادة الضبط الافتراضي",
    ),
    "restoreAllAppSettingsToFactoryDefaults":
        MessageLookupByLibrary.simpleMessage(
          "إعادة كافة إعدادات التطبيق إلى ضبط المصنع",
        ),
    "restoreDatabase": MessageLookupByLibrary.simpleMessage(
      "استعادة قاعدة البيانات",
    ),
    "resumeOrder": MessageLookupByLibrary.simpleMessage("استئناف الطلب"),
    "reviewOrder": MessageLookupByLibrary.simpleMessage("مراجعة الطلب"),
    "sar": MessageLookupByLibrary.simpleMessage("ر.ي"),
    "saudiRiyal": MessageLookupByLibrary.simpleMessage("- ريال يمني"),
    "save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "saveAddon": MessageLookupByLibrary.simpleMessage("حفظ الإضافة"),
    "saveAllHistoryToExcelXlsx": MessageLookupByLibrary.simpleMessage(
      "حفظ السجل بالكامل إلى ملف (Excel (.xlsx",
    ),
    "saveBuffetBackup": MessageLookupByLibrary.simpleMessage(
      "حفظ نسخة احتياطية للكافتيريا",
    ),
    "saveCategory": MessageLookupByLibrary.simpleMessage("حفظ التصنيف"),
    "saveProduct": MessageLookupByLibrary.simpleMessage("حفظ المنتج"),
    "saveToDefault": MessageLookupByLibrary.simpleMessage(
      "حفظ في الموقع الافتراضي",
    ),
    "saveToDefaultBackups": MessageLookupByLibrary.simpleMessage(
      "حفظ في الافتراضي (backups/)",
    ),
    "saved": MessageLookupByLibrary.simpleMessage("تم الحفظ"),
    "savedSuccessfully": MessageLookupByLibrary.simpleMessage("تم الحفظ بنجاح"),
    "savedTo": m28,
    "savedToBackups": m29,
    "search": MessageLookupByLibrary.simpleMessage("بحث"),
    "searchCountry": MessageLookupByLibrary.simpleMessage("البحث عن الدولة..."),
    "searchProducts": MessageLookupByLibrary.simpleMessage(
      "البحث عن المنتجات...",
    ),
    "selectCategory": MessageLookupByLibrary.simpleMessage("اختر التصنيف"),
    "selectCountry": MessageLookupByLibrary.simpleMessage("اختر الدولة"),
    "selectFolder": MessageLookupByLibrary.simpleMessage("اختر مجلدًا"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("اختر اللغة"),
    "selectLocation": MessageLookupByLibrary.simpleMessage("اختيار الموقع"),
    "selectSupplier": MessageLookupByLibrary.simpleMessage("اختر المورد"),
    "selectedCount": m30,
    "served": MessageLookupByLibrary.simpleMessage("تم التقديم"),
    "settings": MessageLookupByLibrary.simpleMessage("الإعدادت"),
    "settingsRestoredToDefaults": MessageLookupByLibrary.simpleMessage(
      "تم استعادة الإعدادات الافتراضية بنجاح",
    ),
    "shareCsv": MessageLookupByLibrary.simpleMessage("مشاركة ملف CSV"),
    "shareFile": MessageLookupByLibrary.simpleMessage("مشاركة الملف"),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "skipAll": MessageLookupByLibrary.simpleMessage("تخطي الكل"),
    "soon": MessageLookupByLibrary.simpleMessage("قريباً..."),
    "status": MessageLookupByLibrary.simpleMessage("الحالة"),
    "storagePermissionMessage": MessageLookupByLibrary.simpleMessage(
      "مطلوب الوصول إلى التخزين لحفظ النسخ الاحتياطية. يرجى منح الإذن للمتابعة.",
    ),
    "success": MessageLookupByLibrary.simpleMessage("نجاح"),
    "supplier": MessageLookupByLibrary.simpleMessage("المورد"),
    "supplierName": MessageLookupByLibrary.simpleMessage("اسم المورد"),
    "suppliers": MessageLookupByLibrary.simpleMessage("الموردين"),
    "swappedMins": MessageLookupByLibrary.simpleMessage("تم التبديل"),
    "systemDefault": MessageLookupByLibrary.simpleMessage(
      "تلقائي (لغة النظام)",
    ),
    "systemResetSuccessfulRestarting": MessageLookupByLibrary.simpleMessage(
      "تمت إعادة ضبط النظام بنجاح! جاري إعادة التشغيل...",
    ),
    "tapAnItemToPinItToTheTop": MessageLookupByLibrary.simpleMessage(
      "اضغط على صنف لتثبيته في الأعلى",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("مظهر التطبيق"),
    "thisWillOverwriteAllCurrentBuffetDataTheAppWill":
        MessageLookupByLibrary.simpleMessage(
          "سيؤدي هذا إلى استبدال كافة بيانات الكافتيريا الحالية. سيتم إعادة تشغيل التطبيق تلقائياً.",
        ),
    "thisWillRevertYourCurrencyNumbersAndAppNameTo":
        MessageLookupByLibrary.simpleMessage(
          "سيؤدي هذا إلى إعادة العملة، الأرقام، واسم الكافتيريا إلى الوضع الافتراضي. لا يمكن التراجع عن هذا الإجراء.",
        ),
    "thisWillWipeYourEntireDatabaseAreYouAbsolutelySure":
        MessageLookupByLibrary.simpleMessage(
          "سيؤدي هذا إلى مسح قاعدة البيانات بالكامل. هل أنت متأكد تماماً؟",
        ),
    "timeFormat": MessageLookupByLibrary.simpleMessage("تنسيق الوقت"),
    "tooManyAttemptsLockout": MessageLookupByLibrary.simpleMessage(
      "محاولات كثيرة جداً. تم إيقاف المصادقة مؤقتاً.",
    ),
    "tooManyAttemptsRetry": MessageLookupByLibrary.simpleMessage(
      "محاولات كثيرة جداً. يرجى المحاولة بعد 30 ثانية.",
    ),
    "total": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "totalAmount": MessageLookupByLibrary.simpleMessage("إجمالي المبلغ"),
    "totalPaid": MessageLookupByLibrary.simpleMessage("إجمالي المدفوع"),
    "transactionType": MessageLookupByLibrary.simpleMessage("نوع القيد"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("بدون تصنيف"),
    "updateItem": MessageLookupByLibrary.simpleMessage("تحديث الصنف"),
    "usDollar": MessageLookupByLibrary.simpleMessage("\$ - دولار أمريكي"),
    "verifyIdentity": MessageLookupByLibrary.simpleMessage("تحقق من الهوية"),
    "versionUnknown": MessageLookupByLibrary.simpleMessage("إصدار غير معروف"),
    "welcomeToBuffet": MessageLookupByLibrary.simpleMessage(
      "مرحباً بك في كافتيريا",
    ),
    "welcomeToBuffetPreviewAr": MessageLookupByLibrary.simpleMessage(
      "مرحباً بك في كافتيريا",
    ),
    "welcomeToBuffetPreviewEn": MessageLookupByLibrary.simpleMessage(
      "Welcome to Buffet",
    ),
    "whatsappEmail": MessageLookupByLibrary.simpleMessage(
      "واتساب / بريد إلكتروني",
    ),
  };
}
