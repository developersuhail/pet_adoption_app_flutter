import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pet_adoption_app/models/Pet.dart';

class ImageViewerPage extends StatelessWidget {
  final Pet pet;

  ImageViewerPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('View ${pet.name}'),
      ),
      body: Center(
        child: Hero(
          tag: pet.id, // Matches the tag from DetailsPage
          child: PhotoView(
            imageProvider: NetworkImage(pet.imageUrl),
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
