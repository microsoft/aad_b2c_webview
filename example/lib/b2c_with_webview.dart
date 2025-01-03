import 'dart:developer';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'widgets/button_widget.dart';

class B2CWithWebView extends StatefulWidget {
  final B2CWebViewParams params;
  const B2CWithWebView({super.key, required this.params});

  @override
  State<B2CWithWebView> createState() => _B2CWithWebViewState();
}

class _B2CWithWebViewState extends State<B2CWithWebView> {
  ActionController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Azure B2C WebView',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                width: MediaQuery.sizeOf(context).width,
                child: AADB2CBase.webview(
                  params: widget.params,
                  settings: WebViewSettingsEntity(
                    onError: _onError,
                    onSuccess: _onSuccess,
                    controllerBuilder: (
                      BuildContext context,
                      ActionController action,
                    ) =>
                        _controller = action,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ButtonWidget(
                onTap: () async {
                  try {
                    await _controller?.insertAndClick(
                      listIdValue: [
                        ActionEntity(id: 'email', value: 'example@email.com'),
                        ActionEntity(id: 'password', value: '12345678'),
                      ],
                      buttonId: 'next',
                    );
                  } catch (error, trace) {
                    if (kDebugMode) log('Error: $error', stackTrace: trace);
                  }
                },
                title: 'Interact with webview',
                icon: Icons.move_up_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onSuccess(
    BuildContext context,
    accessToken,
    idToken,
    refreshToken,
  ) {
    var snackBar = const SnackBar(
      content: Text('Successfully Authenticated!'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _onError(BuildContext context, String? error) {
    var snackBar = SnackBar(
      content: Text(error ?? ''),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
