import 'dart:async';

import 'package:framework/framework.dart';

import '../../model/CounterProxy.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/HistoryProxy.dart';
import '../../model/vos/CounterVO.dart';
import '../../model/vos/HistoryVO.dart';

class PrepareCompleteCommand extends AsyncCommand {
  @override
  Future execute(INotification note) async {
    print("> StartupCommand -> PrepareCompleteCommand > execute");

    final databaseProxy = facade.retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;

    final counterProxy = facade.retrieveProxy(CounterProxy.NAME) as CounterProxy;
    final historyProxy = facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy;

    CounterVO valueVO = await RetrieveCounterValueFromDatabase(databaseProxy);
    List<HistoryVO> history = await RetrieveHistoryFromDatabase(databaseProxy);

    counterProxy.setData(valueVO);
    historyProxy.setData(history);

    print("> StartupCommand -> PrepareCompleteCommand > valueVO.value = ${valueVO.value}");
    print("> StartupCommand -> PrepareCompleteCommand > history.length = ${history.length}");

    commandComplete();
  }

  Future<CounterVO> RetrieveCounterValueFromDatabase(DatabaseProxy databaseProxy) async {
    CounterVO result;
    Map? rawValues = await databaseProxy.retrieveVO(CounterVO);
    if (rawValues == null) {
      result = CounterVO();
      result.key = await databaseProxy.insertVO(CounterVO, CounterVO.databaseMapKeyValues(result.value));
    } else {
      result = CounterVO.fromRawValue(rawValues);
    }
    return result;
  }

  Future<List<HistoryVO>> RetrieveHistoryFromDatabase(DatabaseProxy databaseProxy) async {
    final result = List<HistoryVO>.empty(growable: true);
    List rawValues = await databaseProxy.retrieve(HistoryVO);
    // print("> StartupCommand -> PrepareCompleteCommand > RetrieveHistoryFromDatabase : rawValues = $rawValues");
    if (rawValues.isNotEmpty) rawValues.forEach((dynamic rawValue) => result.add(HistoryVO.fromRawValues(rawValue)));
    return result;
  }
}
