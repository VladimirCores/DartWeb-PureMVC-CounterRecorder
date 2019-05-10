import 'dart:html';

import 'package:framework/framework.dart';

import 'app/command/Command.dart';
import 'app/command/StartupCommand.dart';
import 'app/module/ApplicationJunctionMediator.dart';
import 'app/view/components/Application.dart';
import 'app/view/mediator/ApplicationMediator.dart';

void main() {
  final root = querySelector( 'body' );
  final facade = Facade.getInstance( "CORE" );
  facade.registerMediator( ApplicationMediator( Application( root ) ));
  facade.registerMediator( ApplicationJunctionMediator( Junction() ));
  facade.registerCommand( StartupCommand.NAME, Command.startupCommand );
  facade.executeCommand( StartupCommand.NAME, PipeAwareModule( facade ) );
}
