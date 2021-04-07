import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:dsapptmi/Camara/camara.dart';
import 'package:dsapptmi/BoundingBox/boundingBox.dart';

class MyComenzar extends StatefulWidget {
  // Cámara de video.
  final CameraDescription _systemCamera;
  // Recibimos la cámara a través de la constructora.
  MyComenzar(this._systemCamera);
  @override
  _MyComenzar createState() => _MyComenzar();
}

class _MyComenzar extends State<MyComenzar> {
  // Para controlar si grabar o no.
  bool _stopCamera = true;
  // Lista de elementos reconocidos en el frame de vídeo.
  List<dynamic> _recognitions;

  @override
  void initState() {
    /* 
    El estado de un widget se inicializa cuando el widget se inserta en
    el arbol de widgets que componen la interfaz de usuario.
    */
    super.initState();
    // Carga el modelo de red neuronal y las etiquetas de cada clase.
    Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
  }

  // Método para detener la grabación de vídeo.
  _stop() {
    /*
    La llamada a setState le dice al framework Flutter que algo ha cambiado en 
    este State, lo que hace que se vuelva a ejecutar el método build, de esta
    forma la pantalla se redibujará para reflejar los cambios.
    */
    setState(() {
      _stopCamera = true;
    });
  }

  // Método para activar la grabación de vídeo.
  _start() {
    /* 
    La llamada a setState le dice al framework Flutter que algo ha cambiado en 
    este State, lo que hace que se vuelva a ejecutar el método build, de esta
    forma la pantalla se redibujará para reflejar los cambios.
    */
    setState(() {
      _stopCamera = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // Cuerpo de la página.
        body: Column(children: [
          Expanded(
              // El contenido del panel superior depende de la activación de la cámara.
              child: (_stopCamera)
                  // Mostramos un lienzo negro mientras la cámara no esté activa.
                  ? Container(color: Colors.black)
                  // Pila de elementos, en este caso, "BoundingBox" sobre "Camera".
                  : Stack(
                      children: [
                        // Muestra lo que devuelve su método "build" (el vídeo grabado).
                        Camera(
                          // Obtiene la cámara a través del widget asociado este estado.
                          this.widget._systemCamera,
                          /* 
                          Pasamos un CallBack a la cámara para que podamos recuperar a
                          través de el la lista de Bounding Boxes. 
                          */
                          _recognitionsCB,
                        ),
                        // Muestra lo que devuelve su método "build" (los boundding boxes).
                        BoundingBox(
                          /*
                          Si no se ha reconocido ningún objeto, entonces no se dibujará
                          nada, de lo contrario, pasamos la lista de objetos reconocidos
                          y las dimensiones del contexto de este widget.
                          */
                          _recognitions == null ? [] : _recognitions,
                          MediaQuery.of(context).size.height * 0.94,
                          MediaQuery.of(context).size.width,
                        )
                      ],
                    )),
          // Fila con los dos botones "Comenzar" y "Parar", componen el panel inferior.
          Row(children: [
            Flexible(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      child: const Text(
                        "Comenzar",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => _start())),
            ),
            Flexible(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      child: const Text(
                        "Parar",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => _stop())),
            )
          ])
        ]));
  }
}
