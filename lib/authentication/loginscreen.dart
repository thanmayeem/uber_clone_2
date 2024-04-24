import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_2/authentication/signupscreen.dart';
import 'package:uber_clone_2/methods/common_methods.dart';
import 'package:uber_clone_2/pages/home_page.dart';

import '../globals/global_var.dart';
import '../widgets/loading_dialog.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController PasswordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  checkIfNetworkIsAvailable(){
    cMethods.checkConnectivity(context);
    signinFormValidation();

  }
  signinFormValidation(){
    if(!emailTextEditingController.text.contains("@")){
      cMethods.displaySnackBar("Please enter valid mail", context);
    }
    else if(PasswordTextEditingController.text.trim().length <5){
      cMethods.displaySnackBar("Your password must be at least 6 or more characters. ", context);
    }
    else{
      signInUser();
    }
  }
  signInUser() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> LoadingDialog(messageText: "Loging into your account..."),
    );
    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: PasswordTextEditingController.text.trim(),
        ).catchError((errorMsg){
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;
    if(!context.mounted) return;
    Navigator.pop(context);

    if(userFirebase !=null){
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
      userRef.once().then((snap)
      {
       if(snap.snapshot.value!=null){
          if((snap.snapshot.value as Map)["blockStatus"] == "no"){
           userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(context,MaterialPageRoute(builder: (c)=>HomePage()));
          }
          else{
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("you are blocked. Contact your admin", context);
          }
       }
       else{
         FirebaseAuth.instance.signOut();
         Navigator.push(context,MaterialPageRoute(builder: (c)=>HomePage()));

       }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                  "assets/images/logo.png"
              ),
              const Text(
                "Create User account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),

              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType:TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(
                          fontSize: 14,

                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: PasswordTextEditingController,
                      obscureText: true,
                      keyboardType:TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14,

                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                     onPressed: (){
                      checkIfNetworkIsAvailable();
                      },

                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10)
                      ),
                      child: const Text(
                          "Login"
                      ),
                    ),
                  ],
                ),




              ),
              const SizedBox(height: 12,),
              TextButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>SignUpscreen()));
                },

                child: const Text(
                  "Don\'t have an Account? Register Here",
                  style: TextStyle(
                    color: Colors.grey,

                  ),

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
