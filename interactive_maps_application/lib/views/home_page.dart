import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/providers/controller_provider.dart';
import 'package:interactive_maps_application/helpers/helper_functions.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';
import 'package:interactive_maps_application/providers/selected_country_provider.dart';
import 'package:interactive_maps_application/services/api_calls.dart';
import 'package:interactive_maps_application/views/slide_up_panel.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Marker> _countryMarkerList = [];

  bool _isCountriesLoading = true;
  bool _isLocationLoading = true;
  bool _isLoading = true;

  //default coordinates
  double _currentLatitude = 47.6964719;
  double _currentLongitude = 13.3457347;

  CountryDataListModel _countryList = CountryDataListModel();

  @override
  void initState() {
    super.initState();
    _fetchCountryList();
    _determinePosition();
  }

  _setLoadedData() {
    if (!_isCountriesLoading && !_isLocationLoading) {
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  _fetchCountryList() async {
    try {
      //Can check for internet connectivity before the actual fetch
      _countryList = await getCountryList();
      _createMarkers();
    } catch (e) {
      //Can log error
      showAlertDialog(context, 'Oops!', 'Something went wrong');
    } finally {
      _isCountriesLoading = false;
      _setLoadedData();
    }
  }

  void _createMarkers() {
    for (var country in _countryList.countries) {
      var marker = Marker(
          point: LatLng(country.latLng[0], country.latLng[1]),
          builder: (_) {
            String getCountryDetails() {
              String message = 'Name : ' +
                  country.name +
                  '\n' +
                  'Capital : ' +
                  country.capital.join(', ') +
                  '\n' +
                  'Population : ' +
                  country.population.toString() +
                  '\nBorders: ' +
                  country.borders.join(', ');
              return message;
            }

            Color getMarkerColor() {
              if (country.name ==
                  context
                      .watch<SelectedCountryProvider>()
                      .getSelectedCountry()
                      .name) {
                return ColorConstants.kTextPrimaryColor;
              }
              return ColorConstants.kMarkerColor;
            }

            return Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              enableFeedback: true,
              message: getCountryDetails(),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.location_on_rounded,
                  size: 50,
                  color: getMarkerColor(),
                ),
              ),
            );
          });
      _countryMarkerList.add(marker);
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showAlertDialog(context, 'Note',
          'Location services are disabled. Please turn on location.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        showAlertDialog(context, 'Note',
            "Location permissions are denied. You can enable them through phone 'Settings'.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showAlertDialog(context, 'Note',
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();

    _currentLatitude = position.latitude;
    _currentLongitude = position.longitude;

    var currentLocationMarker = Marker(
        point: LatLng(position.latitude, position.longitude),
        builder: (_) {
          GlobalKey toolTipKey = GlobalKey();
          return InkWell(
            onTap: () {
              final dynamic _toolTip = toolTipKey.currentState;
              _toolTip.ensureTooltipVisible();
            },
            child: Tooltip(
              message: kCurrentMarkerText,
              key: toolTipKey,
              child: const Icon(
                Icons.person,
                size: 40,
                color: ColorConstants.kCurrentMarkerColor,
              ),
            ),
          );
        });

    _countryMarkerList.add(currentLocationMarker);

    _isLocationLoading = false;
    _setLoadedData();
  }

  @override
  Widget build(BuildContext context) {
    double _panelHeightClosed = MediaQuery.of(context).size.height * 0.18;
    double _panelHeightOpen = MediaQuery.of(context).size.height * 0.8;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.kAppBackgroundColor,
        body: _isLoading
            ? SpinKitDoubleBounce(
                color: ColorConstants.kMarkerColor.withOpacity(0.5),
                size: 40,
              )
            : SlidingUpPanel(
                controller: context.read<ControllerProvider>().panelController,
                maxHeight: _panelHeightOpen,
                minHeight: _panelHeightClosed,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                onPanelSlide: (double pos) => setState(() {}),
                panelBuilder: (scrollController) => PanelWidget(
                  scrollController,
                  _countryList,
                ),
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: _getMap(),
                ),
              ),
      ),
    );
  }

  Widget _getMap() {
    return FlutterMap(
      mapController: context.read<ControllerProvider>().mapController,
      options: MapOptions(
          zoom: 5, center: LatLng(_currentLatitude, _currentLongitude)),
      nonRotatedLayers: [
        TileLayerOptions(urlTemplate: kUrlTemplate, additionalOptions: {
          'accessToken': kMapboxToken,
          'id': kMapboxStyle,
        }),
        MarkerLayerOptions(markers: _countryMarkerList)
      ],
    );
  }
}
