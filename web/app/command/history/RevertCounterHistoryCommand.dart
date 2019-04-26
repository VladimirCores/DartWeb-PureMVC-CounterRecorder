import 'dart:async';

import 'package:framework/framework.dart';

import '../../../consts/commands/CounterCommand.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/HistoryProxy.dart';
import '../../model/vos/HistoryVO.dart';

class RevertCounterHistoryCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {

		final int revertToIndex = note.getBody();

		final DatabaseProxy databaseProxy = facade.retrieveProxy( DatabaseProxy.NAME );
		final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );

		print("> RevertCounterHistoryCommand > revertToIndex: $revertToIndex");

		final List<HistoryVO> items = historyProxy.getHistoryItemsUntilReverseIndex( revertToIndex );

		print("> RevertCounterHistoryCommand > items: $items");

		items.forEach(( HistoryVO item ) async => await databaseProxy.deleteItemByKey( HistoryVO, item.key ));

		Timer.periodic(Duration(seconds: 2), (timer) {
			timer.cancel();

			historyProxy.deleteHistoryItemsFromList( items );

			HistoryVO historyVO = historyProxy.getLastHistoryItem();
			sendNotification( CounterCommand.UPDATE, historyVO.value );

		});
	}
}
