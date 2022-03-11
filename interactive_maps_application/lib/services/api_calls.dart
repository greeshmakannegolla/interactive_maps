import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interactive_maps_application/models/country_data_model.dart';

Future<CountryDataListModel> getCountryList() async {
  String url =
      'https://restcountries.com/v3.1/all?fields=name,capital,population,borders,flags,latlng';
  final response =
      await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    var jsonDecoded = jsonDecode(response.body);
    CountryDataListModel countryDataListModel =
        CountryDataListModel.fromJSONList(jsonDecoded);
    return countryDataListModel;
  } else {
    //Can log the error here
    throw Exception('Failed to load post');
  }
}
