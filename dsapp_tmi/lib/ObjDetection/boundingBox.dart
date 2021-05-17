import 'package:flutter/material.dart';

class BoundingBox extends StatelessWidget {
  // Lista de elementos reconocidos en el frame de vídeo.
  final List<dynamic> _recognitions;

  // Crea una instancia con los valores recibidos.
  BoundingBox(this._recognitions);

  List<Widget> _calculateBoundingBoxes(double screenH, double screenW) {
    /* 
    Mapeamos cada elemento "re" de los objetos que han sido reconocidos 
    ("_recognitions") por una función anónima que calculará cada Bounding Box.
    */

    return _recognitions.map((re) {
      // Positioned es un elemento que permite indicar donde se ubica su hijo.
      return (re["detectedClass"] != "???")
          ? Positioned(
              // Ubicación y dimiensiones del objeto hijo.
              left: re["rect"]["x"] * screenW,
              top: re["rect"]["y"] * screenH,
              width: re["rect"]["w"] * screenW,
              height: re["rect"]["h"] * screenH,
              // Contenedor que enmarca al objeto detectado.
              child: Container(
                // Margen para el contenido interno.
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                // Decoramos el contenedor con un marco.
                decoration: BoxDecoration(
                  // Estilo de todo el borde de la caja (color y anchura).
                  border: Border.all(
                    color: Color.fromRGBO(255, 255, 255, 1.0),
                    width: 4.0,
                  ),
                ),
                // El elento hijo del contenedor es un texto.
                child: Text(
                  // El texto muestra la clase de pertenencia y el grado de pentenencia.
                  "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(2)}%",
                  // Estilo del texto (color, tamaño y tipo de fuente).
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1.0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  decoration: BoxDecoration(
                // Estilo de todo el borde de la caja (color y anchura).
                border: Border.all(
                  width: 0.0,
                ),
              )));
    }).toList(); // Devolvemos las Bounding Boxes en una misma lista.
  }

  @override
  Widget build(BuildContext context) {
    // Devolvemos todos los Bunding Boxes (Marcos que envuelven a las imágenes).
    return Stack(
        // Los hijos de esta pila son los Bounding Boxes.
        children: _calculateBoundingBoxes(
            // Alto de la pantalla.
            MediaQuery.of(context).size.height * 0.92,
            // Ancho de la pantalla.
            MediaQuery.of(context).size.width));
  }
}
