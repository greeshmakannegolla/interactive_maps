import 'package:flutter/material.dart';
import 'package:interactive_maps_application/providers/controller_provider.dart';
import 'package:interactive_maps_application/helpers/helper_functions.dart';
import 'package:interactive_maps_application/helpers/string_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';
import 'package:interactive_maps_application/views/reusable_widgets/country_card.dart';
import 'package:provider/provider.dart';
import '../helpers/color_constants.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController scrollController;
  final CountryDataListModel countryList;

  const PanelWidget(this.scrollController, this.countryList, {Key? key})
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
    return Column(
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
              onTap: () {
                context.read<ControllerProvider>().panelController.open();
              },
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
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: CountryCard(_filteredCountryList[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 30,
        height: 6,
        decoration: BoxDecoration(
            color: ColorConstants.kSecondaryTextColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
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
