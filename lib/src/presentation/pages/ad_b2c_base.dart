import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';

class ADB2CBase extends StatefulWidget {
  final ADB2CType type;
  final B2CWebViewParams params;
  final ButtonStyleEntity? buttonStyle;
  final ButtonSettingsEntity? buttonSettings;
  final CustomSettingsEntity? customSettings;
  final WebViewSettingsEntity? webviewSettings;

  const ADB2CBase({
    super.key,
    required this.params,
    required this.type,
    this.buttonStyle,
    this.buttonSettings,
    this.customSettings,
    this.webviewSettings,
  });

  @override
  State<ADB2CBase> createState() => _ADB2CBaseState();

  factory ADB2CBase.button({
    required B2CWebViewParams params,
    required ButtonSettingsEntity settings,
    ButtonStyleEntity? buttonStyle,
  }) {
    return ADB2CBase(
      params: params,
      type: ADB2CType.button,
      buttonStyle: buttonStyle,
      buttonSettings: settings,
    );
  }

  factory ADB2CBase.custom({
    required B2CWebViewParams params,
    required CustomSettingsEntity settings,
  }) {
    return ADB2CBase(
      params: params,
      type: ADB2CType.custom,
      customSettings: settings,
    );
  }

  factory ADB2CBase.webview({
    required B2CWebViewParams params,
    required WebViewSettingsEntity settings,
  }) {
    return ADB2CBase(
      params: params,
      type: ADB2CType.webview,
      webviewSettings: settings,
    );
  }
}

class _ADB2CBaseState extends State<ADB2CBase> with MixinControllerAccess {
  Future<void> _initPackage() async => await initInjections();

  @override
  void initState() {
    _initPackage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => switch (widget.type) {
        ADB2CType.button => ADLoginButton(
            params: widget.params,
            buttonStyle: widget.buttonStyle,
            settings: widget.buttonSettings,
          ),
        ADB2CType.custom => ADB2CCustom(
            params: widget.params,
            settings: widget.customSettings,
          ),
        ADB2CType.webview => ADLoginWebView(
            params: widget.params,
            settings: widget.webviewSettings,
          ),
      };
}
