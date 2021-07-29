import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // var cart = FlutterCart();

  @override
  Widget build(BuildContext context) {
    ProductProvider product = Provider.of<ProductProvider>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: Colors.grey.shade300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  "items(" + product.totalItems.toString() + ")",
                  textScaleFactor: 1.2,
                ),
              ),
              Container(
                child: Text(
                  "Total: " + product.totalAmount.toString(),
                  textScaleFactor: 1.2,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (product.totalItems > 0) {
                    Navigator.pushNamed(context, 'checkout');
                  } else {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: Text("Message"),
                            content: Text(
                              "Your cart is empty\nplease buy something",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }
                },
                icon: Icon(Icons.next_plan),
                label: Text("Checkout"),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Cart"),
        ),
        body: product.totalItems == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_basket,
                      color: Theme.of(context).accentColor,
                      size: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No items in basket,\nPlease buy something..!",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: product.totalItems,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: .2,
                            child: ListTile(
                              leading:
                                  Image.network(product.products[index].image),
                              title: Text(product.products[index].name),
                              subtitle: Text(
                                product.products[index].qty.toString() +
                                    " x " +
                                    product.products[index].sp.toString() +
                                    " = " +
                                    product.products[index].amount.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    product.removeProduct(
                                        product.products[index].id);
                                  }),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
