import 'package:flutter/material.dart';
import 'package:interactive_maps_application/providers/controller_provider.dart';
import 'package:interactive_maps_application/views/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
          providers: [Provider.value(value: ControllerProvider())],
          child: const HomePage())));
}
