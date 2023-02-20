import 'package:flutter/material.dart';
import 'package:uploader_example/video_upload.dart';

const primaryColor = Color(0xFFFA5B30);
const secondaryColor = Color.fromARGB(255, 97, 170, 230);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const UploadVideo(),
    );
  }
}
