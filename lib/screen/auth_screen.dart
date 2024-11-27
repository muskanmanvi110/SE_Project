// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _formkey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  
  var _islogin = true;
  
  
  void submit() async{
    var isvalid = _formkey.currentState!.validate();
 
    if(isvalid){
      _formkey.currentState!.save();
    }

    try{
      if(_islogin){
      
      await _firebase.signInWithEmailAndPassword(
        email: _email, password: _password
      );
    }else{
      
        await _firebase.createUserWithEmailAndPassword(
        email: _email, password: _password
        );
    }

    }on FirebaseAuthException catch(error){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Authentication failed")
          ) 
        );
      }
    }
  
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:100),
              child: Image.asset("assets/books_image.png",height: 400,),
            ),
            Container(
              height: 300,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.brown[500],
                borderRadius: const  BorderRadius.all(Radius.circular(10)),
              ),
              child: Form(
                key: _formkey,
                child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:12,right:12),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("email", style: TextStyle(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 182, 165, 165)), 
                        ),
                      ),
                      autocorrect: false,
                      style: const TextStyle(color: Colors.white),
                      validator: (value){
                        if(value == null || value.trim().isEmpty || value.contains("@")==false){
                          return "Enter valid email address";
                        }
                        return null;
                      },
                      onSaved: (value){
                        _email = value!;
                      },
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:12,right:12),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("password", style: TextStyle(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 182, 165, 165)), 
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      validator: (value){
                        if(value == null || value.trim().isEmpty || value.length < 6){
                          return "Enter password with 6 characters";
                        }
                        return null;
                      },
                      onSaved: (value){
                        _password = value!;
                      },
                      
                    ),
                  ),
                  const SizedBox(height: 40,),

                  ElevatedButton(onPressed: submit, 
                  style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                  ),
                  child: Text(_islogin ? "Sign In" : "Sign Up")
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      _islogin = !_islogin;
                    }); 
                  }, 
                  child: Text(
                  _islogin ? "create an account" : "already have an account",
                   style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                     ) ,
                    )
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}