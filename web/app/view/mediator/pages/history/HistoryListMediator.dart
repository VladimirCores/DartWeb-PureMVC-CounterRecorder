import 'dart:async';
import 'dart:html';

import 'package:framework/framework.dart';
import 'package:intl/intl.dart';

import '../../../../../consts/commands/DataCommand.dart';
import '../../../../../consts/commands/HistoryCommand.dart';
import '../../../../../consts/notification/HistoryNotification.dart';
import '../../../../../consts/types/CounterHistoryAction.dart';
import '../../../../model/vos/HistoryVO.dart';
import '../../../components/pages/history/HistoryItem.dart';
import '../../../components/pages/history/HistoryList.dart';

class HistoryListMediator extends Mediator {
  static const String NAME = "HistoryListMediator";

  HistoryListMediator(view) : super(NAME, view);

  StreamSubscription? onHistoryListClickSubscription;

  @override
  void onRegister() {
    print("> HistoryListMediator -> onRegister");
    Stream onClickPressed = EventStreamProvider<Event>('click').forTarget(_historyList.dom);
    onHistoryListClickSubscription = onClickPressed.listen(_OnHistoryListClickListener);
    sendNotification(DataCommand.GET_HISTORY_DATA);
  }

  @override
  void onRemove() {
    print("> HistoryListMediator -> onRemove");
    onHistoryListClickSubscription?.cancel();
    onHistoryListClickSubscription = null;
    _historyList.dispose();
    setViewComponent(null);
  }

  @override
  List<String> listNotificationInterests() {
    return [
      HistoryNotification.HISTORY_DATA_READY,
      HistoryNotification.HISTORY_ITEM_DELETED,
      HistoryNotification.HISTORY_LOCK,
      HistoryNotification.HISTORY_UNLOCK
    ];
  }

  @override
  void handleNotification(INotification note) {
    print("> HistoryListMediator -> handleNotification: note.name = ${note.getName()}");
    switch (note.getName()) {
      case HistoryNotification.HISTORY_ITEM_DELETED:
        final int key = note.getBody();
        final int index = _historyList.domElements.indexWhere((element) => (element as HistoryItem).key == key);
        if (index > -1) _historyList.removeListElementByIndex(index);
        break;
      case HistoryNotification.HISTORY_LOCK:
        _historyList.disable();
        break;
      case HistoryNotification.HISTORY_UNLOCK:
        _historyList.enabled();
        break;
      case HistoryNotification.HISTORY_DATA_READY:
        appendHistoryItems(note.getBody());
        _historyList.show();
        break;
    }
  }

  void appendHistoryItems(List<HistoryVO> data) {
    HistoryItem historyItem;
    var formatter = DateFormat('HH:mm:ss dd/MM/y');
    data.asMap().forEach((index, item) {
      var dt = DateTime.fromMillisecondsSinceEpoch(item.time);
      historyItem = HistoryItem(
          _historyList.dom,
          item.key,
          (item.action == CounterHistoryAction.INCREMENT ? "INCREMENT" : "DECREMENT"),
          formatter.format(dt),
          item.value.toString());
      _historyList.addElement(historyItem, appendToDom: true);
    });
  }

  void _OnHistoryListClickListener(e) {
    if (e.target is ButtonElement)
      switch (e.target.id) {
        case HistoryItem.ID_BUTTON_RESTORE:
          _processHistoryItemAction(e.target, HistoryCommand.REVERT_COUNTER_HISTORY);
          break;
        case HistoryItem.ID_BUTTON_DELETE:
          _processHistoryItemAction(e.target, HistoryCommand.DELETE_COUNTER_HISTORY);
          break;
      }
  }

  void _processHistoryItemAction(ButtonElement button, action) {
    int index = _historyList.getChildIndex(button.parentNode);
    final historyItem = _historyList.domElements[index] as HistoryItem;
    historyItem.lock();
    sendNotification(action, index);
  }

  HistoryList get _historyList => getViewComponent() as HistoryList;
}
