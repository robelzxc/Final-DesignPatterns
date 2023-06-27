import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/ipt-api.dart';
import 'dart:convert' as convert;

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var userData;

  void _getInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString("user");
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
    });
    nameController.text = userData['name'];
    phoneController.text = userData['phone'];
    addressController.text = userData['address'];
    emailController.text = userData['email'];
    passwordController = userData['password'];
    confirmationController = userData['password'];
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FurCare Information Update'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
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
                    return (value != passwordController.value.text)
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
                      _updateRegister();
                   }
                  }, child: Text('Update data'))
              ],
            )),
      ),
    );
  }
  void _updateRegister() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = {
      'id':userData['id'],
      'name': nameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'email': addressController.text,
      'password': passwordController.text,
      'password_confirmation': confirmationController.text
    };
      await CallApi().updateData(data, 'update');
      setState(() {
      });
      Navigator.pop(context);
  }
}
