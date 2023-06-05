import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do/firebase_options.dart';
import 'package:to_do/home_page.dart';
import 'package:to_do/login_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = "pk_test_51NFYUjDag1KlV3i51fxITlYgLpjOIMzpmhixWBb4uIEg5gciSFdcE8a8lukteLAVosVJ449b1nY5MIvEEYHHFf1z00ySzzK2G9";
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TO DO APP',
          // You can use the library anywhere in the app even in theme
          home: Scaffold(
            backgroundColor: Colors.white,
            body: animation_screen()
          ),
        );
      },
    );
  }
}


class animation_screen extends StatefulWidget {
  const animation_screen({Key? key}) : super(key: key);

  @override
  State<animation_screen> createState() => _animation_screenState();
}

class _animation_screenState extends State<animation_screen> {

  final credential = FirebaseAuth.instance.currentUser;

  usercheck(){
    if(credential != null){
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => home_page()));
      });
    }else{
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => login_page()));
      });
    }
  }

  @override
  void initState() {
    usercheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Lottie.asset("assets/animated screen.json"),
    );
  }
}

