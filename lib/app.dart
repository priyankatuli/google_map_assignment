
import 'package:flutter/material.dart';
import 'package:google_map_assignment/screens/map_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       home: const MapScreen(),
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
         appBarTheme: const AppBarTheme(
           backgroundColor: Colors.deepPurpleAccent,
           foregroundColor: Colors.white
         )
       ),
     );
  }

}