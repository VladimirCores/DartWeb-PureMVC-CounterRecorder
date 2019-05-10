import 'package:framework/framework.dart';

import '../../consts/modules/PipeChannel.dart';

class DataProcessorJunctionMediator extends JunctionMediator
{
  static const String NAME = "DataProcessorJunctionMediator";
	@override
	String getName() { return NAME; }

	DataProcessorJunctionMediator( Junction junction ):super( junction );

  @override
	void onRegister()
	{

	}

	@override
	List<String> listNotificationInterests() {
		return super.listNotificationInterests()..addAll([
		]);
	}

	@override
	void handleNotification( INotification note ) {
		print("\n> DataProcessorJunctionMediator -> handleNotification: note = ${note.getName()}");
		switch( note.getName() ) {
		}
		if ( note.getBody() is IPipeFitting ) super.handleNotification( note );
	}

	/**
	 * Handle incoming pipe messages only on worker\module side
	 */
  @override
	void handlePipeMessage( IPipeMessage message )
	{
		print("\n> DataProcessorJunctionMediator -> handlePipeMessage: ${message.getType()} - ${message.getHeader()} ${message.getBody()}");

		(viewComponent as Junction).sendMessage(
				PipeChannel.FROM_DATA_PROCESSOR,
				new Message("RESPONSE", "HELLO", "APP")
		);

		// if( message is WorkerRequestMessage )
		// {
		// 	const requestMessage	: WorkerRequestMessage = message as WorkerRequestMessage;
		// 	const request			    : String = requestMessage.getRequest();
		// 	const messageID			  : String = requestMessage.getMessageID();
		// 	const data				    : Object = requestMessage.getBody();
    //
		// 	const hasCommand:Boolean = facade.hasCommand( request );
		// 	const command:String = hasCommand ? request : null;
		// 	trace("> DataProcessorJunctionMediator -> handlePipeMessage: request:", request);
		// 	trace("> DataProcessorJunctionMediator -> handlePipeMessage: inputData:", data ? JSON.stringify(data) : null);
		// 	trace("> DataProcessorJunctionMediator -> handlePipeMessage: messageID:", messageID);
		// 	trace("> DataProcessorJunctionMediator -> handlePipeMessage: command:", command);
		// 	trace("> DataProcessorJunctionMediator -> handlePipeMessage: hasCommand:", hasCommand);
    //
		// 	if ( command )
		// 	{
		// 		_responseKeeper[ messageID ] = function( responsePipeID:uint ):Function
		// 		{
		// 			return function ( data:Object = null ):void {
		// 		    trace("> DataProcessorJunctionMediator -> Write to junction with responsePipeID:", responsePipeID);
		// 				junction.sendMessage( WorkerModule.WRK_OUT, new WorkerResponseMessage( messageID, data, responsePipeID ) );
		// 			};
		// 		} ( requestMessage.getResponsePipeID() );
		// 		this.exec( command, data, messageID );
		// 	}
		// }

	}
}
