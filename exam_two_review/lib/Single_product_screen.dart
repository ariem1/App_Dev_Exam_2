import 'package:flutter/material.dart';
import 'dummy_product.dart';
import 'Product_List_Screen.dart';

class SingleProductScreen extends StatelessWidget {
  const SingleProductScreen({super.key});

  @override
  Widget build(BuildContext context) {

    //ModalRoute is the class used to capture the named
    //arguments from the calling class

   final productID=ModalRoute.of(context)?.settings.arguments;

   //find the product that matches the id passed from the productListScreen
  final product= dummyProducts.firstWhere((e)=>e["id"]==productID);
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text("Name of the product: ${product["name"]}",
            style: TextStyle(fontSize: 30,color: Colors.green)),

            Text("Price of the product: ${product["price"]}",
                style: TextStyle(fontSize: 30,color: Colors.red)),

            Text("Description of the product: ${product["Description"]}"),
          ],
        ),
      ),
    );
  }
}
