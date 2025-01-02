import 'dart:developer';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/core/commons.dart';
import 'package:example/customizations/mixin_controller.dart';
import 'package:example/customizations/sign_up_mfa_page.dart';
import 'package:example/widgets/button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with MixinControllerPage {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    changeStateLoading(false);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: ValueListenableBuilder<bool>(
          valueListenable: loadingNotifier,
          builder: (_, isLoading, __) => CustomScrollView(
            slivers: [
              defaultImage(),
              buildTitle('B2C Sign Up Page'),
              _mfaPage(isLoading),
              padding(height: 16.0),
              _passInput(isLoading),
              padding(height: 8.0),
              _confirmPassInput(isLoading),
              padding(height: 8.0),
              _nameInput(isLoading),
              padding(height: 8.0),
              _lastNameInput(isLoading),
              padding(height: 32.0),
              _createButton(isLoading),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _mfaPage(bool isLoading) {
    return SliverToBoxAdapter(
      child: SignUpMFAPage(
        isLoading: isLoading,
      ),
    );
  }

  SliverToBoxAdapter _passInput(bool isLoading) {
    final disabled =
        selectByID('newPassword')?.getAttribute('aria-disabled') == 'true';

    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _passwordController,
        enabled: !isLoading && !disabled,
        decoration: const InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please, enter a password';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters long';
          }
          return null;
        },
      ),
    );
  }

  SliverToBoxAdapter _confirmPassInput(bool isLoading) {
    final disabled =
        selectByID('reenterPassword')?.getAttribute('aria-disabled') == 'true';

    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _confirmController,
        enabled: !isLoading && !disabled,
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please, confirm password';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters long';
          }
          if (passText != confirmPassText) {
            return 'The passwords are different';
          }
          return null;
        },
      ),
    );
  }

  SliverToBoxAdapter _nameInput(bool isLoading) {
    final disabled =
        selectByID('givenName')?.getAttribute('aria-disabled') == 'true';

    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _nameController,
        enabled: !isLoading && !disabled,
        decoration: const InputDecoration(
          labelText: 'Give Name',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please, enter a name';
          }
          if (value.length < 3) {
            return 'The name must contain more than 3 characters';
          }
          return null;
        },
      ),
    );
  }

  SliverToBoxAdapter _lastNameInput(bool isLoading) {
    final disabled =
        selectByID('surname')?.getAttribute('aria-disabled') == 'true';

    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _lastNameController,
        enabled: !isLoading && !disabled,
        decoration: const InputDecoration(
          labelText: 'Last Name',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please, enter a last name';
          }
          if (value.length < 3) {
            return 'The last name must contain more than 3 characters';
          }
          return null;
        },
      ),
    );
  }

  SliverToBoxAdapter _createButton(bool isLoading) {
    const id = 'continue';
    final disabled = selectByID(id)?.getAttribute('aria-disabled') == 'true';

    if (isLoading && !disabled) return _buildLoading();
    return SliverToBoxAdapter(
      child: ButtonWidget(
        title: 'Create',
        icon: Icons.create,
        onTap: () async {
          if (_formKey.currentState?.validate() ?? false) {
            changeStateLoading(true);
            try {
              await actionController.insertAndClick(
                listIdValue: [
                  ActionEntity(id: 'newPassword', value: passText),
                  ActionEntity(id: 'reenterPassword', value: confirmPassText),
                  ActionEntity(id: 'givenName', value: nameText),
                  ActionEntity(id: 'surname', value: lastNameText),
                ],
                buttonId: id,
              );

              await actionController.getCustomAlerts([
                FlutterJsCustomAlert(
                    type: JsDocumentType.elementById,
                    code: 'claimVerificationServerError',
                    conditions: {
                      'aria-hidden': 'false',
                    })
              ]);
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

  String get passText => _passwordController.text.trim();
  String get confirmPassText => _confirmController.text.trim();
  String get nameText => _nameController.text.trim();
  String get lastNameText => _lastNameController.text.trim();
  String get btnVerifyId => 'emailVerificationControl_but_verify_code';
  String get btnResendId => 'emailVerificationControl_but_send_new_code';
}
