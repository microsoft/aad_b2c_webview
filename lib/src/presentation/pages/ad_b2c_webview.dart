import 'package:aad_b2c_webview/src/core/web/webview_web.dart';
import 'package:aad_b2c_webview/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ADLoginWebView extends StatefulWidget {
  final B2CWebViewParams params;
  final WebViewSettingsEntity? settings;

  const ADLoginWebView({
    super.key,
    required this.params,
    required this.settings,
  }) : assert(settings != null);

  @override
  State<ADLoginWebView> createState() => _ADLoginWebViewState();
}

class _ADLoginWebViewState extends State<ADLoginWebView>
    with MixinControllerAccess {
  @override
  void initState() {
    _initWebview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWeb() : _buildMobile();
  }

  Future<void> _initWebview() async {
    final newParams = widget.params.copyWith(
      onHtmlComponents: _onLoadComponents,
      onHtmlErrorInfo: _onError,
      onAllTokensRetrieved: _onSuccess,
    );
    await controller.initWebView(newParams);
  }

  _onLoadComponents(_) {
    widget.settings?.controllerBuilder(context, actionController);
  }

  _onSuccess({
    required TokenEntity accessToken,
    required TokenEntity idToken,
    required TokenEntity refreshToken,
  }) {
    widget.settings?.onSuccess(context, accessToken, idToken, refreshToken);
  }

  _onError(String message) {
    widget.settings?.onError(context, message);
  }

  Widget _buildMobile() => WebViewWidget(
        controller: controller.uiDependency.mobile,
      );

  Widget _buildWeb() => WebViewWeb(
        controller: controller.uiDependency.web,
      );
}
