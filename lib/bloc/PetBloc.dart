import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/models/AdoptPet.dart';
import 'package:pet_adoption_app/models/Pet.dart';

import '../utils/AppSharedPrefrences.dart';

// --- Events ---
abstract class PetEvent {}

class FetchPets extends PetEvent {}
class FetchAdoptionHistory extends PetEvent {}

// --- States ---
abstract class PetState {}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<Pet> pets;

  PetLoaded({required this.pets});
}

class PetError extends PetState {}

class PetHistoryLoaded extends PetState {
  final List<AdoptedPet> adoptedPets;

  PetHistoryLoaded({required this.adoptedPets});
}

// --- Models ---
class AdoptedPet {
  final String name;
  final DateTime adoptedDate;

  AdoptedPet({required this.name, required this.adoptedDate});
}

// --- Bloc ---
class PetBloc extends Bloc<PetEvent, PetState> {
  PetBloc() : super(PetInitial());


  final List<AdoptedPet> _adoptedPets = []; // List to track adopted pets

  @override
  Stream<PetState> mapEventToState(PetEvent event) async* {
    if (event is FetchPets) {
      yield PetLoading();
      try {
        final pets = await fetchPets();
        yield PetLoaded(pets: pets);
      } catch (_) {
        yield PetError();
      }
    } else if (event is FetchAdoptionHistory) {
      yield PetLoading();
      try {
        // Fetch adoption history
        final adoptionHistory = await AppSharedPrefrences.getAdoptedPets();
        yield PetHistoryLoaded(adoptedPets: adoptionHistory);
      } catch (_) {
        yield PetError();
      }
    } else if (event is AdoptPet) {
      yield PetLoading();
      try {
        event.pet.isAdopted = true; // Mark the pet as adopted
        final adoptedPet = AdoptedPet(
          name: event.pet.name,
          adoptedDate: DateTime.now(), // Set the adoption date
        );
        _adoptedPets.add(adoptedPet); // Add to adoption history

        // Save the updated adoption history
        await AppSharedPrefrences.saveAdoptedPets(_adoptedPets);

        yield PetLoaded(pets: await fetchPets()); // Re-fetch the updated pets list
      } catch (_) {
        yield PetError();
      }
    }
  }



  Future<List<Pet>> fetchPets() async {
    // Simulate fetching pets from API or database
    await Future.delayed(Duration(seconds: 1));
    return [
      Pet(
        id: '1',
        name: 'Bella',
        imageUrl: 'https://link.to/bella-image.jpg',
        age: 3,
        price: 150.0,
        isAdopted: _adoptedPets.any((pet) => pet.name == 'Bella'),
      ),
      Pet(
        id: '2',
        name: 'Max',
        imageUrl: 'https://link.to/max-image.jpg',
        age: 4,
        price: 200.0,
        isAdopted: _adoptedPets.any((pet) => pet.name == 'Max'),
      ),
      Pet(
        id: '3',
        name: 'Charlie',
        imageUrl: 'https://link.to/charlie-image.jpg',
        age: 2,
        price: 100.0,
        isAdopted: _adoptedPets.any((pet) => pet.name == 'Charlie'),
      ),
    ];
  }


  Future<List<AdoptedPet>> fetchAdoptionHistory() async {
    // database
    await Future.delayed(Duration(seconds: 1));
    return [
      AdoptedPet(name: 'Bella', adoptedDate: DateTime(2022, 8, 20)),
      AdoptedPet(name: 'Max', adoptedDate: DateTime(2023, 1, 15)),
    ];
  }
}
