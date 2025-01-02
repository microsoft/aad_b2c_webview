import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/core/commons.dart';
import 'package:example/customizations/mixin_controller.dart';
import 'package:example/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class SignInMFAPage extends StatefulWidget {
  const SignInMFAPage({super.key});

  @override
  State<SignInMFAPage> createState() => _SignInMFAPageState();
}

class _SignInMFAPageState extends State<SignInMFAPage>
    with MixinControllerPage {
  final _codeController = TextEditingController();
  bool _showVerificationCodeInput = false;

  @override
  Widget build(BuildContext context) {
    changeStateLoading(false);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: loadingNotifier,
        builder: (_, isLoading, __) => CustomScrollView(
          slivers: [
            defaultImage(),
            buildTitle('MFA'),
            _emailInput(isLoading),
            padding(height: 8.0),
            _codeInput(isLoading),
            padding(height: 32.0),
            if (isLoading)
              _buildLoading()
            else ...[
              verifyAndResendButtons(
                verifyId: 'ReadOnlyEmail_ver_but_verify',
                resendId: 'ReadOnlyEmail_ver_but_resend',
                showButtons: _showVerificationCodeInput,
                onVerify: _onVerify,
                onChangeState: _changeState,
              ),
              _sendButton(),
              padding(height: 8.0),
              _continueButton(),
            ],
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _emailInput(bool isLoading) {
    final emailInput = selectByID('ReadOnlyEmail');
    final inputValue = emailInput?.getAttribute('value');
    return SliverToBoxAdapter(
      child: TextFormField(
        initialValue: inputValue ?? '',
        enabled: !isLoading,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
      ),
    );
  }

  SliverToBoxAdapter _codeInput(bool isLoading) {
    if (_showVerificationCodeInput) {
      return SliverToBoxAdapter(
        child: TextFormField(
          controller: _codeController,
          enabled: !isLoading,
          decoration: const InputDecoration(
            labelText: 'Verification Code',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please, enter verification code';
            }
            return null;
          },
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox());
  }

  SliverToBoxAdapter _sendButton() {
    String id = 'ReadOnlyEmail_ver_but_send';
    final disabledButton =
        selectByID(id)?.getAttribute('aria-hidden') == 'true';
    if (disabledButton || _showVerificationCodeInput) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: ButtonWidget(
        title: 'Send Verification Code',
        icon: Icons.send,
        onTap: () async {
          changeStateLoading(true);
          await actionController.insertAndClick(buttonId: id);
          setState(() => _showVerificationCodeInput = true);
          changeStateLoading(false);
        },
      ),
    );
  }

  SliverToBoxAdapter _continueButton() {
    final disabledButton =
        selectByID('continue')?.getAttribute('aria-disabled') == 'true';

    return SliverToBoxAdapter(
      child: ButtonWidget(
        title: 'Continue',
        icon: Icons.verified_user_outlined,
        backgroundColor: disabledButton ? Colors.blue.shade100 : Colors.blue,
        onTap: () async {
          if (!disabledButton) {
            changeStateLoading(true);
            await actionController.insertAndClick(buttonId: 'continue');
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

  void _changeState(MixinControllerState state) {
    final disabledContinue =
        selectByID('continue')?.getAttribute('aria-disabled') == 'true';
    final sendButton =
        selectByID('ReadOnlyEmail_ver_but_send')?.getAttribute('aria-hidden') ==
            'true';

    if (mounted &&
        disabledContinue &&
        sendButton &&
        state == MixinControllerState.complete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _showVerificationCodeInput = true);
      });
    }
  }

  void _onVerify(String verifyId) async {
    await actionController.insertAndClick(
      listIdValue: [
        ActionEntity(
          id: 'ReadOnlyEmail_ver_input',
          value: _codeController.text.trim(),
        ),
      ],
      buttonId: verifyId,
    );
  }
}
