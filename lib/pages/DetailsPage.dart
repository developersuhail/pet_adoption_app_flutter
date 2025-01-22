import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/models/Pet.dart';
import 'package:pet_adoption_app/pages/ImageViewerPage.dart';
import 'package:confetti/confetti.dart';
import 'package:pet_adoption_app/utils/AppSharedPrefrences.dart';

import '../bloc/PetBloc.dart';

class DetailsPage extends StatefulWidget {
  final Pet pet;

  DetailsPage({required this.pet});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _adoptPet(BuildContext context, Pet pet) {
    if (pet.isAdopted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${pet.name} is already adopted.")),
      );
      return;
    }


    // Display animation adoption popup
    _confettiController.play();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adopted!"),
          content: Text("You’ve adopted ${pet.name}."),
          actions: [
            TextButton(

              onPressed: () async {
                setState(() {
                  pet.isAdopted = true; // Mark the pet as adopted
                });

                // Save the updated adoption history
                AdoptedPet newPet = AdoptedPet(
                    name: pet.name,
                    adoptedDate: DateTime.now());
                await AppSharedPrefrences.saveAdoptedList(newPet);

                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(widget.pet.name)
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ImageViewerPage(pet : widget.pet)),
                  );
                },
                child: Hero(
                  tag: widget.pet.id,
                  child: CachedNetworkImage(
                    imageUrl: widget.pet.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Text("Name: ${widget.pet.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0,),

              Text("Age: ${widget.pet.age} years", style: TextStyle(fontSize: 16)),
              Text("Price: \$${widget.pet.price}", style: TextStyle(fontSize: 16)),
              ElevatedButton(
                onPressed: widget.pet.isAdopted
                    ? null // Disable button if already adopted
                    : () => _adoptPet(context, widget.pet),
                child: Text(widget.pet.isAdopted ? "Already Adopted" : "Adopt Me"),
              ),
            ],
          ),
          // Confetti animation overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow],
            ),
          ),
        ],
      ),
    );
  }
}
