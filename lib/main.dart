import 'package:chatbot/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart';

void main() async {
  // var byteData = await rootBundle
  //    .load('packages/timezone/data/${tzDataDefaultFilename}');
 // initializeDatabase(byteData.buffer.asUint8List());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepOrange
    ),
    home: HomePage(),
  )
  );
}
