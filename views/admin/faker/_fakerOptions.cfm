<cfscript>
	options = args.options ?: [];
</cfscript>

<cfoutput>
	<cfif !isEmpty( options )>
		<cfloop array="#options#" item="option">
			<cfif !isEmptyString( option.id ?: "" )>
				<option value="#option.id#">
					#!isEmptyString( option.label ?: "" ) ? option.label : option.id#
				</option>
			</cfif>
		</cfloop>
	</cfif>
</cfoutput>