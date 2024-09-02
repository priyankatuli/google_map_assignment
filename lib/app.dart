
import 'package:flutter/material.dart';
import 'package:google_map_assignment/ui/screens/map_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       home: MapScreen(),
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
         appBarTheme: const AppBarTheme(
           backgroundColor: Colors.blueAccent,
           foregroundColor: Colors.white
         )
       ),
     );
  }

}