part of framework;

class Message implements IPipeMessage
{
  static int INDEX = 0;

  static const String BASE = "pipe-message/";
  static const String NORMAL = BASE + "normal/";
  static const String MODULE = BASE + "module/";
  static const String WORKER = BASE + "worker/";

	Object body;
	Object header;
	int responseID;
  int pipeID;
	String messageType;
	String messageID;

  Message( String messageType, [ Object header, Object body ])
	{
		setBody( body );
		setHeader( header );

		int id = ++INDEX;
		this.messageType = messageType;
		this.messageID = id.toString();
	}

	String getType() { return this.messageType; }

	Object getHeader() { return this.header; }
	void setHeader( Object value ) { this.header = value;	}

	Object getBody() { return body; }
	void setBody( Object value ) { this.body = value; }

	int getPipeID() { return this.pipeID; }
	void setPipeID( int value ) { this.pipeID = value; }

	int getResponsePipeID() { return this.responseID; }
	void setResponsePipeID( int value ) { this.responseID = value; }

	String getMessageID() { return this.messageID; }
}
