class CountryDataModel {
  String name = '';
  int population = 0;
  List capital = [];
  List borders = [];
  String flagPath = '';
  List latLng = [47.6964719, 13.3457347];

  CountryDataModel.fromJSON(Map<String, dynamic> json) {
    name = json["name"]['common'] ?? '';
    population = json['population'] ?? 0;
    capital = json['capital'] ?? [];
    borders = json['borders'] ?? [];
    flagPath = json['flags']['png'] ?? '';
    latLng = json['latlng'] ?? [];
  }
}

class CountryDataListModel {
  List<CountryDataModel> countries = [];

  CountryDataListModel() {
    countries = [];
  }

  CountryDataListModel.fromJSONList(var jsonList) {
    for (var eachValue in jsonList) {
      CountryDataModel country = CountryDataModel.fromJSON(eachValue);
      countries.add(country);
    }
  }
}
