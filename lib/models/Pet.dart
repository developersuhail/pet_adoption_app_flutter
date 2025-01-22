class Pet {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final double price;
  bool isAdopted;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.price,
    this.isAdopted = false,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      isAdopted: json['isAdopted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'imageUrl': imageUrl,
      'price': price,
      'isAdopted': isAdopted,
    };
  }
}
