part of framework;

class ModuleMessage extends Message
{
  String _pipeChannel;
  String get pipeChannel => _pipeChannel;

  ModuleMessage( this._pipeChannel, [ String request, Object data, int responsePipeID = 0 ])
    :super( Message.MODULE, request, data ) {
    setResponsePipeID( responsePipeID );
  }
}
