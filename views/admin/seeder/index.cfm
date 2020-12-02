<cfscript>
	actionUrl = prc.actionUrl  ?: "";
</cfscript>

<cfoutput>
	<form id="seeder-form" class="form-horizontal" action="#actionUrl#" method="POST">
		#renderForm(
			  formName         = "seeder.admin.generate"
			, formId           = "seeder-form"
			, validationResult = rc.validationResult ?: ""
		)#

		<div class="form-actions row">
			<div class="col-md-offset-2">
				<button type="submit" class="btn btn-info" tabindex="#getNextTabIndex()#">
					#translateResource( uri="seeder.seederForm:generate.btn" )# <i class="fa fa-fw fa-random bigger-110"></i>
				</button>
			</div>
		</div>
	</form>
</cfoutput>