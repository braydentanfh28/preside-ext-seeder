/**
 * @singleton      true
 * @presideService true
 */
component {

	/**
	 * @fakerService.inject                 fakerService
	 * @systemConfigurationService.inject   systemConfigurationService
	 * @adHocTaskManagerService.inject      adHocTaskManagerService
	 */
	public any function init(
		  required any fakerService
		, required any systemConfigurationService
		, required any adHocTaskManagerService
	) {
		_setFakerService(               arguments.fakerService               );
		_setSystemConfigurationService( arguments.systemConfigurationService );
		_setAdHocTaskManagerService(    arguments.adHocTaskManagerService    );
		return this;
	}

	public void function processSeederEnabledObjects() {
		var seederEnabledObjs = [];
		var allObjs           = $getPresideObjectService().listObjects();

		for ( var obj in allObjs ) {
			var seederEnable = $getPresideObjectService().getObjectAttribute(
				  objectName    = obj
				, attributeName = "seederEnable"
				, defaultValue  = "false"
			);

			if ( $helpers.isTrue( seederEnable ) ) {
				seederEnabledObjs.append( obj );
			}
		}

		if ( arrayLen( seederEnabledObjs ) ) {
			_getSystemConfigurationService().saveSetting(
				  category = "ext_seeder"
				, setting  = "seeder_enabled_objs"
				, value    = arrayToList( seederEnabledObjs )
			);
		}
	}

	public array function getSeederEnabledObjs() {
		var objOptions  = [];
		var enabledObjs = listToArray( _getSystemConfigurationService().getSetting( "ext_seeder", "seeder_enabled_objs", "" ) );

		for ( var obj in enabledObjs ) {
			objOptions.append( {
				  id          = obj
				, label       = $translateResource( uri="preside-objects.#obj#:title.singular", defaultValue=obj )
				, description = $translateResource(
					  uri  = "seeder.seederForm:field.object.description"
					, data = [ _beautifyEnabledProps( objectName=obj, enabledProps=getObjectSeedingEnabledProps( objectName=obj ) ) ]
				)
			} );
		}

		return objOptions;
	}

	public string function getObjectSeedingEnabledProps( required string objectName ) {
		var enabledProps = [];
		var objProps     = $getPresideObjectService().getObjectProperties( objectName=arguments.objectName );

		for ( var prop in objProps ) {
			if ( !$helpers.isEmptyString( objProps[ prop ].seederClass ?: "" ) ) {
				enabledProps.append( prop );
			}

			if ( !$helpers.isEmptyString( objProps[ prop ].seederSameAs ?: "" ) and arrayFind( enabledProps, objProps[ prop ].seederSameAs ) ) {
				enabledProps.append( prop );
			}
		}

		return arrayToList( enabledProps );
	}

	public string function seedingObject(
		  required string  objectName
		, required numeric integration
	) {
		var event         = $getRequestContext();
		var enabledProps  = listToArray( getObjectSeedingEnabledProps( objectName=arguments.objectName ) );
		var seedingConfig = {};

		for ( var p in enabledProps ) {
			var definedClass = $getPresideObjectService().getObjectPropertyAttribute( arguments.objectName, p, "seederClass"  );

			seedingConfig[ p ] = {
				  class  = listFirst( definedClass, "." )
				, method = listLast(  definedClass, "." )
				, prefix = $getPresideObjectService().getObjectPropertyAttribute( arguments.objectName, p, "seederClass"  )
				, suffix = $getPresideObjectService().getObjectPropertyAttribute( arguments.objectName, p, "seederClass"  )
				, sameAs = $getPresideObjectService().getObjectPropertyAttribute( arguments.objectName, p, "seederSameAs" )
			}
		}

		return _getAdHocTaskManagerService().createTask(
			  event             = "admin.seeder.runSeedingInBackgroundThread"
			, runNow            = true
			, returnUrl         = event.buildAdminLink( linkto="seeder" )
			, title             = $translateResource( uri="seeder.general:seeding.task.title", data=[ "{#arguments.objectName#}" ] )
			, args              = {
				  objectName  = arguments.objectName
				, integration = arguments.integration
				, config      = seedingConfig
			}
		);
	}

	public void function seedingObjectProcess(
		  required numeric integration
		, required struct  config
		, required string  objectName
		,          any     logger
		,          any     progress
	) {
		var canLog            = StructKeyExists( arguments, "logger" );
		var canInfo           = canLog && logger.canInfo();
		var canReportProgress = StructKeyExists( arguments, "progress" );

		if ( canInfo ) {
			arguments.logger.info( "Seeding #arguments.integration# record(s) to {#arguments.objectName#}..." );
		}

		for ( var i=1; i<=arguments.integration; i++ ) {
			var insertData = {};

			for ( var c in arguments.config ) {
				if ( !$helpers.isEmptyString( arguments.config[ c ].class ?: "" ) and !$helpers.isEmptyString( arguments.config[ c ].method ?: "" ) ) {
					insertData[ c ] = _getFakerService().getClassMethodValue(
						  class  = arguments.config[ c ].class
						, method = arguments.config[ c ].method
					);
				}

				if ( !$helpers.isEmptyString( arguments.config[ c ].sameAs ?: "" ) and structKeyExists( insertData, arguments.config[ c ].sameAs ) ) {
					insertData[ c ] = insertData[ arguments.config[ c ].sameAs ];
				}
			}

			if ( !isEmpty( insertData ) ) {
				$getPresideObject( arguments.objectName ).insertData( data=insertData );
			}

			if ( canReportProgress ) {
				arguments.progress.setProgress( ceiling( ( 100 / arguments.integration ) * ( i-1 ) ) );
			}
		}

		if ( canReportProgress ) {
			arguments.progress.setProgress( 100 );
		}

		if ( canInfo ) {
			arguments.logger.info( "Seeding completed." );
		}
	}

// PRIVATE HELPERS
	private string function _beautifyEnabledProps(
		  required string objectName
		, required string enabledProps
	) {
		if ( !$helpers.isEmptyString( arguments.enabledProps ) ) {
			var output   = [];
			var propsArr = listToArray( arguments.enabledProps );

			for ( var p in propsArr ) {
				output.append( $translateResource(
					  uri          = "preside-objects.#arguments.objectName#:field.#p#.title"
					, defaultValue = $translateResource(
						  uri          = "cms:preside-objects.default.field.#p#.title"
						, defaultValue = p
					)
				) );
			}

			return arrayToList( output, ", " );
		}

		return "";
	}

// GETTER SETTER
	private any function _getFakerService() {
		return _fakerService;
	}
	private void function _setFakerService( required any fakerService ) {
		_fakerService = arguments.fakerService;
	}

	private any function _getSystemConfigurationService() {
		return _systemConfigurationService;
	}
	private void function _setSystemConfigurationService( required any systemConfigurationService ) {
		_systemConfigurationService = arguments.systemConfigurationService;
	}

	private any function _getAdHocTaskManagerService() {
		return _adHocTaskManagerService;
	}
	private void function _setAdHocTaskManagerService( required any adHocTaskManagerService ) {
		_adHocTaskManagerService = arguments.adHocTaskManagerService;
	}
}