import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/PetBloc.dart';
import 'package:pet_adoption_app/models/Pet.dart';
import 'package:pet_adoption_app/pages/DetailsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'package:flutter/material.dart';
import 'package:pet_adoption_app/pages/HistoryPage.dart';
import 'package:pet_adoption_app/search/PetSearchDelegate.dart';

class HomePage extends StatelessWidget {
  final List<Pet> pets = [
    Pet(id: '1', name: 'Bella', age: 2, imageUrl: 'https://via.placeholder.com/150', price: 100.0),
    Pet(id: '2', name: 'Max', age: 3, imageUrl: 'https://via.placeholder.com/150', price: 120.0),
    Pet(id: '3', name: 'Charlie', age: 1, imageUrl: 'https://via.placeholder.com/150', price: 150.0),
    Pet(id: '4', name: 'Lucy', age: 4, imageUrl: 'https://via.placeholder.com/150', price: 90.0),
    Pet(id: '5', name: 'Luna', age: 5, imageUrl: 'https://via.placeholder.com/150', price: 130.0),
    Pet(id: '6', name: 'Buddy', age: 6, imageUrl: 'https://via.placeholder.com/150', price: 80.0),
    Pet(id: '7', name: 'Daisy', age: 2, imageUrl: 'https://via.placeholder.com/150', price: 95.0),
    Pet(id: '8', name: 'Rocky', age: 3, imageUrl: 'https://via.placeholder.com/150', price: 110.0),
    // Add more pets as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Pet Adoption"),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<PetBloc>(context),
                        child: HistoryPage(),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: PetSearchDelegate(pets: pets),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return ListTile(
            leading: Hero(
              tag: pet.id,
              child: CachedNetworkImage(
                imageUrl: pet.imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            title: Text(pet.name),
            subtitle: Text('Age: ${pet.age}, Price: \$${pet.price}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsPage(pet: pet),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
