import 'package:framework/framework.dart';

import '../../model/CounterProxy.dart';
import '../../model/DatabaseProxy.dart';
import '../../model/vos/CounterVO.dart';

class UpdateCounterCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {
		print("> UpdateCounterCommand > note: $note");
		int value = note.getBody();

		final DatabaseProxy databaseProxy = facade.retrieveProxy( DatabaseProxy.NAME );
		final CounterProxy counterProxy = facade.retrieveProxy( CounterProxy.NAME );

		final CounterVO counterVO = counterProxy.getData();
		counterVO.value = value;

		await databaseProxy.updateVO( CounterVO, counterVO.key,
				params: CounterVO.databaseMapKeyValues( counterVO.value ),
		);

		counterProxy.setData( counterVO );
	}
}
