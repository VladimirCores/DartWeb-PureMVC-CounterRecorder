import 'package:framework/framework.dart';

import '../../model/ApplicationProxy.dart';
import '../../model/CounterProxy.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/HistoryProxy.dart';
import '../../model/NavigationProxy.dart';
import '../../model/vos/CounterVO.dart';
import '../../model/vos/HistoryVO.dart';

class PrepareModelCommand extends AsyncCommand {
  @override
  void execute(INotification note) async {
    print("> StartupCommand -> PrepareModelCommand > note: $note");

    final applicationProxy = ApplicationProxy();
    final databaseProxy = DatabaseProxy();
    final counterProxy = CounterProxy();
    final historyProxy = HistoryProxy();
    final navigationProxy = NavigationProxy();

    facade.registerProxy(applicationProxy);
    facade.registerProxy(databaseProxy);
    facade.registerProxy(counterProxy);
    facade.registerProxy(historyProxy);
    facade.registerProxy(navigationProxy);

    await databaseProxy.init([CounterVO, HistoryVO]);

    commandComplete();
  }
}
