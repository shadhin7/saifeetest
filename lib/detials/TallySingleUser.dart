import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.trolley))],
      ),
      body: Column(
        children: [
          Image.asset(
            product['image'],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            product['name'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "AED ${product['price']}",
            style: const TextStyle(fontSize: 20, color: Colors.green),
          ),
          // Text(
          //   "AED ${product['oldPrice']}",
          //   style: const TextStyle(
          //     decoration: TextDecoration.lineThrough,
          //     color: Colors.grey,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text("Description: ${product['description']}"),
          ),
          Spacer(),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            width: screenwidth * .5,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Added to Cart")));
              },
              style: ElevatedButton.styleFrom(
                shape: ContinuousRectangleBorder(),
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
              child: const Text("Add to Cart"),
            ),
          ),
          SizedBox(
            height: 70,
            width: screenwidth * .5,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Proceeding to Buy")));
              },
              style: ElevatedButton.styleFrom(
                shape: ContinuousRectangleBorder(),
                backgroundColor: Color.fromRGBO(34, 26, 101, 1),
                foregroundColor: Colors.white,
              ),
              child: const Text("Buy Now"),
            ),
          ),
        ],
      ),
    );
  }
}
