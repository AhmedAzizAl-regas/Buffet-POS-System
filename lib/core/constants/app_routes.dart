class AppRoutes {
  // Use a private constructor to prevent someone from "instantiating" this class
  AppRoutes._();

  static const RouteData startedRoute = pos;
  static const RouteData onboarding = RouteData('onboarding', '/onboarding');
  static const RouteData languageGateway = RouteData('language_gateway', '/auth-gateway');
  static const RouteData login = RouteData('login', '/login');
  static const RouteData register = RouteData('register', '/register');
  static const RouteData pos = RouteData('POS_terminal', '/pos');
  static const RouteData orders = RouteData('order_history', '/order-history');
  static const RouteData catalog = RouteData('catalog', '/catalog');
  static const RouteData settings = RouteData('settings', '/settings');
  static const RouteData report = RouteData('report', '/report');
  static const RouteData logViewer = RouteData('logViewer', '/logs');
  static const RouteData importPreview = RouteData('importPreview', '/import-preview');
  static const RouteData suppliers = RouteData('suppliers', '/suppliers');
  static const RouteData accounts = RouteData('accounts', '/accounts');

  // Example for routes with parameters
  static const RouteData orderDetails = RouteData('order_details', ':id');
}

class RouteData {
  final String name;
  final String path;
  String withId(dynamic id) => path.replaceFirst(':id', id.toString());
  const RouteData(this.name, this.path);
}
