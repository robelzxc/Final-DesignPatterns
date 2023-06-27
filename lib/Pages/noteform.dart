import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '/Widgets/build_text.dart';
import 'package:http/http.dart' as http;
import '/Services/ipt-api.dart';
import '/Services/factory_notes.dart';

class NoteForm extends StatefulWidget {
  final Map? todolist;

  const NoteForm({required this.todolist, Key? key}) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  var userData;
  String? valueChoose;
  List dayitems = [
    "Morning","Afternoon","Evening"
  ];


  bool isEdit = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController schedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final todo = widget.todolist;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];
      titleController.text = title;
      descController.text = desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF303030),
                Color(0xFF424242),
                Color(0xFF757575),
                Color(0xFF9E9E9E),
              ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 50,
            elevation: 0.5,
            backgroundColor: const Color(0xFF303030),
            shadowColor: const Color(0xFF9E9E9E),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            title: Image(image: AssetImage('assets/logo.jpg')),
          ),
          body: Card(
            color: const Color(0xFF757575),
            elevation: 10,
            shadowColor: const Color(0xFF424242),
            shape: const BeveledRectangleBorder(
                side: BorderSide(color: Color(0xFF424242), width: 1.0),
                borderRadius:
                BorderRadius.only(topLeft: Radius.elliptical(25, 50))),
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      isEdit ? 'Update Note' : 'Add Note',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                    buildTextField('Title', titleController),
                    buildTextField2('Description', descController),
                    SizedBox(height: 25,),
                    DropdownButton(
                      hint: Text("Select: "),
                      value: valueChoose,
                      onChanged: (newValue){
                        setState(() {
                          valueChoose = newValue as String?;
                        });
                        Schedule schedule = Schedule(valueChoose as String);
                        schedule.work();
                      },
                      items: dayitems.map((valueItem){
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          isEdit ? updateNote() : addNote();
                        },
                        child: Text(isEdit ? 'Update Note' : 'Add Note')),
                    const SizedBox(height: 40,)
                  ],
                )),
          )),
    );
  }

  void addNote() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString("user");
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
    });
    var data = {
      'userID': userData['id'],
      'title': titleController.text,
      'description': descController.text
    };
    await CallApi().addNote(data, 'add');
    Navigator.pop(context, data);
  }

  void updateNote() async {
    var data = {
      'id': widget.todolist!['id'],
      'title': titleController.text,
      'description': descController.text
    };
    await CallApi().updateNote(data, 'update');
    Navigator.pop(context, widget.todolist);
  }
}
