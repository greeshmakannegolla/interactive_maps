import 'package:flutter/material.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';

class SelectedCountryProvider with ChangeNotifier {
  CountryDataModel _selectedCountry = CountryDataModel();

  getSelectedCountry() => _selectedCountry;

  setSelectedCountry(CountryDataModel country) {
    _selectedCountry = country;
    notifyListeners();
  }
}
