import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/views/slide_up_panel.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController _panelController = PanelController();

  final _myLocation = LatLng(17.123184, 79.208824); //TODO: Get current location

  @override
  Widget build(BuildContext context) {
    double _panelHeightClosed = MediaQuery.of(context).size.height * 0.18;
    double _panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.kAppBackgroundColor,
        body: SlidingUpPanel(
          controller: _panelController,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          onPanelSlide: (double pos) => setState(() {}),
          panelBuilder: (scrollController) =>
              PanelWidget(scrollController, _panelController),
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
}
