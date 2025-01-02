import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class ButtonSettingsEntity {
  final WebViewErrorFunction onError;
  final WebViewSuccessFunction onSuccess;

  ButtonSettingsEntity({
    required this.onError,
    required this.onSuccess,
  });
}
