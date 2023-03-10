import 'package:audioapp/screens/preTest/quiet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/appUser.dart';
import '../../services/database.dart';


const List<String> _genders = <String>[
  'male',
  'female'
];

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}

class ProfileInit extends StatefulWidget {
  const ProfileInit({Key? key}) : super(key: key);

  @override
  State<ProfileInit> createState() => _ProfileInitState();
}

class _ProfileInitState extends State<ProfileInit> {

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int gender = 0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 280,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple[600],
          scrolledUnderElevation: 4.0,
          elevation: 0,
          title: const Text(
            'Complete Profile',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          )),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0, width: double.infinity),
          const Text(
            'Select Date of Birth',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40.0, width: double.infinity),

          Padding(
            padding: const EdgeInsets.all(28.0),
            child: _DatePickerItem(
              children: <Widget>[
                const Text('Date',style: TextStyle(fontSize: 22.0) ,),
                CupertinoButton(
                  // Display a CupertinoDatePicker in date picker mode.
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: date,
                      mode: CupertinoDatePickerMode.date,
                      maximumDate: DateTime.now(),
                      use24hFormat: true,
                      // This is called when the user changes the date.
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => date = newDate);
                      },
                    ),
                  ),
                  // In this example, the date is formatted manually. You can
                  // use the intl package to format the value based on the
                  // user's locale settings.
                  child: Text(
                    '${date.month}-${date.day}-${date.year}',
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40.0, width: double.infinity),
          const Text(
            'Select Gender',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40.0, width: double.infinity),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Gender: ',style: const TextStyle(
                fontSize: 22.0,)),
              CupertinoButton(
                padding: EdgeInsets.zero,
                // Display a CupertinoPicker with list of fruits.
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 45,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                          gender = selectedItem;
                      });
                    },
                    children:
                    List<Widget>.generate(_genders.length, (int index) {
                      return Center(
                        child: Text(
                          _genders[index],
                        ),
                      );
                    }),
                  ),
                ),
                // This displays the selected fruit name.
                child: Text(
                  _genders[gender],
                  style: const TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height:120.0, width: double.infinity),
          ElevatedButton(
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Next',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () async {
              final appUser = Provider.of<AppUser?>(context,listen: false);

              final String formatted_date = '${date.month}-${date.day}-${date.year}';
              await DatabaseService(uid: appUser!.uid).updateUserProfile(
                _genders[gender], formatted_date
              );


            },
          ),


        ],
      ),
    );
  }



}





