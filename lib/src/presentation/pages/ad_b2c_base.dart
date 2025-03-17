import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';

class AADB2CBase extends StatefulWidget {
  final AADB2CType type;
  final B2CWebViewParams params;
  final ButtonStyleEntity? buttonStyle;
  final ButtonSettingsEntity? buttonSettings;
  final CustomSettingsEntity? customSettings;
  final WebViewSettingsEntity? webviewSettings;

  const AADB2CBase({
    super.key,
    required this.params,
    required this.type,
    this.buttonStyle,
    this.buttonSettings,
    this.customSettings,
    this.webviewSettings,
  });

  @override
  State<AADB2CBase> createState() => _AADB2CBaseState();

  factory AADB2CBase.button({
    required B2CWebViewParams params,
    required ButtonSettingsEntity settings,
    ButtonStyleEntity? buttonStyle,
  }) {
    return AADB2CBase(
      params: params,
      type: AADB2CType.button,
      buttonStyle: buttonStyle,
      buttonSettings: settings,
    );
  }

  factory AADB2CBase.custom({
    required B2CWebViewParams params,
    required CustomSettingsEntity settings,
  }) {
    return AADB2CBase(
      params: params,
      type: AADB2CType.custom,
      customSettings: settings,
    );
  }

  factory AADB2CBase.webview({
    required B2CWebViewParams params,
    required WebViewSettingsEntity settings,
  }) {
    return AADB2CBase(
      params: params,
      type: AADB2CType.webview,
      webviewSettings: settings,
    );
  }
}

class _AADB2CBaseState extends State<AADB2CBase> with MixinControllerAccess {
  Future<void> _initPackage() async => await initInjections();

  @override
  void initState() {
    _initPackage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => switch (widget.type) {
        AADB2CType.button => ADLoginButton(
            params: widget.params,
            buttonStyle: widget.buttonStyle,
            settings: widget.buttonSettings,
          ),
        AADB2CType.custom => AADB2CCustom(
            params: widget.params,
            settings: widget.customSettings,
          ),
        AADB2CType.webview => ADLoginWebView(
            params: widget.params,
            settings: widget.webviewSettings,
          ),
      };
}
