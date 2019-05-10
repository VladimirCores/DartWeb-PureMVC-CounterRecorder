part of framework;

class Pipe implements IPipeFitting
{
  static int _serial = 1;
	static int newChannelID() { return _serial++; }

	int chainLength = 0;

	int	_channelID = 0;
	String _pipeName;

  IPipeFitting output;

  Pipe( int channelID )
  {
    _channelID = channelID;
  }

  /**
	 * Connect another PipeFitting to the output.
	 *
	 * PipeFittings connect to and write to other
	 * PipeFittings in a one-way, syncrhonous chain.</P>
	 *
	 * @return Boolean true if no other fitting was already connected.
	 */
	bool connect( IPipeFitting output )
	{
		bool success = false;
		if ( this.output == null ) {
			output.pipeName = this.pipeName;
			if ( output is Filter ) {
				output.channelID = this._channelID;
			}
			this.output = output;
			success = true;
			chainLength++;
		}
		print("> Nest -> Pipe.connect: pipeName: ${output.pipeName}, $success");
		return success;
	}

  /**
	 * Disconnect the Pipe Fitting connected to the output.
	 * <P>
	 * This disconnects the output fitting, returning a
	 * reference to it. If you were splicing another fitting
	 * into a pipeline, you need to keep (at least briefly)
	 * a reference to both sides of the pipeline in order to
	 * connect them to the input and output of whatever
	 * fiting that you're splicing in.</P>
	 *
	 * @return IPipeFitting the now disconnected output fitting
	 */
	IPipeFitting disconnect( )
	{
		IPipeFitting disconnectedFitting = this.output;
		this.output = null;
		return disconnectedFitting;
	}

	/**
	 * Write the message to the connected output.
	 *
	 * @param message the message to write
	 * @return Boolean whether any connected downpipe outputs failed
	 */
	bool write( IPipeMessage message )
	{
		print("> Nest -> Pipe.write: pipeName: ${ output != null ? output.pipeName : null }");
		return output != null && output.write( message );
	}

	String get pipeName => _pipeName;
	set pipeName( String value ) { _pipeName = value; }

	get channelID => _channelID;
  set channelID( int value ) { _channelID = value; }
}
