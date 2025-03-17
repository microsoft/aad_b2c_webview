import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/customizations/empty_page.dart';
import 'package:example/customizations/sign_in_mfa_page.dart';
import 'package:example/customizations/mixin_controller.dart';
import 'package:example/customizations/sign_in_page.dart';
import 'package:example/customizations/sign_up_page.dart';
import 'package:example/customizations/success_redirect.dart';
import 'package:flutter/material.dart';

class B2CWithMultipleCustomizations extends StatefulWidget {
  final B2CWebViewParams params;
  const B2CWithMultipleCustomizations({super.key, required this.params});

  @override
  State<B2CWithMultipleCustomizations> createState() =>
      _B2CWithMultipleCustomizationsState();
}

class _B2CWithMultipleCustomizationsState
    extends State<B2CWithMultipleCustomizations> with MixinControllerPage {
  @override
  void dispose() {
    changeStateLoading(false);
    super.dispose();
  }

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
            pageBuilder: (
              context,
              String? currentUrl,
              ActionController controller,
              List<HtmlParseEntity>? htmlItemsBuilder,
            ) {
              final bool areSameItems = loadPageData(
                dataParams: widget.params,
                dataController: controller,
                dataHtmlItems: htmlItemsBuilder,
              );

              if (currentUrl == null) return const EmptyPage();

              if (_goToMFAPage(currentUrl) && !areSameItems) {
                return SignInMFAPage(key: UniqueKey());
              }

              if (_goToSignUpPage(currentUrl)) {
                return SignUpPage(key: UniqueKey());
              }

              return const SignInPage();
            },
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

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => SuccessRedirect(
          accessToken: accessToken,
          idToken: idToken,
          refreshToken: refreshToken,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  _onError(BuildContext context, String? error) {
    changeStateLoading(false);
    var snackBar = SnackBar(
      content: Text(error ?? ''),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _goToMFAPage(String url) {
    final signIn = url.contains('/CombinedSigninAndSignup/confirmed');
    final asserted = url.contains('/SelfAsserted/confirmed');
    return signIn || asserted;
  }

  bool _goToSignUpPage(String url) {
    final signUp = url.contains('/CombinedSigninAndSignup/unified');
    return signUp;
  }
}
