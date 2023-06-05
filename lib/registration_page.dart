import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do/login_page.dart';

class registration extends StatefulWidget {
  const registration({Key? key}) : super(key: key);

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final formKey = GlobalKey<FormState>();


  var eye = true;
  eye_control() {
    setState(() {
      eye = !eye;
    });
    print(eye);
  }


  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }



  Future signUp()async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      var authCredential = credential.user;
      if(authCredential!.uid.isNotEmpty){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>login_page()));
      }
      else{
        showToastMessage("Something is worng");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToastMessage("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showToastMessage("The account already exists for that email.");
      }
    } catch (e) {
      showToastMessage(e.toString());
    }
  }


  Future upload_data()async{
    final fireStore = FirebaseFirestore.instance.collection("users");
    fireStore.doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
      "name": _name.text.toString(),
      "email": _email.text.toString(),
      "password": _password.text.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/signup.png"), fit: BoxFit.cover)
            ),
          ),
          Positioned(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 240.h,
                        ),
                        Text("Sign Up", style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                        SizedBox(height: 20.h,),
                        TextFormField(
                          controller: _name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,color: Colors.white,
                            ),
                            hintText: "Full Name",
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: "Full Name",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Your Full Name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h,),
                        TextFormField(
                          controller: _email,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,color: Colors.white,
                            ),
                            hintText: "E-mail",
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: "E-mail",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Your E-mail";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h,),
                        TextFormField(
                          controller: _password,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            prefixIcon: Icon(
                                Icons.security,color: Colors.white
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  eye_control();
                                },
                                icon: Icon(Icons.remove_red_eye_outlined, color: Colors.white)),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          obscureText: (eye == true ? true : false),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Your Password.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25.h,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          onPressed: () async{
                            if(formKey.currentState!.validate()){
                              signUp();
                              upload_data();
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 24, color: Colors.indigoAccent),
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        Center(
                          child: RichText(
                              text: TextSpan(
                                  text: "Already have an account?",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>login_page()));
                                            },
                                            child: Text(" Login",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white
                                                )
                                            )
                                        )
                                    )
                                  ]
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}

