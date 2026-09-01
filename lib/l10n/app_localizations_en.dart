// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sar => 'SAR';

  @override
  String selectedCount(int count) {
    return '$count Selected';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'SAVE';

  @override
  String editingOrder(String id) {
    return 'Editing Order $id';
  }

  @override
  String get editProduct => 'Edit Product';

  @override
  String get noProducts => 'There are no products';

  @override
  String importError(String error) {
    return 'Import Error: $error';
  }

  @override
  String get buffetName => 'Buffet Name';

  @override
  String get businessInfo => 'Business Info';

  @override
  String get localization => 'Localization';

  @override
  String get appLanguage => 'App Language';

  @override
  String get databaseReports => 'Database & Reports';

  @override
  String get exportOrders => 'Export Orders';

  @override
  String get saveAllHistoryToExcelXlsx => 'Save all history to Excel (.xlsx)';

  @override
  String get factoryReset => 'Factory Reset';

  @override
  String get deleteAllProductsAndHistory => 'Delete all products and history';

  @override
  String appVersionVersion(String version) {
    return 'App Version: v$version';
  }

  @override
  String get versionUnknown => 'Version Unknown';

  @override
  String get dangerousAction => 'Dangerous Action!';

  @override
  String get thisWillWipeYourEntireDatabaseAreYouAbsolutelySure =>
      'This will wipe your entire database. Are you absolutely sure?';

  @override
  String get resetAll => 'RESET ALL';

  @override
  String get editBuffetName => 'Edit Buffet Name';

  @override
  String get enterBuffetName => 'Enter buffet name';

  @override
  String get settings => 'Settings';

  @override
  String get catalog => 'Catalog';

  @override
  String exportType(String type) {
    return 'Export $type';
  }

  @override
  String importType(String type) {
    return 'Import $type';
  }

  @override
  String get products => 'Products';

  @override
  String get addons => 'Add-ons';

  @override
  String get newProduct => 'New Product';

  @override
  String get newAddon => 'New Add-on';

  @override
  String processedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Processed $count items',
      one: 'Processed 1 item',
      zero: 'No items processed',
    );
    return '$_temp0';
  }

  @override
  String get deleteItems => 'Delete Items?';

  @override
  String deleteWarning(int count) {
    return 'Delete $count items? This cannot be undone.';
  }

  @override
  String get addNewProduct => 'Add New Product';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get basePrice => 'Base Price';

  @override
  String get saveProduct => 'Save Product';

  @override
  String editAddon(String name) {
    return 'Edit $name';
  }

  @override
  String get price => 'Price';

  @override
  String get saveAddon => 'Save Add-on';

  @override
  String get exportOptions => 'Export Options';

  @override
  String get saveToDefault => 'Save to Default';

  @override
  String savedTo(String path) {
    return 'Saved to $path';
  }

  @override
  String get selectLocation => 'Select Location';

  @override
  String get chooseFolder => 'Choose a custom folder';

  @override
  String get savedSuccessfully => 'Saved successfully';

  @override
  String get shareCsv => 'Share CSV';

  @override
  String get whatsappEmail => 'WhatsApp/Email';

  @override
  String get duplicates => 'Duplicates:';

  @override
  String get skipAll => 'Skip All';

  @override
  String get replaceAll => 'Replace All';

  @override
  String get exists => 'EXISTS';

  @override
  String get newWord => 'NEW';

  @override
  String get skip => 'Skip';

  @override
  String get replace => 'Replace';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get noAddons => 'There are no add-ons';

  @override
  String get addAddonsNow => 'Add new add-ons now!';

  @override
  String errorOccurred(String error) {
    return 'Error: $error';
  }

  @override
  String get product => 'Product';

  @override
  String get addon => 'Add-on';

  @override
  String get addProductsNow => 'Add new products now!';

  @override
  String clickToOpen(String name) {
    return 'Normal click: Open $name';
  }

  @override
  String get importPreview => 'Import Preview';

  @override
  String get productName => 'Product Name';

  @override
  String get addonName => 'Add-on Name';

  @override
  String get orderHistory => 'Order History';

  @override
  String get noOrdersFound => 'No orders found.';

  @override
  String get pending => 'Pending';

  @override
  String get served => 'Served';

  @override
  String get status => 'STATUS';

  @override
  String get items => 'ITEMS';

  @override
  String get orderNotes => 'ORDER NOTES';

  @override
  String get totalPaid => 'TOTAL PAID';

  @override
  String get markAsServed => 'MARK AS SERVED';

  @override
  String get soon => 'Soon...';

  @override
  String get errorLoadingOrder => 'Error loading order';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deleteConfirmMessage =>
      'This will permanently remove these records from your database.';

  @override
  String orderId(int id) {
    return 'Order #$id';
  }

  @override
  String deleteOrdersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count Orders?',
      one: 'Delete 1 Order?',
    );
    return '$_temp0';
  }

  @override
  String deletedOrdersMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deleted $count orders',
      one: 'Deleted 1 order',
    );
    return '$_temp0';
  }

  @override
  String orderServedSuccess(String orderId) {
    return 'Order $orderId Served';
  }

  @override
  String get posTerminal => 'POS Terminal';

  @override
  String get editCancelled => 'Edit Cancelled';

  @override
  String get clearOrder => 'Clear Order?';

  @override
  String get removeAllItemsFromTheCart => 'Remove all items from the cart?';

  @override
  String get clear => 'Clear';

  @override
  String get cartIsEmpty => 'Cart is empty!';

  @override
  String get failedToSaveOrder => 'Failed to save order. Please try again.';

  @override
  String get cannotPauseWhileEditing =>
      'Cannot pause while editing a saved order';

  @override
  String get pauseOrder => 'Pause Order';

  @override
  String get customerName => 'Customer Name';

  @override
  String get orderPaused => 'Order Paused';

  @override
  String get checkoutSummary => 'Checkout Summary';

  @override
  String get grandTotal => 'Grand Total';

  @override
  String get total => 'Total';

  @override
  String get customerInfo => 'Customer Info';

  @override
  String get enterCustomerName => 'Enter customer name...';

  @override
  String get addOrderNotes => 'Add order notes (optional)...';

  @override
  String get completeSale => 'COMPLETE SALE';

  @override
  String get addNewProductsNow => 'Add new products now!';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get checkout => 'CHECKOUT';

  @override
  String get reviewOrder => 'Review Order';

  @override
  String get plain => 'Plain';

  @override
  String get quantity => 'Quantity';

  @override
  String get free => 'Free';

  @override
  String get errorLoadingAddons => 'Error loading addons';

  @override
  String get addToOrder => 'Add to Order';

  @override
  String get updateItem => 'Update Item';

  @override
  String get pausedOrders => 'Paused Orders';

  @override
  String get noPausedOrders => 'No paused orders';

  @override
  String get orderDeleted => 'Order Deleted';

  @override
  String get delete => 'DELETE';

  @override
  String get resumeOrder => 'RESUME ORDER';

  @override
  String get orderLoaded => 'Order Loaded';

  @override
  String orderUpdatedSuccessfully(String id) {
    return '$id Updated Successfully';
  }

  @override
  String orderSaved(String id) {
    return 'Order $id Saved!';
  }

  @override
  String checkoutError(String e) {
    return 'Checkout Error: $e';
  }

  @override
  String itemsInBasket(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items in basket',
      one: '1 item in basket',
      zero: 'No items in basket',
    );
    return '$_temp0';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String addProductName(String name) {
    return 'Add $name';
  }

  @override
  String editProductName(String name) {
    return 'Edit $name';
  }

  @override
  String orderIndex(int index) {
    return 'Order #$index';
  }

  @override
  String get swappedMins => 'Swapped';

  @override
  String get listView => 'List view';

  @override
  String get gridView => 'Grid view';

  @override
  String get hideSearch => 'Hide search';

  @override
  String get search => 'Search';

  @override
  String get all => 'all';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get dismiss => 'DISMISS';

  @override
  String get errorOccur => 'Error Occurred';

  @override
  String get quickNavigation => 'Quick Navigation';

  @override
  String get numbersFormat => 'Numbers Format';

  @override
  String get currencySign => 'Currency Sign';

  @override
  String get dateFormat => 'Date Format';

  @override
  String get timeFormat => 'Time Format';

  @override
  String numHour(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-Hour',
      one: '1-Hour',
    );
    return '$_temp0';
  }

  @override
  String get backupDatabase => 'Backup Database';

  @override
  String get exportAllDataToAFile => 'Export all data to a file';

  @override
  String get restoreDatabase => 'Restore Database';

  @override
  String get importNewDataFromABackupFile =>
      'Import new data from a backup file';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get restoreAllAppSettingsToFactoryDefaults =>
      'Restore all app settings to factory defaults';

  @override
  String get resetSettings => 'Reset Settings?';

  @override
  String get thisWillRevertYourCurrencyNumbersAndAppNameTo =>
      'This will revert your currency, numbers, and app name to defaults. This action cannot be undone.';

  @override
  String get resetNow => 'Reset Now';

  @override
  String get settingsRestoredToDefaults => 'Settings restored to defaults';

  @override
  String get databaseExportedSuccessfully => 'Database Exported Successfully';

  @override
  String get exportCancelled => 'Export Cancelled';

  @override
  String get permissionDenied => 'Permission Denied';

  @override
  String get importDatabase => 'Import Database?';

  @override
  String get thisWillOverwriteAllCurrentBuffetDataTheAppWill =>
      'This will overwrite all current buffet data. The app will restart automatically.';

  @override
  String get importRestart => 'Import & Restart';

  @override
  String get importSuccessfulRestarting => 'Import Successful! Restarting...';

  @override
  String get importFailed => 'Import Failed';

  @override
  String get saved => 'SAVED';

  @override
  String get livePreview => 'LIVE PREVIEW';

  @override
  String customT(String title) {
    return 'Custom $title...';
  }

  @override
  String get applyChanges => 'Apply Changes';

  @override
  String get systemResetSuccessfulRestarting =>
      'System Reset Successful! Restarting...';

  @override
  String get resetFailed => 'Reset Failed';

  @override
  String get applyLanguage => 'Apply Language';

  @override
  String get saudiRiyal => '- Yemen Riyal';

  @override
  String get usDollar => '\$ - US Dollar';

  @override
  String get biometricAuthentication => 'Biometric Authentication';

  @override
  String get verifyIdentity => 'Verify identity';

  @override
  String get authErrorMessage =>
      'An authentication error occurred. Please try again.';

  @override
  String get pleaseSetUpBiometrics =>
      'Please set up FaceID or TouchID in your device settings.';

  @override
  String get tooManyAttemptsLockout =>
      'Too many attempts. Biometrics have been temporarily disabled.';

  @override
  String get pleaseAuthenticateToConfirm =>
      'Please authenticate to confirm it\'s you';

  @override
  String get biometricsNotAvailable =>
      'Biometrics/PIN are not available on this device.';

  @override
  String get noBiometricsRegistered =>
      'No fingerprints or face data registered on this device.';

  @override
  String get tooManyAttemptsRetry =>
      'Too many attempts. Please try again in 30 seconds.';

  @override
  String get biometricsDisabledUsePasscode =>
      'Biometrics disabled. Please unlock using your phone passcode.';

  @override
  String get osNotSupported =>
      'This operating system does not support local authentication.';

  @override
  String get identityVerified => 'Identity Verified';

  @override
  String get saveBuffetBackup => 'Save Buffet Backup';

  @override
  String resetError(String error) {
    return 'Reset Error: $error';
  }

  @override
  String get invalidFileType => 'Invalid file type';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get tapAnItemToPinItToTheTop => 'Tap an item to pin it to the top';

  @override
  String get categories => 'Categories';

  @override
  String get newCategory => 'New Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get enterName => 'Enter name...';

  @override
  String get saveCategory => 'Save Category';

  @override
  String get deletedSuccessfully => 'Deleted Successfully';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get egChickenBurger => 'e.g. Chicken Burger';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get addNewCategory => 'Add New Category';

  @override
  String get egExtraCheese => 'e.g. Extra Cheese';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get storagePermissionMessage =>
      'Storage access is needed to save backups. Please grant permission to continue.';

  @override
  String get grant => 'Grant';

  @override
  String get basicDetails => 'Basic Details';

  @override
  String get addNewAction => 'ADD NEW ACTION';

  @override
  String get noCategory => 'No Category';

  @override
  String get catExists => 'Exists';

  @override
  String get newCat => 'New Cat';

  @override
  String get importAction => 'Import Now';

  @override
  String get bestBuffet => 'Best Buffet';

  @override
  String get saveToDefaultBackups => 'Save to Default (backups/)';

  @override
  String get selectFolder => 'Select Folder';

  @override
  String get shareFile => 'Share File';

  @override
  String get close => 'close';

  @override
  String savedToBackups(String folder) {
    return 'Saved to $folder';
  }

  @override
  String get exportFailed => 'Export Failed';

  @override
  String get success => 'success';

  @override
  String get exportNow => 'Export Now';

  @override
  String get invalidPattern => 'Invalid Pattern';

  @override
  String get welcomeToBuffet => 'Welcome to Buffet';

  @override
  String get noCategories => 'There are no categories';

  @override
  String get addNewCategoriesNow => 'Add new categories now!';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Products',
      one: '1 Product',
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
  String get welcomeToBuffetPreviewAr => 'مرحباً بك في بوفيه';

  @override
  String get egDateFormat => 'e.g. yyyy-MM-dd';

  @override
  String get onboardingTitle1 => 'Welcome to BuffetPOS';

  @override
  String get onboardingSubtitle1 =>
      'Your smart point-of-sale system designed for speed and simplicity. Manage your buffet like a pro.';

  @override
  String get onboardingTitle2 => 'Track Every Order';

  @override
  String get onboardingSubtitle2 =>
      'From checkout to order history, keep a complete record of all transactions with detailed reports.';

  @override
  String get onboardingTitle3 => 'Ready to Go!';

  @override
  String get onboardingSubtitle3 =>
      'Set up your catalog, customize your settings, and start taking orders in minutes.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get systemDefault => 'System Default';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get arabic => 'العربية (Arabic)';

  @override
  String get english => 'English';

  @override
  String get login => 'Log In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log In';

  @override
  String get searchCountry => 'Search country...';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get emailAlreadyRegistered => 'Email is already registered';

  @override
  String get emailNotRegistered => 'Email is not registered';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get loginSuccess => 'Logged in successfully';

  @override
  String get registerSuccess => 'Registered successfully';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get selectCountry => 'Select the date';

  @override
  String get suppliers => 'Suppliers';

  @override
  String get accounts => 'Accounts';

  @override
  String get addSupplier => 'Add Supplier';

  @override
  String get editSupplier => 'Edit Supplier';

  @override
  String get supplierName => 'Supplier Name';

  @override
  String get address => 'Address';

  @override
  String get credit => 'Credit';

  @override
  String get debit => 'Debit';

  @override
  String get balance => 'Balance';

  @override
  String get dailyDebit => 'Daily Debit';

  @override
  String get dailyCredit => 'Daily Credit';

  @override
  String get dailySales => 'Daily Sales';

  @override
  String get netProfit => 'Net Profit';

  @override
  String get profits => 'Profits';

  @override
  String get supplier => 'Supplier';

  @override
  String get selectSupplier => 'Select Supplier';

  @override
  String get noSupplier => 'No Supplier';

  @override
  String get addTransaction => 'Add Entry';

  @override
  String get transactionType => 'Entry Type';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description';

  @override
  String get date => 'Date';

  @override
  String get linkedProducts => 'Linked Products';

  @override
  String get linkedAddons => 'Linked Add-ons';

  @override
  String get printReport => 'Print Report';

  @override
  String get exportAccountsReport => 'Export Daily Accounts Report';

  @override
  String get ledger => 'Ledger / Entries';

  @override
  String get noTransactions => 'No entries found.';

  @override
  String get debitPayment => 'Debit (Payment)';

  @override
  String get creditPurchase => 'Credit (Purchase)';
}
