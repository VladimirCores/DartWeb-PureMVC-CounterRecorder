import 'package:framework/framework.dart';

import '../../consts/Routes.dart';
import '../../consts/commands/NavigationCommand.dart';
import '../../consts/modules/PipeChannel.dart';
import '../module/ApplicationJunctionMediator.dart';

class ReadyCommand extends SimpleCommand {
	@override
	void execute( INotification note ) {
		print("> StartupCommand -> ReadyCommand > note: $note");

		sendNotification( NavigationCommand.NAVIGATE_TO_PAGE, null,
				Routes.HISTORY_PAGE );

		sendNotification(
			ApplicationJunctionMediator.TO_DATA_PROCESSOR,
			new Message("MESSAGE", "HELLO", "DP"),
			PipeChannel.TO_DATA_PROCESSOR
		);
	}
}