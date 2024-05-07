import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> cadastrarUsuario({
    required String nome,
    required String senha,
    required String email,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: senha);
      await FirebaseAuth.instance
          .authStateChanges()
          .firstWhere((user) => user != null);
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(nome);
        await _firestore.collection('usuarios').doc(currentUser.uid).set({
          'nome': nome,
          'email': email,
          'pontuacao': 0,
          'isAdmin': false,
        });
        return 'Usuário cadastrado com sucesso';
      } else {
        return "Erro ao cadastrar usuário";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "O usuário já está cadastrado";
      }
      return "Erro desconhecido";
    }
  }

Stream<List<Player>> obterJogadoresDaFirestore() {
  return _firestore.collection('usuarios').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Player(
        nome: data['nome'],
        pontuacao: data['pontuacao'],
        posicao: 0,
        isAdmin: data['isAdmin'] ?? false,
      );
    }).toList();
  });
}


  Future<String?> logarUsuarios({
    required String email,
    required String senha,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> deslogar() async {
    return _firebaseAuth.signOut();
  }

  String? obterNomeUsuario() {
    return _firebaseAuth.currentUser?.displayName;
  }

  Future<String?> atualizarNomeUsuario(String novoNome) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(novoNome);
      return 'Nome de usuário atualizado com sucesso';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Stream<int?> obterPontuacaoUsuario() {
  String? uid = _firebaseAuth.currentUser?.uid;
  if (uid != null) {
    return _firestore.collection('usuarios').doc(uid).snapshots().map((snapshot) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        return data['pontuacao'] as int;
      }
      return null;
    });
  }
  return Stream.value(null);
}


  Future<String?> atualizarPontuacaoUsuario(int novaPontuacao) async {
    try {
      String? uid = _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        await _firestore.collection('usuarios').doc(uid).update({
          'pontuacao': novaPontuacao,
        });
        return 'Pontuação do usuário atualizada com sucesso';
      }
      return 'Usuário não encontrado';
    } catch (e) {
      return "Erro ao atualizar pontuação do usuário: $e";
    }
  }

  Future<Player?> obterJogadorLogado() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('usuarios').doc(user.uid).get();
        Map<String, dynamic>? data =
            snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          return Player(
            nome: data['nome'],
            pontuacao: data['pontuacao'],
            posicao: 0,
            isAdmin: data['isAdmin'] ?? false,
          );
        }
      }
      return null;
    } catch (e) {
      print("Erro ao obter jogador logado: $e");
      return null;
    }
  }
}

class Player {
  final String nome;
  final int pontuacao;
  final int posicao;
  final bool isAdmin;

  Player({
    required this.nome,
    required this.pontuacao,
    required this.posicao,
    required this.isAdmin,
  });
}
