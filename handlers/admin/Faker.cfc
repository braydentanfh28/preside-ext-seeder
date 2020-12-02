component extends="preside.system.base.AdminHandler" {
	property name="fakerService"             inject="FakerService";
	property name="enumService"              inject="EnumService";
	property name="fakerFileStorageProvider" inject="FakerFileStorageProvider";

	public void function preHandler( event, action, eventArguments ) {
		super.preHandler( argumentCollection=arguments );

		if ( !isFeatureEnabled( "seederFaker" ) ) {
			event.notFound();
		}
	}

	public void function index( event, rc, prc, args={} ) {
		prc.pageIcon     = "satellite-dish";
		prc.pageTitle    = translateResource( "cms:faker" );
		prc.pageSubtitle = translateResource( "cms:faker.subtitle" );

		prc.actionUrl    = event.buildAdminLink( linkto="Faker.fakeAction" );
		prc.fakerOptions = enumService.listItems( "fakerOptions" );

		event.includeData( {
			  newFormFieldUrl = event.buildAdminLink( linkto="faker.ajaxGetFakeField" )
			, getSubOptionUrl = event.buildAdminLink( linkto="faker.ajaxGetSubOption" )
		} );
	}

	public string function ajaxGetFakeField( event, rc, prc, args={} ) {
		args.index        = rc.index ?: 2;
		args.fakerOptions = enumService.listItems( "fakerOptions" );

		return renderView( view="/admin/faker/_fakeField", args=args );
	}

	public string function ajaxGetSubOption( event, rc, prc, args={} ) {
		var selectedOption = rc.option ?: "";

		if ( !isEmptyString( selectedOption ) ) {
			args.options = enumService.listItems( "faker#selectedOption#" );

			return renderView( view="/admin/faker/_fakerOptions", args=args );
		}

		return  "";
	}

	public void function fakeAction( event, rc, prc, args={} ) {
		var formData         = event.getCollectionWithoutSystemVars();
		var validationResult = validateForms();
		var totalFields      = val( formData.total_field ?: "1" );

		for ( var i=1; i<=totalFields; i++ ) {
			if ( isEmptyString( formData[ "field-#i#-name" ]      ?: "" ) or
				 isEmptyString( formData[ "field-#i#-option" ]    ?: "" ) or
				 isEmptyString( formData[ "field-#i#-suboption" ] ?: "" )
			) {
				validationResult.addError( fieldName="field-#i#", message="cms:validation.required.default" );
			}
		}

		if ( !validationResult.validated() ) {
			var persist              = formData;
			persist.validationResult = validationResult;

			messageBox.error( translateResource( uri="faker.general:faker.error.message" ) );
			setNextEvent( url=event.buildAdminLink( linkto="faker" ), persistStruct=persist );
		}

		var processedData = fakerService.processData( formData=formData, totalFields=totalFields );
		var generatedData = fakerService.generateData( integration=val( formData.integration ?: 100 ), settings=processedData );

		if ( generatedData.recordcount ) {
			var csvColumns = queryColumnArray( generatedData );

			savecontent variable="generatedRecords" {
				writeOutput( listQualify( arrayToList( csvColumns ), '"' ) );
				writeOutput( "#chr(13)##chr(10)#" );

				for ( var data in generatedData ) {
					var lineOutput = "";

					for ( var column in csvColumns ) {
						lineOutput = listAppend( lineOutput, '"#data[ column ]#"' );
					}

					writeOutput(lineOutput );
					writeOutput( "#chr(13)##chr(10)#" );
				}
			};

			var fileName = createUUID();
			fileWrite( getTempDirectory() & "tempcsv.csv", generatedRecords );
			var uploadedFile = _uploadFakerFile(
				  fileName   = fileName
				, fileBinary = fileReadBinary( getTempDirectory() & "tempcsv.csv" )
			);
			var generatedCsvLink = event.buildLink( fileStorageProvider="fakerFileStorageProvider", fileStoragePath=uploadedFile );
		}

		messageBox.info( translateResource( uri="faker.general:faker.success.message" ) );
		setNextEvent( url=generatedCsvLink );
	}

// PRIVATE HELPERS
	private string function _uploadFakerFile(
		  required string fileName
		, required binary fileBinary
	) {
		var filePath = "/#createUUID()#.csv";

		fakerFileStorageProvider.putObject(
			  object = arguments.fileBinary
			, path   = filePath
		);

		return filePath;
	}
}