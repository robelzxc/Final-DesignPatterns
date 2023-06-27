import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ipt_capstone/Pages/emailverification.dart';
import 'package:ipt_capstone/Pages/loginpage.dart';
import 'navigationpage.dart';
import 'package:ipt_capstone/Services/ipt-api.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var userData;
  var userToken;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationController = TextEditingController();


  var formKey = GlobalKey<FormState>();

  void _getInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var userJson = localStorage.getString('user');
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
      userToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FurCare Registration'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: fnameController,
                  validator: (value) {
                    return (value == '')
                        ? 'Please enter your first name'
                        : null;
                  },
                  decoration: InputDecoration(hintText: 'First name'),
                ),
                TextFormField(
                  controller: lnameController,
                  validator: (value) {
                    return (value == '') ? 'Please enter your last name' : null;
                  },
                  decoration: InputDecoration(hintText: 'Last name'),
                ),
                TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    return (value == '')
                        ? 'Please enter your phone number'
                        : null;
                  },
                  decoration: InputDecoration(hintText: 'Phone number'),
                ),
                TextFormField(
                  controller: addressController,
                  validator: (value) {
                    return (value == '') ? 'Please enter your address' : null;
                  },
                  decoration: InputDecoration(hintText: 'Address'),
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter your email address';
                    } else {
                      return (!EmailValidator.validate(value!))
                          ? 'Invalid email address'
                          : null;
                    }
                  },
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    return (value == '') ? 'Please enter your password' : null;
                  },
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                TextFormField(
                  controller: confirmationController,
                  validator: (value) {
                    return (value != passwordController.text)
                        ? 'Password dont match'
                        : null;
                  },
                  decoration: InputDecoration(hintText: 'Confirm Password'),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(onPressed: () {
                    var isFormValid = formKey.currentState!.validate();
                    if(isFormValid){
                       _handleRegister();
                    }
                  }, child: Text('Sign up'))
              ],
            )),
      ),
    );
  }

  void _handleRegister() async {
    var fullname = '${fnameController.text} ${lnameController.text}';
    var data = {
      'name': fullname,
      'phone': phoneController.text,
      'address': addressController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': confirmationController.text
    };

    var result = await CallApi().postData(data, 'register');
    var body = convert.jsonDecode(result.body);
    if(body['success']){
      _showMsg(body['message']);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', convert.jsonEncode(body['user']));
      setState(() {

      });

      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    }
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

