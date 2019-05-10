part of framework;

/**
  * Pipe Aware interface.
  * <P>
  * Can be implemented by any PureMVC Core that wishes
  * to communicate with other Cores using the Pipes
  * utility.</P>
  */
abstract class IPipeAware
{
  void acceptInputPipe( String name, IPipeFitting pipe );
	void acceptOutputPipe( String name, IPipeFitting pipe );
}
