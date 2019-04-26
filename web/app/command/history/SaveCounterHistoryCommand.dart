import 'package:framework/framework.dart';

import '../../model/CounterProxy.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/HistoryProxy.dart';
import '../../model/vos/CounterVO.dart';
import '../../model/vos/HistoryVO.dart';

class SaveCounterHistoryCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {
		print("> SaveCounterHistoryCommand > note: ${note.getBody().toString()}");

		final int time = DateTime.now().toUtc().millisecondsSinceEpoch;
		final String type = note.getBody();

		print("> SaveCounterHistoryCommand > time: $time");
		print("> SaveCounterHistoryCommand > type: $type");

		final DatabaseProxy databaseProxy = facade.retrieveProxy( DatabaseProxy.NAME );
		final CounterProxy counterProxy = facade.retrieveProxy( CounterProxy.NAME );
		final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );

		final CounterVO counterVO = counterProxy.getData() as CounterVO;

		final HistoryVO historyVO = HistoryVO.fromValues( time, counterVO.value, type );

		historyVO.key = await databaseProxy.insertVO( HistoryVO, HistoryVO.databaseMapKeyValues( historyVO ));

		historyProxy.addHistoryItem( historyVO );

		print("> SaveCounterHistoryCommand > Completed");
	}
}
