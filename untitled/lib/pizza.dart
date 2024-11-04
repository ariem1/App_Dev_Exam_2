class Pizza {
  final int pizzaId;
  final String name;
  final String imageName;
  final String ingredients;
  final Map<String, double> price; // prices for different sizes
  final Map<String, double> extra; // extra charges for different sizes
  final List<String> add; // list of additional items

  Pizza({
    required this.pizzaId,
    required this.name,
    required this.imageName,
    required this.ingredients,
    required this.price,
    required this.extra,
    required this.add,
  });

  // Factory constructor to create a Pizza object from JSON
  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      pizzaId: json['pizza_id'],
      name: json['name'],
      imageName: json['image'],
      ingredients: json['ingredients'],
      price: Map<String, double>.from(json['price']),
      extra: Map<String, double>.from(json['extra']),
      add: List<String>.from(json['add']),
    );
  }
}
