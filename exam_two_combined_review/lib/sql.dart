import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();


// open the database and store the reference

  final database = openDatabase(
      join(await getDatabasesPath(), 'databasesample.db'),
      onCreate: (db, version){
        return db.execute(
          'create table dogs (id integer primary key, name text, age integer)',
        );

      },
      version: 1
  );

// define a function that add some dog objects into the database
  Future<void> insertDog(Dog dog)async{
    final db = await database;
    await db.insert('dogs',dog.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);


  }
// method that retrieves all the dogs from the table
  Future<List<Dog>> dogs() async{
    final db=  await database;
    final List<Map<String,Object?>>dogMaps= await db.query('dogs');
    return dogMaps.map((map) {
      return Dog(
          id: map['id'] as int,
          name: map['name'] as String,
          age: map ['age'] as int

      );}).toList();
  }

//update method

  Future<void> update(Dog dog) async{

    final db=await database;
    await db.update(

      'dogs',
      dog.toMap(),
      where: 'id=?',
      whereArgs: [dog.id],

    );


  }

//delete method
  Future<void> deleteDog(int id)async{

    final db = await database;
    await db.delete(
      'dogs',
      where: 'id=?',
      whereArgs: [id],
    );
  }
  var fido = Dog(
      id:0,
      name:'Fido',
      age:12
  );
  await insertDog(fido);
// now use the above metod to retrieve all the dogs
  print(await dogs());

  fido= Dog(
      id:fido.id,
      name:fido.name,
      age:fido.age+10
  );
  await update(fido);
  print(await dogs());



}
class Dog{
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,

  });

  Map<String,Object?> toMap(){
    return{
      'id':id,
      'name':name,
      'age':age
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'Dog{id: $id,name:$name,age:$age} ';
  }

}
