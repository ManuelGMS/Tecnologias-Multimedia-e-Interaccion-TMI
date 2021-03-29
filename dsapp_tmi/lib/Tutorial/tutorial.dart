import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTutorial extends StatefulWidget {
  MyTutorial({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyTutorial createState() => _MyTutorial();
}


class _MyTutorial extends State<MyTutorial> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tutorial'),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10,top:5,right:5),

          child: ListView(

              children:  <Widget>[
                Text('1. Instrucciones generales: Es necesario conexión a internet para el funcionamiento de la aplicación.\n', style: TextStyle(fontSize: 17)),
                Text( '2. Comenzar: Para empezar a usar la aplicacion, activara la cámara para detectara los semáforos. En la parte inferior derecha de la ventana hay un boton para realizar una foto, si en dicha foto se reconoce un texto, este se mostrara por pantalla y audio.\n', style: TextStyle(fontSize: 17)),
                Text( '3. Tutorial: Explicacion de uso y de los botones de la aplicación.\n', style: TextStyle(fontSize: 17)),
                Text( '4. Ajustes: En la ventana ajustes se compone de dos botones para activar o desactivar la vibracion y los Pop-Ups, respectivamente. Y de un control deslizante para ajustar el volumen de la aplicación.\n', style: TextStyle(fontSize: 17)),
              ]
          ),
        )
    );
  }

}
