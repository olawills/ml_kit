import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class DetailsScreen extends StatefulWidget {
  final String imagePath;
  const DetailsScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final String _imagePath;
  final ImageLabeler = GoogleMlKit.vision.imageLabeler();
  Size? _imageSize;
  List<String> imagesData = [];
  List<String> indexData = [];
  List<String> confidenceData = [];

  // Fetching the image size from the image file
  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  void _recognizeImage() async {
    _getImageSize(File(_imagePath));
    final inputImage = InputImage.fromFilePath(_imagePath);
    final List<ImageLabel> labels = await ImageLabeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String item = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      imagesData.add(item);
      indexData.add(index.toString());
      confidenceData.add(confidence.toString());
    }
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;

    // Initializing the Image Labeler
    final imageLabeler = GoogleMlKit.vision.imageLabeler();
    _recognizeImage();
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the imageLabeler when not used anymore
    ImageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.black,
                  child: AspectRatio(
                    aspectRatio: _imageSize!.aspectRatio,
                    child: Image.file(
                      File(_imagePath),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "CapturedItems  Index   Readings",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            child: SingleChildScrollView(
                              child: imagesData != null
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: imagesData.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(imagesData[index]),
                                            Text(indexData[index]),
                                            Text(confidenceData[index])
                                          ],
                                        );
                                      })
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.blue,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
