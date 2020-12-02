component extends="coldbox.system.Interceptor" {
	property name="seederService" inject="delayedInjector:seederService";

// PUBLIC API
	public void function configure() {}

	public void function postPresideReload( event, interceptData={} ) {
		seederService.processSeederEnabledObjects();
	}
}