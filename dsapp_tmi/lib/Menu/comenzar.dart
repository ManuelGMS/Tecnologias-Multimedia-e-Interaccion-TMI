import 'package:camera/camera.dart';
import 'package:dsapptmi/APIK/spach.dart';
import 'package:dsapptmi/TextToSpeech/textSpeecher.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:dsapptmi/ObjDetection/camara.dart';
import 'package:dsapptmi/ObjDetection/boundingBox.dart';
import 'package:dsapptmi/OCR/rekognize.dart';

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
  String _OCRtext; // Texto para el OCR
  CloudOCR apiOcr; // Servicio para el OCR
  bool isUploaded = false; // Atributo para controlar el estado del OCR
  bool loading = false; // Atributo para controlar el estado del OCR

  @override
  void initState() {
    /*
    El estado de un widget se inicializa cuando el widget se inserta en
    el arbol de widgets que componen la interfaz de usuario.
    */
    super.initState();

    // Arranca la conexion con Google para el OCR
    apiOcr = CloudOCR();

    // Carga el modelo de red neuronal y las etiquetas de cada clase.
    Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
  }

  // Método para actualizar la pantalla y los objetos reconocidos.
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
  // TTS Para el ImageRecognition
  _recogttsCB(List<dynamic> recognitions) {
    setState(() {
      // Se comprueba que el mapa contenga alguna imagen reconocida.
      if(recognitions.isNotEmpty) {
        if (recognitions[0].containsKey("detectedClass")) {
          var ttsService = TextToSpeechService(
              Spach.ttsAPIKEY); // Obtiene el servicio para el TTS
          String texto = recognitions[0]["detectedClass"]; // Obtenemos el valor de la palabra
          ttsService.textToSpeech(text: texto); // Llamada a la API
        }
      }
    });
  }

  // Para guardar el frame del OCR
  _frameOCR(CameraImage oscar) {
    setState(() {
      this._frame = oscar;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* Pasamos un CallBack a la cámara para que podamos recuperar a
      través de el la lista de Bounding Boxes. */
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
              Camera(this.widget._systemCamera, _recognitionsCB, _frameOCR, _recogttsCB),
              if (loading)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (isUploaded)
                Center(
                    child: new Column(children: [
                  new Padding(padding: EdgeInsets.only(top: 5.0)),
                  new Text(
                    _OCRtext,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        backgroundColor: Colors.black),
                  ),
                ])),
              Align(
                alignment: Alignment.bottomCenter,
                child: FutureBuilder(
                    initialData: false,
                    builder: (context, snapshot) {
                      return FloatingActionButton(
                        child: Icon(
                            Icons.chrome_reader_mode),
                        tooltip: 'OCR',
                        // camara modificada para que haga fotos
                        onPressed: _processImage,
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
          ))
        ]));
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
      // Se llama al TTS para que se reproduzca el texto
      var ttsService =  TextToSpeechService(Spach.ttsAPIKEY);
      // Se ordena al servicio la reproduccion del texto obtenido del OCR
      ttsService.textToSpeech(text:_OCRtext);

      print(_OCRtext);
      setState(() {
        loading = false;
        isUploaded = true;
      });
    }
  }
}
