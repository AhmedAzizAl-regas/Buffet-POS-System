// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(name) => "Add ${name}";

  static String m1(name) => "+ ${name}";

  static String m2(version) => "App Version: v${version}";

  static String m3(e) => "Checkout Error: ${e}";

  static String m4(name) => "Normal click: Open ${name}";

  static String m5(title) => "Custom ${title}...";

  static String m6(count) =>
      "${Intl.plural(count, one: 'Delete 1 Order?', other: 'Delete ${count} Orders?')}";

  static String m7(count) => "Delete ${count} items? This cannot be undone.";

  static String m8(count) =>
      "${Intl.plural(count, one: 'Deleted 1 order', other: 'Deleted ${count} orders')}";

  static String m9(name) => "Edit ${name}";

  static String m10(name) => "Edit ${name}";

  static String m11(id) => "Editing Order ${id}";

  static String m12(error) => "Error: ${error}";

  static String m13(type) => "Export ${type}";

  static String m14(error) => "Import Error: ${error}";

  static String m15(type) => "Import ${type}";

  static String m16(count) =>
      "${Intl.plural(count, one: '1 item', other: '${count} items')}";

  static String m17(count) =>
      "${Intl.plural(count, zero: 'No items in basket', one: '1 item in basket', other: '${count} items in basket')}";

  static String m18(count) =>
      "${Intl.plural(count, one: '1-Hour', other: '${count}-Hour')}";

  static String m19(id) => "Order #${id}";

  static String m20(index) => "Order #${index}";

  static String m21(id) => "Order ${id} Saved!";

  static String m22(orderId) => "Order ${orderId} Served";

  static String m23(id) => "${id} Updated Successfully";

  static String m24(count) =>
      "${Intl.plural(count, zero: 'No items processed', one: 'Processed 1 item', other: 'Processed ${count} items')}";

  static String m25(count) =>
      "${Intl.plural(count, one: '1 Product', other: '${count} Products')}";

  static String m26(count, name) => "${count}x ${name}";

  static String m27(error) => "Reset Error: ${error}";

  static String m28(path) => "Saved to ${path}";

  static String m29(folder) => "Saved to ${folder}";

  static String m30(count) => "${count} Selected";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
    "addAddonsNow": MessageLookupByLibrary.simpleMessage(
      "Add new add-ons now!",
    ),
    "addNewAction": MessageLookupByLibrary.simpleMessage("ADD NEW ACTION"),
    "addNewCategoriesNow": MessageLookupByLibrary.simpleMessage(
      "Add new categories now!",
    ),
    "addNewCategory": MessageLookupByLibrary.simpleMessage("Add New Category"),
    "addNewProduct": MessageLookupByLibrary.simpleMessage("Add New Product"),
    "addNewProductsNow": MessageLookupByLibrary.simpleMessage(
      "Add new products now!",
    ),
    "addOrderNotes": MessageLookupByLibrary.simpleMessage(
      "Add order notes (optional)...",
    ),
    "addProductName": m0,
    "addProductsNow": MessageLookupByLibrary.simpleMessage(
      "Add new products now!",
    ),
    "addSupplier": MessageLookupByLibrary.simpleMessage("Add Supplier"),
    "addToOrder": MessageLookupByLibrary.simpleMessage("Add to Order"),
    "addTransaction": MessageLookupByLibrary.simpleMessage("Add Entry"),
    "addon": MessageLookupByLibrary.simpleMessage("Add-on"),
    "addonName": MessageLookupByLibrary.simpleMessage("Add-on Name"),
    "addonPrefix": m1,
    "addons": MessageLookupByLibrary.simpleMessage("Add-ons"),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "all": MessageLookupByLibrary.simpleMessage("all"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account? Log In",
    ),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "appLanguage": MessageLookupByLibrary.simpleMessage("App Language"),
    "appVersionVersion": m2,
    "applyChanges": MessageLookupByLibrary.simpleMessage("Apply Changes"),
    "applyLanguage": MessageLookupByLibrary.simpleMessage("Apply Language"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية (Arabic)"),
    "authErrorMessage": MessageLookupByLibrary.simpleMessage(
      "An authentication error occurred. Please try again.",
    ),
    "backupDatabase": MessageLookupByLibrary.simpleMessage("Backup Database"),
    "balance": MessageLookupByLibrary.simpleMessage("Balance"),
    "basePrice": MessageLookupByLibrary.simpleMessage("Base Price"),
    "basicDetails": MessageLookupByLibrary.simpleMessage("Basic Details"),
    "bestBuffet": MessageLookupByLibrary.simpleMessage("Best Buffet"),
    "biometricAuthentication": MessageLookupByLibrary.simpleMessage(
      "Biometric Authentication",
    ),
    "biometricsDisabledUsePasscode": MessageLookupByLibrary.simpleMessage(
      "Biometrics disabled. Please unlock using your phone passcode.",
    ),
    "biometricsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Biometrics/PIN are not available on this device.",
    ),
    "buffetName": MessageLookupByLibrary.simpleMessage("Buffet Name"),
    "businessInfo": MessageLookupByLibrary.simpleMessage("Business Info"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotPauseWhileEditing": MessageLookupByLibrary.simpleMessage(
      "Cannot pause while editing a saved order",
    ),
    "cartIsEmpty": MessageLookupByLibrary.simpleMessage("Cart is empty!"),
    "catExists": MessageLookupByLibrary.simpleMessage("Exists"),
    "catalog": MessageLookupByLibrary.simpleMessage("Catalog"),
    "categories": MessageLookupByLibrary.simpleMessage("Categories"),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "categoryName": MessageLookupByLibrary.simpleMessage("Category Name"),
    "checkout": MessageLookupByLibrary.simpleMessage("CHECKOUT"),
    "checkoutError": m3,
    "checkoutSummary": MessageLookupByLibrary.simpleMessage("Checkout Summary"),
    "chooseFolder": MessageLookupByLibrary.simpleMessage(
      "Choose a custom folder",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearOrder": MessageLookupByLibrary.simpleMessage("Clear Order?"),
    "clickToOpen": m4,
    "close": MessageLookupByLibrary.simpleMessage("close"),
    "completeSale": MessageLookupByLibrary.simpleMessage("COMPLETE SALE"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmOrder": MessageLookupByLibrary.simpleMessage("Confirm Order"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "credit": MessageLookupByLibrary.simpleMessage("Credit"),
    "creditPurchase": MessageLookupByLibrary.simpleMessage("Credit (Purchase)"),
    "currencySign": MessageLookupByLibrary.simpleMessage("Currency Sign"),
    "customT": m5,
    "customerInfo": MessageLookupByLibrary.simpleMessage("Customer Info"),
    "customerName": MessageLookupByLibrary.simpleMessage("Customer Name"),
    "dailyCredit": MessageLookupByLibrary.simpleMessage("Daily Credit"),
    "dailyDebit": MessageLookupByLibrary.simpleMessage("Daily Debit"),
    "dailySales": MessageLookupByLibrary.simpleMessage("Daily Sales"),
    "dangerousAction": MessageLookupByLibrary.simpleMessage(
      "Dangerous Action!",
    ),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "databaseExportedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Database Exported Successfully",
    ),
    "databaseReports": MessageLookupByLibrary.simpleMessage(
      "Database & Reports",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "dateFormat": MessageLookupByLibrary.simpleMessage("Date Format"),
    "debit": MessageLookupByLibrary.simpleMessage("Debit"),
    "debitPayment": MessageLookupByLibrary.simpleMessage("Debit (Payment)"),
    "delete": MessageLookupByLibrary.simpleMessage("DELETE"),
    "deleteAll": MessageLookupByLibrary.simpleMessage("Delete All"),
    "deleteAllProductsAndHistory": MessageLookupByLibrary.simpleMessage(
      "Delete all products and history",
    ),
    "deleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "This will permanently remove these records from your database.",
    ),
    "deleteItems": MessageLookupByLibrary.simpleMessage("Delete Items?"),
    "deleteOrdersCount": m6,
    "deleteWarning": m7,
    "deletedOrdersMessage": m8,
    "deletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Deleted Successfully",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "dismiss": MessageLookupByLibrary.simpleMessage("DISMISS"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? Sign Up",
    ),
    "duplicate": MessageLookupByLibrary.simpleMessage("Duplicate"),
    "duplicates": MessageLookupByLibrary.simpleMessage("Duplicates:"),
    "editAddon": m9,
    "editBuffetName": MessageLookupByLibrary.simpleMessage("Edit Buffet Name"),
    "editCancelled": MessageLookupByLibrary.simpleMessage("Edit Cancelled"),
    "editCategory": MessageLookupByLibrary.simpleMessage("Edit Category"),
    "editProduct": MessageLookupByLibrary.simpleMessage("Edit Product"),
    "editProductName": m10,
    "editSupplier": MessageLookupByLibrary.simpleMessage("Edit Supplier"),
    "editingOrder": m11,
    "egChickenBurger": MessageLookupByLibrary.simpleMessage(
      "e.g. Chicken Burger",
    ),
    "egDateFormat": MessageLookupByLibrary.simpleMessage("e.g. yyyy-MM-dd"),
    "egExtraCheese": MessageLookupByLibrary.simpleMessage("e.g. Extra Cheese"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAlreadyRegistered": MessageLookupByLibrary.simpleMessage(
      "Email is already registered",
    ),
    "emailNotRegistered": MessageLookupByLibrary.simpleMessage(
      "Email is not registered",
    ),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterBuffetName": MessageLookupByLibrary.simpleMessage(
      "Enter buffet name",
    ),
    "enterCustomerName": MessageLookupByLibrary.simpleMessage(
      "Enter customer name...",
    ),
    "enterName": MessageLookupByLibrary.simpleMessage("Enter name..."),
    "errorLoadingAddons": MessageLookupByLibrary.simpleMessage(
      "Error loading addons",
    ),
    "errorLoadingOrder": MessageLookupByLibrary.simpleMessage(
      "Error loading order",
    ),
    "errorOccur": MessageLookupByLibrary.simpleMessage("Error Occurred"),
    "errorOccurred": m12,
    "exists": MessageLookupByLibrary.simpleMessage("EXISTS"),
    "exportAccountsReport": MessageLookupByLibrary.simpleMessage(
      "Export Daily Accounts Report",
    ),
    "exportAllDataToAFile": MessageLookupByLibrary.simpleMessage(
      "Export all data to a file",
    ),
    "exportCancelled": MessageLookupByLibrary.simpleMessage("Export Cancelled"),
    "exportFailed": MessageLookupByLibrary.simpleMessage("Export Failed"),
    "exportNow": MessageLookupByLibrary.simpleMessage("Export Now"),
    "exportOptions": MessageLookupByLibrary.simpleMessage("Export Options"),
    "exportOrders": MessageLookupByLibrary.simpleMessage("Export Orders"),
    "exportType": m13,
    "factoryReset": MessageLookupByLibrary.simpleMessage("Factory Reset"),
    "failedToSaveOrder": MessageLookupByLibrary.simpleMessage(
      "Failed to save order. Please try again.",
    ),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "free": MessageLookupByLibrary.simpleMessage("Free"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "grandTotal": MessageLookupByLibrary.simpleMessage("Grand Total"),
    "grant": MessageLookupByLibrary.simpleMessage("Grant"),
    "gridView": MessageLookupByLibrary.simpleMessage("Grid view"),
    "hideSearch": MessageLookupByLibrary.simpleMessage("Hide search"),
    "identityVerified": MessageLookupByLibrary.simpleMessage(
      "Identity Verified",
    ),
    "importAction": MessageLookupByLibrary.simpleMessage("Import Now"),
    "importDatabase": MessageLookupByLibrary.simpleMessage("Import Database?"),
    "importError": m14,
    "importFailed": MessageLookupByLibrary.simpleMessage("Import Failed"),
    "importNewDataFromABackupFile": MessageLookupByLibrary.simpleMessage(
      "Import new data from a backup file",
    ),
    "importPreview": MessageLookupByLibrary.simpleMessage("Import Preview"),
    "importRestart": MessageLookupByLibrary.simpleMessage("Import & Restart"),
    "importSuccessfulRestarting": MessageLookupByLibrary.simpleMessage(
      "Import Successful! Restarting...",
    ),
    "importType": m15,
    "incorrectPassword": MessageLookupByLibrary.simpleMessage(
      "Incorrect password",
    ),
    "invalid": MessageLookupByLibrary.simpleMessage("Invalid"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Invalid email format",
    ),
    "invalidFileType": MessageLookupByLibrary.simpleMessage(
      "Invalid file type",
    ),
    "invalidPattern": MessageLookupByLibrary.simpleMessage("Invalid Pattern"),
    "invalidPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Invalid phone number",
    ),
    "itemCount": m16,
    "items": MessageLookupByLibrary.simpleMessage("ITEMS"),
    "itemsInBasket": m17,
    "ledger": MessageLookupByLibrary.simpleMessage("Ledger / Entries"),
    "lightMode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "linkedAddons": MessageLookupByLibrary.simpleMessage("Linked Add-ons"),
    "linkedProducts": MessageLookupByLibrary.simpleMessage("Linked Products"),
    "listView": MessageLookupByLibrary.simpleMessage("List view"),
    "livePreview": MessageLookupByLibrary.simpleMessage("LIVE PREVIEW"),
    "localization": MessageLookupByLibrary.simpleMessage("Localization"),
    "login": MessageLookupByLibrary.simpleMessage("Log In"),
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "Logged in successfully",
    ),
    "markAsServed": MessageLookupByLibrary.simpleMessage("MARK AS SERVED"),
    "netProfit": MessageLookupByLibrary.simpleMessage("Net Profit"),
    "newAddon": MessageLookupByLibrary.simpleMessage("New Add-on"),
    "newCat": MessageLookupByLibrary.simpleMessage("New Cat"),
    "newCategory": MessageLookupByLibrary.simpleMessage("New Category"),
    "newProduct": MessageLookupByLibrary.simpleMessage("New Product"),
    "newWord": MessageLookupByLibrary.simpleMessage("NEW"),
    "noAddons": MessageLookupByLibrary.simpleMessage("There are no add-ons"),
    "noBiometricsRegistered": MessageLookupByLibrary.simpleMessage(
      "No fingerprints or face data registered on this device.",
    ),
    "noCategories": MessageLookupByLibrary.simpleMessage(
      "There are no categories",
    ),
    "noCategory": MessageLookupByLibrary.simpleMessage("No Category"),
    "noOrdersFound": MessageLookupByLibrary.simpleMessage("No orders found."),
    "noPausedOrders": MessageLookupByLibrary.simpleMessage("No paused orders"),
    "noProducts": MessageLookupByLibrary.simpleMessage("There are no products"),
    "noSupplier": MessageLookupByLibrary.simpleMessage("No Supplier"),
    "noTransactions": MessageLookupByLibrary.simpleMessage("No entries found."),
    "numHour": m18,
    "numbersFormat": MessageLookupByLibrary.simpleMessage("Numbers Format"),
    "onboardingGetStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "onboardingNext": MessageLookupByLibrary.simpleMessage("Next"),
    "onboardingSkip": MessageLookupByLibrary.simpleMessage("Skip"),
    "onboardingSubtitle1": MessageLookupByLibrary.simpleMessage(
      "Your smart point-of-sale system designed for speed and simplicity. Manage your buffet like a pro.",
    ),
    "onboardingSubtitle2": MessageLookupByLibrary.simpleMessage(
      "From checkout to order history, keep a complete record of all transactions with detailed reports.",
    ),
    "onboardingSubtitle3": MessageLookupByLibrary.simpleMessage(
      "Set up your catalog, customize your settings, and start taking orders in minutes.",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Welcome to BuffetPOS",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Track Every Order",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage("Ready to Go!"),
    "orderDeleted": MessageLookupByLibrary.simpleMessage("Order Deleted"),
    "orderHistory": MessageLookupByLibrary.simpleMessage("Order History"),
    "orderId": m19,
    "orderIndex": m20,
    "orderLoaded": MessageLookupByLibrary.simpleMessage("Order Loaded"),
    "orderNotes": MessageLookupByLibrary.simpleMessage("ORDER NOTES"),
    "orderPaused": MessageLookupByLibrary.simpleMessage("Order Paused"),
    "orderSaved": m21,
    "orderServedSuccess": m22,
    "orderUpdatedSuccessfully": m23,
    "osNotSupported": MessageLookupByLibrary.simpleMessage(
      "This operating system does not support local authentication.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "pauseOrder": MessageLookupByLibrary.simpleMessage("Pause Order"),
    "pausedOrders": MessageLookupByLibrary.simpleMessage("Paused Orders"),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "permissionDenied": MessageLookupByLibrary.simpleMessage(
      "Permission Denied",
    ),
    "permissionRequired": MessageLookupByLibrary.simpleMessage(
      "Permission Required",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "plain": MessageLookupByLibrary.simpleMessage("Plain"),
    "pleaseAuthenticateToConfirm": MessageLookupByLibrary.simpleMessage(
      "Please authenticate to confirm it\'s you",
    ),
    "pleaseSetUpBiometrics": MessageLookupByLibrary.simpleMessage(
      "Please set up FaceID or TouchID in your device settings.",
    ),
    "posTerminal": MessageLookupByLibrary.simpleMessage("POS Terminal"),
    "price": MessageLookupByLibrary.simpleMessage("Price"),
    "printReport": MessageLookupByLibrary.simpleMessage("Print Report"),
    "processedItems": m24,
    "product": MessageLookupByLibrary.simpleMessage("Product"),
    "productCount": m25,
    "productName": MessageLookupByLibrary.simpleMessage("Product Name"),
    "products": MessageLookupByLibrary.simpleMessage("Products"),
    "profits": MessageLookupByLibrary.simpleMessage("Profits"),
    "quantity": MessageLookupByLibrary.simpleMessage("Quantity"),
    "quantityLabel": m26,
    "quickNavigation": MessageLookupByLibrary.simpleMessage("Quick Navigation"),
    "registerSuccess": MessageLookupByLibrary.simpleMessage(
      "Registered successfully",
    ),
    "removeAllItemsFromTheCart": MessageLookupByLibrary.simpleMessage(
      "Remove all items from the cart?",
    ),
    "replace": MessageLookupByLibrary.simpleMessage("Replace"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("Replace All"),
    "required": MessageLookupByLibrary.simpleMessage("Required"),
    "resetAll": MessageLookupByLibrary.simpleMessage("RESET ALL"),
    "resetError": m27,
    "resetFailed": MessageLookupByLibrary.simpleMessage("Reset Failed"),
    "resetNow": MessageLookupByLibrary.simpleMessage("Reset Now"),
    "resetSettings": MessageLookupByLibrary.simpleMessage("Reset Settings?"),
    "resetToDefault": MessageLookupByLibrary.simpleMessage("Reset to Default"),
    "restoreAllAppSettingsToFactoryDefaults":
        MessageLookupByLibrary.simpleMessage(
          "Restore all app settings to factory defaults",
        ),
    "restoreDatabase": MessageLookupByLibrary.simpleMessage("Restore Database"),
    "resumeOrder": MessageLookupByLibrary.simpleMessage("RESUME ORDER"),
    "reviewOrder": MessageLookupByLibrary.simpleMessage("Review Order"),
    "sar": MessageLookupByLibrary.simpleMessage("SAR"),
    "saudiRiyal": MessageLookupByLibrary.simpleMessage("- Yemen Riyal"),
    "save": MessageLookupByLibrary.simpleMessage("SAVE"),
    "saveAddon": MessageLookupByLibrary.simpleMessage("Save Add-on"),
    "saveAllHistoryToExcelXlsx": MessageLookupByLibrary.simpleMessage(
      "Save all history to Excel (.xlsx)",
    ),
    "saveBuffetBackup": MessageLookupByLibrary.simpleMessage(
      "Save Buffet Backup",
    ),
    "saveCategory": MessageLookupByLibrary.simpleMessage("Save Category"),
    "saveProduct": MessageLookupByLibrary.simpleMessage("Save Product"),
    "saveToDefault": MessageLookupByLibrary.simpleMessage("Save to Default"),
    "saveToDefaultBackups": MessageLookupByLibrary.simpleMessage(
      "Save to Default (backups/)",
    ),
    "saved": MessageLookupByLibrary.simpleMessage("SAVED"),
    "savedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Saved successfully",
    ),
    "savedTo": m28,
    "savedToBackups": m29,
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchCountry": MessageLookupByLibrary.simpleMessage("Search country..."),
    "searchProducts": MessageLookupByLibrary.simpleMessage(
      "Search products...",
    ),
    "selectCategory": MessageLookupByLibrary.simpleMessage("Select Category"),
    "selectCountry": MessageLookupByLibrary.simpleMessage("Select Date"),
    "selectFolder": MessageLookupByLibrary.simpleMessage("Select Folder"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Select Language"),
    "selectLocation": MessageLookupByLibrary.simpleMessage("Select Location"),
    "selectSupplier": MessageLookupByLibrary.simpleMessage("Select Supplier"),
    "selectedCount": m30,
    "served": MessageLookupByLibrary.simpleMessage("Served"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsRestoredToDefaults": MessageLookupByLibrary.simpleMessage(
      "Settings restored to defaults",
    ),
    "shareCsv": MessageLookupByLibrary.simpleMessage("Share CSV"),
    "shareFile": MessageLookupByLibrary.simpleMessage("Share File"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "skipAll": MessageLookupByLibrary.simpleMessage("Skip All"),
    "soon": MessageLookupByLibrary.simpleMessage("Soon..."),
    "status": MessageLookupByLibrary.simpleMessage("STATUS"),
    "storagePermissionMessage": MessageLookupByLibrary.simpleMessage(
      "Storage access is needed to save backups. Please grant permission to continue.",
    ),
    "success": MessageLookupByLibrary.simpleMessage("success"),
    "supplier": MessageLookupByLibrary.simpleMessage("Supplier"),
    "supplierName": MessageLookupByLibrary.simpleMessage("Supplier Name"),
    "suppliers": MessageLookupByLibrary.simpleMessage("Suppliers"),
    "swappedMins": MessageLookupByLibrary.simpleMessage("Swapped"),
    "systemDefault": MessageLookupByLibrary.simpleMessage("System Default"),
    "systemResetSuccessfulRestarting": MessageLookupByLibrary.simpleMessage(
      "System Reset Successful! Restarting...",
    ),
    "tapAnItemToPinItToTheTop": MessageLookupByLibrary.simpleMessage(
      "Tap an item to pin it to the top",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme Mode"),
    "thisWillOverwriteAllCurrentBuffetDataTheAppWill":
        MessageLookupByLibrary.simpleMessage(
          "This will overwrite all current buffet data. The app will restart automatically.",
        ),
    "thisWillRevertYourCurrencyNumbersAndAppNameTo":
        MessageLookupByLibrary.simpleMessage(
          "This will revert your currency, numbers, and app name to defaults. This action cannot be undone.",
        ),
    "thisWillWipeYourEntireDatabaseAreYouAbsolutelySure":
        MessageLookupByLibrary.simpleMessage(
          "This will wipe your entire database. Are you absolutely sure?",
        ),
    "timeFormat": MessageLookupByLibrary.simpleMessage("Time Format"),
    "tooManyAttemptsLockout": MessageLookupByLibrary.simpleMessage(
      "Too many attempts. Biometrics have been temporarily disabled.",
    ),
    "tooManyAttemptsRetry": MessageLookupByLibrary.simpleMessage(
      "Too many attempts. Please try again in 30 seconds.",
    ),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalAmount": MessageLookupByLibrary.simpleMessage("Total Amount"),
    "totalPaid": MessageLookupByLibrary.simpleMessage("TOTAL PAID"),
    "transactionType": MessageLookupByLibrary.simpleMessage("Entry Type"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Uncategorized"),
    "updateItem": MessageLookupByLibrary.simpleMessage("Update Item"),
    "usDollar": MessageLookupByLibrary.simpleMessage("\$ - US Dollar"),
    "verifyIdentity": MessageLookupByLibrary.simpleMessage("Verify identity"),
    "versionUnknown": MessageLookupByLibrary.simpleMessage("Version Unknown"),
    "welcomeToBuffet": MessageLookupByLibrary.simpleMessage(
      "Welcome to Buffet",
    ),
    "welcomeToBuffetPreviewAr": MessageLookupByLibrary.simpleMessage(
      "مرحباً بك في بوفيه",
    ),
    "welcomeToBuffetPreviewEn": MessageLookupByLibrary.simpleMessage(
      "Welcome to Buffet",
    ),
    "whatsappEmail": MessageLookupByLibrary.simpleMessage("WhatsApp/Email"),
  };
}
