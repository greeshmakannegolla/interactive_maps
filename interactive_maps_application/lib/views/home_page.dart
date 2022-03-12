import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/controller_provider.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';
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
      _countryList = await getCountryList();
      _createMarkers();
    } catch (e) {
      //TODO: Show something went wrong popup
      //TODO: Check internet
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
            GlobalKey toolTipKey = GlobalKey();
//TODO: complete all details
            String getCountryDetails() {
              var msg = 'Name : ' +
                  country.name +
                  '\n' +
                  'Capital : ' +
                  country.capital.join(', ') +
                  '\n' +
                  'Population : ' +
                  country.population.toString();
              return msg;
            }

            return InkWell(
              onTap: () {
                final dynamic _toolTip = toolTipKey.currentState;
                _toolTip.ensureTooltipVisible();
              },
              child: Tooltip(
                key: toolTipKey,
                message: getCountryDetails(),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 50,
                  color: ColorConstants.kMarkerColor,
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
      return Future.error('Location services are disabled.'); //TODO:alert
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
        return Future.error('Location permissions are denied'); //TODO:alert
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'); //TODO:alert
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
              message: 'Current Location',
              key: toolTipKey,
              child: const Icon(
                Icons.location_on_rounded,
                size: 50,
                color: Colors.green,
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
