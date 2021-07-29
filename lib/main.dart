import 'package:final_food_app/pages/cart.dart';
import 'package:final_food_app/pages/checkout.dart';
import 'package:final_food_app/pages/complete.dart';
import 'package:final_food_app/pages/dashboard.dart';
import 'package:final_food_app/pages/login.dart';
import 'package:final_food_app/pages/product_profile.dart';
import 'package:final_food_app/pages/profile.dart';
import 'package:final_food_app/pages/register.dart';
import 'package:final_food_app/pages/splash.dart';
import 'package:final_food_app/pages/success.dart';
import 'package:final_food_app/provider/darkmode.dart';
import 'package:final_food_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProductProvider()),
      ChangeNotifierProvider(create: (context) => DarkMode()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DarkMode darkMode = Provider.of<DarkMode>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hungy App',
      theme: ThemeData(
        brightness: darkMode.flag == true ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        'dashboard': (context) => DashboardScreen(),
        'productprofile': (context) => ProductProfileScreen(),
        'cart': (context) => CartScreen(),
        'checkout': (context) => CheckOutScreen(),
        'complete': (context) => CompleteScreen(),
        'profile': (context) => ProfileScreen(),
        'success': (context) => SuccessScreen(),
      },
    );
  }
}
