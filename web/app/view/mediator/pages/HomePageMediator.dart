import 'dart:async';
import 'dart:html';

import 'package:framework/framework.dart';

import '../../../../consts/Routes.dart';
import '../../../../consts/commands/CounterCommand.dart';
import '../../../../consts/commands/DataCommand.dart';
import '../../../../consts/commands/HistoryCommand.dart';
import '../../../../consts/commands/NavigationCommand.dart';
import '../../../../consts/notification/CounterNotification.dart';
import '../../../../consts/types/CounterHistoryAction.dart';
import '../../../model/vos/CounterVO.dart';
import '../../components/pages/HomePage.dart';

class HomePageMediator extends Mediator {
  static const String NAME = "HomePageMediator";

  static const String SET_COUNTER = "note_home_screen_mediator_set_counter";

  HomePageMediator() : super(NAME);

  StreamSubscription? onIncrementButtonPressedSubscription;
  StreamSubscription? onDecrementButtonPressedSubscription;
  StreamSubscription? onNavigateHistoryButtonSubscription;

  @override
  void onRegister() {
    print("> HomePageMediator -> onRegister");

    Stream onIncrementButtonPressed = EventStreamProvider<Event>('click').forTarget(_homePage.plusButton);
    Stream onDecrementButtonPressed = EventStreamProvider<Event>('click').forTarget(_homePage.minusButton);
    Stream onNavigateHistoryButtonPressed = EventStreamProvider<Event>('click').forTarget(_homePage.navigateButton);

    onIncrementButtonPressedSubscription = onIncrementButtonPressed.listen((time) {
      print("> HomePageMediator -> onIncrementButtonPressed");
      sendNotification(CounterCommand.INCREMENT);
      sendNotification(HistoryCommand.SAVE_COUNTER_HISTORY, CounterHistoryAction.INCREMENT);
    });
    onDecrementButtonPressedSubscription = onDecrementButtonPressed.listen((time) {
      print("> HomePageMediator -> onDecrementButtonPressed");
      sendNotification(CounterCommand.DECREMENT);
      sendNotification(HistoryCommand.SAVE_COUNTER_HISTORY, CounterHistoryAction.DECREMENT);
    });
    onNavigateHistoryButtonSubscription = onNavigateHistoryButtonPressed.listen((event) {
      print("> HomePageMediator -> onNavigateHistoryButtonPressed");
      sendNotification(NavigationCommand.NAVIGATE_TO_PAGE, false, Routes.HISTORY_PAGE);
    });

    this.sendNotification(DataCommand.GET_COUNTER_DATA);
  }

  @override
  void onRemove() {
    print("> HomePageMediator -> onRemove");

    onIncrementButtonPressedSubscription!.cancel();
    onIncrementButtonPressedSubscription = null;

    onDecrementButtonPressedSubscription!.cancel();
    onDecrementButtonPressedSubscription = null;

    onNavigateHistoryButtonSubscription!.cancel();
    onNavigateHistoryButtonSubscription = null;
  }

  @override
  List<String> listNotificationInterests() {
    return [CounterNotification.COUNTER_VALUE_UPDATED];
  }

  @override
  void handleNotification(INotification note) {
    print("> HomePageMediator -> handleNotification: note.name = ${note.getName()}");
    print("> HomePageMediator -> handleNotification: note.body = ${note.getBody()}");
    switch (note.getName()) {
      case CounterNotification.COUNTER_VALUE_UPDATED:
        CounterVO valueVO = note.getBody();
        _homePage.setCounter(valueVO.value);
    }
  }

  HomePage get _homePage => getViewComponent() as HomePage;
}
