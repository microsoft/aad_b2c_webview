import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class WebViewSettingsEntity {
  final WebViewErrorFunction onError;
  final WebViewSuccessFunction onSuccess;
  final WebViewControllerBuilder controllerBuilder;

  WebViewSettingsEntity({
    required this.onError,
    required this.onSuccess,
    required this.controllerBuilder,
  });
}
