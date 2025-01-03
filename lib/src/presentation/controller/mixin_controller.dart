import 'package:aad_b2c_webview/aad_b2c_webview.dart';

mixin MixinControllerAccess {
  Future<void> initInjections() => Injections.initialize();
  bool get hasInitialize => Injections.hasInitialize.value.isCompleted;
  AADB2CController get controller => getIt.get<AADB2CController>();
  ActionController get actionController => getIt.get<ActionController>();
}
