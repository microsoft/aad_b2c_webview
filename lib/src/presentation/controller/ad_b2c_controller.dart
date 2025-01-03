import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class AADB2CController with MixinControllerAccess {
  final B2CAuthRepository _b2cAuthRepository;
  final B2CWebViewRepository _b2cWebViewRepository;
  final WebViewControllersHelper _webviewController;

  AADB2CController({
    required B2CAuthRepository b2cAuthRepository,
    required B2CWebViewRepository b2cWebViewRepository,
    required WebViewControllersHelper webviewController,
  })  : _b2cAuthRepository = b2cAuthRepository,
        _b2cWebViewRepository = b2cWebViewRepository,
        _webviewController = webviewController;

  WebViewControllersHelper get uiDependency => _webviewController;

  Future<void> initWebView(B2CWebViewParams params) async {
    if (hasInitialize) {
      await _webviewController.mobile.removeJavaScriptChannel(
        FlutterJs.jsFlutterAlertChannel,
      );
      await _webviewController.mobile.removeJavaScriptChannel(
        FlutterJs.jsFlutterComponentChannel,
      );
    }
    return await _b2cWebViewRepository.initialize(params);
  }

  Future<AzureTokenResponseEntity?> refreshToken(B2CAuthEntity params) =>
      _b2cAuthRepository.refreshTokens(params);
}
