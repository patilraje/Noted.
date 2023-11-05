import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late Future<void> _initializeControllerFuture;
  // ignore: prefer_typing_uninitialized_variables
  var urlImageApi = '';

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    // Next, initialize the controller. This returns a Future.
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  void post(String text) {
    //post to model
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noted!')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Login',
                ),
              ),
            ]),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Capture the image when the "Capture" button is pressed.
            // Ensure that the camera is initialized.
            final ImagePicker _picker = ImagePicker();
            final XFile? pickedFile = await _picker.pickImage(
              source: ImageSource.camera,
            );
            processOCR(pickedFile?.path ?? '').then((String result) {
              setState(() {
                urlImageApi = result;
              });
            });
            print(urlImageApi);
            post(urlImageApi);
            // If the picture was taken, display it on a new screen.
            // await Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DisplayPictureScreen(
            //       // Pass the automatically generated path to
            //       // the DisplayPictureScreen widget.
            //       image: pickedFile,
            //     ),
            //   ),
            // );
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}

// A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final XFile? image;

//   const DisplayPictureScreen({super.key, required this.image});

// //NEW ADDITIONS

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Display the Picture')),
//         // The image is stored as a file on the device. Use the `Image.file`
//         // constructor with the given path to display the image.
//         body: Image.file(File(image!.path)),
//         floatingActionButton: Stack(
//           children: [
//             FloatingActionButton(
//               // Provide an onPressed callback.
//               onPressed: () async {},
//               child: const Icon(Icons.redo),
//             ),
//             FloatingActionButton(
//               // Provide an onPressed callback.
//               onPressed: () async {},
//               child: const Icon(Icons.check),
//             ),
//           ],
//         ));
//   }
// }

Future<String> processOCR(String imagePath) async {
  try {
    final result = await FlutterTesseractOcr.extractText(imagePath);
    print(result);
    return result;
  } catch (e) {
    print("OCR Error: $e");
    return "OCR processing failed.";
  }
}
