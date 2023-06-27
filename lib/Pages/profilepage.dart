import 'package:flutter/material.dart';
import 'package:ipt_capstone/Pages/editpage.dart';
import 'package:ipt_capstone/Pages/loginpage.dart';
import 'package:ipt_capstone/Pages/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  var userData;
  
  @override
  void initState() {
    _getInfo();
    super.initState();
  }
  
  void _getInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text(userData != null ? '${userData['name']} Profile': '')
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.account_circle_rounded),
                Text(userData != null ? '${userData['name']}': '')
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Icon(Icons.phone),
                Text(userData != null ? '${userData['phone']}': '')
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Icon(Icons.location_on),
                Text(userData != null ? '${userData['address']}': '')
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Icon(Icons.email_outlined),
                Text(userData != null ? '${userData['email']}': '')
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditPage()));
                  }, child: Text('Edit')),
                SizedBox(width: 20,),
                ElevatedButton(onPressed: (){
                    logout();
                  }, child: Text('Logout'))
              ],
            )
          ],
        ),
      ),
    );
  }
  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var url = 'https://ipt-todolist.000webhostapp.com/api/logout';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization":"Bearer $token",
        "Accept":"application/json"
      },
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    _showMsg('Logout Sucessfully');

  }
  _showMsg(msg) {
    final snackBar = SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

