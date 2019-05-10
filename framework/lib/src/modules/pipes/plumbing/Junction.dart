part of framework;

class Junction
{
  /**
	 *  INPUT Pipe Type
	 */
	static const String INPUT 	= 'input';
	/**
	 *  OUTPUT Pipe Type
	 */
	static const String OUTPUT 	= 'output';

	/**
	 *  The names of the INPUT pipes
	 */
	List<String> inputPipes = [];

	/**
	 *  The names of the OUTPUT pipes
	 */
	List<String> outputPipes = [];

	/**
	 * The map of pipe names to their pipes
	 */
	Map<String, IPipeFitting> pipesMap = Map<String, IPipeFitting>();

	/**
	 * The map of pipe names to their types
	 */
	Map<String, String> pipeTypesMap = Map<String, String>();

  Junction();

  /**
   * Register a pipe with the junction.
   * <P>
   * Pipes are registered by unique name and type,
   * which must be either <code>Junction.INPUT</code>
   * or <code>Junction.OUTPUT</code>.</P>
  	 * <P>
   * NOTE: You cannot have an INPUT pipe and an OUTPUT
   * pipe registered with the same name. All pipe names
   * must be unique regardless of type.</P>
   *
   * @return Boolean true if successfully registered. false if another pipe exists by that name.
   */
  bool registerPipe( String name, String type, IPipeFitting pipe )
  {
  	bool success = true;
  	if ( pipesMap[ name ] == null ) {
  		pipe.pipeName = name;
  		pipesMap[ name ] = pipe;
  		pipeTypesMap[ name ] = type;
  		switch ( type ) {
  			case INPUT: 	inputPipes.add( name );	 	break;
  			case OUTPUT: 	outputPipes.add( name ); 	break;
  			default: success = false;
  		}
  	} else success = false;
  	print("> Nest -> Junction > registerPipe: type = $type, name = ${name}");
  	return success;
  }

  /**
	 * Does this junction have a pipe by this name?
	 *
	 * @param name the pipe to check for
	 * @return Boolean whether as pipe is registered with that name.
	 */
	bool hasPipe( String name )
	{
		return pipesMap.containsKey( name );
	}

  /**
	 * Does this junction have an INPUT pipe by this name?
	 *
	 * @param name the pipe to check for
	 * @return Boolean whether an INPUT pipe is registered with that name.
	 */
	bool hasInputPipe( String name )
	{
		return ( hasPipe( name ) && ( pipeTypesMap[ name ] == INPUT ));
	}

  /**
	 * Does this junction have an OUTPUT pipe by this name?
	 *
	 * @param name the pipe to check for
	 * @return Boolean whether an OUTPUT pipe is registered with that name.
	 */
	bool hasOutputPipe( String name )
	{
		return ( hasPipe( name ) && ( pipeTypesMap[ name ] == OUTPUT ));
	}

  /**
	 * Remove the pipe with this name if it is registered.
	 * <P>
	 * NOTE: You cannot have an INPUT pipe and an OUTPUT
	 * pipe registered with the same name. All pipe names
	 * must be unique regardless of type.</P>
	 *
	 * @param name the pipe to remove
	 */
	void removePipe( String name )
	{
		if ( hasPipe( name ))
		{
			String type = pipeTypesMap[name];
			List pipesList;
			switch (type) {
				case INPUT: pipesList = inputPipes; break;
				case OUTPUT: pipesList = outputPipes; break;
			}
			int counter = pipesList.length;
			String pipeName;
			while( counter-- > 0 ) {
				pipeName = pipesList[counter];
				if (pipeName == name){
					pipesList.removeAt(counter);
					break;
				}
			}
			pipesMap.remove( name );
			pipeTypesMap.remove( name );
		}
	}

  /**
	 * Retrieve the named pipe.
	 *
	 * @param name the pipe to retrieve
	 * @return IPipeFitting the pipe registered by the given name if it exists
	 */
	IPipeFitting retrievePipe( String name )
	{
		IPipeFitting original = pipesMap[name];
		IPipeFitting result = original;
		bool isFilter = result is Filter;
		while( result != null && isFilter ) {
			result = ( result as Filter ).getOutput();
			isFilter = result is Filter;
		}
		return result != null ? result : original;
	}

  /**
   * Add a PipeListener to an INPUT pipe.
   * <P>
   * NOTE: there can only be one PipeListener per pipe,
   * and the listener function must accept an IPipeMessage
   * as its sole argument.</P>
   *
   * @param name the INPUT pipe to add a PipeListener to
   * @param context the calling context or 'this' object
   * @param listener the function on the context to call
   */
  bool addPipeListener( String inputPipeName, Object context, Function listener )
  {
    bool success = false;
		print("> Nest -> Junction > addPipeListener: hasPipe = ${hasPipe( inputPipeName )}, name = ${inputPipeName}");
		if ( hasPipe( inputPipeName ))
    {
      IPipeFitting pipe = pipesMap[ inputPipeName ];
      success = pipe.connect( PipeListener( context, listener ));
    }
    return success;
  }

  /**
   * Send a message on an OUTPUT pipe.
   *
   * @param name the OUTPUT pipe to send the message on
   * @param message the IPipeMessage to send
   * @param individual message will be send only to pipe from where this message is comming from, by channelID
   */
  bool sendMessage( String outputPipeName, IPipeMessage message, [ bool individual = true ])
  {
    bool success = false;
    bool outputPipeExist = hasOutputPipe( outputPipeName );
    print(">\tJunction.sendMessage: outputPipeExist = ${outputPipeExist}" );
    print(">\tJunction.sendMessage: outputPipeName = ${outputPipeName}" );
    if ( outputPipeExist )
    {
      IPipeFitting pipe = pipesMap[ outputPipeName ];
      if ( individual && message.getPipeID() != null )
        message.setPipeID( pipe.channelID );

      print(">\tJunction.sendMessage: message responsePipeID = ${message.getResponsePipeID()} | pipeID = ${message.getPipeID()}" );
      success = pipe.write( message );
      print(">\tJunction.sendMessage: sent success = ${success}" );
    }
    return success;
  }
}
