import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/PetBloc.dart';
import 'package:pet_adoption_app/pages/HomePage.dart';
import 'package:provider/provider.dart'; // Import your home page here


void main() {
  runApp(
    BlocProvider(
      create: (context) => PetBloc(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Initial page (e.g., the page with the list of pets)
    );
  }
}