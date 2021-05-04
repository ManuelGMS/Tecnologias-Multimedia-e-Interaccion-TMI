import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:dsapptmi/ObjDetection/camara.dart';
import 'package:dsapptmi/ObjDetection/boundingBox.dart';
import 'package:dsapptmi/OCR/rekognize.dart';
import 'package:image/image.dart' as imgLib;
import 'dart:convert';

class MyComenzar extends StatefulWidget {
  // Cámara de video.
  final CameraDescription _systemCamera;
  // Recibimos la cámara a través de la constructora.
  MyComenzar(this._systemCamera);
  @override
  _MyComenzar createState() => _MyComenzar();
}

class _MyComenzar extends State<MyComenzar> {
  // Lista de elementos reconocidos en el frame de vídeo.
  List<dynamic> _recognitions;
  CameraImage _frame;
  String _OCRtext; // aqui estan las valiosas palabras
  CloudOCR apiOcr;
  bool isUploaded = false;
  bool loading = false;

  @override
  void initState() {
    /*
    El estado de un widget se inicializa cuando el widget se inserta en
    el arbol de widgets que componen la interfaz de usuario.
    */
    super.initState();

    // Arranca la conexion con el gogle on the line de la nube
    apiOcr = CloudOCR();

    // Carga el modelo de red neuronal y las etiquetas de cada clase.
    Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
  }

  // Método para actualizar la pantalla y los datos asociados a los objetos reconocidos.
  _recognitionsCB(List<dynamic> recognitions) {
    /*
    La llamada a setState le dice al framework Flutter que algo ha cambiado en
    este State, lo que hace que se vuelva a ejecutar el método build, de esta
    forma la pantalla se redibujará para reflejar los cambios.
    */
    setState(() {
      this._recognitions = recognitions;
    });
  }

  // Método dedicado a oscar y aiko los mejores joder. Sirve para guardar el frame
  // del OCR
  _frameOCR(CameraImage oscar) {
    setState(() {
      this._frame = oscar;
    });
  }

  // @override
  // Widget build(BuildContext context) => FutureBuilder(
  //       initialData: false,
  //       future: apiOcr.ocr(""),
  //       builder: (context, snapshot) =>
  //           snapshot.hasData ? _buildWidget(snapshot.data) : const SizedBox(),
  //     );

