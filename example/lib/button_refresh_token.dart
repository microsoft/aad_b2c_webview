import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/main.dart';
import 'package:example/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonRefreshToken extends StatefulWidget {
  const ButtonRefreshToken({super.key});

  @override
  State<ButtonRefreshToken> createState() => _ButtonRefreshTokenState();
}

class _ButtonRefreshTokenState extends State<ButtonRefreshToken>
    with MixinControllerAccess {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _enableToCopy = false;
  AzureTokenResponseEntity? response;
  final _refreshTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Refresh Token Page',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _refreshTokenController,
                enabled: !_isLoading,
                maxLines: 10,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Old Refresh Token',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, put the old refresh token';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ButtonWidget(
                  onTap: _refreshToken,
                  title: 'Refresh token',
                  icon: Icons.refresh_outlined,
                  backgroundColor: Colors.deepOrangeAccent,
                ),
              const SizedBox(height: 16.0),
              ButtonWidget(
                onTap: () {
                  if (_enableToCopy) {
                    Clipboard.setData(
                      ClipboardData(
                        text: 'access:${response?.accessToken}\n\n'
                            'idToken:${response?.idToken}\n\n'
                            'refreshToken:${response?.refreshToken}',
                      ),
                    );
                  }
                },
                title: 'Copy Refresh Token',
                icon: Icons.copy_all,
                backgroundColor: _enableToCopy
                    ? Colors.orange
                    : Colors.deepOrangeAccent.shade100,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshToken() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      response = await controller.refreshToken(
        B2CAuthEntity(
          refreshToken: _refreshTokenController.text.trim(),
          userFlowName: aadB2CUserFlowName,
          tenantBaseUrl: aadB2CUserAuthFlow,
          clientId: aadB2CClientID,
        ),
      );
      setState(() => _isLoading = false);
      if (response != null) {
        setState(() => _enableToCopy = true);
        var snackBar = const SnackBar(
          content: Text('Successfully Refresh token!'),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var snackBar = const SnackBar(
          content: Text('Error in refresh token'),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
