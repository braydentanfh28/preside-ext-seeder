( function( $ ){
	var newFieldUrl   = cfrequest.newFormFieldUrl
	  , plusLink      = cfrequest.plusLink     || ".plus-link"
	  , minusLink     = cfrequest.minusLink    || ".minus-link"
	  , fieldActions  = cfrequest.fieldActions || "field-actions"
	  , fakerFieldset = $( "#faker-fields" )
	  , totalField    = $( "input[name='total_field']" )
	  , loadNewField, showActionButton, updateToTalField;

	loadNewField = function( indexNo ) {
		$.ajax({
			  url: newFieldUrl
			, data: { index: indexNo }
		})
		.done(function(output) {
			fakerFieldset.append( output );
		});
	};

	showActionButton = function( indexNo ) {
		$( "#" + fieldActions + "-" + indexNo ).show();
	};

	updateToTalField = function( totalAmt ) {
		totalField.val( totalAmt );
	}

	fakerFieldset.on( "click", plusLink, function(event) {
		event.preventDefault();

		var nextIndex = $(this).closest( ".form-group" ).data( "index" ) + 1;
		loadNewField( nextIndex );
		updateToTalField( nextIndex );

		$(this).closest( "." + fieldActions  ).hide();
	} );

	fakerFieldset.on( "click", minusLink, function(event) {
		event.preventDefault();

		var thisFormGroup = $(this).closest( ".form-group" );
		var preIndex      = thisFormGroup.data( "index" ) - 1;

		showActionButton( preIndex );
		updateToTalField( preIndex );
		thisFormGroup.remove();
	} );
} )( presideJQuery );