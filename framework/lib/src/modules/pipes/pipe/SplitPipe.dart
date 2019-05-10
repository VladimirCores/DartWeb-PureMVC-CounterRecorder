part of framework;

/**
 * Splitting Pipe Tee.
 * <P>
 * Writes input messages to multiple output pipe fittings.</P>
 */
class SplitPipe implements IPipeFitting
{
  List _outputs = [];
  int	_channelID = Pipe.newChannelID();
  String _pipeName;

  /**
	 * Constructor.
	 * <P>
	 * Create the SplitPipe.
	 * This is the most common configuration, though you can connect
	 * as many outputs as necessary by calling <code>connect</code>.</P>
	 */
  SplitPipe();

  /**
	 * Connect the output IPipeFitting.
	 * <P>
	 * NOTE: You can connect as many outputs as you want
	 * by calling this method repeatedly.</P>
	 *
	 * @param output the IPipeFitting to connect for output.
	 */
	bool connect( IPipeFitting output )
	{
		output.pipeName = this.pipeName;
		_outputs.add( output );
		return true;
	}

	/**
	 * Disconnect the most recently connected output fitting. (LIFO)
	 * <P>
	 * To disconnect all outputs, you must call this
	 * method repeatedly untill it returns null.</P>
	 *
	 * @return the IPipeFitting to connect for output.
	 */
	IPipeFitting disconnect()
	{
		return _outputs.removeLast() as IPipeFitting;
	}

	/**
	 * Disconnect a given output fitting.
	 * <P>
	 * If the fitting passed in is connected
	 * as an output of this <code>TeeSplit</code>, then
	 * it is disconnected and the reference returned.</P>
	 * <P>
	 * If the fitting passed in is not connected as an
	 * output of this <code>TeeSplit</code>, then <code>null</code>
	 * is returned.</P>
	 *
	 * @return the IPipeFitting to connect for output.
	 */
	IPipeFitting disconnectFitting( IPipeFitting target )
	{
		IPipeFitting removed;
		IPipeFitting output;
		int length = _outputs.length;
//			print(">\t\t : SplitPipe.disconnectFitting, target.id =", target.channelID);
//			print(">\t\t : SplitPipe.disconnectFitting, target.pipe =", target.pipeName);
//			print(">\t\t : SplitPipe.disconnectFitting, length =", length);
		while( length-- > 0) {
			output = _outputs[length];
//				print(">\t\t\t output :", output.channelID, output.pipeName);
			if (output.channelID == target.channelID) {
				removed = _outputs.removeAt(length - 1);
				break;
			}
		}
//			print(">\t\t : SplitPipe.disconnectFitting, removed =", removed);
		return removed;
	}

	int get outputsCount => _outputs.length;

	/**
	 * Write the message to all connected outputs.
	 * <P>
	 * Returns false if any output returns false,
	 * but all outputs are written to regardless.</P>
	 * @param message the message to write
	 * @return Boolean whether any connected outputs failed
	 */
	bool write( IPipeMessage message )
	{
		bool success = true;
		IPipeFitting output;
		int counter = _outputs.length;
		int messagePipeID = message.getPipeID();
		bool isIndividual = messagePipeID > 0;

//			print("\t\t : SplitPipe.write: isIndividual =", isIndividual, messagePipeID);

		while ( counter-- > 0 ) {
			output = _outputs[ counter ];
			if( output != null ) {
				_outputs.remove( output );
				output = null;
				counter++;
			}
//				print("\t\t\t : output channelID =", output.channelID);
//				print("\t\t\t : output pipeName =", output.pipeName);
			if ( isIndividual ) {
				success = output != null && (_channelID == messagePipeID || output.channelID == messagePipeID) && !output.write( message );
				break;
			} else {
				success = output != null && !output.write( message );
			}
		}
		return success;
	}

	String get pipeName => _pipeName;
  set pipeName( String value ) { _pipeName = value; }

	int get channelID => _channelID;
	set channelID( int value ) { _channelID = value; }
}
