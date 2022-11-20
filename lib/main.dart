import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screen/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return MaterialApp(
            title: 'Flutter Firebase Email Password Auth',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            debugShowCheckedModeBanner: false,
            home: Home(),
            // AuthService().handleAuthState(),
          );
        });
  }

}
