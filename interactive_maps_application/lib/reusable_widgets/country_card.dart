import 'package:flutter/material.dart';
import 'package:interactive_maps_application/helpers/color_constants.dart';
import 'package:interactive_maps_application/helpers/style_constants.dart';

class CountryCard extends StatefulWidget {
  const CountryCard({Key? key}) : super(key: key);

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
            //TODO: Get from API
            const Text(
              "India",
              style: kSubHeader,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Capital city: ',
              style: kData,
            ),
            //TODO: Get from API
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Language: ', style: kData), //TODO: Get from API
                Text('Currency: ', style: kData), //TODO: Get from API
              ],
            ),
          ],
        ),
      ),
    );
  }
}
