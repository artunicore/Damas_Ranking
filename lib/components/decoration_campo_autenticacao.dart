import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_comum/minhas_cores.dart';

InputDecoration getAuthenticationInputDecoration(String label, IconData icon ){
  return InputDecoration(
      hintText: label,
      label: Text(label),
      prefixIcon: Icon(icon),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: MinhasCores.rosaClaro, width: 4)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide:
              const BorderSide(color: MinhasCores.rosaTopoGradiente, width: 4)),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.red, width: 4),
      ));
}
