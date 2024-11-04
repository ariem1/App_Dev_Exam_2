import 'package:flutter/material.dart';
import 'pizza.dart';
import 'user.dart';
import 'checkout.dart';

class CustomizationScreen extends StatefulWidget {
  final User user;
  final Pizza pizza;

  const CustomizationScreen({Key? key, required this.user, required this.pizza})
      : super(key: key);

  @override
  _CustomizationScreenState createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  int smallQuantity = 0;
  int mediumQuantity = 0;
  int largeQuantity = 0;

  int ingSmallQuantity = 0;
  int ingMediumQuantity = 0;
  int ingLargeQuantity = 0;

  @override
  Widget build(BuildContext context) {
    double smallPrice = widget.pizza.price['small'] ?? 0.0;
    double mediumPrice = widget.pizza.price['medium'] ?? 0.0;
    double largePrice = widget.pizza.price['large'] ?? 0.0;

    double ingSmallPrice = widget.pizza.extra['small'] ?? 0.0;
    double ingMediumPrice = widget.pizza.extra['medium'] ?? 0.0;
    double ingLargePrice = widget.pizza.extra['large'] ?? 0.0;

    double totalPrice = (smallQuantity * smallPrice) +
        (mediumQuantity * mediumPrice) +
        (largeQuantity * largePrice) +
        (ingSmallQuantity * ingSmallPrice) +
        (ingMediumQuantity * ingMediumPrice) +
        (ingLargeQuantity * ingLargePrice);

    void _goToCheckoutScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CheckoutScreen(user: widget.user, totalPrice: totalPrice),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 219, 204),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 107, 71),
        title: const Text('Pizza Heaven', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white,),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
              print("Sign out");
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(
                context); // This will pop the current screen off the stack
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome, ${widget.user.id}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    widget.pizza.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/${widget.pizza.imageName}.jpg'),
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Text('Image not found');
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('${widget.pizza.ingredients}'),
                  const SizedBox(height: 30),
                  // Price selection
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select Size and Quantity:'),
                          SizedBox(height: 20),
                          arrangeRow('Small', smallPrice, 40, smallQuantity,
                              (newQuantity) {
                            setState(() {
                              smallQuantity = newQuantity;
                            });
                          }),
                          arrangeRow('Medium', mediumPrice, 24, mediumQuantity,
                              (newQuantity) {
                            setState(() {
                              mediumQuantity = newQuantity;
                            });
                          }),
                          arrangeRow('Large', largePrice, 40, largeQuantity,
                              (newQuantity) {
                            setState(() {
                              largeQuantity = newQuantity;
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add extra toppings:'),
                          SizedBox(height: 20),
                          arrangeRow(
                              'Small', ingSmallPrice, 40, ingSmallQuantity,
                              (newQuantity) {
                            setState(() {
                              ingSmallQuantity = newQuantity;
                            });
                          }),
                          arrangeRow(
                              'Medium', ingMediumPrice, 24, ingMediumQuantity,
                              (newQuantity) {
                            setState(() {
                              ingMediumQuantity = newQuantity;
                            });
                          }),
                          arrangeRow(
                              'Large', ingLargePrice, 40, ingLargeQuantity,
                              (newQuantity) {
                            setState(() {
                              ingLargeQuantity = newQuantity;
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 206, 153, 112),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 60,
          color: Color.fromARGB(255, 206, 153, 112),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _goToCheckoutScreen,
                icon: const Icon(Icons.check_outlined),
                label: const Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.brown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row arrangeRow(String size, double price, double sb, int quantity,
      Function(int) changeQuantity) {
    return Row(
      children: [
        SizedBox(width: 10),
        Text(size),
        SizedBox(width: sb),
        ElevatedButton(
          onPressed: () => changeQuantity(quantity + 1),
          child: const Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            shape: CircleBorder(),
          ),
        ),
        Text(
          '\$ $price ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            if (quantity > 0) {
              changeQuantity(quantity - 1);
            }
            ;
          },
          child: const Icon(Icons.remove),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }
}
