import 'package:framework/framework.dart';

import 'StartupCommand.dart';
import 'counter/DecrementCounterCommand.dart';
import 'counter/IncrementCounterCommand.dart';
import 'counter/UpdateCounterCommand.dart';
import 'history/DeleteCounterHistoryCommand.dart';
import 'history/RevertCounterHistoryCommand.dart';
import 'history/SaveCounterHistoryCommand.dart';
import 'navigation/NavigateBackCommand.dart';
import 'navigation/NavigateToPageCommand.dart';

class Command {
  static ICommand startupCommand() { return StartupCommand(); }

  // Counter Action Commands
  static ICommand incrementCounterCommand() { return IncrementCounterCommand(); }
  static ICommand decrementCounterCommand() { return DecrementCounterCommand(); }
  static ICommand updateCounterCommand() { return UpdateCounterCommand(); }

  // History Commands
  static ICommand saveCounterHistoryCommand() { return SaveCounterHistoryCommand(); }
  static ICommand deleteCounterHistoryCommand() { return DeleteCounterHistoryCommand(); }
  static ICommand revertCounterHistoryCommand() { return RevertCounterHistoryCommand(); }

  // Navigation Commands
  static ICommand navigateToPageCommand() { return NavigateToPageCommand(); }
  static ICommand navigateBackCommand() { return NavigateBackCommand(); }
}