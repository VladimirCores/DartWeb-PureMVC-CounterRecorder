part of framework;

/**
 * Pipe Filter.
 * <P>
 * Filters may modify the contents of messages before writing them to
 * their output pipe fitting. They may also have their parameters and
 * filter function passed to them by control message, as well as having
 * their Bypass/Filter operation mode toggled via control message.</p>
 */
class Filter extends Pipe
{
  /**
	 * Constructor.
	 * <P>
	 * Optionally connect the output and set the parameters.</P>
	 */
	Filter( String name, [ IPipeFitting output, Function filter, Object params ])
    :super( output != null ? output.channelID : Pipe.newChannelID() )
	{
		if ( output != null ) this.connect(output);
		this.name = name;
		if ( filter != null ) setFilter( filter );
		if ( params != null ) setParams( params );
	}

	IPipeFitting getOutput() => this.output;

	/**
	 * Handle the incoming message.
	 * <P>
	 * If message type is normal, filter the message (unless in BYPASS mode)
	 * and write the result to the output pipe fitting if the filter
	 * operation is successful.</P>
	 *
	 * <P>
	 * The FilterControlMessage.SET_PARAMS message type tells the Filter
	 * that the message class is FilterControlMessage, which it
	 * casts the message to in order to retrieve the filter parameters
	 * object if the message is addressed to this filter.</P>
	 *
	 * <P>
	 * The FilterControlMessage.SET_FILTER message type tells the Filter
	 * that the message class is FilterControlMessage, which it
	 * casts the message to in order to retrieve the filter function.</P>
	 *
	 * <P>
	 * The FilterControlMessage.BYPASS message type tells the Filter
	 * that it should go into Bypass mode operation, passing all normal
	 * messages through unfiltered.</P>
	 *
	 * <P>
	 * The FilterControlMessage.FILTER message type tells the Filter
	 * that it should go into Filtering mode operation, filtering all
	 * normal normal messages before writing out. This is the default
	 * mode of operation and so this message type need only be sent to
	 * cancel a previous BYPASS message.</P>
	 *
	 * <P>
	 * The Filter only acts on the control message if it is targeted
	 * to this named filter instance. Otherwise it writes through to the
	 * output.</P>
	 *
	 * @return Boolean True if the filter process does not throw an error and subsequent operations
	 * in the pipeline succede.
	 */
  @override
	bool write( IPipeMessage message )
	{
		IPipeMessage outputMessage = message;
		bool success = true;

//			print("FILTER WRITE:", message.getType() == Message.NORMAL);
//			print("\t\t : Mode:", mode === FilterControlMessage.FILTER);


		// Filter normal messages
		switch ( message.getType() )
		{
			case  Message.WORKER:
			case  Message.NORMAL:
				if ( mode == FilterControlMessage.FILTER ) {
					outputMessage = applyFilter( message );
				}
//					print("> FILTER\t\t : Output:", output);
//					print("> FILTER\t\t : outputMessage:", JSON.stringify(outputMessage));
				success = output != null && outputMessage != null && output.write( outputMessage );
			break;

			// Accept parameters from control message
			case FilterControlMessage.SET_PARAMS:
				if ( isTarget( message )) {
					setParams(( message as FilterControlMessage ).getParams() );
				} else {
					success = output.write( outputMessage );
				}
				break;

			// Accept filter function from control message
			case FilterControlMessage.SET_FILTER:
				if ( isTarget( message )){
					setFilter(( message as FilterControlMessage ).getFilter() );
				} else {
					success = output.write( outputMessage );
				}

				break;

			// Toggle between Filter or Bypass operational modes
			case FilterControlMessage.BYPASS:
			case FilterControlMessage.FILTER:
				if ( isTarget( message )) {
					mode = ( message as FilterControlMessage ).getType();
				} else {
					success = output.write( outputMessage );
				}
				break;

			// Write control messages for other fittings through
			default:
				success = output.write( outputMessage );
		}
		return success;
	}

	/**
	 * Is the message directed at this filter instance?
	 */
	bool isTarget( IPipeMessage m )
	{
		return (( m as FilterControlMessage ).getName() == this.name );
	}

	/**
	 * Set the Filter parameters.
	 * <P>
	 * This can be an object can contain whatever arbitrary
	 * properties and values your filter method requires to
	 * operate.</P>
	 *
	 * @param params the parameters object
	 */
	void setParams( Object params )
	{
		this.params = params;
	}

	/**
	 * Set the Filter function.
	 * <P>
	 * It must accept two arguments; an IPipeMessage,
	 * and a parameter Object, which can contain whatever
	 * arbitrary properties and values your filter method
	 * requires.</P>
	 *
	 * @param filter the filter function.
	 */
	void setFilter( Function filter )
	{
		this.filter = filter;
	}

	/**
	 * Filter the message.
	 */
	IPipeMessage applyFilter( IPipeMessage message )
	{
		return filter( message, params );
	}

	String mode = FilterControlMessage.FILTER;
  Function filter = (IPipeMessage message, Object params) => null;
	Object params = {};
	String name;
}
