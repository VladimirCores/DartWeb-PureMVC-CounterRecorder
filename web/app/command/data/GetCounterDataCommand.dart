import 'package:framework/framework.dart';
import '../../../consts/notification/CounterNotification.dart';
import '../../model/CounterProxy.dart';
import '../../model/vos/CounterVO.dart';

class GetCounterDataCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {
		print("> GetCounterDataCommand");
		final CounterProxy counterProxy = facade.retrieveProxy( CounterProxy.NAME );
		final CounterVO counterVO = counterProxy.getData();

		sendNotification( CounterNotification.COUNTER_VALUE_UPDATED, counterVO );
	}
}
