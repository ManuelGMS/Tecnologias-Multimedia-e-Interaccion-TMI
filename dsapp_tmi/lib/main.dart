import 'Menu/ajustes.dart';
import 'Menu/tutorial.dart';
import 'Menu/comenzar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// **************************************************************************************************
// **************************************************************************************************
// **************************************************************************************************

// Lista con las cámaras del sistema.
List<CameraDescription> systemCameras;

main() async {
  // Para utilizar código asíncrono antes iniciar la aplicación.
  WidgetsFlutterBinding.ensureInitialized();
  try {
    /*
    Función de la librería 'cameras', obtiene
    una lista con las cámaras disponibles para
    su uso. Esta instruccion obtiene la camara
    del sistema, esperando que estas esten
    disponibles. La cámara [0] es la trasera
    del móvil, mientras que la [1] es la cámara
    frontal del móvil.
    */
    systemCameras = await availableCameras();
  } on Exception catch (e) {
    print('Error: $e.message');
  }
  // Cargamos la aplicación.
  //inicializaAjustes();
  runApp(new MyApp());
}

// **************************************************************************************************
// **************************************************************************************************
// **************************************************************************************************

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DSAPP',
      home: MyHome(),
    );
  }
}

// **************************************************************************************************
// **************************************************************************************************
// **************************************************************************************************

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DsApp Menu'),
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
    children: [
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(24.0)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyComenzar(systemCameras[0])),
            );
          },
          child: Text(
              label, style: TextStyle(fontSize: 30, color: Colors.white)),
        ),
      ),
      const SizedBox(height: 40),
    ],
  );
}

Flex _buildButtonTutorial(BuildContext context, String label) {
  return Flex(
    direction: Axis.vertical,
    children: [
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(24.0)),
          ),
          onPressed: () {
            //buscado = false;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyTutorial()),
            );
          },
          child: Text(
              label, style: TextStyle(fontSize: 30, color: Colors.white)),
        ),
      ),
      const SizedBox(height: 40),
    ],
  );
}

Flex _buildButtonAjustes(BuildContext context, String label) {
  return Flex(
    direction: Axis.vertical,
    children: [
      SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(24.0)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAjustes()),
            );
          },
          child: Text(
              label, style: TextStyle(fontSize: 30, color: Colors.white)),
        ),
      ),
      const SizedBox(height: 40),
    ],
  );
}