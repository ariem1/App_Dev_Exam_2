import 'package:flutter/material.dart';
import 'dummy_product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  //write a function to be triggered
  // by an user when tap a product

  void goToSingleProduct(context, productID){
    Navigator.of(context).pushNamed("single-product", arguments: productID);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List Screen"),
      ),
      body: ListView(
        children: dummyProducts.map((singleProduct){
          return Card(
            child: ListTile(
              onTap: ()=>goToSingleProduct(context,singleProduct["id"]),
              title: Text(singleProduct["name"]),
            ),
          );
        }).toList(),

      ),

    );
  }
}


