import 'package:framework/framework.dart';

import '../../../../consts/commands/NavigationCommand.dart';
import '../../../../consts/notification/HistoryNotification.dart';
import '../../../model/HistoryProxy.dart';
import '../../components/pages/HistoryPage.dart';
import '../../components/pages/history/HistoryItem.dart';
import '../../components/pages/history/HistoryList.dart';

class HistoryPageMediator extends Mediator {

	static const String NAME = "HistoryPageMediator";

	HistoryPageMediator() : super( NAME );

	HistoryList _historyList;

	@override
	void onRegister() {
		// final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );
//		_historyScreen.onStateChanged.listen( handleComponentStateChanged );
//		_historyScreen.onRevertHistoryItemButtonPressed.listen(( index ) {
//			print("> HistoryPageMediator -> onRevertHistoryItemButtonPressed: $index");
//			sendNotification( HistoryCommand.REVERT_COUNTER_HISTORY, index );
//		});
//		_historyScreen.onDeleteHistoryItemButtonPressed.listen(( index ) {
//			print("> HistoryPageMediator -> onDeleteHistoryItemBackButtonPressed: $index");
//			sendNotification( HistoryCommand.DELETE_COUNTER_HISTORY, index );
//		});
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
		_historyScreen.removeElement(_historyList);
		_historyList.dispose();
		_historyList = null;
	}

	void onShownHandler(e) {
		print("> HistoryPageMediator -> onShownHandler");
		final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );
		updateHistoryList( historyProxy.getHistoryToDisplay() );
		_historyScreen.addElement(_historyList);
	}

	@override
  List<String> listNotificationInterests() {
    return [
	    HistoryNotification.HISTORY_UPDATED
    ];
  }

  @override
  void handleNotification( INotification note ) {
	  print("> HistoryPageMediator -> handleNotification: note.name = ${note.getName()}");
		switch( note.getName() ) {
			case HistoryNotification.HISTORY_UPDATED:
				if (_historyScreen.parent != null)
					updateHistoryList( note.getBody() as List<List<String>> );
			break;
		}
  }

  void handleComponentStateChanged( state ) {
		print("> HistoryPageMediator -> handleComponentStateChanged: state = $state");
//		switch( state ) {
//			case StateChange.INIT_STATE:
//				updateHistoryList( _historyProxy.getHistoryToDisplay() );
//				break;
//			default: break;
//		}
  }

  void updateHistoryList( List<List<String>> data ) {
		_historyList = new HistoryList();
	  data.forEach((item){
			_historyList.addElement(
				new HistoryItem(
					item[0], item[1], item[2]));
		});
  }

	HistoryPage get _historyScreen => getViewComponent() as HistoryPage;
}
