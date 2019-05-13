part of framework;

class CallbackMessage extends RequestMessage
{
  CallbackMessage([ Function callback, Object data ])
    :super( "", data ) {
    _callback = callback;
  }

  get callback => _callback;
  Callback _callback;

  void setRequest( String value ) { setHeader( value ); }
}

typedef Callback<T> = void Function(T a);