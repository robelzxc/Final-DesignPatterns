import '/Services/ipt-api.dart';
import 'noteform.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List usersInfo = <dynamic>[];
  var userData;

  @override
  void initState() {
    _getID();
    _getData();
    super.initState();
  }

  // void _getNotes() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   var url = 'http://10.0.2.2:8000/api/todo';
  //   var response = await http.get(Uri.parse(url), headers: {
  //     "Authorization": "Bearer $token",
  //     "Accept": "application/json"
  //   });
  //   setState(() {
  //     usersInfo = convert.jsonDecode(response.body) as List<dynamic>;
  //   });
  // }
  void _getID() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var userJson = localStorage.getString("user");
    var user = convert.jsonDecode(userJson.toString());
    var url = 'https://ipt-todolist.000webhostapp.com/api/user/todos/${user['id']}';
    print(user['id']);
    var response = await http.get(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        });
    setState(() {
      usersInfo = convert.jsonDecode(response.body) as List<dynamic>;
    });
  }
  void _getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString("user");
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
    });
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
          title: Text(userData != null ? userData['name'] + ' Notes' : "",
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          toolbarHeight: 50,
          elevation: 0.5,
          backgroundColor: const Color(0xFF0097A7),
          shadowColor: const Color(0xFF006064),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
        ),
        body: ListView.builder(
            itemCount: usersInfo.length,
            itemBuilder: (context, index) {
              final notes = usersInfo[index] as Map;
              return Card(
                color: const Color(0xFFE0F7FA),
                elevation: 10,
                shadowColor: const Color(0xFF00838F),
                shape: const BeveledRectangleBorder(
                    side: BorderSide(color: Color(0xFF0097A7), width: 1.0),
                    borderRadius:
                    BorderRadius.only(topLeft: Radius.elliptical(25, 50))),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.only(left: 30.0, right: 30.0),
                  title: Text(
                    usersInfo[index]["title"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  subtitle: Text(
                    usersInfo[index]["description"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  trailing: PopupMenuButton(onSelected: (value) async {
                    if (value == 'edit') {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoteForm(todolist: notes)));
                      setState(() {
                        //_getNotes();
                        _getID();
                      });
                    } else if (value == 'delete') {
                      CallApi().deleteNote(
                          'delete/', usersInfo[index]['id'].toString());
                      setState(() {
                        //_getNotes();
                        _getID();
                      });
                    }
                  }, itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                          value: 'edit', child: Text('Edit Note')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete Note')),
                    ];
                  }),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteForm(todolist: null)));
            setState(() {
              _getID();
            });
          },
          backgroundColor: const Color(0xFF0097A7),
          elevation: 30,
          hoverColor: const Color(0xFF4DD0E1),
          child: const Icon(Icons.note_add),
        ),
      ),
    );
  }
}
