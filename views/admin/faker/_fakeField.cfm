<cfscript>
	index        = args.index       ?: 1;
	fakerOptions = prc.fakerOptions ?: ( args.fakerOptions ?: [] );

	curFieldHasError = false;
	curFieldErrorMsg = "";
	validationResult = rc.validationResult ?: "";
	if ( !isEmpty( validationResult ) ) {
		curFieldHasError = validationResult.fieldHasError( fieldName="field-#index#" );
		curFieldErrorMsg = validationResult.getError(      fieldName="field-#index#" );
	}
</cfscript>

<cfoutput>
	<div class="form-group <cfif isTrue( curFieldHasError )>has-error</cfif>" id="faker-group-#index#" data-index="#index#">
		<label class="col-sm-1 control-label no-padding-right" for="faker-field-#index#">
			#translateResource( uri="faker.fakeForm:field.label", data=[ index ] )#
		</label>

		<div class="col-sm-10">
			<div class="clearfix">
				<table width="100%">
					<tr>
						<td class="field-name-column" width="30%">
							<label class="control-label" for="field-#index#-name">#translateResource( uri="faker.fakeForm:field.fieldName.label" )#</label>
							<input class="form-control"
								   type="text"
								   name="field-#index#-name"
								   id="field-#index#-name"
								   value="#rc[ "field-#index#-name" ] ?: ""#"
							/>
						</td>
						<td>
							<div class="row">
								<div class="col-md-6 no-padding-right">
									<label class="control-label" for="field-#index#-option">
										#translateResource( uri="faker.fakeForm:field.fakerOptions.label" )#
									</label>
									<select name="field-#index#-option" id="field-#index#-option" class="form-control faker-option">
										<option disabled selected>Select your option</option>
										#renderView( view="/admin/faker/_fakerOptions", args={ options=fakerOptions } )#
									</select>
								</div>

								<div class="col-md-6 no-padding-right">
									<label class="control-label" for="field-#index#-suboption">
										#translateResource( uri="faker.fakeForm:field.fakerSubOptions.label" )#
									</label>
									<select name="field-#index#-suboption" id="field-#index#-suboption" class="form-control faker-sub-option" disabled>
										<option disabled selected>Select your option</option>
									</select>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>

			<cfif isTrue( curFieldHasError ) and !isEmptyString( curFieldErrorMsg )>
				<div class="help-block error">
					#translateResource( uri=curFieldErrorMsg, defaultValue=curFieldErrorMsg )#
				</div>
			</cfif>
		</div>

		<div class="col-sm-1 field-actions" id="field-actions-#index#">
			<a href="##" id="plus-field-#index#" class="plus-link">
				<i class="fa fa-lg fa-plus green"></i>
			</a>

			<cfif index gt 1>
				<a href="##" id="minus-field-#index#" class="minus-link">
					<i class="fa fa-lg fa-minus red"></i>
				</a>
			</cfif>
		</div>
	</div>
</cfoutput>