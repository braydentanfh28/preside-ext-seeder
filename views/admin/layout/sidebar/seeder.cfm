<cfscript>
	submenuItems   = [];
	var menuActive = false;

	if ( isFeatureEnabled( "seeder" ) ) {
		var seederMenuActive = listLast( event.getCurrentHandler(), ".") eq "seeder";
		menuActive          = menuActive or seederMenuActive;

		subMenuItems.append(  {
			  link   = event.buildAdminLink( linkto="seeder" )
			, title  = translateResource( "cms:seeder" )
			, active = seederMenuActive
		} );
	}

	if ( isFeatureEnabled( "seederFaker" ) ) {
		var fakerMenuActive = listLast( event.getCurrentHandler(), ".") eq "faker";
		menuActive          = menuActive or fakerMenuActive;

		subMenuItems.append(  {
			  link   = event.buildAdminLink( linkto="faker" )
			, title  = translateResource( "cms:faker" )
			, active = fakerMenuActive
		} );
	}

	WriteOutput( renderView(
		  view = "/admin/layout/sidebar/_menuItem"
		, args = {
			  active       = menuActive
			, icon         = "fa-table"
			, title        = translateResource( 'cms:seeder' )
			, subMenuItems = subMenuItems
		  }
	) );
</cfscript>