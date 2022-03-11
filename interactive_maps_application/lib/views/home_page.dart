import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';
import 'package:interactive_maps_application/services/api_calls.dart';
import 'package:interactive_maps_application/views/slide_up_panel.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  final latitude;
  final longitude;

  const HomePage({Key? key, this.latitude, this.longitude}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController _panelController = PanelController();

  MapController _mapController = MapController();

  final List<Marker> _countryMarkerList = [];

  bool _isLoading = true;

  CountryDataListModel _countryList = CountryDataListModel();

  final _myLocation = LatLng(11.059821, 78.387451); //TODO: Get current location

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCountryList();

    // Future.delayed(const Duration(seconds: 5), () {
    //   _mapController.move(LatLng(17.123184, 79.208824), 10);
    // });
  }

  _fetchCountryList() async {
    try {
      _countryList = await getCountryList();
      _createMarkers();
    } catch (e) {
      //TODO: Show something went wrong popup
      //TODO: Check internet
    } finally {
      _isLoading = false;
      setState(() {});
    }
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
                controller: _panelController,
                maxHeight: _panelHeightOpen,
                minHeight: _panelHeightClosed,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                onPanelSlide: (double pos) => setState(() {}),
                panelBuilder: (scrollController) => PanelWidget(
                    scrollController, _panelController, _countryList),
                body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: _map()),
              ),
      ),
    );
  }

  Widget _map() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(zoom: 5, center: _myLocation),
      nonRotatedLayers: [
        TileLayerOptions(urlTemplate: kUrlTemplate, additionalOptions: {
          'accessToken': kMapboxToken,
          'id': kMapboxStyle,
        }),
        MarkerLayerOptions(markers: _countryMarkerList)
      ],
    );
  }

  void _createMarkers() {
    for (var country in _countryList.countries) {
      var marker = Marker(
          point: LatLng(country.latLng[0], country.latLng[1]),
          builder: (_) {
            return const Icon(
              Icons.location_on_rounded,
              size: 40,
              color: ColorConstants.kMarkerColor,
            );
          });
      _countryMarkerList.add(marker);
    }
    var currentLocationMarker = Marker(
        point: _myLocation,
        builder: (_) {
          return const Icon(
            Icons.location_on_rounded,
            size: 40,
            color: Colors.green,
          );
        });
    _countryMarkerList.add(currentLocationMarker);
  }
}
