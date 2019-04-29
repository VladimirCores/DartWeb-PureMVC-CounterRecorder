import 'dart:html';
import 'package:intl/intl.dart';

import 'package:framework/framework.dart';

import '../../../../consts/commands/DataCommand.dart';
import '../../../../consts/commands/HistoryCommand.dart';
import '../../../../consts/commands/NavigationCommand.dart';
import '../../../../consts/notification/HistoryNotification.dart';
import '../../../../consts/types/CounterHistoryAction.dart';
import '../../../model/vos/HistoryVO.dart';
import '../../components/pages/HistoryPage.dart';
import '../../components/pages/history/HistoryItem.dart';
import '../../components/pages/history/HistoryList.dart';

class HistoryPageMediator extends Mediator {

	static const String NAME = "HistoryPageMediator";

	HistoryPageMediator() : super( NAME );

	HistoryList _historyList;

	@override
	void onRegister() {
		_historyScreen.onNavigationBackButtonPressed.listen(( context ) {
			print("> HistoryPageMediator -> onNavigationBackButtonPressed");
			_historyScreen.hide();
			sendNotification( NavigationCommand.NAVIGATE_BACK );
		});

		_historyScreen.onShown.listen(onShownHandler);
		_historyScreen.onHidden.listen(onHiddenHandler);

		print("> HistoryPageMediator -> onRegister");
	}

	void onHiddenHandler(e) {
		print("> HistoryPageMediator -> onHiddenHandler");
		_historyScreen.removeElement( _historyList );
		_historyList.dispose();
		_historyList = null;
	}

	void onShownHandler(e) {
		print("> HistoryPageMediator -> onShownHandler");
		sendNotification( DataCommand.GET_HISTORY_DATA );
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
				if (_historyList != null) {
					final int key = note.getBody();
					_historyList.removeListElementByIndex(
						_historyList.domElements.indexWhere(
							(element) => (element as HistoryItem).key == key
						)
					);
				}
			break;
			case HistoryNotification.HISTORY_LOCK:
				_historyList.disable();
			break;
			case HistoryNotification.HISTORY_UNLOCK:
				_historyList.enabled();
			break;
			case HistoryNotification.HISTORY_DATA_READY:
				_historyList = _createHistoryList( note.getBody() );
				_historyScreen.addElement( _historyList );
			break;
		}
  }

  HistoryList _createHistoryList( List<HistoryVO> data ) {
		HistoryList result = new HistoryList();
		HistoryItem historyItem;
		var formatter = new DateFormat('HH:mm:ss dd/MM/y');
	  data.asMap().forEach((index, item){
			var dt = DateTime.fromMillisecondsSinceEpoch(item.time);
			historyItem = new HistoryItem(
				item.key,
				(item.action == CounterHistoryAction.INCREMENT ? "INCREMENT" : "DECREMENT"),
				formatter.format(dt),
				item.value.toString()
			);
			historyItem.onDeleteButtonPressed.listen(
				onHistoryItemDeleteButtonPressed);
			historyItem.onRevertButtonPressed.listen(
				onHistoryItemRestoreButtonPressed);
			result.addElement(historyItem);
		});
		return result;
  }

	void onHistoryItemDeleteButtonPressed(e) {
		ButtonElement button = e.target;
		button.disabled = true;
		int domIndex = _historyList.dom.children.indexOf(button.parentNode);
		print("> HistoryPageMediator -> onHistoryItemDeletePressed: index = ${domIndex}");
		sendNotification( HistoryCommand.DELETE_COUNTER_HISTORY, domIndex );
	}

	void onHistoryItemRestoreButtonPressed(e) {
		ButtonElement button = e.target;
		int index = _historyList.dom.children.indexOf(button.parentNode);
		print("> HistoryPageMediator -> onHistoryItemDeletePressed: state = ${e.target} : index = ${index}");
		sendNotification( HistoryCommand.REVERT_COUNTER_HISTORY, index );
	}

	HistoryPage get _historyScreen => getViewComponent() as HistoryPage;
}
