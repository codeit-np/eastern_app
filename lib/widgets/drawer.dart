import 'dart:convert';

import 'package:final_food_app/api/api.dart';
import 'package:final_food_app/provider/darkmode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  Future getData() async {
    var response = await Api().getData('user');
    var data = json.decode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    DarkMode darkMode = Provider.of<DarkMode>(context);
    return Drawer(
      child: ListView(
        children: [
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return UserAccountsDrawerHeader(
                    accountName: Text(snapshot.data['name']),
                    accountEmail: Text(snapshot.data['email']),
                    currentAccountPicture: CircleAvatar(
                      child: Text(
                        snapshot.data['name'].toString().substring(0, 1),
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  );
              }
            },
          ),
          ListTile(
            onTap: () => Navigator.pop(context),
            leading: Icon(Icons.dashboard),
            title: Text("Dashboard"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'profile');
            },
            leading: Icon(Icons.person),
            title: Text("Edit Profile"),
          ),
          // ListTile(
          //   leading: Icon(Icons.pages),
          //   title: Text("Purchase History"),
          // ),
          ListTile(
            leading: Icon(Icons.brightness_2_outlined),
            title: Text("Enable Night Mode"),
            trailing: Switch(
              value: darkMode.flag,
              onChanged: (value) {
                darkMode.setFlag(value);
              },
            ),
          ),
          ListTile(
            onTap: () async {
              Map data = {};
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              Api().postData(data, 'logout').whenComplete(() {
                preferences.remove('token');
                Navigator.popAndPushNamed(context, 'login');
              });
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          )
        ],
      ),
    );
  }
}
