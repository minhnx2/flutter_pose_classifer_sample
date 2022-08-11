import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pose_classifier_pkg/extension/pose_classifier/pose_detector_processor.dart';
import 'package:flutter_pose_classifier_pkg/flutter_pose_classifier_pkg.dart';
import 'package:flutter_pose_classifier_pkg/widget/const/color_constant.dart';

const POSE_SAMPLE_PATH = 'assets/pose/fitness_pose_samples.csv';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var cameras = await availableCameras();
  MLPoseClassifier.init(POSE_SAMPLE_PATH, cameras);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _text;

  void _incrementCounter(PoseWithClassification classification) {
    var resultInText = "";

    for (Map<String, int> result in classification.classificationResult) {
      for (String className in result.keys) {
        resultInText += "$className: ${result[className]}, ";
      }
    }

    setState(() {
      _text = resultInText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            MLPoseClassifierContent(
              onClassifiedCallback: _incrementCounter,
            ),
            Positioned(
              top: 50,
              left: 50,
              right: 50,
              child: Center(
                child: Text(
                  _text ?? "0",
                  style: TextStyle(
                    color: ColorConstants.cardioColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
