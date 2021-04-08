import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';

/*
Definimos un CallBack (una función que puede ser recibida
como parámetro de alguna función de este módulo).
*/
typedef void Callback(List<dynamic> list);

class Camera extends StatefulWidget {
  // CallBack para dar deedback sobre las capturas y el tamaño de los frames.
  final Callback _recognitionsCB;
  // Objeto que representa la cámara de vídeo del sistema.
  final CameraDescription _systemCamera;
  Camera(this._systemCamera, this._recognitionsCB);
  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  // Objeto para controlar la cámara del sistema.
  CameraController cameraController;
  // Booleano para controlar si actualmente hemos detectado algo en el vídeo.
  bool _ssdMobileNetIsNotWorking = false;

  @override
  void initState() {
    /* 
    El estado de un widget se inicializa cuando el widget se inserta en
    el arbol de widgets que componen la interfaz de usuario.
    */
    super.initState();

    // Instanciamos un objeto para controlar la cámara de vídeo.
    this.cameraController = new CameraController(
      this.widget._systemCamera,
      ResolutionPreset.high,
    );

    // Inicializa la cámara de vídeo y permite indicar a esta que debe de hacer.
    this.cameraController.initialize().then((_) {
      /*
      Indica a la cámara que comience un streaming (captura CONTINUAMENTE 
      el vídeo en tiempo real frame a frame).
      */
      this.cameraController.startImageStream((CameraImage currentFrame) {
        /* 
        Si la red neuronal no está clasificando nada, entonces podemos 
        analizar el frame de vídeo actual.
        */
        if (!_ssdMobileNetIsNotWorking) {
          // Indicamos que la red neuronal está analizando y no se admiten frames.
          _ssdMobileNetIsNotWorking = true;
          // Indicamos a TensorFlow que trate de detectar un objeto en la imagen.
          Tflite.detectObjectOnFrame(
            // Proporcionamos a la red "SSD MobileNet" la imagen de entrada.
            bytesList: currentFrame.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            // Dimensiones de la imagen.
            imageHeight: currentFrame.height,
            imageWidth: currentFrame.width,
            // Seguridad de la clasificación (60%).
            threshold: 0.6,
          ).then((recognitions) {
            // Llegamos aquí cuando "SSD MobileNet" ha realizado su clasificación.
            // Indicamos que la red neuronal ya puede volver a clasificar un frame.
            this._ssdMobileNetIsNotWorking = false;
            /* 
            Invocamos a la función CallBack para devolver una lista con las
            imágenes detectadas y el tamaño de todo el frame capturado.
            */
            this.widget._recognitionsCB(recognitions);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // Libera los recursos de la cámara, por lo que se deja de grabar.
    this.cameraController.dispose();
    // Libera los recursos de este estado (es como una llamada a la destructora).
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* 
    Si el objeto que manipula la cámara no está instanciado, devolvemos como 
    imagen un lienzo negro.
    */
    if (this.cameraController == null) Container(color: Colors.black);

    /*
    Si la cámara que manipula el objeto no se ha inicializado, devolvemos como 
    imagen un lienzo negro.
    */
    if (!this.cameraController.value.isInitialized)
      return Container(color: Colors.black);

    // Contenedor cuyo hijo es la grabación de la cámara de vídeo.
    return Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.92,
        child: CameraPreview(this.cameraController));
  }
}
