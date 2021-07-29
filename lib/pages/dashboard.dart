import 'dart:convert';
import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/pages/product_profile.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:final_food_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Get Categories

  Future getCategories() async {
    var response = await Api().getData('categories');
    var data = json.decode(response.body);
    return data;
  }

  // Get Product
  Future getProduct() async {
    var response = await Api().getData('products');
    var data = json.decode(response.body)['data'];
    return data;
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    // var cart = FlutterCart();
    final double width = MediaQuery.of(context).size.width;
    final double height = 80;
    ProductProvider product = Provider.of<ProductProvider>(context);
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("Eastern Gears"),
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
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 3)).then((onvalue) {});
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: width,
                    height: height,
                    child: FutureBuilder(
                      future: getCategories(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              var mydata = snapshot.data[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Chip(label: Text(mydata['name'])),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error");
                        } else {
                          return Text("Loading...");
                        }
                      },
                    )),
                FutureBuilder(
                  future: getProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              print('product id is ' +
                                  snapshot.data[index]['id'].toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductProfileScreen(
                                    id: snapshot.data[index]['id'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: .2,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      padding: EdgeInsets.all(10),
                                      child: Image.network(
                                        link + snapshot.data[index]['feature'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data[index]['name'],
                                            textScaleFactor: 1.4,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          snapshot.data[index]['discount'] == 0
                                              ? SizedBox()
                                              : Text(
                                                  "Rs. " +
                                                      snapshot.data[index]
                                                              ['price']
                                                          .toString() +
                                                      " /" +
                                                      snapshot.data[index]
                                                              ['unit']
                                                          .toString(),
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.red),
                                                ),
                                          Text(
                                            "Rs. " +
                                                snapshot.data[index]['sp']
                                                    .toString() +
                                                " /" +
                                                snapshot.data[index]['unit']
                                                    .toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          snapshot.data[index]['description'] ==
                                                  null
                                              ? SizedBox()
                                              : Text(
                                                  snapshot.data[index]
                                                      ['description'],
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error contact developers");
                    } else {
                      return Text('Loading.....');
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
