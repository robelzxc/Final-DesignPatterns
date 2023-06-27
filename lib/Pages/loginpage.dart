import 'package:flutter/material.dart';
import 'package:ipt_capstone/Pages/navigationpage.dart';
import 'package:ipt_capstone/Services/ipt-api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registerpage.dart';
import 'dart:convert' as convert;


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FurCare Pet Hotel'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email'
                ),
                controller: emailController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password'
                ),
                controller: passwordController,
              ),
              const SizedBox(height: 40,),
              Container(
                child: ElevatedButton(onPressed: () {
                    _login();
                  }, child: Text('Login')),
              ),
              const SizedBox(height: 40,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'Don\'t have an Account?',
                        style: TextStyle(
                          color: Colors.white38,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                          text: ' '
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ])),
              )
            ],
          ),
        ),
      ),
    );
  }
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: (){},
      ),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _login() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text
    };

    var result = await CallApi().postData(data, 'login');
    var body = convert.jsonDecode(result.body);
    print(body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', convert.jsonEncode(body['user']));

      Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationPage()));
    } else {
      _showMsg(body['message']);
    }
  }
}
