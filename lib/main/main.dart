import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../ui/components/components.dart';
import 'factories/pages/login/login.dart';



void main(){
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return GetMaterialApp(
        title: 'ForDev',
        debugShowCheckedModeBanner: false,
        theme: makeAppTheme(),
        initialRoute: '/login',
        getPages: [
          GetPage(name:'/login',page:makeLoginPage),
          GetPage(name:'/surveys',page:() => Scaffold(body: Center(child: Text('Enquetes'),),)),
        ],
    );
  }
}