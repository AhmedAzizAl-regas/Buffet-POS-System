// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get sar => 'ر.ي';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديد $count طلب',
      many: 'تم تحديد $count طلباً',
      few: 'تم تحديد $count طلبات',
      two: 'تم تحديد طلبين',
      one: 'تم تحديد طلب واحد',
      zero: 'لا يوجد تحديد',
    );
    return '$_temp0';
  }

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String editingOrder(String id) {
    return 'تعديل طلب $id';
  }

  @override
  String get editProduct => 'تعديل المنتج';

  @override
  String get noProducts => 'لا توجد منتجات';

  @override
  String importError(String error) {
    return 'خطأ في الاستيراد: $error';
  }

  @override
  String get buffetName => 'اسم الكافتيريا';

  @override
  String get businessInfo => 'معلومات العمل';

  @override
  String get localization => 'الإعدادات المحلية';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get databaseReports => 'قاعدة البيانات والتقارير';

  @override
  String get exportOrders => 'تصدير الطلبات';

  @override
  String get saveAllHistoryToExcelXlsx =>
      'حفظ السجل بالكامل إلى ملف (Excel (.xlsx';

  @override
  String get factoryReset => 'إعادة ضبط المصنع';

  @override
  String get deleteAllProductsAndHistory => 'حذف جميع المنتجات والسجل';

  @override
  String appVersionVersion(String version) {
    return 'إصدار التطبيق: v$version';
  }

  @override
  String get versionUnknown => 'إصدار غير معروف';

  @override
  String get dangerousAction => 'إجراء خطير!';

  @override
  String get thisWillWipeYourEntireDatabaseAreYouAbsolutelySure =>
      'سيؤدي هذا إلى مسح قاعدة البيانات بالكامل. هل أنت متأكد تماماً؟';

  @override
  String get resetAll => 'إعادة ضبط';

  @override
  String get editBuffetName => 'تعديل اسم الكافتيريا';

  @override
  String get enterBuffetName => 'أدخل اسم الكافتيريا';

  @override
  String get settings => 'الإعدادت';

  @override
  String get catalog => 'الكتالوج';

  @override
  String exportType(String type) {
    return 'تصدير $type';
  }

  @override
  String importType(String type) {
    return 'استيراد $type';
  }

  @override
  String get products => 'المنتجات';

  @override
  String get addons => 'الإضافات';

  @override
  String get newProduct => 'منتج جديد';

  @override
  String get newAddon => 'إضافة جديدة';

  @override
  String processedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت معالجة $count عنصر',
      many: 'تمت معالجة $count عنصراً',
      few: 'تمت معالجة $count عناصر',
      two: 'تمت معالجة عنصرين',
      one: 'تمت معالجة عنصر واحد',
      zero: 'لم يتم معالجة أي عناصر',
    );
    return '$_temp0';
  }

  @override
  String get deleteItems => 'حذف العناصر؟';

  @override
  String deleteWarning(int count) {
    return 'حذف $count من العناصر؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get addNewProduct => 'إضافة منتج جديد';

  @override
  String get required => 'مطلوب';

  @override
  String get invalid => 'غير صالح';

  @override
  String get basePrice => 'السعر الأساسي';

  @override
  String get saveProduct => 'حفظ المنتج';

  @override
  String editAddon(String name) {
    return 'تعديل $name';
  }

  @override
  String get price => 'السعر';

  @override
  String get saveAddon => 'حفظ الإضافة';

  @override
  String get exportOptions => 'خيارات التصدير';

  @override
  String get saveToDefault => 'حفظ في الموقع الافتراضي';

  @override
  String savedTo(String path) {
    return 'تم الحفظ في $path';
  }

  @override
  String get selectLocation => 'اختيار الموقع';

  @override
  String get chooseFolder => 'اختر مجلدًا مخصصًا';

  @override
  String get savedSuccessfully => 'تم الحفظ بنجاح';

  @override
  String get shareCsv => 'مشاركة ملف CSV';

  @override
  String get whatsappEmail => 'واتساب / بريد إلكتروني';

  @override
  String get duplicates => 'العناصر المكررة:';

  @override
  String get skipAll => 'تخطي الكل';

  @override
  String get replaceAll => 'استبدال الكل';

  @override
  String get exists => 'موجود مسبقاً';

  @override
  String get newWord => 'جديد';

  @override
  String get skip => 'تخطي';

  @override
  String get replace => 'استبدال';

  @override
  String get duplicate => 'مكرر';

  @override
  String get noAddons => 'لا توجد إضافات';

  @override
  String get addAddonsNow => 'أضف إضافات جديدة الآن!';

  @override
  String errorOccurred(String error) {
    return 'خطأ: $error';
  }

  @override
  String get product => 'منتج';

  @override
  String get addon => 'إضافة';

  @override
  String get addProductsNow => 'أضف منتجات جديدة الآن!';

  @override
  String clickToOpen(String name) {
    return 'نقرة عادية: فتح $name';
  }

  @override
  String get importPreview => 'معاينة الاستيراد';

  @override
  String get productName => 'اسم المتتج';

  @override
  String get addonName => 'اسم الإضافة';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get noOrdersFound => 'لا توجد طلبات.';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get served => 'تم التقديم';

  @override
  String get status => 'الحالة';

  @override
  String get items => 'الأصناف';

  @override
  String get orderNotes => 'ملاحظات الطلب';

  @override
  String get totalPaid => 'إجمالي المدفوع';

  @override
  String get markAsServed => 'تحديد كمكتمل';

  @override
  String get soon => 'قريباً...';

  @override
  String get errorLoadingOrder => 'خطأ في تحميل الطلب';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get deleteConfirmMessage =>
      'سيؤدي هذا إلى حذف هذه السجلات نهائياً من قاعدة البيانات.';

  @override
  String orderId(int id) {
    return 'طلب رقم $id';
  }

  @override
  String deleteOrdersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count طلب؟',
      many: 'حذف $count طلباً؟',
      few: 'حذف $count طلبات؟',
      two: 'حذف طلبين؟',
      one: 'حذف طلب واحد؟',
    );
    return '$_temp0';
  }

  @override
  String deletedOrdersMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم حذف $count طلب',
      many: 'تم حذف $count طلباً',
      few: 'تم حذف $count طلبات',
      two: 'تم حذف طلبين',
      one: 'تم حذف طلب واحد',
    );
    return '$_temp0';
  }

  @override
  String orderServedSuccess(String orderId) {
    return 'تم تقديم طلب $orderId';
  }

  @override
  String get posTerminal => 'الكاشير';

  @override
  String get editCancelled => 'تم إلغاء التعديل';

  @override
  String get clearOrder => 'مسح الطلب؟';

  @override
  String get removeAllItemsFromTheCart =>
      'هل تريد إزالة جميع الأصناف من السلة؟';

  @override
  String get clear => 'مسح';

  @override
  String get cartIsEmpty => 'السلة فارغة!';

  @override
  String get failedToSaveOrder => 'فشل في حفظ الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get cannotPauseWhileEditing =>
      'لا يمكن تعليق الطلب أثناء تعديل طلب محفوظ';

  @override
  String get pauseOrder => 'تعليق الطلب';

  @override
  String get customerName => 'اسم العميل';

  @override
  String get orderPaused => 'تم تعليق الطلب';

  @override
  String get checkoutSummary => 'ملخص الدفع';

  @override
  String get grandTotal => 'الإجمالي النهائي';

  @override
  String get total => 'الإجمالي';

  @override
  String get customerInfo => 'معلومات العميل';

  @override
  String get enterCustomerName => 'أدخل اسم العميل...';

  @override
  String get addOrderNotes => 'إضافة ملاحظات (اختياري)...';

  @override
  String get completeSale => 'إتمام البيع';

  @override
  String get addNewProductsNow => 'أضف منتجات جديدة الآن!';

  @override
  String get totalAmount => 'إجمالي المبلغ';

  @override
  String get checkout => 'دفع';

  @override
  String get reviewOrder => 'مراجعة الطلب';

  @override
  String get plain => 'سادة';

  @override
  String get quantity => 'الكمية';

  @override
  String get free => 'مجاني';

  @override
  String get errorLoadingAddons => 'خطأ في تحميل الإضافات';

  @override
  String get addToOrder => 'إضافة للطلب';

  @override
  String get updateItem => 'تحديث الصنف';

  @override
  String get pausedOrders => 'الطلبات المعلقة';

  @override
  String get noPausedOrders => 'لا توجد طلبات معلقة';

  @override
  String get orderDeleted => 'تم حذف الطلب';

  @override
  String get delete => 'حذف';

  @override
  String get resumeOrder => 'استئناف الطلب';

  @override
  String get orderLoaded => 'تم تحميل الطلب';

  @override
  String orderUpdatedSuccessfully(String id) {
    return 'تم تحديث طلب $id بنجاح';
  }

  @override
  String orderSaved(String id) {
    return 'تم حفظ طلب $id!';
  }

  @override
  String checkoutError(String e) {
    return 'خطأ في الدفع: $e';
  }

  @override
  String itemsInBasket(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صنف في السلة',
      many: '$count صنفاً في السلة',
      few: '$count أصناف في السلة',
      two: 'صنفين في السلة',
      one: 'صنف واحد في السلة',
      zero: 'السلة فارغة',
    );
    return '$_temp0';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صنف',
      many: '$count صنفاً',
      few: '$count أصناف',
      two: 'صنفين',
      one: 'صنف واحد',
    );
    return '$_temp0';
  }

  @override
  String addProductName(String name) {
    return 'إضافة $name';
  }

  @override
  String editProductName(String name) {
    return 'تعديل $name';
  }

  @override
  String orderIndex(int index) {
    return 'طلب رقم $index';
  }

  @override
  String get swappedMins => 'تم التبديل';

  @override
  String get listView => 'عرض القائمة';

  @override
  String get gridView => 'عرض الشبكة';

  @override
  String get hideSearch => 'إخفاء البحث';

  @override
  String get search => 'بحث';

  @override
  String get all => 'الكل';

  @override
  String get confirmOrder => 'تأكيد الطلب';

  @override
  String get dismiss => 'تجاهل';

  @override
  String get errorOccur => 'حدث خطأ';

  @override
  String get quickNavigation => 'التنقل السريع';

  @override
  String get numbersFormat => 'تنسيق الأرقام';

  @override
  String get currencySign => 'رمز العملة';

  @override
  String get dateFormat => 'تنسيق التاريخ';

  @override
  String get timeFormat => 'تنسيق الوقت';

  @override
  String numHour(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعة',
      two: 'ساعتان',
      one: 'ساعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get backupDatabase => 'نسخ احتياطي لقاعدة البيانات';

  @override
  String get exportAllDataToAFile => 'تصدير كافة البيانات إلى ملف خارجي';

  @override
  String get restoreDatabase => 'استعادة قاعدة البيانات';

  @override
  String get importNewDataFromABackupFile =>
      'استيراد بيانات جديدة من ملف نسخة احتياطية';

  @override
  String get resetToDefault => 'إعادة الضبط الافتراضي';

  @override
  String get restoreAllAppSettingsToFactoryDefaults =>
      'إعادة كافة إعدادات التطبيق إلى ضبط المصنع';

  @override
  String get resetSettings => 'إعادة ضبط الإعدادات؟';

  @override
  String get thisWillRevertYourCurrencyNumbersAndAppNameTo =>
      'سيؤدي هذا إلى إعادة العملة، الأرقام، واسم الكافتيريا إلى الوضع الافتراضي. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get resetNow => 'إعادة الضبط الآن';

  @override
  String get settingsRestoredToDefaults =>
      'تم استعادة الإعدادات الافتراضية بنجاح';

  @override
  String get databaseExportedSuccessfully => 'تم تصدير قاعدة البيانات بنجاح';

  @override
  String get exportCancelled => 'تم إلغاء التصدير';

  @override
  String get permissionDenied => 'تم رفض الإذن';

  @override
  String get importDatabase => 'استيراد قاعدة البيانات؟';

  @override
  String get thisWillOverwriteAllCurrentBuffetDataTheAppWill =>
      'سيؤدي هذا إلى استبدال كافة بيانات الكافتيريا الحالية. سيتم إعادة تشغيل التطبيق تلقائياً.';

  @override
  String get importRestart => 'استيراد وإعادة تشغيل';

  @override
  String get importSuccessfulRestarting =>
      'تم الاستيراد بنجاح! جاري إعادة التشغيل...';

  @override
  String get importFailed => 'فشل الاستيراد';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get livePreview => 'معاينة مباشرة';

  @override
  String customT(String title) {
    return '$title مخصص...';
  }

  @override
  String get applyChanges => 'تطبيق التغييرات';

  @override
  String get systemResetSuccessfulRestarting =>
      'تمت إعادة ضبط النظام بنجاح! جاري إعادة التشغيل...';

  @override
  String get resetFailed => 'فشل إعادة الضبط';

  @override
  String get applyLanguage => 'تطبيق اللغة';

  @override
  String get saudiRiyal => '- ريال يمني';

  @override
  String get usDollar => '\$ - دولار أمريكي';

  @override
  String get biometricAuthentication => 'المصادقة الحيوية';

  @override
  String get verifyIdentity => 'تحقق من الهوية';

  @override
  String get authErrorMessage =>
      'حدث خطأ أثناء المصادقة. يرجى المحاولة مرة أخرى.';

  @override
  String get pleaseSetUpBiometrics =>
      'يرجى إعداد بصمة الوجه أو الأصبع في إعدادات الجهاز.';

  @override
  String get tooManyAttemptsLockout =>
      'محاولات كثيرة جداً. تم إيقاف المصادقة مؤقتاً.';

  @override
  String get pleaseAuthenticateToConfirm => 'يرجى المصادقة للتأكد من هويتك';

  @override
  String get biometricsNotAvailable =>
      'البصمة أو رمز الأمان غير متوفر في هذا الجهاز.';

  @override
  String get noBiometricsRegistered => 'لا توجد بصمات مسجلة على هذا الجهاز.';

  @override
  String get tooManyAttemptsRetry =>
      'محاولات كثيرة جداً. يرجى المحاولة بعد 30 ثانية.';

  @override
  String get biometricsDisabledUsePasscode =>
      'البصمة معطلة. يرجى فتح القفل باستخدام رمز مرور الهاتف.';

  @override
  String get osNotSupported => 'نظام التشغيل هذا لا يدعم المصادقة المحلية.';

  @override
  String get identityVerified => 'تم التحقق من الهوية';

  @override
  String get saveBuffetBackup => 'حفظ نسخة احتياطية للكافتيريا';

  @override
  String resetError(String error) {
    return 'خطأ في إعادة الضبط: $error';
  }

  @override
  String get invalidFileType => 'نوع الملف غير صالح';

  @override
  String get searchProducts => 'البحث عن المنتجات...';

  @override
  String get tapAnItemToPinItToTheTop => 'اضغط على صنف لتثبيته في الأعلى';

  @override
  String get categories => 'التصنيفات';

  @override
  String get newCategory => 'تصنيف جديد';

  @override
  String get editCategory => 'تعديل التصنيف';

  @override
  String get categoryName => 'اسم التصنيف';

  @override
  String get enterName => 'أدخل الاسم...';

  @override
  String get saveCategory => 'حفظ التصنيف';

  @override
  String get deletedSuccessfully => 'تم الحذف بنجاح';

  @override
  String get uncategorized => 'بدون تصنيف';

  @override
  String get egChickenBurger => 'مثل: برجر دجاج';

  @override
  String get category => 'التصنيف';

  @override
  String get selectCategory => 'اختر التصنيف';

  @override
  String get addNewCategory => 'إضافة تصنيف جديد';

  @override
  String get egExtraCheese => 'مثل: جبنة إضافية';

  @override
  String get permissionRequired => 'الإذن مطلوب';

  @override
  String get storagePermissionMessage =>
      'مطلوب الوصول إلى التخزين لحفظ النسخ الاحتياطية. يرجى منح الإذن للمتابعة.';

  @override
  String get grant => 'منح';

  @override
  String get basicDetails => 'التفاصيل الأساسية';

  @override
  String get addNewAction => 'إضافة إجراء جديد';

  @override
  String get noCategory => 'بدون تصنيف';

  @override
  String get catExists => 'موجود';

  @override
  String get newCat => 'تصنيف جديد';

  @override
  String get importAction => 'استيراد الآن';

  @override
  String get bestBuffet => 'أفضل كافتيريا';

  @override
  String get saveToDefaultBackups => 'حفظ في الافتراضي (backups/)';

  @override
  String get selectFolder => 'اختر مجلدًا';

  @override
  String get shareFile => 'مشاركة الملف';

  @override
  String get close => 'إغلاق';

  @override
  String savedToBackups(String folder) {
    return 'تم الحفظ في $folder';
  }

  @override
  String get exportFailed => 'فشل التصدير';

  @override
  String get success => 'نجاح';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get invalidPattern => 'تنسيق غير صالح';

  @override
  String get welcomeToBuffet => 'مرحباً بك في كافتيريا';

  @override
  String get noCategories => 'لا توجد تصنيفات';

  @override
  String get addNewCategoriesNow => 'أضف تصنيفات جديدة الآن!';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج',
      many: '$count منتجاً',
      few: '$count منتجات',
      two: 'منتجين',
      one: 'منتج واحد',
    );
    return '$_temp0';
  }

  @override
  String quantityLabel(String count, String name) {
    return '${count}x $name';
  }

  @override
  String addonPrefix(String name) {
    return '+ $name';
  }

  @override
  String get welcomeToBuffetPreviewEn => 'Welcome to Buffet';

  @override
  String get welcomeToBuffetPreviewAr => 'مرحباً بك في كافتيريا';

  @override
  String get egDateFormat => 'مثال: yyyy-MM-dd';

  @override
  String get onboardingTitle1 => 'مرحباً بك في تطبيق الكافتيريا';

  @override
  String get onboardingSubtitle1 =>
      'نظام نقاط البيع الذكي المصمم للسرعة والبساطة. أدر كافتيرياك باحترافية.';

  @override
  String get onboardingTitle2 => 'تتبّع كل طلب';

  @override
  String get onboardingSubtitle2 =>
      'من عملية الدفع إلى سجل الطلبات، احتفظ بسجل كامل لجميع المعاملات مع تقارير مفصّلة.';

  @override
  String get onboardingTitle3 => 'جاهز للانطلاق!';

  @override
  String get onboardingSubtitle3 =>
      'أعدّ قائمة منتجاتك، خصّص إعداداتك، وابدأ في استقبال الطلبات خلال دقائق.';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get systemDefault => 'تلقائي (لغة النظام)';

  @override
  String get themeMode => 'مظهر التطبيق';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية (English)';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get fullName => 'الاسم كامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة السر';

  @override
  String get confirmPassword => 'تأكيد كلمة السر';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get searchCountry => 'البحث عن الدولة...';

  @override
  String get invalidEmail => 'تنسيق البريد الإلكتروني غير صالح';

  @override
  String get passwordsDoNotMatch => 'كلمات السر غير متطابقة';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get emailAlreadyRegistered => 'البريد الإلكتروني مسجل بالفعل';

  @override
  String get emailNotRegistered => 'البريد الإلكتروني غير مسجل';

  @override
  String get incorrectPassword => 'كلمة السر غير صحيحة';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get registerSuccess => 'تم إنشاء الحساب بنجاح';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة السر 6 أحرف على الأقل';

  @override
  String get invalidPhoneNumber => 'رقم الهاتف غير صالح';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get suppliers => 'الموردين';

  @override
  String get accounts => 'الحسابات';

  @override
  String get addSupplier => 'إضافة مورد';

  @override
  String get editSupplier => 'تعديل مورد';

  @override
  String get supplierName => 'اسم المورد';

  @override
  String get address => 'العنوان';

  @override
  String get credit => 'دائن';

  @override
  String get debit => 'مدين';

  @override
  String get balance => 'الرصيد';

  @override
  String get dailyDebit => 'إجمالي المدين اليومي';

  @override
  String get dailyCredit => 'إجمالي الدائن اليومي';

  @override
  String get dailySales => 'المبيعات اليومية';

  @override
  String get netProfit => 'صافي الربح';

  @override
  String get profits => 'الأرباح';

  @override
  String get supplier => 'المورد';

  @override
  String get selectSupplier => 'اختر المورد';

  @override
  String get noSupplier => 'بدون مورد';

  @override
  String get addTransaction => 'إضافة قيد';

  @override
  String get transactionType => 'نوع القيد';

  @override
  String get amount => 'المبلغ';

  @override
  String get description => 'البيان / الوصف';

  @override
  String get date => 'التاريخ';

  @override
  String get linkedProducts => 'المنتجات المرتبطة';

  @override
  String get linkedAddons => 'الإضافات المرتبطة';

  @override
  String get printReport => 'طباعة التقرير';

  @override
  String get exportAccountsReport => 'تصدير تقرير الحسابات اليومي';

  @override
  String get ledger => 'دفتر القيود المحاسبية';

  @override
  String get noTransactions => 'لا توجد قيود مسجلة.';

  @override
  String get debitPayment => 'مدين (سداد نقدي)';

  @override
  String get creditPurchase => 'دائن (شراء بالآجل)';
}
