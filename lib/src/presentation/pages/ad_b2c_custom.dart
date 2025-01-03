import 'dart:convert';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';

class AADB2CCustom extends StatefulWidget {
  final B2CWebViewParams params;
  final CustomSettingsEntity? settings;

  const AADB2CCustom({
    super.key,
    required this.params,
    required this.settings,
  }) : assert(settings != null);

  @override
  State<AADB2CCustom> createState() => _AADB2CCustomState();
}

class _AADB2CCustomState extends State<AADB2CCustom>
    with MixinControllerAccess {
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUrl;
  List<HtmlParseEntity>? _formFields;

  @override
  void initState() {
    _initCustom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.params.loadingReplacement ?? const DefaultLoading();
    }

    if (_errorMessage != null && widget.settings?.errorWidget != null) {
      return widget.settings!.errorWidget!(context, _errorMessage);
    }

    if (_formFields != null) {
      return widget.settings?.pageBuilder(
            context,
            _currentUrl,
            actionController,
            _formFields,
          ) ??
          DefaultError(message: _errorMessage);
    }

    return DefaultError(message: _errorMessage);
  }

  Future<void> _initCustom() async {
    final newParams = widget.params.copyWith(
      onHtmlComponents: _onLoadComponents,
      onHtmlUrlChange: _onChangeUrl,
      onHtmlErrorInfo: _onError,
      onAllTokensRetrieved: _onSuccess,
    );
    await controller.initWebView(newParams);
  }

  void _onLoadComponents(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    List<HtmlParseEntity> formFields =
        jsonList.map((json) => HtmlParseEntity.fromJson(json)).toList();

    if (mounted) {
      setState(() {
        _formFields = formFields;
        _isLoading = false;
      });
    }
  }

  void _onChangeUrl(String url) {
    setState(() => _currentUrl = url);
    if (url.contains(widget.params.redirectUrl)) {
      setState(() => _isLoading = true);
    }
  }

  void _onSuccess({
    required TokenEntity accessToken,
    required TokenEntity idToken,
    required TokenEntity refreshToken,
  }) async {
    widget.settings?.onSuccess(context, accessToken, idToken, refreshToken);
    if (mounted) setState(() => _isLoading = false);
  }

  void _onError(String message) {
    if (mounted) {
      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
    }
    widget.settings?.onError(context, message);
  }
}
