import 'package:framework/framework.dart';
import '../../../consts/notification/HistoryNotification.dart';
import '../../model/HistoryProxy.dart';

class GetHistoryDataCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {
		final String response = note.getType();

		print("> GetHistoryDataCommand > index: $response");
		final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );
		sendNotification( HistoryNotification.HISTORY_DATA_READY, historyProxy.getHistoryToDisplay() );
	}
}
