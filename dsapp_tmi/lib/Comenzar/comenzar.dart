import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyComenzar extends StatefulWidget {
  MyComenzar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyComenzar createState() => _MyComenzar();
}


class _MyComenzar extends State<MyComenzar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comenzar'),
        ),
      body: const Center(child: Text('Press the button below!')),
      floatingActionButton: FloatingActionButton(
        autofocus: true,
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
  }

}
