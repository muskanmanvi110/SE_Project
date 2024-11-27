import 'package:book_uploading/screen/auth_screen.dart';
import 'package:book_uploading/screen/home_screen.dart';
import 'package:book_uploading/screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges() , 
    builder: (ctx, snap){
      if(snap.connectionState == ConnectionState.waiting){
        return const SplashScreen();
      }
      if(snap.hasData){
        return const HomeScreen();
      }
        return const AuthScreen();
      
    })
  );
  }
}