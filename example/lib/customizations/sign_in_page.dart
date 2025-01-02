import 'dart:developer';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/core/commons.dart';
import 'package:example/customizations/mixin_controller.dart';
import 'package:example/widgets/button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with MixinControllerPage {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: ValueListenableBuilder<bool>(
          valueListenable: loadingNotifier,
          builder: (_, isLoading, __) => CustomScrollView(
            slivers: [
              defaultImage(),
              buildTitle('B2C Sign In Page'),
              _emailInput(isLoading),
              padding(height: 8.0),
              _passInput(isLoading),
              padding(height: 32.0),
              _loginButton(isLoading),
              padding(height: 8.0),
              _signUpButton(isLoading),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _emailInput(bool isLoading) {
    final emailInput = selectByID('email');

    if (emailInput == null) return _buildEmpty();
    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _emailController,
        enabled: !isLoading,
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

  SliverToBoxAdapter _passInput(bool isLoading) {
    final passInput = selectByID('password');

    if (passInput == null) return _buildEmpty();
    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _passwordController,
        enabled: !isLoading,
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

  SliverToBoxAdapter _loginButton(bool isLoading) {
    final loginButton = selectByID('next');

    if (isLoading || loginButton == null) return _buildLoading();
    return SliverToBoxAdapter(
      child: ButtonWidget(
        title: 'Sign In',
        icon: Icons.login_outlined,
        onTap: () async {
          if (_formKey.currentState?.validate() ?? false) {
            changeStateLoading(true);
            String email = _emailController.text.trim();
            String password = _passwordController.text.trim();
            try {
              await actionController.insertAndClick(
                listIdValue: [
                  ActionEntity(id: 'email', value: email),
                  ActionEntity(id: 'password', value: password),
                ],
                buttonId: loginButton.id,
              );
            } catch (error, trace) {
              if (kDebugMode) log('Error: $error', stackTrace: trace);
            }
          }
        },
      ),
    );
  }

  /// Example of a component using data retrieved from the B2C page
  SliverToBoxAdapter _signUpButton(bool isLoading) {
    final button = selectByID('createAccount');

    if (isLoading || button == null) return _buildEmpty();
    return SliverToBoxAdapter(
      child: OutlinedButton(
        onPressed: () async {
          try {
            await actionController.insertAndClick(buttonId: button.id);
          } catch (error, trace) {
            if (kDebugMode) log('Error: $error', stackTrace: trace);
          }
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.all(16.0),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: Text(
          button.textContent,
        ),
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

  SliverToBoxAdapter _buildEmpty() {
    return const SliverToBoxAdapter(child: SizedBox());
  }
}
