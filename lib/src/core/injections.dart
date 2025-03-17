import 'dart:async';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/foundation.dart';

final getIt = GetIt.instance;

class Injections {
  static final ValueNotifier<Completer> hasInitialize =
      ValueNotifier(Completer());

  static Future<void> initialize() async {
    if (hasInitialize.value.isCompleted) return;

    getIt
      ..registerSingleton<B2CRestClient>(
        B2CRestClientImpl(
          clientHttp: Client(),
        ),
      )
      ..registerSingleton<PkcePair>(
        PkcePair.generate(),
      )
      ..registerLazySingleton<B2CWebViewHelper>(
        () => B2CWebViewHelper(
          pkcePairInstance: getIt<PkcePair>(),
          b2cAuthRepository: getIt<B2CAuthRepository>(),
        ),
      )
      ..registerLazySingleton<WebViewControllersHelper>(
        () => WebViewControllersUsecaseImpl(
          controllerMobile: WebViewController(),
          controllerWeb: PlatformWebViewController(
            const PlatformWebViewControllerCreationParams(),
          ),
        ),
      )
      ..registerLazySingleton<B2CWebViewDatasource>(
        () => B2CWebViewDatasourceImpl(
          controllers: getIt<WebViewControllersHelper>(),
          helper: getIt<B2CWebViewHelper>(),
        ),
      )
      ..registerLazySingleton<B2CWebViewRepository>(
        () => B2CWebViewRepositoryImpl(
          datasource: getIt<B2CWebViewDatasource>(),
          helper: getIt<B2CWebViewHelper>(),
        ),
      )
      ..registerLazySingleton<B2CAuthDatasource>(
        () => B2CAuthDatasourceImpl(
          client: getIt<B2CRestClient>(),
          pkcePairInstance: getIt<PkcePair>(),
        ),
      )
      ..registerLazySingleton<B2CAuthRepository>(
        () => B2CAuthRepositoryImpl(
          datasource: getIt<B2CAuthDatasource>(),
        ),
      )
      ..registerLazySingleton<AADB2CController>(
        () => AADB2CController(
          b2cAuthRepository: getIt<B2CAuthRepository>(),
          b2cWebViewRepository: getIt<B2CWebViewRepository>(),
          webviewController: getIt<WebViewControllersHelper>(),
        ),
      )
      ..registerLazySingleton<ActionController>(
        () => ActionController(
          b2cWebViewRepository: getIt<B2CWebViewRepository>(),
        ),
      );

    hasInitialize.value.complete();
  }
}
