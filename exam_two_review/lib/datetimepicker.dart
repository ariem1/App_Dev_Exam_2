import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DatePicker(),
    );
  }
}
class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime currentDate= DateTime.now();

  Future<void> _selectDate(BuildContext context) async{

final DateTime? pickedDate=await showDatePicker(
  context: context, 
  initialDate: currentDate,
  firstDate: DateTime(2020),
  lastDate: DateTime(2030));
if(pickedDate!=null && pickedDate!=currentDate)
    {
    setState(() {
    currentDate=pickedDate;
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Date time picker"),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentDate.toString()),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: ()=> _selectDate(context), 
                child: Text("Select date")),
            Ink(
              decoration: ShapeDecoration(
                  color: Colors.orange,
              shape: CircleBorder()),
              child: IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.email,
                  color: Colors.white,),
                iconSize: 25.0,
              ),

            ),
            ElevatedButton(
                onPressed: _showDialog,
                child: Text("Confirm")
            ), ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
      tooltip: "Move to next screen",
      child: Icon(Icons.self_improvement_outlined),
      ),
    );
  }


  Future<void> _showDialog() async{
    return showDialog(
    context : context,
    barrierDismissible:false,
    builder:(BuildContext context){
      return AlertDialog(
      title: Text("Are you sure"),
    content: SingleChildScrollView(
    child: Column(
    children: [
      Text("Want to connecct to omni"),
    Text("would you like to approve the slides"),
    ],
    ),
    ),
    actions: [
      TextButton(
        onPressed:()
      {
        Navigator.of(context).pop();
      },
    child: Text("Confirm"),
    ),
      TextButton(
        onPressed:()
        {
          Navigator.of(context).pop();
        },
        child: Text("Cancel"),
      ),

    ],
    );
    });
  }
}
