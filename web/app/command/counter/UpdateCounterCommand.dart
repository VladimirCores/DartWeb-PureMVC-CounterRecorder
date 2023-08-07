import 'package:framework/framework.dart';

import '../../model/CounterProxy.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/vos/CounterVO.dart';

class UpdateCounterCommand extends SimpleCommand {
  @override
  void execute(INotification note) async {
    print("> UpdateCounterCommand > note: $note");
    int value = note.getBody();

    final databaseProxy = facade.retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
    final counterProxy = facade.retrieveProxy(CounterProxy.NAME) as CounterProxy;

    final CounterVO counterVO = counterProxy.getData();
    counterVO.value = value;

    await databaseProxy.updateVO(
      CounterVO,
      counterVO.key!,
      params: CounterVO.databaseMapKeyValues(counterVO.value),
    );

    counterProxy.setData(counterVO);
  }
}
