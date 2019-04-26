import 'package:framework/framework.dart';

import '../../../consts/commands/CounterCommand.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/HistoryProxy.dart';
import '../../model/vos/HistoryVO.dart';

class DeleteCounterHistoryCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {
		final int index = note.getBody();

		print("> DeleteCounterHistoryCommand > index: $index");

		final DatabaseProxy databaseProxy = facade.retrieveProxy( DatabaseProxy.NAME );
		final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );

		final HistoryVO historyVO = historyProxy.getHistoryItemAtReverseIndex( index );

		print("> DeleteCounterHistoryCommand > historyVO.key: ${historyVO.key}");
		await databaseProxy.deleteItemByKey( HistoryVO, historyVO.key );

		historyProxy.deleteHistoryItem( historyVO );

		if( index == 0 ) {
			final counterUpdateValue = historyProxy.itemsInHistory > 0 ? historyProxy.getLastHistoryItem().value : 0;
			sendNotification( CounterCommand.UPDATE, counterUpdateValue );
		}
	}
}
