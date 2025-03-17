import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/core/commons.dart';
import 'package:example/customizations/mixin_controller.dart';
import 'package:example/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class SignUpMFAPage extends StatefulWidget {
  final bool isLoading;

  const SignUpMFAPage({
    super.key,
    required this.isLoading,
  });

  @override
  State<SignUpMFAPage> createState() => _SignUpMFAPageState();
}

final TextEditingController _emailController = TextEditingController();

class _SignUpMFAPageState extends State<SignUpMFAPage>
    with MixinControllerPage {
  final TextEditingController _codeController = TextEditingController();

  bool _showVerificationCodeInput = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxSize,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          _emailInput(widget.isLoading),
          padding(height: 8.0),
          _codeInput(widget.isLoading),
          padding(height: 32.0),
          if (widget.isLoading)
            _buildLoading()
          else ...[
            verifyAndResendButtons(
              verifyId: 'emailVerificationControl_but_verify_code',
              resendId: 'emailVerificationControl_but_send_new_code',
              showButtons: _showVerificationCodeInput,
              onVerify: _onVerify,
              onChangeState: _changeState,
            ),
            _sendButton(),
            padding(height: 8.0),
          ],
        ],
      ),
    );
  }

  SliverToBoxAdapter _emailInput(bool isLoading) {
    print(_emailController.text);
    return SliverToBoxAdapter(
      child: TextFormField(
        controller: _emailController,
        enabled: !isLoading,
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        readOnly: readOnly,
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
    String id = 'emailVerificationControl_but_send_code';
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
          await actionController.insertAndClick(
            listIdValue: [
              ActionEntity(
                id: 'email',
                value: _emailController.text.trim(),
              ),
            ],
            buttonId: id,
          );
          setState(() => _showVerificationCodeInput = true);
          changeStateLoading(false);
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
          id: 'emailVerificationCode',
          value: _codeController.text.trim(),
        ),
      ],
      buttonId: verifyId,
    );
  }

  bool get readOnly =>
      selectByID('email')?.containsAttribute('disabled') ?? false;
  double get boxSize {
    if (_showVerificationCodeInput) return 280.0;
    if (readOnly) return 60.0;
    return 160.0;
  }
}
