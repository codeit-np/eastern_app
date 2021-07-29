import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/const/const.dart';
import 'package:final_food_app/widgets/inputText.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future getData() async {
    var response = await Api().getData('user');
    var data = json.decode(response.body);
    name.text = data['name'];
    address.text = data['address'];
    mobile.text = data['mobile'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: getData(),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Update your profile"),
                      ),
                      inputText(name, "Full Name", Icons.person_add_alt, false,
                          true, TextInputType.text),
                      SizedBox(
                        height: 10,
                      ),
                      inputText(address, "Address", Icons.location_city, false,
                          true, TextInputType.streetAddress),
                      SizedBox(
                        height: 10,
                      ),
                      inputText(mobile, "Mobile", Icons.call, false, true,
                          TextInputType.phone),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                                  icon: Icon(Icons.update),
                                  onPressed: () async {
                                    if (_key.currentState.validate()) {
                                      Map data = {
                                        "name": name.text,
                                        "address": address.text,
                                        "mobile": mobile.text,
                                      };

                                      var response = await Api()
                                          .postData(data, 'profileupdate');
                                      var result = json.decode(response.body);
                                      print(result);
                                      if (result['message'] == 'success') {
                                        showDialog(
                                            context: context,
                                            builder: (builder) {
                                              return AlertDialog(
                                                title: Text("Message"),
                                                content:
                                                    Text("Update successful"),
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
                                    }
                                  },
                                  label: Text("Update"))),
                        ],
                      )
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
