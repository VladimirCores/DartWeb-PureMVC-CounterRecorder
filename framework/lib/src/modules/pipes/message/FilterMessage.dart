part of framework;

class FilterMessage extends Message
{
	static const String BASE  	= Message.BASE+'filter-control/';

	static const String SET_PARAMS = BASE+'setparams';
	static const String SET_FILTER = BASE+'setfilter';
	static const String BYPASS = BASE+'bypass';
	static const String FILTER = BASE+'filter';

	// Constructor
	FilterMessage( String type, String name, [ Function filter, Object params ]):super( type )
	{
		setName( name );
		setFilter( filter );
		setParams( params );
	}

	/**
	 * Set the target filter name.
	 */
	void setName( String name ) { this.name = name; }

	/**
	 * Get the target filter name.
	 */
	String getName() { return this.name; }

	/**
	 * Set the filter function.
	 */
	void setFilter( Function value ) { this.filter = value; }

	/**
	 * Get the filter function.
	 */
	Function getFilter( ) { return this.filter; }

	/**
	 * Set the parameters object.
	 */
	void setParams( Object params ) { this.params = params; }

	/**
	 * Get the parameters object.
	 */
	Object getParams( ) { return this.params; }

	Object params;
	Function filter;
	String name;
}
