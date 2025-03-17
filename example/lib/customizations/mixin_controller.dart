import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/widgets/button_widget.dart';
import 'package:flutter/material.dart';

enum MixinControllerState { loading, empty, complete }

final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
void changeStateLoading(bool value) => loadingNotifier.value = value;

late final ValueNotifier<B2CWebViewParams> _params;
B2CWebViewParams get params => _params.value;

late final ValueNotifier<ActionController> _actionController;
ActionController get actionController => _actionController.value;

late final ValueNotifier<List<HtmlParseEntity>?> _htmlItems;
List<HtmlParseEntity>? get htmlItems => _htmlItems.value;

final ValueNotifier<bool> _hasInitialized = ValueNotifier(false);
final ValueNotifier<bool> _forceReloadPage = ValueNotifier(false);

mixin MixinControllerPage {
  bool loadPageData({
    required B2CWebViewParams dataParams,
    required ActionController dataController,
    required List<HtmlParseEntity>? dataHtmlItems,
  }) {
    bool areSameItems = false;
    if (!_hasInitialized.value) {
      _params = ValueNotifier(dataParams);
      _actionController = ValueNotifier(dataController);
      _htmlItems = ValueNotifier(dataHtmlItems);
      _hasInitialized.value = true;
      _forceReloadPage.value = false;
      return areSameItems;
    } else {
      areSameItems = _htmlItems.value == dataHtmlItems;
      _params.value = dataParams;
      _actionController.value = dataController;
      _htmlItems.value = dataHtmlItems;
      if (_forceReloadPage.value) areSameItems = false;
      _forceReloadPage.value = false;
      return areSameItems;
    }
  }

  HtmlParseEntity? selectByID(String id) => htmlItems?.selectByID(id);

  SliverToBoxAdapter verifyAndResendButtons({
    required String verifyId,
    required String resendId,
    required Function(String verifyId) onVerify,
    required Function(MixinControllerState state) onChangeState,
    Function(String resendId)? onResend,
    bool? showButtons,
  }) {
    onChangeState(MixinControllerState.loading);
    final isNotShow = !showVerify(verifyId) && !showResend(resendId);
    if (isNotShow && showButtons == false) {
      onChangeState(MixinControllerState.empty);
      return const SliverToBoxAdapter(child: SizedBox());
    }

    changeStateLoading(false);
    onChangeState(MixinControllerState.complete);
    return SliverToBoxAdapter(
      child: Column(
        children: [
          ButtonWidget(
            title: 'Verify Code',
            icon: Icons.check_circle_outline,
            onTap: () async {
              changeStateLoading(true);
              _forceReloadPage.value = true;
              await onVerify(verifyId);
              await _pauseToReloadThePage();
              await actionController.syncPage();
            },
          ),
          const SizedBox(height: 8.0),
          ButtonWidget(
            title: 'Send new code',
            icon: Icons.restart_alt,
            onTap: () async {
              changeStateLoading(true);
              if (onResend != null) {
                onResend(resendId);
              } else {
                await actionController.insertAndClick(buttonId: resendId);
              }
              changeStateLoading(false);
            },
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  bool showVerify(String id) =>
      selectByID(id)?.getAttribute('aria-hidden') == 'false';

  bool showResend(String id) =>
      selectByID(id)?.getAttribute('aria-hidden') == 'false';

  Future<void> _pauseToReloadThePage() => Future.delayed(
        const Duration(milliseconds: 1500),
      );
}
