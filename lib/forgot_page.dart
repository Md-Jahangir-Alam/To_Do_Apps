import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgot_pass extends StatefulWidget {
  const forgot_pass({Key? key}) : super(key: key);

  @override
  State<forgot_pass> createState() => _forgot_passState();
}

class _forgot_passState extends State<forgot_pass> {
  final _email = TextEditingController();

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


  Future passwordreset()async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text.trim());
      showToastMessage("Check your email");
    }on FirebaseAuthException catch(e){
      showToastMessage("Something is worng");
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
                  image: DecorationImage(
                      image: AssetImage("assets/forget.png"), fit: BoxFit.cover)
              ),
            ),
            Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 250.h,
                        ),
                        Text("Forgot Password?", style: TextStyle(fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigoAccent),),
                        SizedBox(height: 35.h,),
                        TextFormField(
                          controller: _email,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.indigoAccent),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.indigoAccent),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12))
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined, color: Colors.indigoAccent,
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigoAccent,
                            minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          onPressed: () {
                            passwordreset();
                          },
                          child: const Text(
                            'Forgot',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ],
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
