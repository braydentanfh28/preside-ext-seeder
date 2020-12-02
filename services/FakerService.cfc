/**
 * @singleton      true
 * @presideService true
 */
component {

	/**
	 *
	 * Integrate Java Faker package
	 * Docs: https://dius.github.io/java-faker/apidocs/index.html
	 *
	 */
	public any function init() {
		variables.Faker = _createFakerObject();

		return this;
	}

// PUBLIC API
	/**
	 *
	 * Get the generated value from class's method
	 * i.e. getClassMethodValue( class="name", method="fullName" )
	 *
	 */
	public any function getClassMethodValue(
		  required string class
		, required string method
	) {
		var fakerClass = getFakerClass( class=arguments.class );
		if ( isObject( fakerClass ) ) {
			try {
				return fakerClass[ arguments.method ]();
			} catch (any e) {
				$raiseError( e );
			}
		}
		 return nullValue();
	}

	public any function getFakerClass( required string class ) {
		try {
			return getFakerPackage()[ arguments.class ]();
		} catch (any e) {
			$raiseError( e );
		}

		return false;
	}

	public array function processData(
		  required struct  formData
		, required numeric totalFields
	) {
		var data = [];

		for ( var i=1; i<=arguments.totalFields; i++ ) {
			data.append( {
				  name      = lCase( arguments.formData[ "field-#i#-name" ] ?: "" )
				, option    = arguments.formData[ "field-#i#-option" ]      ?: ""
				, suboption = arguments.formData[ "field-#i#-suboption" ]   ?: ""
			} );
		}

		return data;
	}

	public query function generateData(
		  required numeric integration
		, required array   settings
	) {
		var queryFieldName = "";
		var queryFieldType = "";

		for ( var setting in arguments.settings ) {
			queryFieldName = listAppend( queryFieldName, setting.name ?: "" );
			queryFieldType = listAppend( queryFieldType, "varchar" );
		}

		var data       = queryNew( queryFieldName, queryFieldType );
		var currentRun = 1;

		while ( currentRun <= arguments.integration ) {
			var newData = {};
			for ( var setting in arguments.settings ) {
				if ( !isEmpty( setting.name ?: "" ) ) {
					newData[ setting.name ] = getClassMethodValue(
						  class  = setting.option    ?: ""
						, method = setting.suboption ?: ""
					);
				}
			}

			if ( !isEmpty( newData ) ) {
				queryAddRow( data, newData );
			}

			currentRun ++;
		}

		return data;
	}

// LIB FUNCTIONS
	private any function getFakerPackage() { return Faker; }

// PRIVATE HERLPS
	private array function _getLib() {
		return [
			  "./lib/javafaker-1.0.2.jar"
			, "./lib/snakeyaml-1.26.jar"
			, "./lib/commons-lang3-3.11.jar"
		];
	}

	private any function _createFakerObject() {
		return createObject( "java", "com.github.javafaker.Faker", _getLib() );
	}
}