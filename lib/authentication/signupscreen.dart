import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_2/authentication/loginscreen.dart';
import 'package:uber_clone_2/methods/common_methods.dart';
import 'package:uber_clone_2/pages/home_page.dart';
import 'package:uber_clone_2/widgets/loading_dialog.dart';
class SignUpscreen extends StatefulWidget {
  const SignUpscreen({super.key});

  @override
  State<SignUpscreen> createState() => _SignUpscreenState();
}

class _SignUpscreenState extends State<SignUpscreen> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController PasswordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
 checkIfNetworkIsAvailable(){
cMethods.checkConnectivity(context);
signUpFormValidation();

 }
 signUpFormValidation(){
   if(usernameTextEditingController.text.trim().length <3){
    cMethods.displaySnackBar("Your name must be atleast 4 or more characters", context);
   }
   else if(!emailTextEditingController.text.contains("@")){
     cMethods.displaySnackBar("Please enter valid mail", context);
   }
   else if(PasswordTextEditingController.text.trim().length <5){
     cMethods.displaySnackBar("Your password must be at least 6 or more characters. ", context);
   }
   else{
     registerNewUser();
   }
 }
registerNewUser() async{
   showDialog(
     context: context,
     barrierDismissible: false,
     builder: (BuildContext context)=> LoadingDialog(messageText: "Registering your account..."),
   );
   final User? userFirebase = (
   await FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: emailTextEditingController.text.trim(),
       password: PasswordTextEditingController.text.trim(),
   ).catchError((errorMsg){
     cMethods.displaySnackBar(errorMsg.toString(), context);
   })
   ).user;
    if(!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
   Map userDataMap = {
     "name" : usernameTextEditingController.text.trim(),
     "email" :emailTextEditingController.text.trim(),
     "phone" : phoneTextEditingController.text.trim(),
     "id": userFirebase.uid,
   "blockStatus": "no",
   //"password": PasswordTextEditingController.text.trim(),

   };
   userRef.set(userDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
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
                  controller: usernameTextEditingController,
                   keyboardType:TextInputType.text,
                   decoration: const InputDecoration(
                     labelText: "User Name",
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
                   controller: phoneTextEditingController,
                   keyboardType:TextInputType.phone,
                   decoration: const InputDecoration(
                     labelText: "User Phone",
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
                     "Sign Up"
                   ),
                 ),
               ],
             ),




           ),
const SizedBox(height: 12,),
TextButton(
    onPressed:(){
Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
    },

 child: const Text(
   "Already have an Account? Login Here",
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
