import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String selectedCount(int count);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @editingOrder.
  ///
  /// In en, this message translates to:
  /// **'Editing Order {id}'**
  String editingOrder(String id);

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'There are no products'**
  String get noProducts;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import Error: {error}'**
  String importError(String error);

  /// No description provided for @buffetName.
  ///
  /// In en, this message translates to:
  /// **'Buffet Name'**
  String get buffetName;

  /// No description provided for @businessInfo.
  ///
  /// In en, this message translates to:
  /// **'Business Info'**
  String get businessInfo;

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @databaseReports.
  ///
  /// In en, this message translates to:
  /// **'Database & Reports'**
  String get databaseReports;

  /// No description provided for @exportOrders.
  ///
  /// In en, this message translates to:
  /// **'Export Orders'**
  String get exportOrders;

  /// No description provided for @saveAllHistoryToExcelXlsx.
  ///
  /// In en, this message translates to:
  /// **'Save all history to Excel (.xlsx)'**
  String get saveAllHistoryToExcelXlsx;

  /// No description provided for @factoryReset.
  ///
  /// In en, this message translates to:
  /// **'Factory Reset'**
  String get factoryReset;

  /// No description provided for @deleteAllProductsAndHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete all products and history'**
  String get deleteAllProductsAndHistory;

  /// No description provided for @appVersionVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version: v{version}'**
  String appVersionVersion(String version);

  /// No description provided for @versionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Version Unknown'**
  String get versionUnknown;

  /// No description provided for @dangerousAction.
  ///
  /// In en, this message translates to:
  /// **'Dangerous Action!'**
  String get dangerousAction;

  /// No description provided for @thisWillWipeYourEntireDatabaseAreYouAbsolutelySure.
  ///
  /// In en, this message translates to:
  /// **'This will wipe your entire database. Are you absolutely sure?'**
  String get thisWillWipeYourEntireDatabaseAreYouAbsolutelySure;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'RESET ALL'**
  String get resetAll;

  /// No description provided for @editBuffetName.
  ///
  /// In en, this message translates to:
  /// **'Edit Buffet Name'**
  String get editBuffetName;

  /// No description provided for @enterBuffetName.
  ///
  /// In en, this message translates to:
  /// **'Enter buffet name'**
  String get enterBuffetName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalog;

  /// No description provided for @exportType.
  ///
  /// In en, this message translates to:
  /// **'Export {type}'**
  String exportType(String type);

  /// No description provided for @importType.
  ///
  /// In en, this message translates to:
  /// **'Import {type}'**
  String importType(String type);

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @addons.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get addons;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get newProduct;

  /// No description provided for @newAddon.
  ///
  /// In en, this message translates to:
  /// **'New Add-on'**
  String get newAddon;

  /// Message shown after importing items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items processed} =1{Processed 1 item} other{Processed {count} items}}'**
  String processedItems(int count);

  /// No description provided for @deleteItems.
  ///
  /// In en, this message translates to:
  /// **'Delete Items?'**
  String get deleteItems;

  /// No description provided for @deleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} items? This cannot be undone.'**
  String deleteWarning(int count);

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProduct;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @editAddon.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editAddon(String name);

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @saveAddon.
  ///
  /// In en, this message translates to:
  /// **'Save Add-on'**
  String get saveAddon;

  /// No description provided for @exportOptions.
  ///
  /// In en, this message translates to:
  /// **'Export Options'**
  String get exportOptions;

  /// No description provided for @saveToDefault.
  ///
  /// In en, this message translates to:
  /// **'Save to Default'**
  String get saveToDefault;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String savedTo(String path);

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @chooseFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose a custom folder'**
  String get chooseFolder;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get savedSuccessfully;

  /// No description provided for @shareCsv.
  ///
  /// In en, this message translates to:
  /// **'Share CSV'**
  String get shareCsv;

  /// No description provided for @whatsappEmail.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp/Email'**
  String get whatsappEmail;

  /// No description provided for @duplicates.
  ///
  /// In en, this message translates to:
  /// **'Duplicates:'**
  String get duplicates;

  /// No description provided for @skipAll.
  ///
  /// In en, this message translates to:
  /// **'Skip All'**
  String get skipAll;

  /// No description provided for @replaceAll.
  ///
  /// In en, this message translates to:
  /// **'Replace All'**
  String get replaceAll;

  /// No description provided for @exists.
  ///
  /// In en, this message translates to:
  /// **'EXISTS'**
  String get exists;

  /// No description provided for @newWord.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newWord;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @noAddons.
  ///
  /// In en, this message translates to:
  /// **'There are no add-ons'**
  String get noAddons;

  /// No description provided for @addAddonsNow.
  ///
  /// In en, this message translates to:
  /// **'Add new add-ons now!'**
  String get addAddonsNow;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorOccurred(String error);

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @addon.
  ///
  /// In en, this message translates to:
  /// **'Add-on'**
  String get addon;

  /// No description provided for @addProductsNow.
  ///
  /// In en, this message translates to:
  /// **'Add new products now!'**
  String get addProductsNow;

  /// No description provided for @clickToOpen.
  ///
  /// In en, this message translates to:
  /// **'Normal click: Open {name}'**
  String clickToOpen(String name);

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'Import Preview'**
  String get importPreview;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @addonName.
  ///
  /// In en, this message translates to:
  /// **'Add-on Name'**
  String get addonName;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found.'**
  String get noOrdersFound;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @served.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get served;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get status;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'ITEMS'**
  String get items;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'ORDER NOTES'**
  String get orderNotes;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'TOTAL PAID'**
  String get totalPaid;

  /// No description provided for @markAsServed.
  ///
  /// In en, this message translates to:
  /// **'MARK AS SERVED'**
  String get markAsServed;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon...'**
  String get soon;

  /// No description provided for @errorLoadingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error loading order'**
  String get errorLoadingOrder;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove these records from your database.'**
  String get deleteConfirmMessage;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderId(int id);

  /// No description provided for @deleteOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 Order?} other{Delete {count} Orders?}}'**
  String deleteOrdersCount(int count);

  /// No description provided for @deletedOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Deleted 1 order} other{Deleted {count} orders}}'**
  String deletedOrdersMessage(int count);

  /// No description provided for @orderServedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order {orderId} Served'**
  String orderServedSuccess(String orderId);

  /// No description provided for @posTerminal.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get posTerminal;

  /// No description provided for @editCancelled.
  ///
  /// In en, this message translates to:
  /// **'Edit Cancelled'**
  String get editCancelled;

  /// No description provided for @clearOrder.
  ///
  /// In en, this message translates to:
  /// **'Clear Order?'**
  String get clearOrder;

  /// No description provided for @removeAllItemsFromTheCart.
  ///
  /// In en, this message translates to:
  /// **'Remove all items from the cart?'**
  String get removeAllItemsFromTheCart;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty!'**
  String get cartIsEmpty;

  /// No description provided for @failedToSaveOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to save order. Please try again.'**
  String get failedToSaveOrder;

  /// No description provided for @cannotPauseWhileEditing.
  ///
  /// In en, this message translates to:
  /// **'Cannot pause while editing a saved order'**
  String get cannotPauseWhileEditing;

  /// No description provided for @pauseOrder.
  ///
  /// In en, this message translates to:
  /// **'Pause Order'**
  String get pauseOrder;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @orderPaused.
  ///
  /// In en, this message translates to:
  /// **'Order Paused'**
  String get orderPaused;

  /// No description provided for @checkoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Checkout Summary'**
  String get checkoutSummary;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @customerInfo.
  ///
  /// In en, this message translates to:
  /// **'Customer Info'**
  String get customerInfo;

  /// No description provided for @enterCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name...'**
  String get enterCustomerName;

  /// No description provided for @addOrderNotes.
  ///
  /// In en, this message translates to:
  /// **'Add order notes (optional)...'**
  String get addOrderNotes;

  /// No description provided for @completeSale.
  ///
  /// In en, this message translates to:
  /// **'COMPLETE SALE'**
  String get completeSale;

  /// No description provided for @addNewProductsNow.
  ///
  /// In en, this message translates to:
  /// **'Add new products now!'**
  String get addNewProductsNow;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'CHECKOUT'**
  String get checkout;

  /// No description provided for @reviewOrder.
  ///
  /// In en, this message translates to:
  /// **'Review Order'**
  String get reviewOrder;

  /// No description provided for @plain.
  ///
  /// In en, this message translates to:
  /// **'Plain'**
  String get plain;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @errorLoadingAddons.
  ///
  /// In en, this message translates to:
  /// **'Error loading addons'**
  String get errorLoadingAddons;

  /// No description provided for @addToOrder.
  ///
  /// In en, this message translates to:
  /// **'Add to Order'**
  String get addToOrder;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Item'**
  String get updateItem;

  /// No description provided for @pausedOrders.
  ///
  /// In en, this message translates to:
  /// **'Paused Orders'**
  String get pausedOrders;

  /// No description provided for @noPausedOrders.
  ///
  /// In en, this message translates to:
  /// **'No paused orders'**
  String get noPausedOrders;

  /// No description provided for @orderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Order Deleted'**
  String get orderDeleted;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// No description provided for @resumeOrder.
  ///
  /// In en, this message translates to:
  /// **'RESUME ORDER'**
  String get resumeOrder;

  /// No description provided for @orderLoaded.
  ///
  /// In en, this message translates to:
  /// **'Order Loaded'**
  String get orderLoaded;

  /// No description provided for @orderUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{id} Updated Successfully'**
  String orderUpdatedSuccessfully(String id);

  /// No description provided for @orderSaved.
  ///
  /// In en, this message translates to:
  /// **'Order {id} Saved!'**
  String orderSaved(String id);

  /// No description provided for @checkoutError.
  ///
  /// In en, this message translates to:
  /// **'Checkout Error: {e}'**
  String checkoutError(String e);

  /// No description provided for @itemsInBasket.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items in basket} =1{1 item in basket} other{{count} items in basket}}'**
  String itemsInBasket(int count);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @addProductName.
  ///
  /// In en, this message translates to:
  /// **'Add {name}'**
  String addProductName(String name);

  /// No description provided for @editProductName.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editProductName(String name);

  /// No description provided for @orderIndex.
  ///
  /// In en, this message translates to:
  /// **'Order #{index}'**
  String orderIndex(int index);

  /// No description provided for @swappedMins.
  ///
  /// In en, this message translates to:
  /// **'Swapped'**
  String get swappedMins;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get listView;

  /// No description provided for @gridView.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get gridView;

  /// No description provided for @hideSearch.
  ///
  /// In en, this message translates to:
  /// **'Hide search'**
  String get hideSearch;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get all;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get dismiss;

  /// No description provided for @errorOccur.
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get errorOccur;

  /// No description provided for @quickNavigation.
  ///
  /// In en, this message translates to:
  /// **'Quick Navigation'**
  String get quickNavigation;

  /// No description provided for @numbersFormat.
  ///
  /// In en, this message translates to:
  /// **'Numbers Format'**
  String get numbersFormat;

  /// No description provided for @currencySign.
  ///
  /// In en, this message translates to:
  /// **'Currency Sign'**
  String get currencySign;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// No description provided for @numHour.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1-Hour} other{{count}-Hour}}'**
  String numHour(num count);

  /// No description provided for @backupDatabase.
  ///
  /// In en, this message translates to:
  /// **'Backup Database'**
  String get backupDatabase;

  /// No description provided for @exportAllDataToAFile.
  ///
  /// In en, this message translates to:
  /// **'Export all data to a file'**
  String get exportAllDataToAFile;

  /// No description provided for @restoreDatabase.
  ///
  /// In en, this message translates to:
  /// **'Restore Database'**
  String get restoreDatabase;

  /// No description provided for @importNewDataFromABackupFile.
  ///
  /// In en, this message translates to:
  /// **'Import new data from a backup file'**
  String get importNewDataFromABackupFile;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @restoreAllAppSettingsToFactoryDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore all app settings to factory defaults'**
  String get restoreAllAppSettingsToFactoryDefaults;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings?'**
  String get resetSettings;

  /// No description provided for @thisWillRevertYourCurrencyNumbersAndAppNameTo.
  ///
  /// In en, this message translates to:
  /// **'This will revert your currency, numbers, and app name to defaults. This action cannot be undone.'**
  String get thisWillRevertYourCurrencyNumbersAndAppNameTo;

  /// No description provided for @resetNow.
  ///
  /// In en, this message translates to:
  /// **'Reset Now'**
  String get resetNow;

  /// No description provided for @settingsRestoredToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Settings restored to defaults'**
  String get settingsRestoredToDefaults;

  /// No description provided for @databaseExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Database Exported Successfully'**
  String get databaseExportedSuccessfully;

  /// No description provided for @exportCancelled.
  ///
  /// In en, this message translates to:
  /// **'Export Cancelled'**
  String get exportCancelled;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionDenied;

  /// No description provided for @importDatabase.
  ///
  /// In en, this message translates to:
  /// **'Import Database?'**
  String get importDatabase;

  /// No description provided for @thisWillOverwriteAllCurrentBuffetDataTheAppWill.
  ///
  /// In en, this message translates to:
  /// **'This will overwrite all current buffet data. The app will restart automatically.'**
  String get thisWillOverwriteAllCurrentBuffetDataTheAppWill;

  /// No description provided for @importRestart.
  ///
  /// In en, this message translates to:
  /// **'Import & Restart'**
  String get importRestart;

  /// No description provided for @importSuccessfulRestarting.
  ///
  /// In en, this message translates to:
  /// **'Import Successful! Restarting...'**
  String get importSuccessfulRestarting;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import Failed'**
  String get importFailed;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'SAVED'**
  String get saved;

  /// No description provided for @livePreview.
  ///
  /// In en, this message translates to:
  /// **'LIVE PREVIEW'**
  String get livePreview;

  /// No description provided for @customT.
  ///
  /// In en, this message translates to:
  /// **'Custom {title}...'**
  String customT(String title);

  /// No description provided for @applyChanges.
  ///
  /// In en, this message translates to:
  /// **'Apply Changes'**
  String get applyChanges;

  /// No description provided for @systemResetSuccessfulRestarting.
  ///
  /// In en, this message translates to:
  /// **'System Reset Successful! Restarting...'**
  String get systemResetSuccessfulRestarting;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset Failed'**
  String get resetFailed;

  /// No description provided for @applyLanguage.
  ///
  /// In en, this message translates to:
  /// **'Apply Language'**
  String get applyLanguage;

  /// No description provided for @saudiRiyal.
  ///
  /// In en, this message translates to:
  /// **'- Yemen Riyal'**
  String get saudiRiyal;

  /// No description provided for @usDollar.
  ///
  /// In en, this message translates to:
  /// **'\$ - US Dollar'**
  String get usDollar;

  /// No description provided for @biometricAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthentication;

  /// No description provided for @verifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify identity'**
  String get verifyIdentity;

  /// No description provided for @authErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An authentication error occurred. Please try again.'**
  String get authErrorMessage;

  /// No description provided for @pleaseSetUpBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Please set up FaceID or TouchID in your device settings.'**
  String get pleaseSetUpBiometrics;

  /// No description provided for @tooManyAttemptsLockout.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Biometrics have been temporarily disabled.'**
  String get tooManyAttemptsLockout;

  /// No description provided for @pleaseAuthenticateToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to confirm it\'s you'**
  String get pleaseAuthenticateToConfirm;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics/PIN are not available on this device.'**
  String get biometricsNotAvailable;

  /// No description provided for @noBiometricsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No fingerprints or face data registered on this device.'**
  String get noBiometricsRegistered;

  /// No description provided for @tooManyAttemptsRetry.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again in 30 seconds.'**
  String get tooManyAttemptsRetry;

  /// No description provided for @biometricsDisabledUsePasscode.
  ///
  /// In en, this message translates to:
  /// **'Biometrics disabled. Please unlock using your phone passcode.'**
  String get biometricsDisabledUsePasscode;

  /// No description provided for @osNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This operating system does not support local authentication.'**
  String get osNotSupported;

  /// No description provided for @identityVerified.
  ///
  /// In en, this message translates to:
  /// **'Identity Verified'**
  String get identityVerified;

  /// No description provided for @saveBuffetBackup.
  ///
  /// In en, this message translates to:
  /// **'Save Buffet Backup'**
  String get saveBuffetBackup;

  /// No description provided for @resetError.
  ///
  /// In en, this message translates to:
  /// **'Reset Error: {error}'**
  String resetError(String error);

  /// No description provided for @invalidFileType.
  ///
  /// In en, this message translates to:
  /// **'Invalid file type'**
  String get invalidFileType;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @tapAnItemToPinItToTheTop.
  ///
  /// In en, this message translates to:
  /// **'Tap an item to pin it to the top'**
  String get tapAnItemToPinItToTheTop;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name...'**
  String get enterName;

  /// No description provided for @saveCategory.
  ///
  /// In en, this message translates to:
  /// **'Save Category'**
  String get saveCategory;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted Successfully'**
  String get deletedSuccessfully;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @egChickenBurger.
  ///
  /// In en, this message translates to:
  /// **'e.g. Chicken Burger'**
  String get egChickenBurger;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// No description provided for @egExtraCheese.
  ///
  /// In en, this message translates to:
  /// **'e.g. Extra Cheese'**
  String get egExtraCheese;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @storagePermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Storage access is needed to save backups. Please grant permission to continue.'**
  String get storagePermissionMessage;

  /// No description provided for @grant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grant;

  /// No description provided for @basicDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basicDetails;

  /// No description provided for @addNewAction.
  ///
  /// In en, this message translates to:
  /// **'ADD NEW ACTION'**
  String get addNewAction;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @catExists.
  ///
  /// In en, this message translates to:
  /// **'Exists'**
  String get catExists;

  /// No description provided for @newCat.
  ///
  /// In en, this message translates to:
  /// **'New Cat'**
  String get newCat;

  /// No description provided for @importAction.
  ///
  /// In en, this message translates to:
  /// **'Import Now'**
  String get importAction;

  /// No description provided for @bestBuffet.
  ///
  /// In en, this message translates to:
  /// **'Best Buffet'**
  String get bestBuffet;

  /// No description provided for @saveToDefaultBackups.
  ///
  /// In en, this message translates to:
  /// **'Save to Default (backups/)'**
  String get saveToDefaultBackups;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get selectFolder;

  /// No description provided for @shareFile.
  ///
  /// In en, this message translates to:
  /// **'Share File'**
  String get shareFile;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get close;

  /// No description provided for @savedToBackups.
  ///
  /// In en, this message translates to:
  /// **'Saved to {folder}'**
  String savedToBackups(String folder);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export Failed'**
  String get exportFailed;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'success'**
  String get success;

  /// No description provided for @exportNow.
  ///
  /// In en, this message translates to:
  /// **'Export Now'**
  String get exportNow;

  /// No description provided for @invalidPattern.
  ///
  /// In en, this message translates to:
  /// **'Invalid Pattern'**
  String get invalidPattern;

  /// No description provided for @welcomeToBuffet.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Buffet'**
  String get welcomeToBuffet;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'There are no categories'**
  String get noCategories;

  /// No description provided for @addNewCategoriesNow.
  ///
  /// In en, this message translates to:
  /// **'Add new categories now!'**
  String get addNewCategoriesNow;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Product} other{{count} Products}}'**
  String productCount(int count);

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'{count}x {name}'**
  String quantityLabel(String count, String name);

  /// No description provided for @addonPrefix.
  ///
  /// In en, this message translates to:
  /// **'+ {name}'**
  String addonPrefix(String name);

  /// No description provided for @welcomeToBuffetPreviewEn.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Buffet'**
  String get welcomeToBuffetPreviewEn;

  /// No description provided for @welcomeToBuffetPreviewAr.
  ///
  /// In en, this message translates to:
  /// **'مرحباً بك في بوفيه'**
  String get welcomeToBuffetPreviewAr;

  /// No description provided for @egDateFormat.
  ///
  /// In en, this message translates to:
  /// **'e.g. yyyy-MM-dd'**
  String get egDateFormat;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BuffetPOS'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Your smart point-of-sale system designed for speed and simplicity. Manage your buffet like a pro.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track Every Order'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'From checkout to order history, keep a complete record of all transactions with detailed reports.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Ready to Go!'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Set up your catalog, customize your settings, and start taking orders in minutes.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية (Arabic)'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log In'**
  String get alreadyHaveAccount;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get emailAlreadyRegistered;

  /// No description provided for @emailNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email is not registered'**
  String get emailNotRegistered;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully'**
  String get registerSuccess;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add Supplier'**
  String get addSupplier;

  /// No description provided for @editSupplier.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get editSupplier;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name'**
  String get supplierName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @dailyDebit.
  ///
  /// In en, this message translates to:
  /// **'Daily Debit'**
  String get dailyDebit;

  /// No description provided for @dailyCredit.
  ///
  /// In en, this message translates to:
  /// **'Daily Credit'**
  String get dailyCredit;

  /// No description provided for @dailySales.
  ///
  /// In en, this message translates to:
  /// **'Daily Sales'**
  String get dailySales;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @profits.
  ///
  /// In en, this message translates to:
  /// **'Profits'**
  String get profits;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @selectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Select Supplier'**
  String get selectSupplier;

  /// No description provided for @noSupplier.
  ///
  /// In en, this message translates to:
  /// **'No Supplier'**
  String get noSupplier;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addTransaction;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Entry Type'**
  String get transactionType;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @linkedProducts.
  ///
  /// In en, this message translates to:
  /// **'Linked Products'**
  String get linkedProducts;

  /// No description provided for @linkedAddons.
  ///
  /// In en, this message translates to:
  /// **'Linked Add-ons'**
  String get linkedAddons;

  /// No description provided for @printReport.
  ///
  /// In en, this message translates to:
  /// **'Print Report'**
  String get printReport;

  /// No description provided for @exportAccountsReport.
  ///
  /// In en, this message translates to:
  /// **'Export Daily Accounts Report'**
  String get exportAccountsReport;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger / Entries'**
  String get ledger;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No entries found.'**
  String get noTransactions;

  /// No description provided for @debitPayment.
  ///
  /// In en, this message translates to:
  /// **'Debit (Payment)'**
  String get debitPayment;

  /// No description provided for @creditPurchase.
  ///
  /// In en, this message translates to:
  /// **'Credit (Purchase)'**
  String get creditPurchase;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
