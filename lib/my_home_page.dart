import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static const id='myhomepage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  List<TFLiteOutput> _output = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _loading = true;
        _image = File(pickedImage.path);
        _predictImage(_image!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _predictImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    setState(() {
      _loading = false;
      _output = output!
          .map((e) =>
              TFLiteOutput(label: e['label'], confidence: e['confidence']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotton Disease Predictor'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _output.isEmpty
              ? const Center(
                  child: Text('No image selected.'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    _image == null
                        ? Container()
                        : Image.file(
                            _image!,
                            height: 300,
                          ),
                    const SizedBox(height: 20),
                    const Text(
                      'Predictions:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _output.isNotEmpty
                        ? Column(
                            children: _output.map<Widget>((e) {
                              return ListTile(
                                title: Text(e.label ?? 'Unknown'),
                                subtitle: Text(
                                    'Confidence: ${(e.confidence ?? 0.0) * 100}%'),
                              );
                            }).toList(),
                          )
                        : Container(),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class TFLiteOutput {
  final String? label;
  final double? confidence;

  TFLiteOutput({required this.label, required this.confidence});
}
