import 'package:flutter/material.dart';
import 'package:ipt_capstone/Pages/loginpage.dart';
import 'package:ipt_capstone/Pages/notepage.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: LoginPage(),
  ));
}