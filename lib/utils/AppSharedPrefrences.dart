import 'package:pet_adoption_app/models/Pet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_adoption_app/bloc/PetBloc.dart';

class AppSharedPrefrences {

  // save list
  static Future<void> saveAdoptedPets(List<AdoptedPet> adoptedPets) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> adoptedPetNames = adoptedPets.map((pet) => pet.name).toList();
    prefs.setStringList('adopted_pets', adoptedPetNames);
  }

  // save one by one
  static Future<void> saveAdoptedList(AdoptedPet adoptedPet) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? adoptedPetNames = prefs.getStringList('adopted_pets') ?? [];
    adoptedPetNames.add(adoptedPet.name);
    await prefs.setStringList('adopted_pets', adoptedPetNames);
  }


// get list
  static Future<List<AdoptedPet>> getAdoptedPets() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? adoptedPetNames = prefs.getStringList('adopted_pets');
    if (adoptedPetNames == null) {
      return [];
    }
    // Create AdoptedPet objects from stored data
    return adoptedPetNames
        .map((name) => AdoptedPet(name: name, adoptedDate: DateTime.now()))
        .toList();
  }


}