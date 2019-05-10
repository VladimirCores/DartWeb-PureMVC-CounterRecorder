part of framework;

/**
 * Pipe Message Interface.
 * <P>
 * <code>IPipeMessage</code>s are objects written into to a Pipeline,
 * composed of <code>IPipeFitting</code>s. The message is passed from
 * one fitting to the next in synchronous fashion.</P>
 * <P>
 */
abstract class IPipeMessage
{
  String getType();

	// Get the header of this message
	Object getHeader();

	// Set the header of this message
	void setHeader( Object header );

	// Get the body of this message
	Object getBody();

	// Set the body of this message
	void setBody(Object body);

	int getPipeID();
	void setPipeID(int value);

	int getResponsePipeID();
	void setResponsePipeID( int value );

	String getMessageID();
}
