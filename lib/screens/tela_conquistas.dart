import 'package:flutter/material.dart';

class TelaConquistas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conquistas"),
      ),
      body: Center(
        child: Text("Aqui estão suas conquistas!"),
      ),
    );
  }
}