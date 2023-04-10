import 'dart:math';
import 'package:audioapp/screens/authenticate/authHome.dart';
import 'package:audioapp/screens/profile/test2Result.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'test1Result.dart';
import '../../models/appUser.dart';
import '../../services/auth.dart';

class Profile extends StatefulWidget {

  final int? initIndex;
  const Profile({Key? key, this.initIndex, }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  int tabIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    if (widget.initIndex != null) {
      setState(() {
        tabIndex = widget.initIndex!;
      });
      _tabController!.index = widget.initIndex!;

    }

  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabSelection);
    _tabController?.dispose();

    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        tabIndex = _tabController!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    final appUser = Provider.of<AppUser?>(context);
    final appUserData = Provider.of<AppUserData?>(context);

    if (appUser == null || appUserData == null) {
      return const AuthHome();
    }

    Widget _buildTab({required bool isSelected, required int number}) {
      // print(_tabController!.index);
      return Tab(
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/test$number.png',
                width: 25,
                height: 25,
                color: isSelected
                    ? Colors.white
                    : Colors.grey[500],
              ),
               Padding(
                padding: EdgeInsets.only(left: 14.0),
                child: Text('Test $number',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isSelected
                          ? Colors.white
                          : Colors.grey[500],
                    )),
              )
            ],
          ));
    }

    return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.purple[600],
                scrolledUnderElevation: 4.0,
                elevation: 0,
                title: const Text(
                  'Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.pink[50],
                    ),
                    label: const Text('logout',
                        style: TextStyle(
                          fontSize: 18.0,
                        )),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => {GoRouter.of(context).go('/home')},
                    icon: Icon(
                      Icons.home,
                      color: Colors.pink[50],
                    ),
                    label: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text('Home',
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
                bottom: TabBar(
                  indicatorColor: Colors.black,
                  controller: _tabController,
                  tabs: [
                    _buildTab(isSelected: tabIndex == 0, number: 1),
                    _buildTab(isSelected: tabIndex == 1, number: 2),
                    _buildTab(isSelected: tabIndex== 2, number: 3),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  Test1Result(),
                  Test2Result(),
                  Icon(Icons.directions_bike),
                ],
              ),
            ),
          );
  }
}
