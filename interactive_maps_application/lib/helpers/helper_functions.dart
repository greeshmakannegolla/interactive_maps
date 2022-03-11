import 'package:interactive_maps_application/models/country_data_model.dart';

List<CountryDataModel> searchCountry(
    String searchText, List<CountryDataModel> countryList) {
  List<CountryDataModel> result = [];
  searchText = searchText.toLowerCase().replaceAll(' ', '');
  for (var country in countryList) {
    if (country.name
            .toLowerCase()
            .replaceAll(RegExp('[^A-Za-z0-9]'), '')
            .contains(searchText) ||
        country.capital.contains(searchText)) {
      result.add(country);
    }
  }
  return result;
}
