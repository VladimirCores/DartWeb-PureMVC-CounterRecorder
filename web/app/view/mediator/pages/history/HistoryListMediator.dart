import 'dart:async';
import 'dart:html';
import 'package:intl/intl.dart';

import 'package:framework/framework.dart';

import '../../../../../consts/commands/DataCommand.dart';
import '../../../../../consts/commands/HistoryCommand.dart';
import '../../../../../consts/notification/HistoryNotification.dart';
import '../../../../../consts/types/CounterHistoryAction.dart';
import '../../../../model/vos/HistoryVO.dart';
import '../../../components/pages/history/HistoryItem.dart';
import '../../../components/pages/history/HistoryList.dart';

class HistoryListMediator extends Mediator {

	static const String NAME = "HistoryListMediator";

	HistoryListMediator() : super( NAME );

	StreamSubscription onHistoryListClickSubcription;

	@override
	void onRegister() {
		print("> HistoryListMediator -> onRegister");
		sendNotification( DataCommand.GET_HISTORY_DATA );
	}

	@override
	void onRemove() {
		print("> HistoryListMediator -> onRemove");
		onHistoryListClickSubcription?.cancel();
		onHistoryListClickSubcription = null;
		_historyList.dispose();
	}

	@override
  List<String> listNotificationInterests() {
    return [
	   	HistoryNotification.HISTORY_DATA_READY
	  ,	HistoryNotification.HISTORY_ITEM_DELETED
	  ,	HistoryNotification.HISTORY_LOCK
	  ,	HistoryNotification.HISTORY_UNLOCK
    ];
  }

  @override
  void handleNotification( INotification note ) {
	  print("> HistoryPageMediator -> handleNotification: note.name = ${note.getName()}");
		switch( note.getName() ) {
			case HistoryNotification.HISTORY_ITEM_DELETED:
				final int key = note.getBody();
				final int index = _historyList.domElements.indexWhere(
					(element) => (element as HistoryItem).key == key
				);
				if ( index > -1 )
					_historyList.removeListElementByIndex( index );
			break;
			case HistoryNotification.HISTORY_LOCK:
				_historyList.disable();
			break;
			case HistoryNotification.HISTORY_UNLOCK:
				_historyList.enabled();
			break;
			case HistoryNotification.HISTORY_DATA_READY:
				appendHistoryItems( note.getBody() );
				_historyList.show();
			break;
		}
  }

  HistoryList appendHistoryItems( List<HistoryVO> data ) {
		HistoryList result = new HistoryList();
		HistoryItem historyItem;
		var formatter = new DateFormat('HH:mm:ss dd/MM/y');
	  data.asMap().forEach((index, item){
			var dt = DateTime.fromMillisecondsSinceEpoch(item.time);
			historyItem = new HistoryItem(
				result.dom,
				item.key,
				(item.action == CounterHistoryAction.INCREMENT ? "INCREMENT" : "DECREMENT"),
				formatter.format(dt),
				item.value.toString()
			);
			result.addElement( historyItem, appendToDom: true );
		});

		Stream onClickPressed = EventStreamProvider<Event>('click').forTarget(result.dom);
		onHistoryListClickSubcription = onClickPressed.listen(_OnHistoryListClickListener);
		return result;
  }

	void _OnHistoryListClickListener(e) {
		if (e.target is ButtonElement) switch(e.target.id) {
			case HistoryItem.ID_BUTTON_RESTORE:
				_processHistoryItemAction( e.target, HistoryCommand.REVERT_COUNTER_HISTORY );
			break;
			case HistoryItem.ID_BUTTON_DELETE:
				_processHistoryItemAction( e.target, HistoryCommand.DELETE_COUNTER_HISTORY );
			break;
		}
	}

	void _processHistoryItemAction( ButtonElement button, action ) {
		int index = _historyList.getChildIndex( button.parentNode );
		HistoryItem historyItem = _historyList.domElements[ index ];
		historyItem.lock();
		sendNotification( action, index );
	}

	HistoryList get _historyList => getViewComponent() as HistoryList;
}
