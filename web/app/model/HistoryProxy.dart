import 'package:framework/framework.dart';

import 'vos/HistoryVO.dart';

class HistoryProxy extends Proxy {
  static const String NAME = "HistoryProxy";

  bool isLoading = false;

  HistoryProxy() : super(NAME) {
    print(">\t HistoryProxy -> instance created");
  }

  Future<void> loadData() async {
    isLoading = true;
    return Future.delayed(const Duration(seconds: 1), () {
      isLoading = false;
    });
  }

  @override
  void onRegister() {
    print(">\t HistoryProxy -> onRegister");
  }

  @override
  void onRemove() {}

  List<HistoryVO> getHistoryToDisplay() {
    var result = _history.toList();
    return result.reversed.toList();
  }

  void addHistoryItem(HistoryVO item) {
    (getData() as List<HistoryVO>).add(item);
  }

  List<HistoryVO> get _history => getData() as List<HistoryVO>;

  void deleteHistoryItem(HistoryVO item) {
    _history.remove(item);
  }

  void deleteHistoryItemsFromList(List<HistoryVO> list) {
    list.forEach((item) => _history.remove(item));
  }

  int get itemsInHistory => _history.length;

  HistoryVO getHistoryItemAt(int index) => _history[index];
  HistoryVO getHistoryItemAtReverseIndex(int index) => _history[_history.length - 1 - index];
  HistoryVO? getLastHistoryItem() => _history.isNotEmpty ? _history.last : null;

  List<HistoryVO> getHistoryItemsUntilReverseIndex(int revertToIndex) {
    int lastIndex = _history.length;
    int startIndex = lastIndex - revertToIndex;
    return _history.getRange(startIndex, lastIndex).toList();
  }
}
