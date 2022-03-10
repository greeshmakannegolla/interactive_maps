import 'package:flutter/material.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/reusable_widgets/country_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 95.0;

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
                  const SizedBox(height: 200),
                ],
              ),
            ), //TODO: Mapbox needs to be implemented here
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
}
