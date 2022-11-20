import 'package:flutter/material.dart';
import 'package:news_app/Screen/signup.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // late TabController _tabController;
  TabBar get _tabBar => TabBar(
    // controller: _tabController,
    unselectedLabelColor: Colors.black,
    // overlayColor: ,
    labelColor: Colors.white,
    splashBorderRadius: BorderRadius.circular(25),
    indicator: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25)
        )
    ),
    tabs: [
      Tab(text: "LOGIN",),
      Tab(text: "SIGN UP",)
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _tabController = new TabController(vsync: this, length: 2);

  }

  // changeMyTab(){
  //   setState(() {
  //     _tabController.index = 2;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          shape:RoundedRectangleBorder(
            side:  BorderSide(
              color: Colors.deepOrange,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.red,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar
          )
          ),
          title: Text("SocialX",style: TextStyle(
              color: Colors.white,
              fontSize: 25
          ),),
        ),
        body: TabBarView(
          // controller: _tabController,
          children: [
            Login(),
            SignUp()
          ],
        )
      ),
    );
  }
}
