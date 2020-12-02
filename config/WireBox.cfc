component {
	public void function configure( required any binder ) {
		var settings = arguments.binder.getColdbox().getSettingStructure();

		arguments.binder.map( "FakerFileStorageProvider" ).asSingleton().to( "preside.system.services.fileStorage.FileSystemStorageProvider" ).noAutoWire()
			.initArg( name="rootDirectory"   , value=settings.uploads_directory & "/faker"  )
			.initArg( name="privateDirectory", value=settings.uploads_directory & "/faker"  )
			.initArg( name="trashDirectory"  , value=settings.uploads_directory & "/.trash" )
			.initArg( name="rootUrl"         , value="" );
	}
}