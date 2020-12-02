component {

	public void function configure( required struct config ) {
		var conf     = arguments.config ?: {};
		var settings = conf.settings    ?: {};

		_setupFeatures(          settings );
		_setupAdminSidebarItems( settings );
		_setupEnums(             settings );
		_setupInterceptors(      conf     );
	}

// PRIVATE HELPERS
	private void function _setupFeatures( any settings ) {
		settings.features.seeder.enabled      = true;
		settings.features.seederFaker.enabled = true;
	}

	private void function _setupAdminSidebarItems( any settings ) {
		settings.adminSideBarItems = settings.adminSideBarItems ?: [];
		settings.adminSideBarItems.append( "seeder" );
	}

	private void function _setupEnums( any settings ) {
		settings.enum = settings.enum ?: {};

		settings.enum.fakerOptions = [ "address","book","bool","color","commerce","company","country","currency","date","demographic","educator","food","job","lorem","name","number","phoneNumber","superhero","university","weather" ];

		settings.enum.fakerAddress     = [ "state","country","timeZone","lastName","cityName","zipCode","latitude","firstName","streetName","streetAddressNumber","streetAddress","secondaryAddress","stateAbbr","streetSuffix","streetPrefix","citySuffix","cityPrefix","longitude","countryCode","buildingNumber","fullAddress","city" ];
		settings.enum.fakerBook        = [ "title","author","publisher","genr" ];
		settings.enum.fakerBool        = [ "bool" ];
		settings.enum.fakerColor       = [ "hex","name" ];
		settings.enum.fakerCommerce    = [ "color","promotionCode","productName","material","department","price" ];
		settings.enum.fakerCompany     = [ "suffix","bs","name","url","profession","logo","industry","catchPhrase","buzzword" ];
		settings.enum.fakerCountry     = [ "currencyCode","currency","name","flag","capital","countryCode2","countryCode3" ];
		settings.enum.fakerCurrency    = [ "code", "name" ];
		settings.enum.fakerDate        = [ "birthday" ];
		settings.enum.fakerDemographic = [ "race","sex","educationalAttainment","demonym","maritalStatus" ];
		settings.enum.fakerEducator    = [ "university", "campus", "course", "secondarySchool" ];
		settings.enum.fakerFood        = [ "sushi", "vegetable", "measurement", "ingredient", "spice", "fruit", "dish" ];
		settings.enum.fakerJob         = [ "title", "position", "field", "keySkills", "seniority" ];
		settings.enum.fakerLorem       = [ "word", "words", "character", "characters", "sentence", "paragraph" ];
		settings.enum.fakerName        = [ "title", "username", "suffix", "name", "prefix", "lastName", "firstName", "fullName", "bloodGroup", "nameWithMiddle" ];
		settings.enum.fakerNumber      = [ "digit", "randomNumber", "randomDigit", "randomDigitNotZero" ];
		settings.enum.fakerPhoneNumber = [ "extension", "phoneNumber", "cellPhone", "subscriberNumber" ];
		settings.enum.fakerSuperhero   = [ "power", "suffix", "descriptor", "name", "prefix" ];
		settings.enum.fakerUniversity  = [ "suffix", "name", "prefix" ];
		settings.enum.fakerWeather     = [ "description", "temperatureCelsius", "temperatureFahrenheit" ];
	}

	private void function _setupInterceptors( conf ) {
		conf.interceptors.prepend(
			{ class="app.extensions.preside-ext-seeder.interceptors.SeederInterceptor", properties={} }
		);
	}
}