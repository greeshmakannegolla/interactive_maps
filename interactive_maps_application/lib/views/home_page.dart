import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';
import 'package:interactive_maps_application/reusable_widgets/country_card.dart';
import 'package:interactive_maps_application/services/api_calls.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PanelController panelController = PanelController();

  CountryDataListModel _countryList = CountryDataListModel();

  bool _isLoading = true;

  final _myLocation = LatLng(17.123184, 79.208824);

  @override
  void initState() {
    super.initState();
    _fetchCountryList();
  }

  _fetchCountryList() async {
    try {
      _countryList = await getCountryList();
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
        body: SlidingUpPanel(
          controller: panelController,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          onPanelSlide: (double pos) => setState(() {}),
          panelBuilder: (controller) => _panel(controller, panelController),
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: _map()),
        ),
      ),
    );
  }

  Widget _panel(
      ScrollController scrollController, PanelController panelController) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            _buildDragHandle(),
            const SizedBox(
              height: 8,
            ),
            IntrinsicHeight(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
              child: TextField(
                  controller: _searchController,
                  cursorColor: ColorConstants.kSecondaryTextColor,
                  onChanged: (newText) {
                    //TODO: Implement search
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.black.withOpacity(0.05),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: ColorConstants.kSecondaryTextColor,
                      ),
                      hintText: kSearch,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.zero)),
            )),
            _isLoading
                ? SpinKitDoubleBounce(
                    color: ColorConstants.kMarkerColor.withOpacity(0.5),
                    size: 40,
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _countryList.countries.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 8),
                          child: CountryCard(_countryList.countries[index]),
                        );
                      },
                    ),
                  ),
          ],
        ));
  }

  Widget _map() {
    return FlutterMap(
      options:
          MapOptions(minZoom: 5, maxZoom: 16, zoom: 13, center: _myLocation),
      nonRotatedLayers: [
        TileLayerOptions(urlTemplate: kUrlTemplate, additionalOptions: {
          'accessToken': kMapboxToken,
          'id': kMapboxStyle,
        }),
        MarkerLayerOptions(markers: [
          Marker(
              point: _myLocation,
              builder: (_) {
                return const Icon(
                  Icons.location_on_rounded,
                  size: 40,
                  color: ColorConstants.kMarkerColor,
                );
              })
        ])
      ],
    );
  }

  Widget _buildDragHandle() {
    return InkWell(
      onTap: togglePanel, //TODO: Check why not working
      child: Center(
        child: Container(
          width: 30,
          height: 6,
          decoration: BoxDecoration(
              color: ColorConstants.kSecondaryTextColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void togglePanel() {
    panelController.isPanelOpen
        ? panelController.close()
        : panelController.open();
  }
}
