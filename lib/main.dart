import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const ImageOnCanvasApp());
}

class ImageOnCanvasApp extends StatelessWidget {
  const ImageOnCanvasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(appBar: AppBar(title: const Text("Image on canvas example")), body: const ImageOnCanvas()),
    );
  }
}

class ImageOnCanvas extends StatelessWidget {
  const ImageOnCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _loadImage("assets/hello.png"),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Image loading...');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                child: CustomPaint(
                  child: const SizedBox(
                    width: 300,
                    height: 300,
                  ),
                  painter: ImagePainter(snapshot.data!),
                ),
              );
            }
        }
      },
    );
  }
}

Future<ui.Image> _loadImage(String imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  final codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetHeight: 300,
    targetWidth: 300,
  );
  var frame = await codec.getNextFrame();
  return frame.image;
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return false;
  }
}
