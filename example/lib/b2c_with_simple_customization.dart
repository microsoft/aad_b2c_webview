import 'dart:developer';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/commons.dart';
import 'widgets/button_widget.dart';

class B2CWithSimpleCustomization extends StatefulWidget {
  final B2CWebViewParams params;
  const B2CWithSimpleCustomization({super.key, required this.params});

  @override
  State<B2CWithSimpleCustomization> createState() =>
      _B2CWithSimpleCustomizationState();
}

class _B2CWithSimpleCustomizationState
    extends State<B2CWithSimpleCustomization> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scaffold(
        body: AADB2CBase.custom(
          params: widget.params,
          settings: CustomSettingsEntity(
            onError: _onError,
            onSuccess: _onSuccess,
            enableAutomaticAuthenticationAttempt: true,
            pageBuilder: (_, __, controller, List<HtmlParseEntity>? htmlItem) {
              final emailInput = htmlItem?.selectByID('email');
              final passInput = htmlItem?.selectByID('password');
              final loginButton = htmlItem?.selectByID('next');

              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: CustomScrollView(
                    slivers: [
                      defaultImage(),
                      buildTitle('B2C Simple Customization'),
                      if (emailInput != null) _emailInput(),
                      padding(height: 8.0),
                      if (passInput != null) _passInput(),
                      padding(height: 32.0),
                      if (loginButton != null) _loginButton(controller),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _emailInput() {
    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _emailController,
        enabled: !_isLoading,
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please, enter an email';
          }
          final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegExp.hasMatch(value)) {
            return 'Please, enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  SliverToBoxAdapter _passInput() {
    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _passwordController,
        enabled: !_isLoading,
        decoration: const InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please, enter a password';
          }
          return null;
        },
      ),
    );
  }

  SliverToBoxAdapter _loginButton(ActionController controller) {
    if (_isLoading) return _buildLoading();
    return SliverToBoxAdapter(
      child: ButtonWidget(
        title: 'Sign In',
        icon: Icons.login_outlined,
        onTap: () async {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() => _isLoading = true);
            String email = _emailController.text.trim();
            String password = _passwordController.text.trim();
            try {
              await controller.insertAndClick(
                listIdValue: [
                  ActionEntity(id: 'email', value: email),
                  ActionEntity(id: 'password', value: password),
                ],
                buttonId: 'next',
              );
            } catch (error, trace) {
              if (kDebugMode) log('Error: $error', stackTrace: trace);
            }
          }
        },
      ),
    );
  }

  SliverToBoxAdapter _buildLoading() {
    return const SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void _onSuccess(
    BuildContext context,
    accessToken,
    idToken,
    refreshToken,
  ) {
    Clipboard.setData(
      ClipboardData(
        text: 'access:${accessToken.value}\n'
            'idToken:${idToken.value}\n'
            'refreshToken:${refreshToken.value}',
      ),
    );
    var snackBar = const SnackBar(
      content: Text('Successfully Authenticated!'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() => _isLoading = false);
  }

  void _onError(BuildContext context, String? error) {
    setState(() => _isLoading = false);
    var snackBar = SnackBar(
      content: Text(error ?? ''),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
