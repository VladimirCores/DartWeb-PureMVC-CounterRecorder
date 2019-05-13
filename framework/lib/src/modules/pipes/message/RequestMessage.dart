part of framework;

class RequestMessage extends Message
{
  String _pipeChannel;
  String get pipeChannel => _pipeChannel;

  RequestMessage(String pipeChannel, [String request = "", Object data, int responsePipeID = 0]):super(Message.MODULE, request, data)
  {
    _pipeChannel = pipeChannel;
    setResponsePipeID( responsePipeID );
  }

  String getRequest() { return getHeader() as String; }
  RequestMessage copy() {
    RequestMessage result = RequestMessage(
        getRequest(), getBody(), getResponsePipeID() );
    result.setPipeID( getPipeID() );
    return result;
  }
}
