component {
	property name="seederService" inject="seederService";

	public string function index( event, rc, prc, args={} ) {
		args.items = seederService.getSeederEnabledObjs();
		if ( !args.items.len() ) {
			return "";
		}

		return renderView( view="formcontrols/enumRadioList/index", args=args );
	}
}