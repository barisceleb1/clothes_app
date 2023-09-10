import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_fragments.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clothes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: RememberUserPrefs.readUserInfo(),
          builder:
      (context,dataSnapshot){
            if(dataSnapshot.data== null){
              return LoginScreen();
            }
            else
            {
              return DashboardOfFragments();
            }
        return LoginScreen();
      })
    );
  }
}
