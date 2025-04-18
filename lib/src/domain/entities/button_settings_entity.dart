import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class ButtonSettingsEntity {
  final WebViewErrorFunction onError;
  final WebViewSuccessFunction onSuccess;
  final WebViewChangeFunction onKeepLoading;

  ButtonSettingsEntity({
    required this.onError,
    required this.onSuccess,
    required this.onKeepLoading,
  });
}
