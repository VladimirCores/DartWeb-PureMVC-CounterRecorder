import 'dart:async';
import 'dart:html';

import 'package:framework/framework.dart';

import '../../../../consts/commands/NavigationCommand.dart';
import '../../../../consts/notification/HistoryNotification.dart';
import '../../components/pages/HistoryPage.dart';
import '../../components/pages/history/HistoryList.dart';
import 'history/HistoryListMediator.dart';

class HistoryPageMediator extends Mediator {
  static const String NAME = "HistoryPageMediator";

  HistoryPageMediator() : super(NAME);

  StreamSubscription? onNavigationBackButtonPressedSubscription;
  StreamSubscription? onPageShownSubscription;
  StreamSubscription? onPageHiddenSubscription;

  @override
  void onRegister() {
    Stream onNavigationBackButtonPressedStream =
        EventStreamProvider<Event>('click').forTarget(_historyPage.navigateButton);

    onNavigationBackButtonPressedSubscription = onNavigationBackButtonPressedStream.listen((context) {
      print("> HistoryPageMediator -> onNavigationBackButtonPressed");
      sendNotification(NavigationCommand.NAVIGATE_BACK);
    });

    onPageShownSubscription = _historyPage.onShown.listen(onShownHandler);
    onPageHiddenSubscription = _historyPage.onHidden.listen(onHiddenHandler);

    var historyList = HistoryList();
    _historyPage.addElement(historyList, appendToDom: true);
    this.facade.registerMediator(HistoryListMediator(historyList));

    print("> HistoryPageMediator -> onRegister");
  }

  @override
  void onRemove() {
    print("> HistoryPageMediator -> onRemove");
    onPageShownSubscription!.cancel();
    onPageShownSubscription = null;

    onPageHiddenSubscription!.cancel();
    onPageHiddenSubscription = null;

    onNavigationBackButtonPressedSubscription!.cancel();
    onNavigationBackButtonPressedSubscription = null;

    var historyListMediator = this.facade.retrieveMediator(HistoryListMediator.NAME);
    _historyPage.removeElement(historyListMediator.getViewComponent(), hideFromDom: true);
    this.facade.removeMediator(HistoryListMediator.NAME);
  }

  void onHiddenHandler(e) {
    print("> HistoryPageMediator -> onHiddenHandler");
  }

  void onShownHandler(e) {
    print("> HistoryPageMediator -> onShownHandler");
  }

  @override
  List<String> listNotificationInterests() {
    return [HistoryNotification.HISTORY_PRELOADER_SHOW, HistoryNotification.HISTORY_PRELOADER_HIDE];
  }

  @override
  void handleNotification(INotification note) {
    print("> HistoryPageMediator -> handleNotification: note.name = ${note.getName()}");
    switch (note.getName()) {
      case HistoryNotification.HISTORY_PRELOADER_SHOW:
        _historyPage.showPreloader();
        break;
      case HistoryNotification.HISTORY_PRELOADER_HIDE:
        _historyPage.hidePreloader();
        break;
    }
  }

  HistoryPage get _historyPage => getViewComponent() as HistoryPage;
}
