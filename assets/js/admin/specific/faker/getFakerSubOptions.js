( function( $ ){
	var getSubOptionUrl = cfrequest.getSubOptionUrl
	  , fakerFieldset   = $( "#faker-fields" )
	  , optionClass     = ".faker-option"
	  , subOptionClass  = ".faker-sub-option"
	  , updateSubOptionField, enableSubOptionField;

	enableSubOptionField = function( indexNo ) {
		fakerFieldset.find( "#faker-group-" + indexNo ).find( subOptionClass ).prop( 'disabled', false );
	};

	fakerFieldset.on( "change", optionClass, function(event) {
		var selected      = $(this).find(':selected').val();
		var thisFormGroup = $(this).closest( ".form-group" );
		var clickedIndex  = thisFormGroup.data( "index" );

		if ( selected !== null ) {
			$.ajax({
				  url  : getSubOptionUrl
				, data : { option: selected }
			})
			.done(function(output) {
				if ( output !== "" ) {
					var thisSubOptionField = thisFormGroup.find( subOptionClass );
					thisSubOptionField.html( output );

					enableSubOptionField( clickedIndex );
				}
			});

		}
	} );
} )( presideJQuery );