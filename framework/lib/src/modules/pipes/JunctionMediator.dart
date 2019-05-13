part of framework;

class JunctionMediator extends Mediator
{
  /**
	 * Accept input pipe notification name constant.
	 */
  static const String ACCEPT_INPUT_PIPE 	= 'acceptInputPipe';

	/**
	 * Accept output pipe notification name constant.
	 */
  static const String ACCEPT_OUTPUT_PIPE 	= 'acceptOutputPipe';

	Map<String, Object> _resolvers = Map<String, Object>();

	/**
	 * Constructor.
	 */
  JunctionMediator( Junction component ):super( null, component );

  /**
	 * List Notification Interests.
	 * <P>
	 * Returns the notification interests for this base class.
	 * Override in subclass and call <code>super.listNotificationInterests</code>
	 * to get this list, then add any sublcass interests to
	 * the array before returning.</P>
	 */
  @override
	List<String> listNotificationInterests()
	{
		return [
			JunctionMediator.ACCEPT_INPUT_PIPE,
			JunctionMediator.ACCEPT_OUTPUT_PIPE
    ];
	}

	/**
	 * Handle Notification.
	 * <P>
	 * This provides the handling for common junction activities. It
	 * accepts input and output pipes in response to <code>IPipeAware</code>
	 * interface calls.</P>
	 * <P>
	 * Override in subclass, and call <code>super.handleNotification</code>
	 * if none of the subclass-specific notification names are matched.</P>
	 */
  @override
	void handleNotification( INotification note )
	{
		final String connectionChannel = note.getType();
		final IPipeFitting pipeToConnect = note.getBody() as IPipeFitting;
    Junction junction = viewComponent as Junction;
		print("\n> Nest -> JunctionMediator: $this, $connectionChannel, $pipeToConnect");

		switch( note.getName() )
		{
			// accept an input pipe
			// register the pipe and if successful
			// set this mediators as its listener
			case JunctionMediator.ACCEPT_INPUT_PIPE:
				print("\t : ACCEPT_INPUT_PIPE channel name = $connectionChannel");
				print("\t : hasInputPipe for channel: ${junction.hasInputPipe( connectionChannel )}");
				if ( junction.hasInputPipe( connectionChannel ))
				{
					MergePipeToInputChannel( pipeToConnect, connectionChannel );
				}
				else if ( junction.registerPipe( connectionChannel, Junction.INPUT, pipeToConnect ))
				{
					junction.addPipeListener( connectionChannel, this, handlePipeMessage );
				}
				break;

			// accept an output pipe
			case JunctionMediator.ACCEPT_OUTPUT_PIPE:
				print("\t : ACCEPT_OUTPUT_PIPE channel name = $connectionChannel");
				print("\t : hasOutputPipe for channel: ${junction.hasOutputPipe(connectionChannel)}");
				if ( junction.hasOutputPipe( connectionChannel ))
				{
					AddPipeToOutputChannel( pipeToConnect, connectionChannel );
				}
				else
				{
					junction.registerPipe( connectionChannel, Junction.OUTPUT, pipeToConnect );
				}
				break;
		}
		NotificationProcessor( note );
	}

	void NotificationProcessor( INotification note ) {
	//==================================================================================================
		bool isRequestCallbackMessage = note.getBody() is CallbackMessage;
 		Function messageProcessor = isRequestCallbackMessage ?
			CreateResolverForMessage : null;
//	(note.getBody() is CallbackRequestMessage)
//	? 	CreateWorkerRequestFromDataProcessorMessage
//			: 	CreateWorkerRequestMessage;
//		junction.sendMessage( WorkerModule.TO_WRK, messageProcessor(
//				nName, nBody, nType
//				) as WorkerRequestMessage);
	}

	//==================================================================================================
	RequestMessage CreateResolverForMessage( String request, CallbackMessage input, String responseNotification ) {
	//==================================================================================================
		input.setRequest( request );

		bool isResponseNotificationExist = responseNotification != null;
		bool isInputHasCallback = input.callback != null;

		if ( isResponseNotificationExist || isInputHasCallback ) {
			String messageID = input.getMessageID();
			_resolvers[ messageID ] = CreateResponseResolver(
				input.callback, messageID, responseNotification);
		}

		return input;
	}

	//==================================================================================================
	Function CreateResponseResolver( Function callback, String messageID, String response ) {
	//==================================================================================================
		return ([ Object data ])
		{
			print("> ApplicationJunctionMediator -> ResolverFunction response = ${response}");
			print("> ApplicationJunctionMediator -> ResolverFunction callback = ${callback}");

			if ( callback != null ) {
				_resolvers.remove( messageID );
				Function.apply( callback, [ data ]);
			}

			if ( response != null )
				sendNotification( response, data );
		};
	}

	void AddPipeToOutputChannel( IPipeFitting outputPipe, String channelName )
	{
    Junction junction = viewComponent as Junction;
		final IPipeFitting outputChannelPipe = junction.retrievePipe( channelName );
		print("\t : AddPipeToOutputChannel -> connect = ${outputPipe.pipeName} with ${outputChannelPipe.pipeName}");
		if ( outputChannelPipe != null ) {
			outputChannelPipe.connect( outputPipe );
			print("\t : PIPES COUNT: ${(outputChannelPipe as SplitPipe).outputsCount}");
		}
	}

	void MergePipeToInputChannel( IPipeFitting inputPipe, String channelName )
	{
    Junction junction = viewComponent as Junction;
		final MergePipe pipeForInput = junction.retrievePipe( channelName );
		print("\t : MergePipeToInputChannel -> connect ${inputPipe.pipeName} with ${pipeForInput.pipeName}");
		if ( pipeForInput != null ) {
			pipeForInput.connectInput( inputPipe );
			print("\t : CHAIN LENGTH: ${pipeForInput.chainLength}");
		}
	}

	/**
	 * Handle incoming pipe messages.
	 * <P>
	 * Override in subclass and handle messages appropriately for the module.</P>
	 */
	void handlePipeMessage( IPipeMessage message )
	{
	}

  /**
	 * The Junction for this Module.
	 */
	// get Junction junction() => viewComponent as Junction;
}
