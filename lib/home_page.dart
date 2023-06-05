import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:to_do/data_add_page.dart';
import 'package:to_do/data_rwud_page.dart';
import 'package:http/http.dart' as http;
import 'package:to_do/login_page.dart';


class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  var _index = 0;
  var page = [data_add_page(), data_rwud_page()];
  Map<String, dynamic>? paymentintents;

  Future<void> makepayment()async{
    try{
      paymentintents = await createpayment("500", "BDT");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentintents!["client_secret"],
            style: ThemeMode.dark,
            merchantDisplayName: "MD Jahangir Mia"
          )
      );

      displaypaymentsheet();

    }catch(e){
      print(e.toString());
    }
  }

  displaypaymentsheet()async{
    try{
      await Stripe.instance.presentPaymentSheet(

      );
      setState(() {
        paymentintents = null;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("paid successfully")));
    }on StripeException catch(e){
      print(e.toString());
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    }
  }

  createpayment(String amount, String currency)async{
    try{
      Map<String, dynamic> body = {
        "amount": totalamount(amount),
        "curency": currency,
        "payment_type": "card"
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51NFYUjDag1KlV3i5uhSsqptfjfx0caHCtyvRdVsvEBXKqHmMT0ew78buYfJk5WszdEmoYpPy8rqOYa91LbZP9fq500jaOtF13l',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body.toString());

    }catch(e){
      print(e.toString());
    }
  }

  totalamount(String amount){
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.payments),
      ),
      appBar: AppBar(
        title: Text(
          "To Do Apps",
          style: TextStyle(fontSize: 20.sp),
        ),
        actions: [
          IconButton(
              onPressed: ()async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>login_page()));
              },
              icon: Icon(
                Icons.logout,
                size: 30,
              ))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: 25,
                ),
                label: "Add Data"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: 25,
                ),
                label: "My Data"),
          ]),
      body: page[_index],
    );
  }
}
