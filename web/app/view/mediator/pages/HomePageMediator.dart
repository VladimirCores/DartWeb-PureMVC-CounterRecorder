import 'package:framework/framework.dart';

import '../../../../consts/Routes.dart';
import '../../../../consts/commands/CounterCommand.dart';
import '../../../../consts/commands/HistoryCommand.dart';
import '../../../../consts/commands/NavigationCommand.dart';
import '../../../../consts/notification/CounterNotification.dart';
import '../../../../consts/types/CounterHistoryAction.dart';
import '../../../model/vos/CounterVO.dart';
import '../../components/pages/HomePage.dart';

class HomePageMediator extends Mediator
{
	static const String NAME = "HomePageMediator";

	static const String SET_COUNTER = "note_home_screen_mediator_set_counter";

	HomePageMediator() : super( NAME );

	@override
	void onRegister() {
		print("> HomePageMediator -> onRegister");
		_homeScreen.onIncrementButtonPressed.listen((time) {
			print("> HomePageMediator -> onIncrementButtonPressed");
			sendNotification( CounterCommand.INCREMENT );
			sendNotification( HistoryCommand.SAVE_COUNTER_HISTORY, CounterHistoryAction.INCREMENT );
		});
		_homeScreen.onDecrementButtonPressed.listen((time) {
			print("> HomePageMediator -> onDecrementButtonPressed");
			sendNotification( CounterCommand.DECREMENT );
			sendNotification( HistoryCommand.SAVE_COUNTER_HISTORY, CounterHistoryAction.DECREMENT );
		});
		_homeScreen.onNavigateHistoryButtonPressed.listen((event) {
			print("> HomePageMediator -> onNavigateHistoryButtonPressed");
			sendNotification( NavigationCommand.NAVIGATE_TO_PAGE, false, Routes.HISTORY_SCREEN );
		});
	}

	@override
	void onRemove() {

	}

	@override
  List<String> listNotificationInterests() {
    return [
	    CounterNotification.COUNTER_VALUE_UPDATED
    ];
  }

  @override
  void handleNotification(INotification note) {
	  print("> HomePageMediator -> handleNotification: note.name = ${note.getName()}");
	  print("> HomePageMediator -> handleNotification: note.body = ${note.getBody()}");
		switch( note.getName() ) {
			case CounterNotification.COUNTER_VALUE_UPDATED:
				CounterVO valueVO = note.getBody();
				_homeScreen.setCounter( valueVO.value );
		}
  }

	HomePage get _homeScreen => getViewComponent() as HomePage;
}
