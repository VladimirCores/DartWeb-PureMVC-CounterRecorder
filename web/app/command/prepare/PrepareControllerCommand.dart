import 'package:framework/framework.dart';

import '../../../consts/commands/CounterCommand.dart';
import '../../../consts/commands/DataCommand.dart';
import '../../../consts/commands/HistoryCommand.dart';
import '../../../consts/commands/NavigationCommand.dart';
import '../Command.dart';

class PrepareControllerCommand extends SimpleCommand {
  @override
  void execute(INotification note) {
    print("> StartupCommand -> PrepareControllerCommand > note: $note");

    facade.registerCommand(CounterCommand.INCREMENT, Command.incrementCounterCommand);
    facade.registerCommand(CounterCommand.DECREMENT, Command.decrementCounterCommand);
    facade.registerCommand(CounterCommand.UPDATE, Command.updateCounterCommand);

    facade.registerCommand(HistoryCommand.SAVE_COUNTER_HISTORY, Command.saveCounterHistoryCommand);
    facade.registerCommand(HistoryCommand.DELETE_COUNTER_HISTORY, Command.deleteCounterHistoryCommand);
    facade.registerCommand(HistoryCommand.REVERT_COUNTER_HISTORY, Command.revertCounterHistoryCommand);

    facade.registerCommand(NavigationCommand.NAVIGATE_TO_PAGE, Command.navigateToPageCommand);
    facade.registerCommand(NavigationCommand.NAVIGATE_BACK, Command.navigateBackCommand);

    facade.registerCommand(DataCommand.GET_HISTORY_DATA, Command.getHistoryDataCommand);
    facade.registerCommand(DataCommand.GET_COUNTER_DATA, Command.getCounterDataCommand);
  }
}
