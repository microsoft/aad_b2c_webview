import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class ActionController {
  final B2CWebViewRepository _b2cWebViewRepository;

  ActionController({
    required B2CWebViewRepository b2cWebViewRepository,
  }) : _b2cWebViewRepository = b2cWebViewRepository;

  Future<void> insertAndClick({
    List<ActionEntity> listIdValue = const <ActionEntity>[],
    required String buttonId,
  }) async {
    final StringBuffer jsCode = StringBuffer();
    try {
      if (listIdValue.isNotEmpty) {
        for (var idValue in listIdValue) {
          jsCode.write(
              "document.getElementById('${idValue.id}').value = '${idValue.value}';");
        }
      }
      jsCode.write("document.getElementById('$buttonId').click();");
      await runJavaScript(jsCode.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncPage() async {
    try {
      await getCustomAlerts([
        FlutterJsCustomAlert(
            type: JsDocumentType.byClassName,
            code: '.verificationErrorText.error',
            conditions: {
              'aria-hidden': 'false',
            })
      ]);
      await runJavaScript(FlutterJs.jsFunctionToGetAlert);
      await runJavaScript(FlutterJs.jsFunctionToGetComponents);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCustomAlerts(List<FlutterJsCustomAlert> alerts) async {
    for (var alert in alerts) {
      await runJavaScript(
        FlutterJs.jsFunctionToGetCustomAlert(
          params: alert,
        ),
      );
    }
  }

  Future<void> runJavaScript(String jsCode) =>
      _b2cWebViewRepository.runJavaScript(jsCode);

  Future<Object> runJavaScriptReturningResult(String jsCode) =>
      _b2cWebViewRepository.runJavaScriptReturningResult(jsCode);
}
