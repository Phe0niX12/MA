import 'package:flutter/material.dart';
import 'package:flutter_application_1/db_helper.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:provider/provider.dart';
void main(){
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SQLHelperProvider())
      ],
      child: MyApp(),
    )   
  );
  
}
class MyApp extends StatelessWidget{
  @override
  Widget build( BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        ),
      home: HomeScreen(),

    );
  }
}