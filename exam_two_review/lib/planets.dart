import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: databaseView(),
    );
  }
}

class databaseView extends StatefulWidget {
  const databaseView({super.key});

  @override
  State<databaseView> createState() => _databaseViewState();
}

class _databaseViewState extends State<databaseView> {

  late Future<Database> database;
  List<Planet> planetList = [];

  @override
  void initState() {
    // TODO: implement initState
    database = openDatabase(
        join(getDatabasesPath().toString(), 'planetsSample.db'),
        onCreate: (db, version){
          return db.execute(
            'create table planets (id integer primary key, name text, age integer, distancefromsun integer)',
          );
        },
        version: 1
    );

    _fetchPlanets();
  }

  Future<void> _fetchPlanets() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('planets');
    setState(() {
      planetList = List.generate(
          maps.length,
              (i) {
            return Planet(
              id: maps[i]['id'],
              name: maps[i]['name'],
              age: maps[i]['age'],
              distancefromsun: maps[i]['distancefromsun'],
            );
          }
      );
    });
  }

  Future<void> _addPlanet(Planet planet) async{
    final db = await database;
    await db.insert(
        'planets',
        planet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    _fetchPlanets();
  }

  Future<void> _updatePlanet(Planet planet) async{
    final db = await database;
    await db.update(
      'planets',
      planet.toMap(),
      where: 'id = ?',
      whereArgs: [planet.id],
    );

    _fetchPlanets();
  }

  Future<void> _deletePlanet(int id) async{
    final db = await database;
    await db.delete(
      'planets',
      where: 'id = ?',
      whereArgs: [id],
    );

    _fetchPlanets();
  }

  //design a form for adding and editing dog objects details
  void _showPlanetForm({Planet? planet}){
    String name = planet?.name ?? '';
    String ageStr = planet?.age?.toString() ?? '';
    String distanceStr = planet?.distancefromsun?.toString() ?? '';

    showModalBottomSheet(
        context: this.context,
        builder: (BuildContext context){
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Name'
                  ),
                  onChanged: (value) => name = value,
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Age'
                  ),
                  onChanged: (value) => ageStr = value,
                  controller: TextEditingController(text: ageStr),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Distance From Sun'
                  ),
                  onChanged: (value) => distanceStr = value,
                  controller: TextEditingController(text: distanceStr),
                ),
                ElevatedButton(
                  onPressed: (){
                    if(name.isNotEmpty && ageStr.isNotEmpty && distanceStr.isNotEmpty){
                      if(planet == null){
                        _addPlanet(Planet(
                          id: planetList.length + 1,
                          name: name,
                          age: int.parse(ageStr),
                          distancefromsun: int.parse(distanceStr),
                        ));
                      } else {
                        _updatePlanet(Planet(
                          id: planet.id,
                          name: name,
                          age: int.parse(ageStr),
                          distancefromsun: int.parse(distanceStr),
                        ));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(planet == null ? 'Add Planet ' : 'Update Planet'),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planet Object List"),
      ),
      body: ListView.builder(
        itemCount: planetList.length,
        itemBuilder: (context, index){
          final planet = planetList[index];
          return ListTile(
            title: Text('${planet.name}, age: ${planet.age}, \ndistance: ${planet.distancefromsun}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showPlanetForm(planet: planet),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _deletePlanet(planet.id),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlanetForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class Planet{
  late final int id;
  late final String name;
  late final int age;
  late final int distancefromsun;

  Planet({
    required this.id,
    required this.name,
    required this.age,
    required this.distancefromsun,
  });

  Planet.fromMap(Map<String, dynamic> result)
      : id = result['id'],
        name = result['name'],
        age = result['age'],
        distancefromsun = result['distancefromsun'];

  Map<String, Object?> toMap(){
    return {
      'id' : id,
      'name' : name,
      'age' : age,
      'distancefromsun' : distancefromsun,
    };
  }

  @override
  String toString() {
    return 'Planet{id: $id, name: $name, age: $age, distance from sun: $distancefromsun}';
  }
}