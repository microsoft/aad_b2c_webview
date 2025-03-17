import 'package:aad_b2c_webview/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ADLoginButton extends StatefulWidget {
  final B2CWebViewParams params;
  final ButtonStyleEntity? buttonStyle;
  final ButtonSettingsEntity? settings;

  const ADLoginButton({
    super.key,
    required this.params,
    required this.buttonStyle,
    required this.settings,
  }) : assert(settings != null);

  @override
  State<ADLoginButton> createState() => _ADLoginButtonState();
}

class _ADLoginButtonState extends State<ADLoginButton>
    with MixinControllerAccess {
  bool _isLoading = true;

  @override
  void initState() {
    _initButton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _navigateToWebView,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(
          6.0,
        ),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 36.0,
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  flex: 3,
                  child: widget.buttonStyle?.label ??
                      const Text(
                        'Login with Azure AD',
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                ),
                if (widget.buttonStyle?.showImage ?? true)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/icons8-azure-48.png',
                      package: 'aad_b2c_webview',
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToWebView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: kIsWeb ? _buildWeb() : _buildMobile(),
          );
        },
      ),
    );
  }

  Future<void> _initButton() async {
    final newParams = widget.params.copyWith(
      onHtmlComponents: _onLoadComponents,
      onHtmlUrlChange: _onChangeUrl,
      onHtmlErrorInfo: _onError,
      onAllTokensRetrieved: _onSuccess,
    );
    await controller.initWebView(newParams);
  }

  _onChangeUrl(_) => setState(() => _isLoading = true);

  _onLoadComponents(_) => setState(() => _isLoading = false);

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

  Widget _buildMobile() {
    return Stack(
      children: [
        if (_isLoading)
          widget.params.loadingReplacement ?? const DefaultLoading(),
        WebViewWidget(
          controller: controller.uiDependency.mobile,
        ),
      ],
    );
  }

  /// It will be developed in the next version
  Widget _buildWeb() => const Placeholder();
}
