import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/PetBloc.dart';
import 'package:pet_adoption_app/utils/AppSharedPrefrences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// HistoryPage StatefulWidget to fetch and display adoption history
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  void initState() {
    super.initState();

  }

  static Future<List<String>> getAdoptedList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? adoptedPetNames = prefs.getStringList('adopted_pets');

    if (adoptedPetNames == null || adoptedPetNames.isEmpty) {
      return [];
    }

    return adoptedPetNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adopted Pets"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<String>>(
        future: getAdoptedList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading adoption history.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pets adopted yet.'));
          }

          final adoptedPets = snapshot.data!;

          return ListView.builder(
            itemCount: adoptedPets.length,
            itemBuilder: (context, index) {
              final pet = adoptedPets[index];
              return ListTile(
                title: Text(pet),
                subtitle: Text("Adopted on ${pet.toString()}"),
              );
            },
          );
        },
      ),
    );
  }
}