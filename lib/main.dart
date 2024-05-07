import 'package:flutter/material.dart';
import 'package:flutter_gymapp/screens/autenticacao_tela.dart';
import 'package:flutter_gymapp/screens/tela_inicial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoteadorTela(), // Aqui definimos RoteadorTela como a raiz da aplicação
    );
    
  }
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Usuário logado");
          return InicioTela(); // Se o usuário estiver logado, mostra a tela inicial
        } else {
          return AutenticacaoTela(); // Se o usuário não estiver logado, mostra a tela de autenticação
        }
      },
    );
  }
}
