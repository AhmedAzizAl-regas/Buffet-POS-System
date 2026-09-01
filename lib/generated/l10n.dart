// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `SAR`
  String get sar {
    return Intl.message('SAR', name: 'sar', desc: '', args: []);
  }

  /// `{count} Selected`
  String selectedCount(int count) {
    return Intl.message(
      '$count Selected',
      name: 'selectedCount',
      desc: '',
      args: [count],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `SAVE`
  String get save {
    return Intl.message('SAVE', name: 'save', desc: '', args: []);
  }

  /// `Editing Order {id}`
  String editingOrder(String id) {
    return Intl.message(
      'Editing Order $id',
      name: 'editingOrder',
      desc: '',
      args: [id],
    );
  }

  /// `Edit Product`
  String get editProduct {
    return Intl.message(
      'Edit Product',
      name: 'editProduct',
      desc: '',
      args: [],
    );
  }

  /// `There are no products`
  String get noProducts {
    return Intl.message(
      'There are no products',
      name: 'noProducts',
      desc: '',
      args: [],
    );
  }

  /// `Import Error: {error}`
  String importError(String error) {
    return Intl.message(
      'Import Error: $error',
      name: 'importError',
      desc: '',
      args: [error],
    );
  }

  /// `Buffet Name`
  String get buffetName {
    return Intl.message('Buffet Name', name: 'buffetName', desc: '', args: []);
  }

  /// `Business Info`
  String get businessInfo {
    return Intl.message(
      'Business Info',
      name: 'businessInfo',
      desc: '',
      args: [],
    );
  }

  /// `Localization`
  String get localization {
    return Intl.message(
      'Localization',
      name: 'localization',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Database & Reports`
  String get databaseReports {
    return Intl.message(
      'Database & Reports',
      name: 'databaseReports',
      desc: '',
      args: [],
    );
  }

  /// `Export Orders`
  String get exportOrders {
    return Intl.message(
      'Export Orders',
      name: 'exportOrders',
      desc: '',
      args: [],
    );
  }

  /// `Save all history to Excel (.xlsx)`
  String get saveAllHistoryToExcelXlsx {
    return Intl.message(
      'Save all history to Excel (.xlsx)',
      name: 'saveAllHistoryToExcelXlsx',
      desc: '',
      args: [],
    );
  }

  /// `Factory Reset`
  String get factoryReset {
    return Intl.message(
      'Factory Reset',
      name: 'factoryReset',
      desc: '',
      args: [],
    );
  }

  /// `Delete all products and history`
  String get deleteAllProductsAndHistory {
    return Intl.message(
      'Delete all products and history',
      name: 'deleteAllProductsAndHistory',
      desc: '',
      args: [],
    );
  }

  /// `App Version: v{version}`
  String appVersionVersion(String version) {
    return Intl.message(
      'App Version: v$version',
      name: 'appVersionVersion',
      desc: '',
      args: [version],
    );
  }

  /// `Version Unknown`
  String get versionUnknown {
    return Intl.message(
      'Version Unknown',
      name: 'versionUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Dangerous Action!`
  String get dangerousAction {
    return Intl.message(
      'Dangerous Action!',
      name: 'dangerousAction',
      desc: '',
      args: [],
    );
  }

  /// `This will wipe your entire database. Are you absolutely sure?`
  String get thisWillWipeYourEntireDatabaseAreYouAbsolutelySure {
    return Intl.message(
      'This will wipe your entire database. Are you absolutely sure?',
      name: 'thisWillWipeYourEntireDatabaseAreYouAbsolutelySure',
      desc: '',
      args: [],
    );
  }

  /// `RESET ALL`
  String get resetAll {
    return Intl.message('RESET ALL', name: 'resetAll', desc: '', args: []);
  }

  /// `Edit Buffet Name`
  String get editBuffetName {
    return Intl.message(
      'Edit Buffet Name',
      name: 'editBuffetName',
      desc: '',
      args: [],
    );
  }

  /// `Enter buffet name`
  String get enterBuffetName {
    return Intl.message(
      'Enter buffet name',
      name: 'enterBuffetName',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Catalog`
  String get catalog {
    return Intl.message('Catalog', name: 'catalog', desc: '', args: []);
  }

  /// `Export {type}`
  String exportType(String type) {
    return Intl.message(
      'Export $type',
      name: 'exportType',
      desc: '',
      args: [type],
    );
  }

  /// `Import {type}`
  String importType(String type) {
    return Intl.message(
      'Import $type',
      name: 'importType',
      desc: '',
      args: [type],
    );
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Add-ons`
  String get addons {
    return Intl.message('Add-ons', name: 'addons', desc: '', args: []);
  }

  /// `New Product`
  String get newProduct {
    return Intl.message('New Product', name: 'newProduct', desc: '', args: []);
  }

  /// `New Add-on`
  String get newAddon {
    return Intl.message('New Add-on', name: 'newAddon', desc: '', args: []);
  }

  /// `{count, plural, =0{No items processed} =1{Processed 1 item} other{Processed {count} items}}`
  String processedItems(int count) {
    return Intl.plural(
      count,
      zero: 'No items processed',
      one: 'Processed 1 item',
      other: 'Processed $count items',
      name: 'processedItems',
      desc: 'Message shown after importing items',
      args: [count],
    );
  }

  /// `Delete Items?`
  String get deleteItems {
    return Intl.message(
      'Delete Items?',
      name: 'deleteItems',
      desc: '',
      args: [],
    );
  }

  /// `Delete {count} items? This cannot be undone.`
  String deleteWarning(int count) {
    return Intl.message(
      'Delete $count items? This cannot be undone.',
      name: 'deleteWarning',
      desc: '',
      args: [count],
    );
  }

  /// `Add New Product`
  String get addNewProduct {
    return Intl.message(
      'Add New Product',
      name: 'addNewProduct',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required {
    return Intl.message('Required', name: 'required', desc: '', args: []);
  }

  /// `Invalid`
  String get invalid {
    return Intl.message('Invalid', name: 'invalid', desc: '', args: []);
  }

  /// `Base Price`
  String get basePrice {
    return Intl.message('Base Price', name: 'basePrice', desc: '', args: []);
  }

  /// `Save Product`
  String get saveProduct {
    return Intl.message(
      'Save Product',
      name: 'saveProduct',
      desc: '',
      args: [],
    );
  }

  /// `Edit {name}`
  String editAddon(String name) {
    return Intl.message(
      'Edit $name',
      name: 'editAddon',
      desc: '',
      args: [name],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Save Add-on`
  String get saveAddon {
    return Intl.message('Save Add-on', name: 'saveAddon', desc: '', args: []);
  }

  /// `Export Options`
  String get exportOptions {
    return Intl.message(
      'Export Options',
      name: 'exportOptions',
      desc: '',
      args: [],
    );
  }

  /// `Save to Default`
  String get saveToDefault {
    return Intl.message(
      'Save to Default',
      name: 'saveToDefault',
      desc: '',
      args: [],
    );
  }

  /// `Saved to {path}`
  String savedTo(String path) {
    return Intl.message(
      'Saved to $path',
      name: 'savedTo',
      desc: '',
      args: [path],
    );
  }

  /// `Select Location`
  String get selectLocation {
    return Intl.message(
      'Select Location',
      name: 'selectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Choose a custom folder`
  String get chooseFolder {
    return Intl.message(
      'Choose a custom folder',
      name: 'chooseFolder',
      desc: '',
      args: [],
    );
  }

  /// `Saved successfully`
  String get savedSuccessfully {
    return Intl.message(
      'Saved successfully',
      name: 'savedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Share CSV`
  String get shareCsv {
    return Intl.message('Share CSV', name: 'shareCsv', desc: '', args: []);
  }

  /// `WhatsApp/Email`
  String get whatsappEmail {
    return Intl.message(
      'WhatsApp/Email',
      name: 'whatsappEmail',
      desc: '',
      args: [],
    );
  }

  /// `Duplicates:`
  String get duplicates {
    return Intl.message('Duplicates:', name: 'duplicates', desc: '', args: []);
  }

  /// `Skip All`
  String get skipAll {
    return Intl.message('Skip All', name: 'skipAll', desc: '', args: []);
  }

  /// `Replace All`
  String get replaceAll {
    return Intl.message('Replace All', name: 'replaceAll', desc: '', args: []);
  }

  /// `EXISTS`
  String get exists {
    return Intl.message('EXISTS', name: 'exists', desc: '', args: []);
  }

  /// `NEW`
  String get newWord {
    return Intl.message('NEW', name: 'newWord', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Replace`
  String get replace {
    return Intl.message('Replace', name: 'replace', desc: '', args: []);
  }

  /// `Duplicate`
  String get duplicate {
    return Intl.message('Duplicate', name: 'duplicate', desc: '', args: []);
  }

  /// `There are no add-ons`
  String get noAddons {
    return Intl.message(
      'There are no add-ons',
      name: 'noAddons',
      desc: '',
      args: [],
    );
  }

  /// `Add new add-ons now!`
  String get addAddonsNow {
    return Intl.message(
      'Add new add-ons now!',
      name: 'addAddonsNow',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String errorOccurred(String error) {
    return Intl.message(
      'Error: $error',
      name: 'errorOccurred',
      desc: '',
      args: [error],
    );
  }

  /// `Product`
  String get product {
    return Intl.message('Product', name: 'product', desc: '', args: []);
  }

  /// `Add-on`
  String get addon {
    return Intl.message('Add-on', name: 'addon', desc: '', args: []);
  }

  /// `Add new products now!`
  String get addProductsNow {
    return Intl.message(
      'Add new products now!',
      name: 'addProductsNow',
      desc: '',
      args: [],
    );
  }

  /// `Normal click: Open {name}`
  String clickToOpen(String name) {
    return Intl.message(
      'Normal click: Open $name',
      name: 'clickToOpen',
      desc: '',
      args: [name],
    );
  }

  /// `Import Preview`
  String get importPreview {
    return Intl.message(
      'Import Preview',
      name: 'importPreview',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get productName {
    return Intl.message(
      'Product Name',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Add-on Name`
  String get addonName {
    return Intl.message('Add-on Name', name: 'addonName', desc: '', args: []);
  }

  /// `Order History`
  String get orderHistory {
    return Intl.message(
      'Order History',
      name: 'orderHistory',
      desc: '',
      args: [],
    );
  }

  /// `No orders found.`
  String get noOrdersFound {
    return Intl.message(
      'No orders found.',
      name: 'noOrdersFound',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Served`
  String get served {
    return Intl.message('Served', name: 'served', desc: '', args: []);
  }

  /// `STATUS`
  String get status {
    return Intl.message('STATUS', name: 'status', desc: '', args: []);
  }

  /// `ITEMS`
  String get items {
    return Intl.message('ITEMS', name: 'items', desc: '', args: []);
  }

  /// `ORDER NOTES`
  String get orderNotes {
    return Intl.message('ORDER NOTES', name: 'orderNotes', desc: '', args: []);
  }

  /// `TOTAL PAID`
  String get totalPaid {
    return Intl.message('TOTAL PAID', name: 'totalPaid', desc: '', args: []);
  }

  /// `MARK AS SERVED`
  String get markAsServed {
    return Intl.message(
      'MARK AS SERVED',
      name: 'markAsServed',
      desc: '',
      args: [],
    );
  }

  /// `Soon...`
  String get soon {
    return Intl.message('Soon...', name: 'soon', desc: '', args: []);
  }

  /// `Error loading order`
  String get errorLoadingOrder {
    return Intl.message(
      'Error loading order',
      name: 'errorLoadingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Delete All`
  String get deleteAll {
    return Intl.message('Delete All', name: 'deleteAll', desc: '', args: []);
  }

  /// `This will permanently remove these records from your database.`
  String get deleteConfirmMessage {
    return Intl.message(
      'This will permanently remove these records from your database.',
      name: 'deleteConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `Order #{id}`
  String orderId(int id) {
    return Intl.message('Order #$id', name: 'orderId', desc: '', args: [id]);
  }

  /// `{count, plural, =1{Delete 1 Order?} other{Delete {count} Orders?}}`
  String deleteOrdersCount(int count) {
    return Intl.plural(
      count,
      one: 'Delete 1 Order?',
      other: 'Delete $count Orders?',
      name: 'deleteOrdersCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{Deleted 1 order} other{Deleted {count} orders}}`
  String deletedOrdersMessage(int count) {
    return Intl.plural(
      count,
      one: 'Deleted 1 order',
      other: 'Deleted $count orders',
      name: 'deletedOrdersMessage',
      desc: '',
      args: [count],
    );
  }

  /// `Order {orderId} Served`
  String orderServedSuccess(String orderId) {
    return Intl.message(
      'Order $orderId Served',
      name: 'orderServedSuccess',
      desc: '',
      args: [orderId],
    );
  }

  /// `POS Terminal`
  String get posTerminal {
    return Intl.message(
      'POS Terminal',
      name: 'posTerminal',
      desc: '',
      args: [],
    );
  }

  /// `Edit Cancelled`
  String get editCancelled {
    return Intl.message(
      'Edit Cancelled',
      name: 'editCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Clear Order?`
  String get clearOrder {
    return Intl.message('Clear Order?', name: 'clearOrder', desc: '', args: []);
  }

  /// `Remove all items from the cart?`
  String get removeAllItemsFromTheCart {
    return Intl.message(
      'Remove all items from the cart?',
      name: 'removeAllItemsFromTheCart',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Cart is empty!`
  String get cartIsEmpty {
    return Intl.message(
      'Cart is empty!',
      name: 'cartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save order. Please try again.`
  String get failedToSaveOrder {
    return Intl.message(
      'Failed to save order. Please try again.',
      name: 'failedToSaveOrder',
      desc: '',
      args: [],
    );
  }

  /// `Cannot pause while editing a saved order`
  String get cannotPauseWhileEditing {
    return Intl.message(
      'Cannot pause while editing a saved order',
      name: 'cannotPauseWhileEditing',
      desc: '',
      args: [],
    );
  }

  /// `Pause Order`
  String get pauseOrder {
    return Intl.message('Pause Order', name: 'pauseOrder', desc: '', args: []);
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Order Paused`
  String get orderPaused {
    return Intl.message(
      'Order Paused',
      name: 'orderPaused',
      desc: '',
      args: [],
    );
  }

  /// `Checkout Summary`
  String get checkoutSummary {
    return Intl.message(
      'Checkout Summary',
      name: 'checkoutSummary',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total`
  String get grandTotal {
    return Intl.message('Grand Total', name: 'grandTotal', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Customer Info`
  String get customerInfo {
    return Intl.message(
      'Customer Info',
      name: 'customerInfo',
      desc: '',
      args: [],
    );
  }

  /// `Enter customer name...`
  String get enterCustomerName {
    return Intl.message(
      'Enter customer name...',
      name: 'enterCustomerName',
      desc: '',
      args: [],
    );
  }

  /// `Add order notes (optional)...`
  String get addOrderNotes {
    return Intl.message(
      'Add order notes (optional)...',
      name: 'addOrderNotes',
      desc: '',
      args: [],
    );
  }

  /// `COMPLETE SALE`
  String get completeSale {
    return Intl.message(
      'COMPLETE SALE',
      name: 'completeSale',
      desc: '',
      args: [],
    );
  }

  /// `Add new products now!`
  String get addNewProductsNow {
    return Intl.message(
      'Add new products now!',
      name: 'addNewProductsNow',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `CHECKOUT`
  String get checkout {
    return Intl.message('CHECKOUT', name: 'checkout', desc: '', args: []);
  }

  /// `Review Order`
  String get reviewOrder {
    return Intl.message(
      'Review Order',
      name: 'reviewOrder',
      desc: '',
      args: [],
    );
  }

  /// `Plain`
  String get plain {
    return Intl.message('Plain', name: 'plain', desc: '', args: []);
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Free`
  String get free {
    return Intl.message('Free', name: 'free', desc: '', args: []);
  }

  /// `Error loading addons`
  String get errorLoadingAddons {
    return Intl.message(
      'Error loading addons',
      name: 'errorLoadingAddons',
      desc: '',
      args: [],
    );
  }

  /// `Add to Order`
  String get addToOrder {
    return Intl.message('Add to Order', name: 'addToOrder', desc: '', args: []);
  }

  /// `Update Item`
  String get updateItem {
    return Intl.message('Update Item', name: 'updateItem', desc: '', args: []);
  }

  /// `Paused Orders`
  String get pausedOrders {
    return Intl.message(
      'Paused Orders',
      name: 'pausedOrders',
      desc: '',
      args: [],
    );
  }

  /// `No paused orders`
  String get noPausedOrders {
    return Intl.message(
      'No paused orders',
      name: 'noPausedOrders',
      desc: '',
      args: [],
    );
  }

  /// `Order Deleted`
  String get orderDeleted {
    return Intl.message(
      'Order Deleted',
      name: 'orderDeleted',
      desc: '',
      args: [],
    );
  }

  /// `DELETE`
  String get delete {
    return Intl.message('DELETE', name: 'delete', desc: '', args: []);
  }

  /// `RESUME ORDER`
  String get resumeOrder {
    return Intl.message(
      'RESUME ORDER',
      name: 'resumeOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order Loaded`
  String get orderLoaded {
    return Intl.message(
      'Order Loaded',
      name: 'orderLoaded',
      desc: '',
      args: [],
    );
  }

  /// `{id} Updated Successfully`
  String orderUpdatedSuccessfully(String id) {
    return Intl.message(
      '$id Updated Successfully',
      name: 'orderUpdatedSuccessfully',
      desc: '',
      args: [id],
    );
  }

  /// `Order {id} Saved!`
  String orderSaved(String id) {
    return Intl.message(
      'Order $id Saved!',
      name: 'orderSaved',
      desc: '',
      args: [id],
    );
  }

  /// `Checkout Error: {e}`
  String checkoutError(String e) {
    return Intl.message(
      'Checkout Error: $e',
      name: 'checkoutError',
      desc: '',
      args: [e],
    );
  }

  /// `{count, plural, =0{No items in basket} =1{1 item in basket} other{{count} items in basket}}`
  String itemsInBasket(int count) {
    return Intl.plural(
      count,
      zero: 'No items in basket',
      one: '1 item in basket',
      other: '$count items in basket',
      name: 'itemsInBasket',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 item} other{{count} items}}`
  String itemCount(int count) {
    return Intl.plural(
      count,
      one: '1 item',
      other: '$count items',
      name: 'itemCount',
      desc: '',
      args: [count],
    );
  }

  /// `Add {name}`
  String addProductName(String name) {
    return Intl.message(
      'Add $name',
      name: 'addProductName',
      desc: '',
      args: [name],
    );
  }

  /// `Edit {name}`
  String editProductName(String name) {
    return Intl.message(
      'Edit $name',
      name: 'editProductName',
      desc: '',
      args: [name],
    );
  }

  /// `Order #{index}`
  String orderIndex(int index) {
    return Intl.message(
      'Order #$index',
      name: 'orderIndex',
      desc: '',
      args: [index],
    );
  }

  /// `Swapped`
  String get swappedMins {
    return Intl.message('Swapped', name: 'swappedMins', desc: '', args: []);
  }

  /// `List view`
  String get listView {
    return Intl.message('List view', name: 'listView', desc: '', args: []);
  }

  /// `Grid view`
  String get gridView {
    return Intl.message('Grid view', name: 'gridView', desc: '', args: []);
  }

  /// `Hide search`
  String get hideSearch {
    return Intl.message('Hide search', name: 'hideSearch', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `all`
  String get all {
    return Intl.message('all', name: 'all', desc: '', args: []);
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `DISMISS`
  String get dismiss {
    return Intl.message('DISMISS', name: 'dismiss', desc: '', args: []);
  }

  /// `Error Occurred`
  String get errorOccur {
    return Intl.message(
      'Error Occurred',
      name: 'errorOccur',
      desc: '',
      args: [],
    );
  }

  /// `Quick Navigation`
  String get quickNavigation {
    return Intl.message(
      'Quick Navigation',
      name: 'quickNavigation',
      desc: '',
      args: [],
    );
  }

  /// `Numbers Format`
  String get numbersFormat {
    return Intl.message(
      'Numbers Format',
      name: 'numbersFormat',
      desc: '',
      args: [],
    );
  }

  /// `Currency Sign`
  String get currencySign {
    return Intl.message(
      'Currency Sign',
      name: 'currencySign',
      desc: '',
      args: [],
    );
  }

  /// `Date Format`
  String get dateFormat {
    return Intl.message('Date Format', name: 'dateFormat', desc: '', args: []);
  }

  /// `Time Format`
  String get timeFormat {
    return Intl.message('Time Format', name: 'timeFormat', desc: '', args: []);
  }

  /// `{count, plural, =1{1-Hour} other{{count}-Hour}}`
  String numHour(num count) {
    return Intl.plural(
      count,
      one: '1-Hour',
      other: '$count-Hour',
      name: 'numHour',
      desc: '',
      args: [count],
    );
  }

  /// `Backup Database`
  String get backupDatabase {
    return Intl.message(
      'Backup Database',
      name: 'backupDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Export all data to a file`
  String get exportAllDataToAFile {
    return Intl.message(
      'Export all data to a file',
      name: 'exportAllDataToAFile',
      desc: '',
      args: [],
    );
  }

  /// `Restore Database`
  String get restoreDatabase {
    return Intl.message(
      'Restore Database',
      name: 'restoreDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Import new data from a backup file`
  String get importNewDataFromABackupFile {
    return Intl.message(
      'Import new data from a backup file',
      name: 'importNewDataFromABackupFile',
      desc: '',
      args: [],
    );
  }

  /// `Reset to Default`
  String get resetToDefault {
    return Intl.message(
      'Reset to Default',
      name: 'resetToDefault',
      desc: '',
      args: [],
    );
  }

  /// `Restore all app settings to factory defaults`
  String get restoreAllAppSettingsToFactoryDefaults {
    return Intl.message(
      'Restore all app settings to factory defaults',
      name: 'restoreAllAppSettingsToFactoryDefaults',
      desc: '',
      args: [],
    );
  }

  /// `Reset Settings?`
  String get resetSettings {
    return Intl.message(
      'Reset Settings?',
      name: 'resetSettings',
      desc: '',
      args: [],
    );
  }

  /// `This will revert your currency, numbers, and app name to defaults. This action cannot be undone.`
  String get thisWillRevertYourCurrencyNumbersAndAppNameTo {
    return Intl.message(
      'This will revert your currency, numbers, and app name to defaults. This action cannot be undone.',
      name: 'thisWillRevertYourCurrencyNumbersAndAppNameTo',
      desc: '',
      args: [],
    );
  }

  /// `Reset Now`
  String get resetNow {
    return Intl.message('Reset Now', name: 'resetNow', desc: '', args: []);
  }

  /// `Settings restored to defaults`
  String get settingsRestoredToDefaults {
    return Intl.message(
      'Settings restored to defaults',
      name: 'settingsRestoredToDefaults',
      desc: '',
      args: [],
    );
  }

  /// `Database Exported Successfully`
  String get databaseExportedSuccessfully {
    return Intl.message(
      'Database Exported Successfully',
      name: 'databaseExportedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Export Cancelled`
  String get exportCancelled {
    return Intl.message(
      'Export Cancelled',
      name: 'exportCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Permission Denied`
  String get permissionDenied {
    return Intl.message(
      'Permission Denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Import Database?`
  String get importDatabase {
    return Intl.message(
      'Import Database?',
      name: 'importDatabase',
      desc: '',
      args: [],
    );
  }

  /// `This will overwrite all current buffet data. The app will restart automatically.`
  String get thisWillOverwriteAllCurrentBuffetDataTheAppWill {
    return Intl.message(
      'This will overwrite all current buffet data. The app will restart automatically.',
      name: 'thisWillOverwriteAllCurrentBuffetDataTheAppWill',
      desc: '',
      args: [],
    );
  }

  /// `Import & Restart`
  String get importRestart {
    return Intl.message(
      'Import & Restart',
      name: 'importRestart',
      desc: '',
      args: [],
    );
  }

  /// `Import Successful! Restarting...`
  String get importSuccessfulRestarting {
    return Intl.message(
      'Import Successful! Restarting...',
      name: 'importSuccessfulRestarting',
      desc: '',
      args: [],
    );
  }

  /// `Import Failed`
  String get importFailed {
    return Intl.message(
      'Import Failed',
      name: 'importFailed',
      desc: '',
      args: [],
    );
  }

  /// `SAVED`
  String get saved {
    return Intl.message('SAVED', name: 'saved', desc: '', args: []);
  }

  /// `LIVE PREVIEW`
  String get livePreview {
    return Intl.message(
      'LIVE PREVIEW',
      name: 'livePreview',
      desc: '',
      args: [],
    );
  }

  /// `Custom {title}...`
  String customT(String title) {
    return Intl.message(
      'Custom $title...',
      name: 'customT',
      desc: '',
      args: [title],
    );
  }

  /// `Apply Changes`
  String get applyChanges {
    return Intl.message(
      'Apply Changes',
      name: 'applyChanges',
      desc: '',
      args: [],
    );
  }

  /// `System Reset Successful! Restarting...`
  String get systemResetSuccessfulRestarting {
    return Intl.message(
      'System Reset Successful! Restarting...',
      name: 'systemResetSuccessfulRestarting',
      desc: '',
      args: [],
    );
  }

  /// `Reset Failed`
  String get resetFailed {
    return Intl.message(
      'Reset Failed',
      name: 'resetFailed',
      desc: '',
      args: [],
    );
  }

  /// `Apply Language`
  String get applyLanguage {
    return Intl.message(
      'Apply Language',
      name: 'applyLanguage',
      desc: '',
      args: [],
    );
  }

  /// `- Yemen Riyal`
  String get saudiRiyal {
    return Intl.message(
      '- Yemen Riyal',
      name: 'saudiRiyal',
      desc: '',
      args: [],
    );
  }

  /// `$ - US Dollar`
  String get usDollar {
    return Intl.message('\$ - US Dollar', name: 'usDollar', desc: '', args: []);
  }

  /// `Biometric Authentication`
  String get biometricAuthentication {
    return Intl.message(
      'Biometric Authentication',
      name: 'biometricAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Verify identity`
  String get verifyIdentity {
    return Intl.message(
      'Verify identity',
      name: 'verifyIdentity',
      desc: '',
      args: [],
    );
  }

  /// `An authentication error occurred. Please try again.`
  String get authErrorMessage {
    return Intl.message(
      'An authentication error occurred. Please try again.',
      name: 'authErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please set up FaceID or TouchID in your device settings.`
  String get pleaseSetUpBiometrics {
    return Intl.message(
      'Please set up FaceID or TouchID in your device settings.',
      name: 'pleaseSetUpBiometrics',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Biometrics have been temporarily disabled.`
  String get tooManyAttemptsLockout {
    return Intl.message(
      'Too many attempts. Biometrics have been temporarily disabled.',
      name: 'tooManyAttemptsLockout',
      desc: '',
      args: [],
    );
  }

  /// `Please authenticate to confirm it's you`
  String get pleaseAuthenticateToConfirm {
    return Intl.message(
      'Please authenticate to confirm it\'s you',
      name: 'pleaseAuthenticateToConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Biometrics/PIN are not available on this device.`
  String get biometricsNotAvailable {
    return Intl.message(
      'Biometrics/PIN are not available on this device.',
      name: 'biometricsNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No fingerprints or face data registered on this device.`
  String get noBiometricsRegistered {
    return Intl.message(
      'No fingerprints or face data registered on this device.',
      name: 'noBiometricsRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Please try again in 30 seconds.`
  String get tooManyAttemptsRetry {
    return Intl.message(
      'Too many attempts. Please try again in 30 seconds.',
      name: 'tooManyAttemptsRetry',
      desc: '',
      args: [],
    );
  }

  /// `Biometrics disabled. Please unlock using your phone passcode.`
  String get biometricsDisabledUsePasscode {
    return Intl.message(
      'Biometrics disabled. Please unlock using your phone passcode.',
      name: 'biometricsDisabledUsePasscode',
      desc: '',
      args: [],
    );
  }

  /// `This operating system does not support local authentication.`
  String get osNotSupported {
    return Intl.message(
      'This operating system does not support local authentication.',
      name: 'osNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `Identity Verified`
  String get identityVerified {
    return Intl.message(
      'Identity Verified',
      name: 'identityVerified',
      desc: '',
      args: [],
    );
  }

  /// `Save Buffet Backup`
  String get saveBuffetBackup {
    return Intl.message(
      'Save Buffet Backup',
      name: 'saveBuffetBackup',
      desc: '',
      args: [],
    );
  }

  /// `Reset Error: {error}`
  String resetError(String error) {
    return Intl.message(
      'Reset Error: $error',
      name: 'resetError',
      desc: '',
      args: [error],
    );
  }

  /// `Invalid file type`
  String get invalidFileType {
    return Intl.message(
      'Invalid file type',
      name: 'invalidFileType',
      desc: '',
      args: [],
    );
  }

  /// `Search products...`
  String get searchProducts {
    return Intl.message(
      'Search products...',
      name: 'searchProducts',
      desc: '',
      args: [],
    );
  }

  /// `Tap an item to pin it to the top`
  String get tapAnItemToPinItToTheTop {
    return Intl.message(
      'Tap an item to pin it to the top',
      name: 'tapAnItemToPinItToTheTop',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `New Category`
  String get newCategory {
    return Intl.message(
      'New Category',
      name: 'newCategory',
      desc: '',
      args: [],
    );
  }

  /// `Edit Category`
  String get editCategory {
    return Intl.message(
      'Edit Category',
      name: 'editCategory',
      desc: '',
      args: [],
    );
  }

  /// `Category Name`
  String get categoryName {
    return Intl.message(
      'Category Name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Enter name...`
  String get enterName {
    return Intl.message('Enter name...', name: 'enterName', desc: '', args: []);
  }

  /// `Save Category`
  String get saveCategory {
    return Intl.message(
      'Save Category',
      name: 'saveCategory',
      desc: '',
      args: [],
    );
  }

  /// `Deleted Successfully`
  String get deletedSuccessfully {
    return Intl.message(
      'Deleted Successfully',
      name: 'deletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Uncategorized`
  String get uncategorized {
    return Intl.message(
      'Uncategorized',
      name: 'uncategorized',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Chicken Burger`
  String get egChickenBurger {
    return Intl.message(
      'e.g. Chicken Burger',
      name: 'egChickenBurger',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Select Category`
  String get selectCategory {
    return Intl.message(
      'Select Category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Add New Category`
  String get addNewCategory {
    return Intl.message(
      'Add New Category',
      name: 'addNewCategory',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Extra Cheese`
  String get egExtraCheese {
    return Intl.message(
      'e.g. Extra Cheese',
      name: 'egExtraCheese',
      desc: '',
      args: [],
    );
  }

  /// `Permission Required`
  String get permissionRequired {
    return Intl.message(
      'Permission Required',
      name: 'permissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Storage access is needed to save backups. Please grant permission to continue.`
  String get storagePermissionMessage {
    return Intl.message(
      'Storage access is needed to save backups. Please grant permission to continue.',
      name: 'storagePermissionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Grant`
  String get grant {
    return Intl.message('Grant', name: 'grant', desc: '', args: []);
  }

  /// `Basic Details`
  String get basicDetails {
    return Intl.message(
      'Basic Details',
      name: 'basicDetails',
      desc: '',
      args: [],
    );
  }

  /// `ADD NEW ACTION`
  String get addNewAction {
    return Intl.message(
      'ADD NEW ACTION',
      name: 'addNewAction',
      desc: '',
      args: [],
    );
  }

  /// `No Category`
  String get noCategory {
    return Intl.message('No Category', name: 'noCategory', desc: '', args: []);
  }

  /// `Exists`
  String get catExists {
    return Intl.message('Exists', name: 'catExists', desc: '', args: []);
  }

  /// `New Cat`
  String get newCat {
    return Intl.message('New Cat', name: 'newCat', desc: '', args: []);
  }

  /// `Import Now`
  String get importAction {
    return Intl.message('Import Now', name: 'importAction', desc: '', args: []);
  }

  /// `Best Buffet`
  String get bestBuffet {
    return Intl.message('Best Buffet', name: 'bestBuffet', desc: '', args: []);
  }

  /// `Save to Default (backups/)`
  String get saveToDefaultBackups {
    return Intl.message(
      'Save to Default (backups/)',
      name: 'saveToDefaultBackups',
      desc: '',
      args: [],
    );
  }

  /// `Select Folder`
  String get selectFolder {
    return Intl.message(
      'Select Folder',
      name: 'selectFolder',
      desc: '',
      args: [],
    );
  }

  /// `Share File`
  String get shareFile {
    return Intl.message('Share File', name: 'shareFile', desc: '', args: []);
  }

  /// `close`
  String get close {
    return Intl.message('close', name: 'close', desc: '', args: []);
  }

  /// `Saved to {folder}`
  String savedToBackups(String folder) {
    return Intl.message(
      'Saved to $folder',
      name: 'savedToBackups',
      desc: '',
      args: [folder],
    );
  }

  /// `Export Failed`
  String get exportFailed {
    return Intl.message(
      'Export Failed',
      name: 'exportFailed',
      desc: '',
      args: [],
    );
  }

  /// `success`
  String get success {
    return Intl.message('success', name: 'success', desc: '', args: []);
  }

  /// `Export Now`
  String get exportNow {
    return Intl.message('Export Now', name: 'exportNow', desc: '', args: []);
  }

  /// `Invalid Pattern`
  String get invalidPattern {
    return Intl.message(
      'Invalid Pattern',
      name: 'invalidPattern',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Buffet`
  String get welcomeToBuffet {
    return Intl.message(
      'Welcome to Buffet',
      name: 'welcomeToBuffet',
      desc: '',
      args: [],
    );
  }

  /// `There are no categories`
  String get noCategories {
    return Intl.message(
      'There are no categories',
      name: 'noCategories',
      desc: '',
      args: [],
    );
  }

  /// `Add new categories now!`
  String get addNewCategoriesNow {
    return Intl.message(
      'Add new categories now!',
      name: 'addNewCategoriesNow',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 Product} other{{count} Products}}`
  String productCount(int count) {
    return Intl.plural(
      count,
      one: '1 Product',
      other: '$count Products',
      name: 'productCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count}x {name}`
  String quantityLabel(String count, String name) {
    return Intl.message(
      '${count}x $name',
      name: 'quantityLabel',
      desc: '',
      args: [count, name],
    );
  }

  /// `+ {name}`
  String addonPrefix(String name) {
    return Intl.message('+ $name', name: 'addonPrefix', desc: '', args: [name]);
  }

  /// `Welcome to Buffet`
  String get welcomeToBuffetPreviewEn {
    return Intl.message(
      'Welcome to Buffet',
      name: 'welcomeToBuffetPreviewEn',
      desc: '',
      args: [],
    );
  }

  /// `مرحباً بك في بوفيه`
  String get welcomeToBuffetPreviewAr {
    return Intl.message(
      'مرحباً بك في بوفيه',
      name: 'welcomeToBuffetPreviewAr',
      desc: '',
      args: [],
    );
  }

  /// `e.g. yyyy-MM-dd`
  String get egDateFormat {
    return Intl.message(
      'e.g. yyyy-MM-dd',
      name: 'egDateFormat',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to BuffetPOS`
  String get onboardingTitle1 {
    return Intl.message(
      'Welcome to BuffetPOS',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Your smart point-of-sale system designed for speed and simplicity. Manage your buffet like a pro.`
  String get onboardingSubtitle1 {
    return Intl.message(
      'Your smart point-of-sale system designed for speed and simplicity. Manage your buffet like a pro.',
      name: 'onboardingSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Track Every Order`
  String get onboardingTitle2 {
    return Intl.message(
      'Track Every Order',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `From checkout to order history, keep a complete record of all transactions with detailed reports.`
  String get onboardingSubtitle2 {
    return Intl.message(
      'From checkout to order history, keep a complete record of all transactions with detailed reports.',
      name: 'onboardingSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Ready to Go!`
  String get onboardingTitle3 {
    return Intl.message(
      'Ready to Go!',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Set up your catalog, customize your settings, and start taking orders in minutes.`
  String get onboardingSubtitle3 {
    return Intl.message(
      'Set up your catalog, customize your settings, and start taking orders in minutes.',
      name: 'onboardingSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get onboardingNext {
    return Intl.message('Next', name: 'onboardingNext', desc: '', args: []);
  }

  /// `Get Started`
  String get onboardingGetStarted {
    return Intl.message(
      'Get Started',
      name: 'onboardingGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get onboardingSkip {
    return Intl.message('Skip', name: 'onboardingSkip', desc: '', args: []);
  }

  /// `System Default`
  String get systemDefault {
    return Intl.message(
      'System Default',
      name: 'systemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Theme Mode`
  String get themeMode {
    return Intl.message('Theme Mode', name: 'themeMode', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `العربية (Arabic)`
  String get arabic {
    return Intl.message('العربية (Arabic)', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Log In`
  String get login {
    return Intl.message('Log In', name: 'login', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Sign Up`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account? Sign Up',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Log In`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account? Log In',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Search country...`
  String get searchCountry {
    return Intl.message(
      'Search country...',
      name: 'searchCountry',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalidEmail {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email is already registered`
  String get emailAlreadyRegistered {
    return Intl.message(
      'Email is already registered',
      name: 'emailAlreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Email is not registered`
  String get emailNotRegistered {
    return Intl.message(
      'Email is not registered',
      name: 'emailNotRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Logged in successfully`
  String get loginSuccess {
    return Intl.message(
      'Logged in successfully',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Registered successfully`
  String get registerSuccess {
    return Intl.message(
      'Registered successfully',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalidPhoneNumber {
    return Intl.message(
      'Invalid phone number',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get selectCountry {
    return Intl.message(
      'Select Country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Suppliers`
  String get suppliers {
    return Intl.message('Suppliers', name: 'suppliers', desc: '', args: []);
  }

  /// `Accounts`
  String get accounts {
    return Intl.message('Accounts', name: 'accounts', desc: '', args: []);
  }

  /// `Add Supplier`
  String get addSupplier {
    return Intl.message(
      'Add Supplier',
      name: 'addSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Edit Supplier`
  String get editSupplier {
    return Intl.message(
      'Edit Supplier',
      name: 'editSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name`
  String get supplierName {
    return Intl.message(
      'Supplier Name',
      name: 'supplierName',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Credit`
  String get credit {
    return Intl.message('Credit', name: 'credit', desc: '', args: []);
  }

  /// `Debit`
  String get debit {
    return Intl.message('Debit', name: 'debit', desc: '', args: []);
  }

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `Daily Debit`
  String get dailyDebit {
    return Intl.message('Daily Debit', name: 'dailyDebit', desc: '', args: []);
  }

  /// `Daily Credit`
  String get dailyCredit {
    return Intl.message(
      'Daily Credit',
      name: 'dailyCredit',
      desc: '',
      args: [],
    );
  }

  /// `Daily Sales`
  String get dailySales {
    return Intl.message('Daily Sales', name: 'dailySales', desc: '', args: []);
  }

  /// `Net Profit`
  String get netProfit {
    return Intl.message('Net Profit', name: 'netProfit', desc: '', args: []);
  }

  /// `Profits`
  String get profits {
    return Intl.message('Profits', name: 'profits', desc: '', args: []);
  }

  /// `Supplier`
  String get supplier {
    return Intl.message('Supplier', name: 'supplier', desc: '', args: []);
  }

  /// `Select Supplier`
  String get selectSupplier {
    return Intl.message(
      'Select Supplier',
      name: 'selectSupplier',
      desc: '',
      args: [],
    );
  }

  /// `No Supplier`
  String get noSupplier {
    return Intl.message('No Supplier', name: 'noSupplier', desc: '', args: []);
  }

  /// `Add Entry`
  String get addTransaction {
    return Intl.message(
      'Add Entry',
      name: 'addTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Entry Type`
  String get transactionType {
    return Intl.message(
      'Entry Type',
      name: 'transactionType',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Linked Products`
  String get linkedProducts {
    return Intl.message(
      'Linked Products',
      name: 'linkedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Linked Add-ons`
  String get linkedAddons {
    return Intl.message(
      'Linked Add-ons',
      name: 'linkedAddons',
      desc: '',
      args: [],
    );
  }

  /// `Print Report`
  String get printReport {
    return Intl.message(
      'Print Report',
      name: 'printReport',
      desc: '',
      args: [],
    );
  }

  /// `Export Daily Accounts Report`
  String get exportAccountsReport {
    return Intl.message(
      'Export Daily Accounts Report',
      name: 'exportAccountsReport',
      desc: '',
      args: [],
    );
  }

  /// `Ledger / Entries`
  String get ledger {
    return Intl.message('Ledger / Entries', name: 'ledger', desc: '', args: []);
  }

  /// `No entries found.`
  String get noTransactions {
    return Intl.message(
      'No entries found.',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Debit (Payment)`
  String get debitPayment {
    return Intl.message(
      'Debit (Payment)',
      name: 'debitPayment',
      desc: '',
      args: [],
    );
  }

  /// `Credit (Purchase)`
  String get creditPurchase {
    return Intl.message(
      'Credit (Purchase)',
      name: 'creditPurchase',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
