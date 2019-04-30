import 'dart:async';
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
	StreamSubscription onNavigationBackButtonPressedSubcription;
	StreamSubscription onPageShownSubcription;
	StreamSubscription onPageHiddenSubcription;
	StreamSubscription onHistoryListClickSubcription;

	@override
	void onRegister() {
		  Stream onNavigationBackButtonPressedStream = EventStreamProvider<Event>('click')
				.forTarget(_historyPage.navigateButton);

		onNavigationBackButtonPressedSubcription =
			onNavigationBackButtonPressedStream.listen(( context ) {
				print("> HistoryPageMediator -> onNavigationBackButtonPressed");
				sendNotification( NavigationCommand.NAVIGATE_BACK );
			});

		onPageShownSubcription = _historyPage.onShown.listen(onShownHandler);
		onPageHiddenSubcription = _historyPage.onHidden.listen(onHiddenHandler);

		print("> HistoryPageMediator -> onRegister");
	}

	@override
	void onRemove() {
		print("> HistoryPageMediator -> onRemove");
		onPageShownSubcription.cancel();
		onPageHiddenSubcription.cancel();
		onHistoryListClickSubcription?.cancel();
		onNavigationBackButtonPressedSubcription.cancel();

		onNavigationBackButtonPressedSubcription = null;
		onHistoryListClickSubcription = null;
		onPageShownSubcription = null;
		onPageHiddenSubcription = null;
	}

	void onHiddenHandler(e) {
		print("> HistoryPageMediator -> onHiddenHandler");
		if ( _historyList != null ) {
			_historyPage.removeElement( _historyList );
			_historyList.dispose();
			_historyList = null;
		}
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
	  ,	HistoryNotification.HISTORY_PRELOADER_SHOW
	  ,	HistoryNotification.HISTORY_PRELOADER_HIDE
    ];
  }

  @override
  void handleNotification( INotification note ) {
	  print("> HistoryPageMediator -> handleNotification: note.name = ${note.getName()}");
		switch( note.getName() ) {
			case HistoryNotification.HISTORY_PRELOADER_SHOW:
				_historyPage.showPreloader(); break;
			case HistoryNotification.HISTORY_PRELOADER_HIDE:
				_historyPage.hidePreloader(); break;
			case HistoryNotification.HISTORY_ITEM_DELETED:
				if (_historyList != null) {
					final int key = note.getBody();
					final int index = _historyList.domElements.indexWhere(
						(element) => (element as HistoryItem).key == key
					);
					if ( index > -1 )
						_historyList.removeListElementByIndex( index );
				}
			break;
			case HistoryNotification.HISTORY_LOCK:
				_historyList.disable();
			break;
			case HistoryNotification.HISTORY_UNLOCK:
				_historyList.enabled();
			break;
			case HistoryNotification.HISTORY_DATA_READY:
				_historyList = createHistoryList( note.getBody() );
				_historyPage.addElement( _historyList, appendToDom: true );
				_historyList.show();
			break;
		}
  }

  HistoryList createHistoryList( List<HistoryVO> data ) {
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

	HistoryPage get _historyPage => getViewComponent() as HistoryPage;
}
