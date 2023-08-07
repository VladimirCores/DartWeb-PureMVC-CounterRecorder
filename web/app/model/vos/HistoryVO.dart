class HistoryVO {
  int? key;
  int time = 0;
  int value = 0;
  String action = "";

  HistoryVO.fromValues(this.time, this.value, this.action);

  HistoryVO.fromRawValues(Map rawValue) {
    this.action = rawValue['action'];
    this.value = rawValue['value'];
    this.time = rawValue['time'];
    this.key = rawValue['key'];
  }

  static Map<String, Object> databaseMapKeyValues(HistoryVO input) {
    return {'time': input.time, 'value': input.value, 'action': input.action};
  }
}
