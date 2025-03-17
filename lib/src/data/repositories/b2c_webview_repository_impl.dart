import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/foundation.dart';

class B2CWebViewRepositoryImpl implements B2CWebViewRepository {
  final B2CWebViewDatasource _datasource;
  final B2CWebViewHelper _helper;

  B2CWebViewRepositoryImpl({
    required B2CWebViewDatasource datasource,
    required B2CWebViewHelper helper,
  })  : _datasource = datasource,
        _helper = helper;

  @override
  Future<void> initialize(B2CWebViewParams params) async {
    try {
      final result = _helper.getUserFlowUrl(params: params);
      if (kIsWeb) {
        await _datasource.initializeWeb(result);
      } else {
        await _datasource.initializeMobile(result);
      }
    } catch (error, stack) {
      throw ConfigWebViewException(
        error: error,
        trace: stack,
      );
    }
  }

  @override
  Future<void> runJavaScript(String code) async {
    try {
      await _datasource.runJavaScript(code);
    } catch (error, stack) {
      throw RunJavaScriptException(
        error: error,
        trace: stack,
      );
    }
  }

  @override
  Future<Object> runJavaScriptReturningResult(String code) async {
    try {
      return await _datasource.runJavaScriptReturningResult(code);
    } catch (error, stack) {
      throw RunJavaScriptException(
        error: error,
        trace: stack,
      );
    }
  }
}
