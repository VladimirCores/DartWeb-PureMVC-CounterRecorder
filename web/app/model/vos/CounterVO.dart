class CounterVO
{
	int key;
	int value = 10;

	CounterVO();

	CounterVO.fromRawValue(Map rawObjects) {
		this.value = rawObjects['value'];
		this.key = rawObjects['key'];
	}

	static Map<String, Object> databaseMapKeyValues(int value) {
		return { 'value': value };
	}
}
