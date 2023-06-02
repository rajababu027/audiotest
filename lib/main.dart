import 'package:audiotest/screens/home.dart';
import 'package:audiotest/voic_%20recording/audio_record.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audio Recorder',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: Home(),
      home: AudioRecordScreen(),
    );
  }
}
