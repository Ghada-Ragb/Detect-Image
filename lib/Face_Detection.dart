import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Face_Detection extends StatefulWidget {
  const Face_Detection({super.key});

  @override
  State<Face_Detection> createState() => _Face_DetectionState();
}

class _Face_DetectionState extends State<Face_Detection> {
  File? _image;
  List<Face> faces = [];
  String text = '';

  //فانكشن الخاصه باختيار او التقاط الصوره....
  Future _PickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // فانكشن للتعرف على الوجه ....
  /*Future _DetectionFace(File img) async {
    final options = FaceDetectorOptions();
    final faceDetecor = FaceDetector(options: options);
    final inputImage = InputImage.fromFilePath(img.path);
    faces = await faceDetecor.processImage(inputImage);
    setState(() {
      print(faces.length);
    });
  }


  //فانكشن استخراج الكلام من الصوره
  Future textRecognition(File img) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(img.path);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    setState(() {
      text = recognizedText.text;
    });
    print(text); 
  }*/
  Future _processImage(File img) async {
    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final inputImage = InputImage.fromFilePath(img.path);

    // Face detection
    faces = await faceDetector.processImage(inputImage);
    print(faces.length);

    // Text recognition
    final recognizedText = await textRecognizer.processImage(inputImage);
    text = recognizedText.text;
    print(text);

    setState(() {
      // Update the UI state here if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 10,
          shadowColor: const Color.fromARGB(255, 245, 240, 240),
          title: const Center(
            child: Text(
              "Detect Image",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 101, 85, 103),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    height: 280,
                    color: const Color.fromARGB(255, 207, 207, 207),
                    child: Center(
                      child: _image == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 60,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 330,
                    height: 50,
                    color: const Color.fromARGB(255, 177, 153, 194),
                    child: MaterialButton(
                      onPressed: () {
                        _PickImage(ImageSource.camera).then((value) {
                          if (_image != null) {
                            _processImage(_image!);
                          }
                        });
                      },
                      child: const Text(
                        "Take photo from camera",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 330,
                    height: 50,
                    color: const Color.fromARGB(255, 177, 153, 194),
                    child: MaterialButton(
                      onPressed: () {
                        _PickImage(ImageSource.gallery).then((value) {
                          if (_image != null) {
                            _processImage(_image!);
                          }
                        });
                      },
                      child: const Text(
                        "Choose photo from gallery",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Number of persons is : ${faces.length}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 101, 85, 103),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SelectableText(
                    "Text is : ${text}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 101, 85, 103),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
