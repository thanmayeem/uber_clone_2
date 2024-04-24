import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uber_clone_2/authentication/loginscreen.dart';
import 'package:uber_clone_2/authentication/signupscreen.dart';
import 'package:uber_clone_2/pages/home_page.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    
    options: FirebaseOptions(
      apiKey: "AIzaSyDm-9QG9g-6uxZbC_IhxgKzaX6GCOTykAA", // Your apiKey
      appId: "1:552045119723:android:de4bcf3792604ccc2596ae", // Your appId
      messagingSenderId: "552045119723", // Your messagingSenderId
      projectId: "uber-clone-2-8ce6c", // Your projectId
    ),
  );
  await Permission.locationWhenInUse.isDenied.then((valueOfPermission){
    if(valueOfPermission){
      Permission.locationWhenInUse.request();
    }
  }
  );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,


      ),
      home: FirebaseAuth.instance.currentUser == null? LoginScreen(): HomePage(),
    );
  }
}

