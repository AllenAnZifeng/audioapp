import 'package:audioapp/models/appUser.dart';
import 'package:audioapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/constants.dart';
import '../../shared/loading.dart';


class SettingForm extends StatefulWidget {
  const SettingForm({Key? key}) : super(key: key);

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {

    final appUser = Provider.of<AppUser?>(context);

    return StreamBuilder<AppUserData>(
      stream: DatabaseService(uid: appUser!.uid).getUserData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AppUserData userData = snapshot.data!;
          return Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Update your brew settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),


                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),

                  const SizedBox(height: 20.0),
                  // dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),
                  // slider
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    activeColor: Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (val) => setState(() => _currentStrength = val.round()),
                  ),
                  // button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(uid: appUser.uid).updateUserData(
                          _currentSugars ?? userData.sugars,
                          _currentName ?? userData.name,
                          _currentStrength ?? userData.strength,
                        );
                      Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }else {
          return Loading();
        }

      }
    );
  }
}
