import 'package:flutter/material.dart';
import 'package:dsapptmi/TextToSpeech/textSpeecher.dart';

class MyAjustes extends StatefulWidget {
  MyAjustes({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAjustes createState() => _MyAjustes();
}

class _MyAjustes extends State<MyAjustes> {
  bool vibracion = false;
  bool popups = false;
  double currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ajustes'),
        ),
        body: Center(
            heightFactor: double.infinity,
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: <Widget>[
                _switchVibracion("Desactivar vibración"),
                _switchPopups("Desactivar Pop-Ups"),
                _sliderVolumen(),
                TextToSpeech("Preuba TTS"),
              ],
            )));
  }

  Widget _switchVibracion(String label) {
    return SwitchListTile(
      title: Text(label),
      value: vibracion,
      onChanged: (bool value) {
        setState(() {
          vibracion = value;
        });
        //print(value);
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }

  Widget _switchPopups(String label) {
    return SwitchListTile(
      title: Text(label),
      value: popups,
      onChanged: (bool value) {
        setState(() {
          popups = value;
        });
        //print(value);
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
  Widget TextToSpeech(String label) {
    return SwitchListTile(
      title: Text(label),
      value: popups,
      onChanged: (bool value) {
        var _aux = TextToSpeechAPI();
        _aux.synthesizeText("Hola esto es una prueba y va a funcionar");
        //print(value);
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }

  Widget _sliderVolumen() {
    return Slider(
      value: currentSliderValue,
      min: 0,
      max: 50,
      label: currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          currentSliderValue = value;
        });
      },
    );
  }
}
