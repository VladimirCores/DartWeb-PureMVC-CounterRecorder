import 'package:framework/framework.dart';

import '../../consts/notification/CounterNotification.dart';

class CounterProxy extends Proxy {
  static const String NAME = "CounterProxy";

  CounterProxy() : super(NAME) {
    print(">\t CounterProxy -> instance created");
  }

  @override
  void onRegister() {
    print(">\t CounterProxy -> onRegister");
  }

  @override
  void onRemove() {}

  @override
  void setData(dynamic value) {
    super.setData(value);
    _notifyCounterUpdated();
  }

  void _notifyCounterUpdated() {
    sendNotification(CounterNotification.COUNTER_VALUE_UPDATED, this.getData());
  }
}
