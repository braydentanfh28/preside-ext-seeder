<cfscript>
	actionUrl  = prc.actionUrl  ?: "";
	totalField = rc.total_field ?: "1";

	event.include( "/css/admin/specific/faker/" )
		 .include( "/js/admin/specific/faker/"  );
</cfscript>

<cfoutput>
	<form id="faker-form" class="form-horizontal" action="#actionUrl#" method="POST">
		<input type="hidden" name="total_field" value="#totalField#" />

		<fieldset id="settings">
			<h3 class="header smaller lighter green">
				#translateResource( uri="faker.fakeForm:fieldset.settings.title" )#
			</h3>

			#renderFormControl(
				  name         = "integration"
				, type         = "spinner"
				, context      = "admin"
				, label        = translateResource( uri="faker.fakeForm:field.integration.title" )
				, defaultValue = rc.integration ?: "100"
				, help         = translateResource( uri="faker.fakeForm:field.integration.help" )
				, required     = true
			)#
		</fieldset>

		<fieldset id="faker-fields">
			<h3 class="header smaller lighter green">
				#translateResource( uri="faker.fakeForm:fieldset.fields.title" )#
			</h3>

			<cfloop index="i" from="1" to="#val( totalField )#">
				<cfset args.index = i />
				#renderView( view="/admin/faker/_fakeField", args=args )#
			</cfloop>
		</fieldset>

		<div class="form-actions row">
			<div class="col-md-offset-2">
				<button type="submit" class="btn btn-info" tabindex="#getNextTabIndex()#">
					#translateResource( uri="faker.fakeForm:generate.btn" )# <i class="fa fa-fw fa-random bigger-110"></i>
				</button>
			</div>
		</div>
	</form>
</cfoutput>