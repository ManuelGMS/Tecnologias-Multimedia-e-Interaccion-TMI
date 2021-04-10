import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'storage.dart';
import 'rekognize.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movida oscar -> (ocr)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'TMI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  Uint8List _imageBytes;
  String _imageName;
  String _imageB52;
  final picker = ImagePicker();
  CloudStorage apiStorage;
  CloudOCR apiOcr;
  String lastOCR;
  bool isUploaded = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    lastOCR = "";
    apiStorage = CloudStorage();
    apiOcr = CloudOCR();
    // rootBundle.loadString('assets/maenstorage.json').then((json) {
    //   apiStorage = CloudStorage(json);
    // });
    //apiStorage = CloudStorage(json);
  }

  void _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
        _image = File(pickedFile.path);
        _imageBytes = _image.readAsBytesSync();
        _imageName = _image.path.split('/').last;
        _imageB52 = base64Encode(_imageBytes);
        isUploaded = false;
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveImage() async {
    setState(() {
      loading = true;
    });
    // Sube sube a Google cloud
    final response = await apiStorage.save(_imageName, _imageBytes);
    print(response.downloadLink);
    setState(() {
      loading = false;
      isUploaded = true;
    });
  }

  void _processImage() async {
    setState(() {
      loading = true;
    });

    print("Empiesa el oscar");
    final response = await apiOcr.ocr(_imageB52);
    print(response);

    lastOCR = response;

    setState(() {
      loading = false;
      isUploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: _imageBytes == null
              ? Text('No image selected.')
              : Stack(
                  children: [
                    Image.memory(_imageBytes),
                    if (loading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    isUploaded
                        ? Center(
                            child: new Column(children: [
                            new Padding(padding: EdgeInsets.only(top: 50.0)),
                            new Text(
                              lastOCR,
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  backgroundColor: Colors.black),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 50.0)),
                            new CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ]))
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButton(
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              //onPressed: _saveImage,
                              onPressed: _processImage,
                              //child: Text('Save to cloud'),
                              child: Text('OCR golf day'),
                            ))
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Haga uste foto xfabor',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
/*

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: _MyHomePage()));

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  dynamic _scanResults;
  CameraController _camera;

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  void _initializeCamera() async {
    _camera = CameraController(
      await _getCamera(_direction),
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
    await _camera.initialize();
    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      try {
        // await doSomethingWith(image)
      } catch (e) {
        // await handleExepction(e)
      } finally {
        _isDetecting = false;
      }
    });
  }

  Widget build(BuildContext context) {
    /* 
    Si el objeto que manipula la cámara no está instanciado, devolvemos como 
    imagen un lienzo negro.
    */
    if (this._camera == null) Container(color: Colors.black);

    /*
    Si la cámara que manipula el objeto no se ha inicializado, devolvemos como 
    imagen un lienzo negro.
    */
    if (!this._camera.value.isInitialized)
      return Container(color: Colors.black);

    // Contenedor cuyo hijo es la grabación de la cámara de vídeo.
    return Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.92,
        child: CameraPreview(this._camera));
  }
}
*/
