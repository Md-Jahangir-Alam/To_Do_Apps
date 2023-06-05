import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class data_add_page extends StatefulWidget {
  const data_add_page({Key? key}) : super(key: key);

  @override
  State<data_add_page> createState() => _data_add_pageState();
}

class _data_add_pageState extends State<data_add_page> {

  final formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _discription = TextEditingController();
  final id = DateTime.now().microsecondsSinceEpoch.toString();
  final database = FirebaseDatabase.instance.ref("User");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                TextFormField(
                  controller: _title,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Title here",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    )
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Your E-mail";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  controller: _discription,
                  maxLines: 15,
                  decoration: InputDecoration(
                    hintText: "Description here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                    )
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
                    database.child(id.toString()).set({
                      "title": _title.text.toString(),
                      "discription": _discription.text.toString(),
                      "id": id.toString()
                    });
                  },
                  child: const Text(
                    'Add Data',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
