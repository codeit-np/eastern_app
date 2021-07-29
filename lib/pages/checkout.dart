import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future getDetails() async {
    var response = await Api().getData('user');
    var data = json.decode(response.body);
    name.text = data['name'];
    email.text = data['email'];
    address.text = data['address'];
    mobile.text = data['mobile'];
    return data;
  }

  String deliveryType;

  @override
  Widget build(BuildContext context) {
    ProductProvider provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: getDetails(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: .2,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text("Delivery Details"),
                              subtitle: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Full Name',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        border: OutlineInputBorder()),
                                    controller: name,
                                    enabled: false,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Email',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        border: OutlineInputBorder()),
                                    controller: email,
                                    enabled: false,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Deliver Address',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        border: OutlineInputBorder()),
                                    controller: address,
                                    enabled: true,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Mobile',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        border: OutlineInputBorder()),
                                    controller: mobile,
                                    enabled: false,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Card(
                        elevation: .2,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text("Bill Details"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Items: '),
                                      Text("(" +
                                          provider.totalItems.toString() +
                                          ")"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payable Amount: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                      Text(
                                        provider.totalAmount.toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Text(
                                    "Payment Method",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Cash on delivery: '),
                                      Container(
                                          child: Checkbox(
                                              value: true,
                                              onChanged: (value) {}))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Pay Khalti: '),
                                      Container(
                                          child: Checkbox(
                                              value: false,
                                              onChanged: (value) {
                                                showDialog(
                                                    context: context,
                                                    builder: (builder) {
                                                      return AlertDialog(
                                                        title: Text("Message"),
                                                        content: Text(
                                                            "This feature is coming soon"),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("OK"))
                                                        ],
                                                      );
                                                    });
                                              }))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Pay eSewa: '),
                                      Container(
                                          child: Checkbox(
                                              value: false,
                                              onChanged: (value) {
                                                showDialog(
                                                    context: context,
                                                    builder: (builder) {
                                                      return AlertDialog(
                                                        title: Text("Message"),
                                                        content: Text(
                                                            "This feature is coming soon"),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("OK"))
                                                        ],
                                                      );
                                                    });
                                              }))
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            Map data = {
                              'address': address.text,
                              'total': provider.totalAmount,
                              'products': provider.products.map((e) {
                                return {
                                  'id': e.id,
                                  'qty': e.qty,
                                  'amount': e.amount,
                                };
                              }).toList(),
                            };

                            var response = await Api()
                                .postData(data, 'invoice')
                                .whenComplete(() {
                              provider.reset();
                              Navigator.pushNamed(context, 'success');
                            });
                            var result = json.decode(response.body);
                            print(response.statusCode);
                            print(result);
                          }
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      )),
    );
  }
}
