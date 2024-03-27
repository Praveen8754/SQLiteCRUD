import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(dbclearflag: true),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key, required this.dbclearflag}): super(key: key);
  final bool dbclearflag;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database _database;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  //bool firstcall = true;

  @override
  void initState() {
    super.initState();
    print('LOGG+++'+widget.dbclearflag.toString());
    if(widget.dbclearflag){
      _initializeDatabasefirst();
    }else{
      setState(() {
        print("hello");
        print("DB STATUS"+_database.isOpen.toString());
      });
    }
  }

  Future<void> _initializeDatabasefirst() async {
    // Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'example.db');
    if (kDebugMode) {
      print("DB CLEAR: "+widget.dbclearflag.toString());
    }
    // Delete the database if it already exists
    if(widget.dbclearflag) {
      await deleteDatabase(path);
    }
    // Open the database
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            age INTEGER
          )
        ''');
      },
readOnly: false
    );
  }

  Future<void> _initializeDatabase() async {
    // Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'example.db');
    if (kDebugMode) {
      print("DB CLEAR: "+widget.dbclearflag.toString());
    }
    // Delete the database if it already exists
    if(widget.dbclearflag) {
      await deleteDatabase(path);
    }
    // Open the database
    _database = await openDatabase(
        path,
        version: 1,
        readOnly: false
    );
  }

  Future<void> _insertUser(String name, int age) async {
    // Insert into the table
    await _database.insert(
      'users',
      {'name': name, 'age': age},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> _queryUsers() async {
    // Query the table for all users
    print("data "+_database.query('users').toString());
    return await _database.query('users');
  }

/*  Future<void> _updateUser(*//*int id, String name, int age*//*user) async {


    final newUser = Map.of(user);
    newUser['name'] = user['name'];
    newUser['age']=user['age'];

    await _database.update(
      'users',
      {'name': user, 'age': age},
      where: '$id = ?',
      whereArgs: [id],
    );





    // Update the user
    await _database.update(
      'users',
      {'name': user[]name, 'age': age},
      where: '$id = ?',
      whereArgs: [id],
    );
  }*/





/*  Future<void> _updateUser(int id, String name, int age) async {
   *//* await _database.transaction((txn) async {
      // Perform write operations within the transaction
      await txn.update(
        'users',
        {'name': name, 'age': age},
        where: '$id = ?',
        whereArgs: [id],
     //   conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });*//*

    setState(() {});
  }*/














  Future<void> _updateUser( int id, String name,int age) async {
    // Get a reference to the database.
    final db = _database;

    // Update the given Dog.
  /* await db.update(
      'user',
      user.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );*/

 /*   await db.rawUpdate('''
    UPDATE users 
    SET name = ?, age = ? 
    WHERE _id = ?
    ''',
        [name*//*'Susan'*//*, age, id]);*/
    /*mydb.*/db.rawInsert("UPDATE users SET id = ?, name = ?, age = ? WHERE id = ?",
        [id, name/*.text*/,age ,id/*rollno*//*.text*//*, address.text, widget.rollno*/]);


  /*  setState(() {});*/




  }











  Future<void> _deleteUser(int id) async {
    // Delete the user
    await _database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite CRUD Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _insertUser(_nameController.text, int.parse(_ageController.text));
                _nameController.clear();
                _ageController.clear();
                setState(() {});
              },
              child: const Text('Add User'),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: _queryUsers(),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No users in the database.');
                }

                return Column(
                  children: [
                    const Text('Users in the database:'),
                    for (var user in snapshot.data!)
                      ListTile(
                        title: Text('ID: ${user['id']}, Name: ${user['name']}, Age: ${user['age']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                return Edit(id: user["id"], name:  user["name"], age: user["age"],database: _database);
                              }));
                            }, icon: Icon(Icons.edit)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // Delete the user
                                await _deleteUser(user['id']);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class user {
  late final int id;
  late final String name;
  late final int age;

 user({
    required this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'user{id: $id, name: $name, age: $age}';
  }
}
