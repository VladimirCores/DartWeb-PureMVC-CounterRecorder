import 'package:framework/framework.dart';

import '../../../consts/commands/CounterCommand.dart';
import '../../../consts/notification/HistoryNotification.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/HistoryProxy.dart';
import '../../model/vos/HistoryVO.dart';

class RevertCounterHistoryCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {

		final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );
		final DatabaseProxy databaseProxy = facade.retrieveProxy( DatabaseProxy.NAME );

		int itemsInHistory = historyProxy.itemsInHistory;
		int revertToIndex = itemsInHistory - note.getBody() - 1;
		int counter = itemsInHistory;

		sendNotification( HistoryNotification.HISTORY_LOCK );

		print("> RevertCounterHistoryCommand > revertToIndex: $revertToIndex");
		print("> RevertCounterHistoryCommand > itemsInHistory: $itemsInHistory");
		while ( counter > revertToIndex ) {
			print("> RevertCounterHistoryCommand > counter: ${counter--}");
			HistoryVO historyVO = historyProxy.getHistoryItemAt(counter);
			print("> RevertCounterHistoryCommand > value: ${historyVO.value}");
			await databaseProxy.deleteItemByKey( HistoryVO, historyVO.key );
			historyProxy.deleteHistoryItem( historyVO );
			sendNotification( HistoryNotification.HISTORY_ITEM_DELETED, historyVO.key );
		}

		HistoryVO historyVO = historyProxy.getLastHistoryItem();
		sendNotification( CounterCommand.UPDATE, historyVO != null ? historyVO.value : 0 );
		sendNotification( HistoryNotification.HISTORY_UNLOCK );
	}
}
