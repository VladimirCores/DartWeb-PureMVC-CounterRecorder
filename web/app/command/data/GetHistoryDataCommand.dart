import 'package:framework/framework.dart';
import '../../../consts/notification/HistoryNotification.dart';
import '../../model/HistoryProxy.dart';

class GetHistoryDataCommand extends SimpleCommand {
	@override
	void execute( INotification note ) async {

		sendNotification( HistoryNotification.HISTORY_PRELOADER_SHOW );

		final HistoryProxy historyProxy = facade.retrieveProxy( HistoryProxy.NAME );
		if ( historyProxy.isLoading ) return;

		print("> GetHistoryDataCommand: load begin");
		await historyProxy.loadData();
		print("> GetHistoryDataCommand: complete");

		final historyListData = historyProxy.getHistoryToDisplay();

		sendNotification( HistoryNotification.HISTORY_DATA_READY, historyListData );
		sendNotification( HistoryNotification.HISTORY_PRELOADER_HIDE );
	}
}
