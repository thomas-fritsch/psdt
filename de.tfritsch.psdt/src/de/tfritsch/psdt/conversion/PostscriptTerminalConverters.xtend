package de.tfritsch.psdt.conversion

// import org.eclipse.xtext.conversion.IValueConverter
// import org.eclipse.xtext.conversion.ValueConverter
// import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService

// Do not extend from DefaultTerminalConverters, because we don't want its ValueConverters
@Singleton
class PostscriptTerminalConverters extends AbstractDeclarativeValueConverterService {
	// @Inject
	// STRINGValueConverter stringValueConverter
	//
	// @ValueConverter(rule = "STRING")
	// def IValueConverter<String> getStringValueConverter() {
	//     stringValueConverter
	// }
	//
	// @Inject
	// AbstractIDValueConverter idValueConverter;
	//
	// @ValueConverter(rule = "ID")
	// def IValueConverter<String> getIdValueConverter() {
	//     idValueConverter
	// }
}