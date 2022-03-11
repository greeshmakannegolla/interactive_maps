import 'package:flutter/material.dart';
import 'package:interactive_maps_application/helpers/helper_functions.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../helpers/color_constants.dart';
import '../reusable_widgets/country_card.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;
  final CountryDataListModel countryList;

  const PanelWidget(
      this.scrollController, this.panelController, this.countryList,
      {Key? key})
      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  List<CountryDataModel> _filteredCountryList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _filteredCountryList.addAll(widget.countryList.countries);
  }

  @override
  Widget build(BuildContext context) {
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
                  onChanged: (searchText) {
                    onSearch(searchText);
                  },
                  decoration: InputDecoration(
                      fillColor:
                          ColorConstants.kSecondaryTextColor.withOpacity(0.15),
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
            Expanded(
              child: ListView.builder(
                controller: widget.scrollController,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _filteredCountryList.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: CountryCard(_filteredCountryList[index]),
                  );
                },
              ),
            ),
          ],
        ));
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
    widget.panelController.isPanelOpen
        ? widget.panelController.close()
        : widget.panelController.open();
  }

  void onSearch(String searchText) {
    _filteredCountryList.clear();
    _filteredCountryList.addAll(widget.countryList.countries);

    if (_searchController.text.isNotEmpty) {
      _filteredCountryList = searchCountry(searchText, _filteredCountryList);
    }
    setState(() {});
  }
}
