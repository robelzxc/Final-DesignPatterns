import 'package:flutter/material.dart';

Widget buildTextField(String hint, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.all(4),
    child: TextField(
      decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              )
          )
      ),
      controller: controller,
    ),
  );
}
Widget buildTextField2(String hint, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.all(4),
    child: TextField(
      minLines: 5,
      maxLines: 10,
      decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              )
          )
      ),
      controller: controller,
    ),
  );
}