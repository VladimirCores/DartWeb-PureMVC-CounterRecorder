import 'dart:html';

import 'app/ApplicationFacade.dart';
import 'app/command/Command.dart';
import 'app/command/StartupCommand.dart';
import 'app/view/components/Application.dart';

void main() {
  final root = querySelector('body'); 
  final applicationFacade = ApplicationFacade.getInstance( ApplicationFacade.CORE );
  applicationFacade.registerCommand( StartupCommand.NAME, Command.startupCommand );
  applicationFacade.executeCommand( StartupCommand.NAME, new Application(root) );
}
