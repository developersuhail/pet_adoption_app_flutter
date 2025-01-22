import 'package:pet_adoption_app/bloc/PetBloc.dart';
import 'package:pet_adoption_app/models/Pet.dart';

class AdoptPet extends PetEvent {
  final Pet pet;

  AdoptPet({required this.pet});
}
