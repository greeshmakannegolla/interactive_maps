import 'package:flutter/material.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/providers/controller_provider.dart';
import 'package:interactive_maps_application/helpers/style_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';
import 'package:interactive_maps_application/providers/selected_country_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CountryCard extends StatelessWidget {
  final CountryDataModel countryDetail;
  const CountryCard(this.countryDetail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ControllerProvider>().panelController.close();
        FocusScope.of(context).unfocus();
        context
            .read<ControllerProvider>()
            .mapController
            .move(LatLng(countryDetail.latLng[0], countryDetail.latLng[1]), 4);
        context
            .read<SelectedCountryProvider>()
            .setSelectedCountry(countryDetail);
      },
      child: Card(
        elevation: 0,
        color: ColorConstants.kSecondaryTextColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                countryDetail.name.replaceAll(RegExp('[^A-Za-z0-9]'), ' '),
                style: kSubHeader,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Capital city: ' + countryDetail.capital.join(', '),
                style: kData,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Population: ' + countryDetail.population.toString(),
                style: kData,
              ),
              countryDetail.borders.isEmpty
                  ? Container()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Borders: ' + countryDetail.borders.join(', '),
                            style: kData),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
