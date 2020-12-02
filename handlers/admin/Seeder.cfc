component extends="preside.system.base.AdminHandler" {
	property name="seederService" inject="seederService";

	public void function preHandler( event, action, eventArguments ) {
		super.preHandler( argumentCollection=arguments );

		if ( !isFeatureEnabled( "seeder" ) ) {
			event.notFound();
		}
	}

	public void function index( event, rc, prc, args={} ) {
		prc.pageIcon     = "database";
		prc.pageTitle    = translateResource( "cms:seeder" );
		prc.pageSubtitle = translateResource( "cms:seeder.subtitle" );
		prc.actionUrl    = event.buildAdminLink( linkto="Seeder.seedingAction" );
	}

	public void function seedingAction( event, rc, prc, args={} ) {
		var formData         = event.getCollectionWithoutSystemVars();
		var validationResult = validateForms();

		if ( !validationResult.validated() ) {
			var persist              = formData;
			persist.validationResult = validationResult;

			messageBox.error( translateResource( uri="seeder.general:seeding.error.message" ) );
			setNextEvent( url=event.buildAdminLink( linkto="seeder" ), persistStruct=persist );
		}

		var taskId = seederService.seedingObject( objectName=formData.object, integration=formData.integration );
		setNextEvent( url=event.buildAdminLink(
			  linkTo      = "adhoctaskmanager.progress"
			, queryString = "taskId=" & taskId
		) );
	}

	private void function runSeedingInBackgroundThread( event, rc, prc, args={}, logger, progress ) {
		seederService.seedingObjectProcess(
			  argumentCollection = args
			, logger             = logger   ?: NullValue()
			, progress           = progress ?: NullValue()
		);
	}
}