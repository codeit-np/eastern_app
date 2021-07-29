import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_cart/flutter_cart.dart';

class ProductProfileScreen extends StatefulWidget {
  final int id;
  ProductProfileScreen({this.id});
  @override
  _ProductProfileScreenState createState() => _ProductProfileScreenState();
}

class _ProductProfileScreenState extends State<ProductProfileScreen> {
  Future getProduct() async {
    var response = await Api().getData('products/${widget.id}');
    var data = json.decode(response.body)['data'];
    return data;
  }

  // var cart = FlutterCart();
  var message;

  int total = 1;
  @override
  void initState() {
    super.initState();
    // print("product id is " + widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider product = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Profile"),
        actions: [
          Row(
            children: [
              Text(product.totalItems.toString()),
              IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, 'cart');
                  })
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: getProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Image.network(
                    link + snapshot.data[0]['feature'].toString(),
                  ),
                ),
                ListTile(
                  title: Text(
                    snapshot.data[0]['name'],
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      snapshot.data[0]['discount'] == 0
                          ? SizedBox()
                          : Text(
                              "Rs." +
                                  snapshot.data[0]['price'].toString() +
                                  " /" +
                                  snapshot.data[0]['unit'].toString(),
                              style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough),
                            ),
                      Text(
                        "Rs." +
                            snapshot.data[0]['sp'].toString() +
                            " /" +
                            snapshot.data[0]['unit'].toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      snapshot.data[0]['description'] == null
                          ? Text(
                              "Description no available",
                              style: TextStyle(fontSize: 12),
                            )
                          : Text(snapshot.data[0]['description'].toString(),
                              style: TextStyle(fontSize: 12)),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              size: 30,
                            ),
                            onPressed: () {
                              total--;
                              if (total <= 1) {
                                total = 1;
                              }
                              setState(() {});
                            },
                          ),
                          Text(
                            total.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 30,
                            ),
                            onPressed: () {
                              total++;
                              setState(() {});
                              // total++;
                              // cart.incrementItemToCart(total);
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        child: Text("ADD TO CART"),
                        onPressed: () {
                          // print(snapshot.data['id']);
                          product.addProduct(
                              snapshot.data[0]['id'].toString(),
                              snapshot.data[0]['name'].toString(),
                              total,
                              snapshot.data[0]['sp'],
                              link + snapshot.data[0]['feature'].toString());

                          // message = cart.addToCart(
                          //     productId: snapshot.data['id'],
                          //     unitPrice: snapshot.data['sp'],
                          //     quantity: total);
                          // print(message);
                          // print(cart.cartItem[0].quantity);
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("Error please contact developers");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )),
    );
  }
}
