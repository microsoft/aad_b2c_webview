import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class CustomSettingsEntity {
  final WebViewErrorFunction onError;
  final WebViewSuccessFunction onSuccess;
  final NullableWidgetsBuilder pageBuilder;
  final WebViewErrorWidgetBuilder? errorWidget;
  final bool? enableAutomaticAuthenticationAttempt;

  CustomSettingsEntity({
    required this.onError,
    required this.onSuccess,
    required this.pageBuilder,
    this.errorWidget,
    this.enableAutomaticAuthenticationAttempt,
  });
}
