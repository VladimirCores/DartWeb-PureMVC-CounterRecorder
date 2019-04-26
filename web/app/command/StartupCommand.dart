import 'package:framework/framework.dart';

import 'ReadyCommand.dart';
import 'prepare/PrepareCompleteCommand.dart';
import 'prepare/PrepareControllerCommand.dart';
import 'prepare/PrepareModelCommand.dart';
import 'prepare/PrepareViewCommand.dart';

class StartupCommand extends AsyncMacroCommand {
  static const String NAME = "StartupCommand";

  StartupCommand() {
    addSubCommands([
	    () => PrepareModelCommand(),
	    () => PrepareControllerCommand(),
	    () => PrepareViewCommand(),

	    () => PrepareCompleteCommand(),
	    () => ReadyCommand()
    ]);
  }
  
  @override
  void execute( INotification note ) {
    print( "> StartupCommand -> note : $note" );
    super.execute( note );
  }
}
