import 'package:flutter/material.dart';
import 'package:flutter_gymapp/_comum/meu_snack_bar.dart';
import 'package:flutter_gymapp/_comum/minhas_cores.dart';
import 'package:flutter_gymapp/components/decoration_campo_autenticacao.dart';
import 'package:flutter_gymapp/services/autenticacao_servicos.dart';

import 'tela_inicial.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({Key? key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  AutenticacaoServico _autenServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: MinhasCores.rosaClaro,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MinhasCores.rosaTopoGradiente,
                  MinhasCores.rosaBaixoGradiente,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/logo-damas.png",
                        height: 128,
                      ),
                      const Text(
                        "DamasRank",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: getAuthenticationInputDecoration("E-mail", Icons.person) ,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "O Email não pode ser vazio";
                          }
                          if (value.length < 5) {
                            return "O Email inserido é muito curto, digite um acima de cinco caracteres";
                          }
                          if (!value.contains("@")) {
                            return "Esse email é inválido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getAuthenticationInputDecoration("Senha", Icons.password_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "A senha não pode ser vazia";
                          }
                          if (value.length < 5) {
                            return "A senha inserida é muito curta, limite mínimo de caracteres: 5";
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      if (!queroEntrar) ...[
                        const SizedBox(height: 5),
                        TextFormField(
                          decoration: getAuthenticationInputDecoration(
                              "Confirme a Senha", Icons.password),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "A confirmação de senha não pode ser vazia";
                            }
                            if (value.length < 5) {
                              return "A confirmação de senha inserida é muito curta, limite mínimo de caracteres: 5";
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _nomeController,
                          decoration:
                              getAuthenticationInputDecoration("Nome", Icons.person),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "O Nome não pode ser vazio";
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          botaoPrincipalCLicado(context);
                        },
                        child: Text((queroEntrar) ? "Entrar" : "Cadastrar"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            queroEntrar = !queroEntrar;
                          });
                        },
                        child: Text((queroEntrar)
                            ? "Ainda não tem uma conta? Cadastre-se"
                            : "Já tem uma conta? Entre"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  

  void botaoPrincipalCLicado(BuildContext context) {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;

    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        _autenServico.logarUsuarios(email: email, senha: senha).then((String? erro) {
          if (erro != null) {
            showSnackBar(context: context, texto: erro);
          } else {
            // Login bem-sucedido, navegue para a tela inicial
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InicioTela()),
            );
          }
        });
      } else {
        // Lógica para cadastro de usuário
        _autenServico
            .cadastrarUsuario(nome: nome, senha: senha, email: email)
            .then((String? erro) {
          if (erro != null) {
            //voltou com erro
            showSnackBar(
              context: context,
              texto: erro,
            );
          } else {
            // Cadastro efetuado com sucesso
            showSnackBar(
              context: context,
              texto: "Cadastro efetuado com sucesso",
              isErro: false,
            );
            // Após o cadastro bem-sucedido, navegue para a tela inicial
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InicioTela()),
            );
          }
        });
      }
    }
  }
}
