import 'package:aad_b2c_webview/aad_b2c_webview.dart';

abstract interface class WebViewControllersHelper {
  WebViewController get mobile;
  PlatformWebViewController get web;
}

class WebViewControllersUsecaseImpl implements WebViewControllersHelper {
  final WebViewController _controllerMobile;
  final PlatformWebViewController _controllerWeb;

  WebViewControllersUsecaseImpl({
    required WebViewController controllerMobile,
    required PlatformWebViewController controllerWeb,
  })  : _controllerMobile = controllerMobile,
        _controllerWeb = controllerWeb;

  @override
  WebViewController get mobile => _controllerMobile;

  @override
  PlatformWebViewController get web => _controllerWeb;
}
