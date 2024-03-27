import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';



class Edit extends StatefulWidget{

  int id;
  String name;
  int age;
  Database database;
  Edit( {required this.id, required this.name, required this.age, required this.database});

  @override
  State<StatefulWidget> createState() {
    return _Edit();
  }
}

class _Edit extends State<Edit>{

  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController age = TextEditingController();

  MyHomePage mydb = MyHomePage(dbclearflag: false);

  @override
  void initState() {
   // mydb. _database  open();
    name.text = widget.name;
    id.text = widget.id.toString();
    age.text = widget.age.toString();
    //setState(() {});
  /*  Future.delayed(Duration(milliseconds: 500), () async {
      var data = await mydb.getStudent(widget.id);
      if(data != null){
        name.text = data["name"];
        id.text = data["roll_no"].toString();
        age.text = data["age"];
        setState(() {});
      }else{
        print("No any data with roll no: " + widget.id.toString());
      }
    });*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit"),
        ),
        body:Container(
          padding: EdgeInsets.all(30),
          child: Column(children: [


            TextField(
              controller: name,
              decoration: const InputDecoration(
                hintText: "Name",
              ),
            ),

            TextField(
              controller: age,
              decoration: InputDecoration(
                hintText: "age:",
              ),
            ),
/*23SCH00051_00008*/
            ElevatedButton(onPressed: (){
               widget.database.rawUpdate("UPDATE users SET id = ?, name = ?, age = ? WHERE id = ?",
                  [ id.text, name.text, age.text, widget.id]);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Data Updated")));
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const MyHomePage(dbclearflag: false)),
               );

            }, child: Text("Update  Data")),
          ],),
        )
    );
  }

}