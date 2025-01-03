import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/core/commons.dart';
import 'package:flutter/material.dart';
import 'widgets/button_widget.dart';

class B2CWithDynamicCustomization extends StatefulWidget {
  final B2CWebViewParams params;
  const B2CWithDynamicCustomization({super.key, required this.params});

  @override
  State<B2CWithDynamicCustomization> createState() =>
      _B2CWithDynamicCustomizationState();
}

class _B2CWithDynamicCustomizationState
    extends State<B2CWithDynamicCustomization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scaffold(
        body: AADB2CBase.custom(
          params: widget.params,
          settings: CustomSettingsEntity(
            onError: (BuildContext context, String? error) {
              setState(() => _isLoading = false);
              var snackBar = SnackBar(
                content: Text(error ?? ''),
                backgroundColor: Colors.redAccent,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            onSuccess: (context, accessToken, idToken, refreshToken) async {
              setState(() => _isLoading = false);
              var snackBar = const SnackBar(
                content: Text('Successfully Authenticated!'),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            pageBuilder: (_, __, controller, List<HtmlParseEntity>? htmlItems) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: CustomScrollView(
                    slivers: [
                      defaultImage(),
                      buildTitle('B2C Page Dynamic'),
                      SliverList.builder(
                        itemCount: htmlItems?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final item = htmlItems?[index];
                          if (item?.type == null) return const SizedBox();
                          return switch (item!.type) {
                            HtmlParseType.input => _inputBuilder(item),
                            HtmlParseType.button => _button(
                                controller,
                                item,
                                false,
                              ),
                            HtmlParseType.a => _button(
                                controller,
                                item,
                                true,
                              ),
                            HtmlParseType.none => const SizedBox(),
                          };
                        },
                      ),
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

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _inputBuilder(HtmlParseEntity params) {
    return TextFormField(
      controller: TextEditingController(),
      enabled: !_isLoading,
      decoration: InputDecoration(
        labelText: params.name,
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget _button(
    ActionController controller,
    HtmlParseEntity params,
    bool isLink,
  ) {
    onTap() async {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _isLoading = true);
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        await controller.insertAndClick(
          listIdValue: [
            ActionEntity(id: 'email', value: email),
            ActionEntity(id: 'password', value: password),
          ],
          buttonId: 'next',
        );
      }
    }

    if (_isLoading) return _buildLoading();
    if (isLink) {
      return TextButton(
        onPressed: onTap,
        child: Text(
          params.textContent,
          style: const TextStyle(
            decorationStyle: TextDecorationStyle.solid,
          ),
        ),
      );
    }
    return ButtonWidget(
      title: params.textContent,
      icon: Icons.login_outlined,
      onTap: onTap,
    );
  }

  Widget _buildLoading() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    );
  }
}
