import 'package:flutter/material.dart';
import 'user.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROOM DATABASE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ROOM DATABASE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller_name = TextEditingController();
  final TextEditingController _controller_phone = TextEditingController();
  final TextEditingController _controller_ssn = TextEditingController();
  final TextEditingController _controller_add = TextEditingController();

  final List<Widget> _details = [];
  User? user_verified;
  User? userUpdate;
  final dbHelper = DatabaseHelper();
  late Function() buttonAction;
  String buttonText = "INSERT USER";

  @override
  void initState() {
    super.initState();
    buttonAction = insertUser;
  }

  //CLEAR
  void clear() {
    _controller_name.text = "";
    _controller_phone.text = "";
    _controller_ssn.text = "";
    _controller_add.text = "";
  }

  //CHECK IF EMPTY
  void checkIfEmpty() {
    if (_controller_name.text.isEmpty &&
        _controller_phone.text.isEmpty &&
        _controller_ssn.text.isEmpty &&
        _controller_add.text.isEmpty) {
      final snackbar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 230,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                'Do not leave any field empty',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 15),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  //INSERT
  Future<void> insertUser() async {
    final name = _controller_name.text;
    final phone = _controller_phone.text;
    final ssn = _controller_ssn.text;
    final address = _controller_add.text;

    if (_controller_name.text.isNotEmpty &&
        _controller_phone.text.isNotEmpty &&
        _controller_ssn.text.isNotEmpty &&
        _controller_add.text.isNotEmpty) {
      final user = User(name: name, phone: phone, ssn: ssn, address: address);
      await dbHelper.insertUser(user);

      user_verified = await dbHelper.getUser(user.name, user.ssn);

      if (user_verified != null) {
        print('Displaying user info');
        addDetailContainer();
        clear();
      }
    }
  }

  //DELETE
  Future<void> deleteUser(String ssn) async {
    await dbHelper.deleteUser(ssn);
    print('Deleting user with SSN: $ssn');

    setState(() {
      _details.removeWhere((element) =>
      (element.key as ValueKey).value == ssn);
    });
  }

  //DISPLAY TO EDIT
  Future<void> displayUserDetails(String ssn, String name) async {
    User? userToUpdate = await dbHelper.getUser(name, ssn);

    print('Editing user with SSN: $ssn');

    //user exists in th db
    //means that a user does exists
    if (userToUpdate != null) {
      _controller_name.text = userToUpdate.name;
      _controller_phone.text = userToUpdate.phone;
      _controller_ssn.text = userToUpdate.ssn;
      _controller_add.text = userToUpdate.address;

      print('Displaying user info to edit');


      //clear()
      setState(() {
        print('UPDATING DB');
        buttonAction = () => updateUser(userToUpdate.ssn, userToUpdate.name);
        buttonText = "UPDATE USER";

      });

    }
  }

  //EDIT
  Future<void> updateUser(String ssn, String name) async {
    print('IN THE UPDATE USER EMTHOD');

    String updatedName = _controller_name.text;
    String updatedPhone = _controller_phone.text;
    String updatedAddress = _controller_add.text;

    //update the USER in the db
    await dbHelper.updateUser(ssn, updatedName, updatedPhone, updatedAddress);

    //get the USER after updating
    User? userUpdated = await dbHelper.getUser(name, ssn);

    //call updatedetailcontainer
    updateDetailContainer(userUpdated!);
    clear();

    setState(() {
      print('UPDATING DB');
      buttonAction = () => insertUser();
      buttonText = "INSERT USER";

    });

  }

  //EDIT CONTAINER
  void updateDetailContainer(User updatedUser) {
    setState(() {
      // Find the index of the container with the updated user
      final index = _details.indexWhere(
          (element) => (element.key as ValueKey).value == updatedUser.ssn);
      if (index != -1) {
        // Replace the old container with a new one with updated data
        _details[index] = Container(
          key: ValueKey(updatedUser.ssn),
          height: 120,
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                child: Icon(
                  Icons.person_outline_outlined,
                  size: 35,
                ),
              ),
              Container(
                width: 260,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(updatedUser.name),
                    Text(updatedUser.phone),
                    Text(updatedUser.ssn),
                    Text(updatedUser.address),
                  ],
                ),
              ),
              Container(
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        deleteUser(user_verified!.ssn);
                      },
                      child: Image.asset(
                        'image/delete.png',
                        width: 20,
                        height: 35,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        updateUser(user_verified!.ssn, user_verified!.name);
                      },
                      child: Image.asset(
                        'image/edit.png',
                        width: 25,
                        height: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  //ADD CONTAINER
  void addDetailContainer() {
    if (user_verified != null) {
      setState(() {
     //   final key = ValueKey(user_verified!.ssn);  // Create a ValueKey
     //   print('Adding container with ValueKey: ${key.value}'); // Print ValueKey value
        _details.add(
          Container(
            key: ValueKey(user_verified!.ssn), // Ensure this is unique
            height: 120,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  child: Icon(
                    Icons.person_outline_outlined,
                    size: 35,
                  ),
                ),
                Container(
                  width: 260,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user_verified!.name),
                      Text(user_verified!.phone),
                      Text(user_verified!.ssn),
                      Text(user_verified!.address),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          deleteUser(user_verified!.ssn);
                        },
                        child: Image.asset(
                          'image/delete.png',
                          width: 20,
                          height: 35,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          displayUserDetails(user_verified!.ssn, user_verified!.name);
                        },
                        child: Image.asset(
                          'image/edit.png',
                          width: 25,
                          height: 23,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _controller_name,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _controller_phone,
                    decoration: const InputDecoration(
                      hintText: 'Contact Phone',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _controller_ssn,
                    decoration: InputDecoration(
                      hintText: 'SSN',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _controller_add,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      checkIfEmpty();
                      buttonAction();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      backgroundColor: Colors.lime,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
            Column(
              children: _details,
            ),
          ],
        ),
      ),
    );
  }

}
