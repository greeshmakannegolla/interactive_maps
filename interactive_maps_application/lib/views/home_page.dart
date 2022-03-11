import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/reusable_widgets/country_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 95.0;

  var MAPBOX_ACCESS_TOKEN =
      'pk.eyJ1IjoiZ3JlZXNobWFrbCIsImEiOiJjbDBqaXg3NDkwY3gwM2Ruc21ucmw5eDNsIn0.yUakmkO38Jo5aYyMVb81gw';
  var MAPBOX_STYLE = 'mapbox.country-boundaries-v1';
  var MARKER_COLOR = Colors.red;

  final _myLocation = LatLng(17.123184, 79.208824);

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstants.kAppBackgroundColor,
          body: SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            onPanelSlide: (double pos) => setState(() {}),
            panelBuilder: (sc) => _panel(sc),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: 80,
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: TextField(
                            controller: _searchController,
                            cursorColor: ColorConstants.kSecondaryTextColor,
                            onChanged: (newText) {
                              // _applyFilters();
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
                                contentPadding: EdgeInsets.zero))),
                    Center(
                      child: SizedBox(height: 500, child: _map()),
                    ) //TODO: Mapbox needs to be implemented here
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: 10, // TODO: Get from API
          itemBuilder: (BuildContext ctx, int index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: CountryCard(),
            );
          },
        ));
  }

  Widget _map() {
    return FlutterMap(
      options:
          MapOptions(minZoom: 5, maxZoom: 16, zoom: 13, center: _myLocation),
      nonRotatedLayers: [
        TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/greeshmakl/cl0m03v7v007v15o8zc9mxxi1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ3JlZXNobWFrbCIsImEiOiJjbDBqaXg3NDkwY3gwM2Ruc21ucmw5eDNsIn0.yUakmkO38Jo5aYyMVb81gw',
            additionalOptions: {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': MAPBOX_STYLE,
            }),
        MarkerLayerOptions(markers: [
          Marker(
              point: _myLocation,
              builder: (_) {
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: MARKER_COLOR,
                    shape: BoxShape.circle,
                  ),
                ); //TODO: Modify to get all markers: create marker list
              })
        ])
      ],
    );
  }
}
