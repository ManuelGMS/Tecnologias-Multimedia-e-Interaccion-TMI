import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool vibracion;
bool popups;
double currentSliderValue = 20;

class MyAjustes extends StatefulWidget {
  MyAjustes({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAjustes createState() => _MyAjustes();
}

class _MyAjustes extends State<MyAjustes> {
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
              ],
            )));
  }

  Widget _switchVibracion(String label) {
    return FutureBuilder(
        future: getSwitch('my_vibracion_key'),
        initialData: false,
        builder: (context, snapshot) {
          return SwitchListTile(
            title: Text(label),
            value: snapshot.data,
            onChanged: (bool value) {
              setState(() {
                setSwitch('my_vibracion_key', value);
              });
              //print(value);
            },
            secondary: const Icon(Icons.lightbulb_outline),
          );
        });
  }

  Widget _switchPopups(String label) {
    return FutureBuilder(
        future: getSwitch('my_popups_key'),
        initialData: false,
        builder: (context, snapshot) {
          return SwitchListTile(
            title: Text(label),
            value: snapshot.data,
            onChanged: (bool value) {
              setState(() {
                setSwitch('my_popups_key', value);
              });
              //print(value);
            },
            secondary: const Icon(Icons.lightbulb_outline),
          );
        });
  }

  Widget _sliderVolumen() {
    return FutureBuilder(
        future: getSlider('my_slider_key'),
        initialData: false,
        builder: (context, snapshot) {
          return Slider(
            value: currentSliderValue,
            min: 0,
            max: 50,
            label: currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                setSlider('my_slider_key', value);
              });
            },
          );
        });
  }

  void setSwitch(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  Future getSwitch(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //bool val = prefs.getBool(key) == null ? false : (prefs.getBool(key));
    bool val = prefs.getBool(key) ?? false;
    return val;
  }

  void setSlider(String key, double val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, val);
  }

  Future getSlider(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //double val = prefs.getDouble(key) == null ? false : (prefs.getDouble(key));
    double val = prefs.getDouble('my_slider_key') ?? 20.0;
    currentSliderValue = val;
    return val;
  }
}
