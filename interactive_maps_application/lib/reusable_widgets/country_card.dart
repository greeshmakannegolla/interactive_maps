import 'package:flutter/material.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/style_constants.dart';
import 'package:interactive_maps_application/models/country_data_model.dart';

class CountryCard extends StatefulWidget {
  final CountryDataModel countryDetail;
  const CountryCard(this.countryDetail, {Key? key}) : super(key: key);

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: ColorConstants.kSecondaryTextColor.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.countryDetail.name,
              style: kSubHeader,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Capital city: ' + widget.countryDetail.capital.join(', '),
              style: kData,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Population: ' + widget.countryDetail.population.toString(),
              style: kData,
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Borders: ' + widget.countryDetail.borders.join(', '),
                style: kData),
          ],
        ),
      ),
    );
  }
}
