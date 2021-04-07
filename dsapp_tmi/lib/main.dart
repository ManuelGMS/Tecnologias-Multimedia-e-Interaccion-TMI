import 'Ajustes/ajustes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dsapptmi/Comenzar/comenzar.dart';
import 'package:dsapptmi/Tutorial/tutorial.dart';

// Lista con las cámaras del sistema.
List<CameraDescription> systemCameras;

main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  try {
    /*
    Función de la librería 'cameras', obtiene
    una lista con las cámaras disponibles para
    su uso. Esta instrucción es asíncrona, por
    lo que mientras las cámaras se obtinenen se
    continúa ejecutando, en este caso, cargamos
    la aplicación 'MyApp'. La cámara [0] es la
    trasera del móvil, mientras que la [1] es
    la cámara frontal del móvil.
    */
    systemCameras = await availableCameras();
  } on Exception catch (e) {
    print('Error: $e.message');
  }
  // Cargamos la aplicación.
  runApp(new MyHome());
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('First Route'),
        ),
        body: Center(
            heightFactor: double.infinity,
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: <Widget>[
                _buildButtonComenzar(context, "Comenzar"),
                _buildButtonTutorial(context, "Tutorial"),
                _buildButtonAjustes(context, "Ajustes"),
              ],
            )));
  }
}

Flex _buildButtonComenzar(BuildContext context, String label) {
  return Flex(
    direction: Axis.vertical,

    // mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 300,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyComenzar(systemCameras[0])),
            );
          },
          color: Colors.indigo,
          textColor: Colors.white,
          padding: EdgeInsets.all(24.0),
          child: Text(label, style: TextStyle(fontSize: 30)),
        ),
      ),
      const SizedBox(height: 40),
    ],
  );
}

Flex _buildButtonTutorial(BuildContext context, String label) {
  return Flex(
    direction: Axis.vertical,

    // mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 300,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            //buscado = false;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyTutorial()),
            );
          },
          color: Colors.indigo,
          textColor: Colors.white,
          padding: EdgeInsets.all(24.0),
          child: Text(label, style: TextStyle(fontSize: 30)),
        ),
      ),
      const SizedBox(height: 40),
    ],
  );
}

Flex _buildButtonAjustes(BuildContext context, String label) {
  return Flex(
    direction: Axis.vertical,

    // mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 300,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            //buscado = false;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAjustes()),
            );
          },
          color: Colors.indigo,
          textColor: Colors.white,
          padding: EdgeInsets.all(24.0),
          child: Text(label, style: TextStyle(fontSize: 30)),
        ),
      ),
      const SizedBox(height: 40),
    ],
  );
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Routeadfghjklñ"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
