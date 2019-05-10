part of framework;

class PipeAwareModule implements IPipeAware
{
	/**
	 * Standard output pipe name constant.
	 */
	static const String STD_OUT 				= 'outputFromShellToAll';

	/**
	 * Standard input pipe name constant.
	 */
	static const String STD_IN 				= 'inputToMain';

	/**
	 * Constructor.
	 * <P>
	 * In subclass, create appropriate facade and pass
	 * to super.</P>
	 */
	PipeAwareModule( IFacade facade )
	{
		this.facade = facade;
	}

	/**
	 * Accept an input pipe.
	 * <P>
	 * Registers an input pipe with this module's Junction.
	 */
	void acceptInputPipe( String name, IPipeFitting pipe )
	{
		facade.sendNotification( JunctionMediator.ACCEPT_INPUT_PIPE, pipe, name );
	}

	/**
	 * Accept an output pipe.
	 * <P>
	 * Registers an input pipe with this module's Junction.
	 */
	void acceptOutputPipe( String name, IPipeFitting pipe )
	{
		facade.sendNotification( JunctionMediator.ACCEPT_OUTPUT_PIPE, pipe, name );
	}

	IFacade facade;
}
