import 'package:flutter/material.dart';
import 'package:saifeetest/Detials/ProductDisplay.dart';

class ProductsTally extends StatelessWidget {
  ProductsTally({super.key});
  final List<Map<String, dynamic>> products = [
    {
      "name": "Tally Single user",
      "price": "2330",
      "oldPrice": "65,000",
      "image": "assets/images/Buy.png",
      "description": '''
Tally Single User is ideal for small businesses and individual entrepreneurs. It provides full access to powerful accounting, inventory, taxation, and payroll features — all in one place.

Key Features:
- Supports GST, VAT, and other tax calculations
- Manages inventory and stock easily
- Generates financial reports and invoices
- Easy bank reconciliation
- Simple interface with high data security

Best suited for:
✔️ Small businesses  
✔️ Freelancers  
✔️ Accountants  

Includes 1 user license. No recurring fees — lifetime validity.
''',
    },
    {
      "name": "Tally Cloud",
      "price": "45,000",
      "oldPrice": "56,000",
      "image": "assets/images/Buy.png",
    },
    {
      "name": "Annual Maintanace Cost(AMC)",
      "price": "35,000",
      "oldPrice": "50,000",
      "image": "assets/images/Buy.png",
    },
    {
      "name": "Tally Multi User",
      "price": "35,000",
      "oldPrice": "50,000",
      "image": "assets/images/Buy.png",
      "description": '''
Tally Multi User (Tally Gold) is designed for growing businesses that require simultaneous access by multiple users. It enables seamless collaboration between accounting, sales, inventory, and finance teams.

Key Features:
- Unlimited multi-user access across a LAN environment
- Real-time synchronization of financial data
- Complete support for GST, VAT, and other compliance
- Advanced inventory and billing management
- High-level security with user role permissions

Best suited for:
✔️ Medium and large businesses  
✔️ Multi-department accounting teams  
✔️ Branch and warehouse coordination  

Includes unlimited user licenses on a single LAN. One-time purchase with lifetime validity.
''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsPage(product: product),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            product["image"],
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "AED ${product['price']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "AED ${product['oldPrice']}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
