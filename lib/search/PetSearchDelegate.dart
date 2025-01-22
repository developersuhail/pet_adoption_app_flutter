import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/Pet.dart';
import 'package:pet_adoption_app/pages/DetailsPage.dart';

class PetSearchDelegate extends SearchDelegate {
  final List<Pet> pets;

  PetSearchDelegate({required this.pets});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = pets.where((pet) => pet.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final pet = results[index];
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = pets.where((pet) => pet.name.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final pet = suggestions[index];
        return ListTile(
          title: Text(pet.name),
          onTap: () {
            query = pet.name;
            showResults(context);
          },
        );
      },
    );
  }
}
