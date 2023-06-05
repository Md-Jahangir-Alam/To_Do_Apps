import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class data_rwud_page extends StatefulWidget {
  const data_rwud_page({Key? key}) : super(key: key);

  @override
  State<data_rwud_page> createState() => _data_rwud_pageState();
}

class _data_rwud_pageState extends State<data_rwud_page> {

  final database = FirebaseDatabase.instance.ref("User");
  final search = TextEditingController();
  final _editcontroler = TextEditingController();

  Future dialogbox(String title, String id)async{
    _editcontroler.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: _editcontroler,
                decoration: InputDecoration(
                  hintText: "Edit"
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              TextButton(onPressed: (){
                Navigator.pop(context);
                database.child(id).update({
                  "title": _editcontroler.text.toString(),
                });
              }, child: Text("Update")),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(        
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: search,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
            Expanded(
                child: FirebaseAnimatedList(
                    query: database,
                    itemBuilder: (context, snapshot, animation, index){
                      final title = snapshot.child("title").value.toString();

                      if(search.text.isEmpty){
                        return ListTile(
                          title: Text(snapshot.child("title").value.toString()),
                          subtitle: Text(snapshot.child("discription").value.toString()),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context)=>[
                              PopupMenuItem(
                                value: 1,
                                  child: ListTile(
                                    onTap: (){
                                      Navigator.pop(context);
                                      dialogbox(title, snapshot.child("id").value.toString());
                                    },
                                    leading: Icon(Icons.edit),
                                    title: Text("Edit"),
                                  )
                              ),
                              PopupMenuItem(
                                value: 2,
                                  child: ListTile(
                                    onTap: (){
                                      Navigator.pop(context);
                                      database.child(snapshot.child("id").value.toString()).remove();
                                    },
                                    leading: Icon(Icons.delete_forever),
                                    title: Text("Delete"),
                                  )
                              ),
                            ],
                          ),
                        );
                      }else if(title.toLowerCase().contains(search.text.toLowerCase().toString())){
                        return ListTile(
                          title: Text(snapshot.child("title").value.toString()),
                          subtitle: Text(snapshot.child("discription").value.toString()),
                        );
                      }else{
                        return Container();
                      }

                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
