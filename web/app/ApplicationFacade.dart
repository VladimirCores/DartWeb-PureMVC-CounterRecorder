import 'package:framework/framework.dart';

class ApplicationFacade extends Facade {
  static const String CORE = "CORE";

  ApplicationFacade(super.key);

  static IFacade getInstance(String key) {
    return Facade.getInstance(key)!;
  }
}
