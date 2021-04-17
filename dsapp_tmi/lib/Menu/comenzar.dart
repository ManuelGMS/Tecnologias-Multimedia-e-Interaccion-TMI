import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:dsapptmi/ObjDetection/camara.dart';
import 'package:dsapptmi/ObjDetection/boundingBox.dart';

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
              Camera(
                // Obtiene la cámara a través del widget asociado este estado.
                this.widget._systemCamera,
                /*
                Pasamos un CallBack a la cámara para que podamos recuperar a
                través de el la lista de Bounding Boxes.
                */
                _recognitionsCB,
              ),

              //************ OJAL OJAL ver https://codesundar.com/flutter-camera-example/
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.camera), // Buscar un icono mejor
                tooltip: 'OCR',
                // hay que modificar la camarapara que haga fotos
                onPressed: _hacerFoto/*() async {
                  final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
                  await controller.takePicture(path).then((res) => {
                    setState(() {
                        _url = path;
                    })
                  });
              }*/,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              //********** OJAL OJAL

              /*
              Muestra lo que devuelve su método "build" (los boundding boxes).

              Si no se ha reconocido ningún objeto, entonces no se dibujará
              nada, de lo contrario, pasamos la lista de objetos reconocidos
              y las dimensiones del contexto de este widget.
              */
              BoundingBox(_recognitions == null ? [] : _recognitions)
            ],
        ))/*, // Metodo segun el chisme antiguo
        Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              //onPressed: _saveImage,
              onPressed: _processImage,
              child: Text('OCR golf day'),
          ))*/
        ]));
  }
}
