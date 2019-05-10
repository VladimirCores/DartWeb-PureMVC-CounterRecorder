import 'package:framework/framework.dart';

class ApplicationJunctionMediator extends JunctionMediator
{
  static const String TO_DATA_PROCESSOR = "notification_to_data_processor";
  static const String NAME = "ApplicationJunctionMediator";
  String getMediatorName() { return NAME; }

	ApplicationJunctionMediator( Junction junction ):super( junction )
	{
		// The STD_IN pipe to the app from all modules
		junction.registerPipe( 	PipeAwareModule.STD_IN,  	Junction.INPUT, new MergePipe() );
		// The STD_OUT pipe from the app to all modules
		junction.registerPipe(	PipeAwareModule.STD_OUT,	Junction.OUTPUT, new SplitPipe() );

		junction.addPipeListener( PipeAwareModule.STD_IN, this, handlePipeMessage );
	}

	@override
	List<String> listNotificationInterests() {
		return super.listNotificationInterests()..addAll([
			TO_DATA_PROCESSOR
		]);
	}

	@override
	void handleNotification( INotification note ) {
		print("\n> ApplicationJunctionMediator -> handleNotification: note = ${note.getName()}");
		switch( note.getName() ) {
			case TO_DATA_PROCESSOR:
				Junction junction = viewComponent as Junction;
				junction.sendMessage( note.getType(), note.getBody() );
				break;
		}
		if ( note.getBody() is IPipeFitting ) super.handleNotification( note );
	}

	void handlePipeMessage( IPipeMessage message )
	{
		print("> ApplicationJunctionMediator -> handlePipeMessage: ${message.getType()} - ${message.getHeader()} ${message.getBody()}");
	}
}
