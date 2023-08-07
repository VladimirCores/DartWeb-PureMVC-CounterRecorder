import 'package:framework/framework.dart';

import '../../../consts/commands/CounterCommand.dart';
import '../../model/CounterProxy.dart';
import '../../model/vos/CounterVO.dart';

class DecrementCounterCommand extends SimpleCommand {
  @override
  void execute(INotification note) async {
    print("> DecrementCounterCommand > note: $note");

    final counterProxy = facade.retrieveProxy(CounterProxy.NAME) as CounterProxy;
    final CounterVO counterVO = counterProxy.getData();

    if (counterVO.value > 0) {
      final nextValue = counterVO.value - 1;
      this.sendNotification(CounterCommand.UPDATE, nextValue);
    } else {}
  }
}
