part of framework;

class PipeListener implements IPipeFitting
{
  Object context;
	Function listener;
	String _pipeName;
	int _id = Pipe.newChannelID();

	PipeListener( Object context, Function listener )
	{
		this.context = context;
		this.listener = listener;
	}

  /**
	 *  Can't connect anything beyond this.
	 */
	bool connect( IPipeFitting output ) => false;

	/**
	 *  Can't disconnect since you can't connect, either.
	 */
	IPipeFitting disconnect() => null;

	// Write the message to the listener
	bool write( IPipeMessage message )
	{
		Function.apply(listener, [message]);
		return true;
	}

	String get pipeName => _pipeName;
	set pipeName(String value) { _pipeName = value; }

	int get channelID => _id;
	set channelID( int value ) { _id = value; }
}