  @override
  Widget build(BuildContext context) {
    /* Pasamos un CallBack a la cámara para que podamos recuperar a
      través de el la lista de Bounding Boxes. */
    Camera cam; // = Camera(this.widget._systemCamera, _recognitionsCB);
    // peta
    return Scaffold(
        appBar: AppBar(
          title: Text('Comenzar'),
        ),
        // Cuerpo de la página.
        body: Column(children: [
          Expanded(
              // El contenido del panel superior depende de la activación de la cámara.
              child: Stack(
            children: [
              // Muestra lo que devuelve su método "build" (el vídeo grabado).
              // Obtiene la cámara a través del widget asociado este estado.
              cam =
                  Camera(this.widget._systemCamera, _recognitionsCB, _frameOCR),
              if (loading)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (isUploaded)
                Center(
                    child: new Column(children: [
                  new Padding(padding: EdgeInsets.only(top: 50.0)),
                  new Text(
                    _OCRtext,
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
                ])),
              Align(
                alignment: Alignment.bottomCenter,
                child: FutureBuilder(
                    //future: getSwitch('my_vibracion_key'),
                    initialData: false,
                    builder: (context, snapshot) {
                      return FloatingActionButton(
                        child: Icon(
                            Icons.chrome_reader_mode), // Buscar un icono mejor
                        tooltip: 'OCR',
                        // hay que modificar la camara para que haga fotos
                        onPressed: _processImage,
                        //     onPressed: () async {
                        //       print("pulsaoo");
                        //       // Para procesar la dichosa fotito
                        //       String b52 = apiOcr.makeBase64(_frame);

                        //       print("### conversion");
                        //       print(b52);

                        //       if (b52 != "") {
                        //         _OCRtext = await apiOcr.ocr(b52);

                        //         print(
                        //             "######### Me he levantado, no es un buen dia");
                        //         print(_OCRtext);
                        //         print(
                        //             "######### Me he levantado, no es un buen dia");

                        //         // TODO INSERTAR AQUI LO QUE HABLA ALBERTO HASLO COSA FINA FILIPINA
                        //       }

                        //       // Cosas viejas que no antiguas como una fender jaguar de 1964
                        //       /*String b52 = cam.getBase64;
                        // if (b52 != "") {
                        //   Future<String> response = apiOcr.ocr(b52);
                        //   print("OSCARRRRRRRRRRRRRRRRRRRR");
                        //   //print(response);

                        //   // TODO INSERTAR AQUI LO QUE HABLA
                        // }*/
                        //     }
                      );
                    }),
              ),

              /*
              Muestra lo que devuelve su método "build" (los boundding boxes).

              Si no se ha reconocido ningún objeto, entonces no se dibujará
              nada, de lo contrario, pasamos la lista de objetos reconocidos
              y las dimensiones del contexto de este widget.
              */
              BoundingBox(_recognitions == null ? [] : _recognitions)
            ],
          )) /*, // Metodo segun el chisme antiguo
        Align(
          alignment: Alignment.bottomCenter,
          child: FlatButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            //onPressed: _saveImage,
            onPressed: _processImage,
            child: Text('OCR golf day'),
          )
        )*/
        ]));
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Comenzar'),
    //     ),
    //     // Cuerpo de la página.
    //     body: Column(children: [
    //       Expanded(
    //           // El contenido del panel superior depende de la activación de la cámara.
    //           child: Stack(
    //         children: [
    //           // Muestra lo que devuelve su método "build" (el vídeo grabado).
    //           // Obtiene la cámara a través del widget asociado este estado.
    //           cam =
    //               Camera(this.widget._systemCamera, _recognitionsCB, _frameOCR),
    //           Align(
    //             alignment: Alignment.bottomCenter,
    //             child: FloatingActionButton(
    //                 child:
    //                     Icon(Icons.chrome_reader_mode), // Buscar un icono mejor
    //                 tooltip: 'OCR',
    //                 // hay que modificar la camara para que haga fotos
    //                 onPressed: () async {
    //                   print("pulsaoo");
    //                   // Para procesar la dichosa fotito
    //                   String b52 = apiOcr.makeBase64(_frame);

    //                   print("### conversion");
    //                   print(b52);

    //                   if (b52 != "") {
    //                     _OCRtext = await apiOcr.ocr(b52);

    //                     print("######### Me he levantado, no es un buen dia");
    //                     print(_OCRtext);
    //                     print("######### Me he levantado, no es un buen dia");

    //                     // TODO INSERTAR AQUI LO QUE HABLA ALBERTO HASLO COSA FINA FILIPINA
    //                   }

    //                   // Cosas viejas que no antiguas como una fender jaguar de 1964
    //                   /*String b52 = cam.getBase64;
    //                   if (b52 != "") {
    //                     Future<String> response = apiOcr.ocr(b52);
    //                     print("OSCARRRRRRRRRRRRRRRRRRRR");
    //                     //print(response);

    //                     // TODO INSERTAR AQUI LO QUE HABLA
    //                   }*/
    //                 }),
    //           ),

    //           /*
    //           Muestra lo que devuelve su método "build" (los boundding boxes).

    //           Si no se ha reconocido ningún objeto, entonces no se dibujará
    //           nada, de lo contrario, pasamos la lista de objetos reconocidos
    //           y las dimensiones del contexto de este widget.
    //           */
    //           BoundingBox(_recognitions == null ? [] : _recognitions)
    //         ],
    //       )) /*, // Metodo segun el chisme antiguo
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: FlatButton(
    //         color: Colors.blueAccent,
    //         textColor: Colors.white,
    //         //onPressed: _saveImage,
    //         onPressed: _processImage,
    //         child: Text('OCR golf day'),
    //       )
    //     )*/
    //     ]));
  }

  void _processImage() async {
    setState(() {
      loading = true;
    });

    String b52 = apiOcr.makeBase64(_frame);

    print("### conversion");
    print(b52);

    if (b52 != "") {
      _OCRtext = await apiOcr.ocr(b52);

      print("######### Me he levantado, no es un buen dia");
      print(_OCRtext);
      print("######### Me he levantado, no es un buen dia");

      setState(() {
        loading = false;
        isUploaded = true;
      });
    }
  }
}
