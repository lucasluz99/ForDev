import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColorLight,
          ),
          labelText: 'Nome'),
    );
  }
}
