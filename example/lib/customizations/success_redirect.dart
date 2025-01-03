import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/main.dart';
import 'package:example/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessRedirect extends StatefulWidget {
  final TokenEntity? accessToken;
  final TokenEntity? idToken;
  final TokenEntity? refreshToken;

  const SuccessRedirect({
    super.key,
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
  });

  @override
  State<SuccessRedirect> createState() => _SuccessRedirectState();
}

class _SuccessRedirectState extends State<SuccessRedirect>
    with MixinControllerAccess {
  bool _isLoading = false;
  bool _enableToCopy = false;
  AzureTokenResponseEntity? response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Success'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Success Page',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32.0),
            _buildCopyResultButton(),
            const SizedBox(height: 16.0),
            _isLoading ? _buildLoadingIndicator() : _buildRefreshTokenButton(),
            const SizedBox(height: 16.0),
            _buildCopyRefreshTokenButton(),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyResultButton() {
    return ButtonWidget(
      onTap: _copyResultToClipboard,
      title: 'Copy result',
      icon: Icons.copy_all,
      backgroundColor: Colors.blueAccent,
    );
  }

  Widget _buildRefreshTokenButton() {
    return ButtonWidget(
      onTap: _refreshToken,
      title: 'Refresh token',
      icon: Icons.refresh_outlined,
      backgroundColor: Colors.deepOrangeAccent,
    );
  }

  Widget _buildCopyRefreshTokenButton() {
    return ButtonWidget(
      onTap: _copyRefreshTokenToClipboard,
      title: 'Copy Refresh Token',
      icon: Icons.copy_all,
      backgroundColor:
          _enableToCopy ? Colors.orange : Colors.deepOrangeAccent.shade100,
    );
  }

  Widget _buildLoadingIndicator() {
    return const CircularProgressIndicator();
  }

  void _copyResultToClipboard() {
    Clipboard.setData(
      ClipboardData(
        text: 'access:${widget.accessToken?.value}\n\n'
            'idToken:${widget.idToken?.value}\n\n'
            'refreshToken:${widget.refreshToken?.value}',
      ),
    );
    _showSnackBar('Result copied to clipboard');
  }

  void _copyRefreshTokenToClipboard() {
    if (_enableToCopy) {
      Clipboard.setData(
        ClipboardData(
          text: 'access:${response?.accessToken}\n\n'
              'idToken:${response?.idToken}\n\n'
              'refreshToken:${response?.refreshToken}',
        ),
      );
      _showSnackBar('Refresh token copied to clipboard');
    }
  }

  void _refreshToken() async {
    if (widget.refreshToken?.value == null) {
      _showSnackBar(
        'Refresh token is NULL',
        backgroundColor: Colors.orange,
      );
      return;
    }

    setState(() => _isLoading = true);
    response = await controller.refreshToken(
      B2CAuthEntity(
        refreshToken: widget.refreshToken?.value,
        userFlowName: aadB2CUserFlowName,
        tenantBaseUrl: aadB2CUserAuthFlow,
        clientId: aadB2CClientID,
      ),
    );
    setState(() => _isLoading = false);

    if (response != null) {
      setState(() => _enableToCopy = true);
      _showSnackBar(
        'Successfully refreshed token!',
        backgroundColor: Colors.green,
      );
    } else {
      _showSnackBar(
        'Error in refreshing token',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.blue}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
