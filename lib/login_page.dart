import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do/forgot_page.dart';
import 'package:to_do/home_page.dart';
import 'package:to_do/registration_page.dart';



class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
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
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  logIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      var authCredential = credential.user;
      if (authCredential!.uid.isNotEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => home_page()));
      } else {
        showToastMessage("Something is worng");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToastMessage("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showToastMessage("Wrong password provided for that user.");
      }
    } catch (e) {
      showToastMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/login.png"), fit: BoxFit.cover)
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Text("Welcome", style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                          SizedBox(height: 270.h,),
                          TextFormField(
                            controller: _email,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,color: Colors.indigoAccent,
                              ),
                              hintText: "E-mail",
                              hintStyle: TextStyle(color: Colors.indigoAccent),
                              labelText: "E-mail",
                              labelStyle: TextStyle(color: Colors.indigoAccent),
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
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              prefixIcon: Icon(
                                  Icons.security,color: Colors.indigoAccent
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    eye_control();
                                  },
                                  icon: Icon(Icons.remove_red_eye_outlined, color: Colors.indigoAccent)),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.indigoAccent),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.indigoAccent),
                            ),
                            obscureText: (eye == true ? true : false),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Your Password.";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigoAccent,
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () {
                              if(formKey.currentState!.validate()){
                                logIn();
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 15.h,),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>forgot_pass()));
                          }, child: Text("Forgot Password")),
                          SizedBox(height: 15.h,),
                          Center(
                            child: RichText(
                                text: TextSpan(
                                    text: "Are you new here?",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.indigoAccent),
                                    children: [
                                      WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>registration()));
                                              },
                                              child: Text(" Signup Now",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.indigoAccent
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
      ),
    );
  }
}