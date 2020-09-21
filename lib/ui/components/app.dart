import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final primaryColor = Color.fromRGBO(136, 14, 79, 1);
    final primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
    final primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    return MaterialApp(
        title: 'ForDev',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: primaryColor,
            primaryColorDark: primaryColorDark,
            primaryColorLight: primaryColorLight,
            accentColor: primaryColor,
            backgroundColor: Colors.white,

            textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: primaryColorDark)),

            inputDecorationTheme: InputDecorationTheme(
              alignLabelWithHint: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColorLight),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor))),
                    
            
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(primary:primaryColor),
              buttonColor: primaryColor,
              splashColor: primaryColorLight,
              padding: const EdgeInsets.symmetric(vertical:10,horizontal: 20),
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))
            )
            ),

            
        home: LoginPage());
  }
}
