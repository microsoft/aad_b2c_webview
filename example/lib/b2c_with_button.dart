import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';

class B2CWithButton extends StatelessWidget {
  final B2CWebViewParams params;
  const B2CWithButton({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Azure B2C Button',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              AADB2CBase.button(
                params: params,
                settings: ButtonSettingsEntity(
                  onError: _onError,
                  onSuccess: _onSuccess,
                ),
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
