import 'dart:developer';
import 'dart:io';
import 'package:uploader_example/main.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadVideo extends StatefulWidget {
  const UploadVideo({Key? key}) : super(key: key);

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {

   @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  File? _videoFile;
  late String _imagePath;
  final ImagePicker _picker = ImagePicker();
  double _progressValue = 0;
  bool showSpinner = false ;

   Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      _controller = VideoPlayerController.file(File(pickedFile.path));
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _uploadVideo(File videoFile) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://fakestoreapi.com/products'));
  request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    setState(() {
        showSpinner = false ;   // Video uploaded successfully
      });
    
  } else {
    print('failed to upload video');  // Video upload failed
  }
}

  void setProgress(double value) async {
    setState(() {
      _progressValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text('Class Shedule'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  MaterialButton(
                    
                    color: primaryColor,
                    child: const Text(
                      "Pick Video from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      var source = ImageSource.gallery;
                      XFile? image = await _picker.pickVideo(source: source);
                      if (image != null) {
                        setState(() {
                          try {
                            _imagePath = image.path;
                          } catch (e) {
                            log("Failed to get video: $e");
                          }
                        });
                      }
                    },
                  ),
                  MaterialButton(
                    color: primaryColor,
                    child: const Text(
                      "Upload video",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      _uploadVideo(_videoFile != null ? _videoFile! : File(_imagePath));
                    },
                  ),
                  LinearProgressIndicator(
                    color: primaryColor,
                    backgroundColor: secondaryColor,
                    value: _progressValue,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}