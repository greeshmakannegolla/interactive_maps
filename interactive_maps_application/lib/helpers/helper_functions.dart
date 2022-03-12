import 'package:flutter/material.dart';
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

showAlertDialog(BuildContext context, String title, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
