import 'package:flutter/material.dart';

class CountryCard extends StatefulWidget {
  const CountryCard({Key? key}) : super(key: key);

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          //TODO: Get from API
          const Text(
            "India",
          ),
          const Text('Capital city: '),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Language: '),
              Text('Currency: '),
            ],
          ),
        ],
      ),
    );
  }
}
