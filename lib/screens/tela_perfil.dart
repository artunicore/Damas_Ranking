import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gymapp/_comum/meu_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';


class TelaPerfil extends StatefulWidget {
  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  String? _userName;
  String _imageUrl = '';
  String _userDescription = '';
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

Future<void> _saveDescription() async {
  if (_userDescription.isNotEmpty) { 
    print('Descrição salva: $_userDescription');
    
    showSnackBar(
      context: context,
      texto: 'Descrição salva com sucesso!',
      isErro: false,
    );
  } else {
    showSnackBar(
      context: context,
      texto: 'A descrição não pode estar vazia.',
      isErro: true,
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: SingleChildScrollView( // Adicionando SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageUrl.isNotEmpty ? FileImage(File(_imageUrl)) : null,
                    child: _imageUrl.isEmpty ? Icon(Icons.person, size: 50) : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Nome de Usuário: $_userName",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Descrição:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 4,
                onChanged: (value) {
                  setState(() {
                    _userDescription = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite sua descrição aqui',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveDescription,
                child: Text('Salvar Descrição')
                ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
