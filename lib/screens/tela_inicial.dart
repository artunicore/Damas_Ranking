import 'package:flutter/material.dart';
import 'autenticacao_tela.dart';
import 'tela_conquistas.dart';
import 'tela_perfil.dart';
import 'package:flutter_gymapp/services/autenticacao_servicos.dart';

class InicioTela extends StatelessWidget {
  const InicioTela({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text("Tela inicial",
                style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.pink[100],
        elevation: 4, // Adicionando uma sombra sutil
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_events, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaConquistas()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 16),
            const Text(
              'Ranking',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 16),
            FutureBuilder<Player?>(
              future: AutenticacaoServico().obterJogadorLogado(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar o jogador: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('Nenhum jogador logado.');
                } else {
                  if (snapshot.data!.nome == 'admin') {
                    return AdminWidget();
                  } else {
                    return JogadorWidget(snapshot.data!);
                  }
                }
              },
            ),
            Expanded(
              child: RankingWidget(),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: const Text("Perfil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaPerfil()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                AutenticacaoServico().deslogar().then((_) {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return AutenticacaoTela();
                  }));
                }).catchError((error) {
                  print("Erro ao deslogar: $error");
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class JogadorWidget extends StatelessWidget {
  final Player jogador;
  final AutenticacaoServico autenticacaoServico = AutenticacaoServico();

  JogadorWidget(this.jogador);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: autenticacaoServico.obterPontuacaoUsuario(),
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Carregando...');
          default:
            return ListTile(
              title: Text(
                '${jogador.nome} - Pontuação: ${snapshot.data ?? jogador.pontuacao}',
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _mostrarDialogoEditarPontuacao(context, jogador);
                },
                child: Text('Editar Pontuação'),
              ),
            );
        }
      },
    );
  }

  Future<void> _mostrarDialogoEditarPontuacao(
      BuildContext context, Player jogador) async {
    TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Pontuação'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Insira a nova pontuação para ${jogador.nome}:'),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                int? novaPontuacao = int.tryParse(controller.text);
                if (novaPontuacao != null) {
                  String? mensagem = await autenticacaoServico
                      .atualizarPontuacaoUsuario(novaPontuacao);
                  if (mensagem != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, insira um valor válido para a pontuação.'),
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}


class AdminWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Você é um administrador.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Você não aparece no ranking, mas pode alterar a pontuação.'),
      ],
    );
  }
}

class RankingWidget extends StatefulWidget {
  @override
  _RankingWidgetState createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingWidget> {
  final AutenticacaoServico autenticacaoServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
      stream: AutenticacaoServico().obterJogadoresDaFirestore(),
      builder: (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Carregando...');
          default:
            List<Player> players = snapshot.data ?? [];
            players.sort((a, b) => b.pontuacao.compareTo(a.pontuacao));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.pink[50],
                  ),
                  child: ListView.separated(
                    itemCount: players.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.transparent, height: 1.0);
                    },
                    itemBuilder: (context, index) {
                      Color backgroundColor;
                      IconData? leadingIcon;
                      if (index == 0) {
                        backgroundColor = Colors.amber[300]!;
                        leadingIcon = Icons.castle_sharp;
                      } else if (index == 1) {
                        backgroundColor = Colors.grey[300]!;
                        leadingIcon = Icons.star_half;
                      } else if (index == 2) {
                        backgroundColor = Colors.orange[600]!;
                        leadingIcon = Icons.star_border;
                      } else {
                        backgroundColor = Colors.pink[100]!;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                              width: 2.0,
                            ),
                          ),
                          child: ListTile(
                            leading: leadingIcon != null
                                ? Icon(leadingIcon, color: Colors.yellow[700])
                                : null,
                            title: Center(
                              child: Text(
                                '${index + 1}. ${players[index].nome} - Pontuação: ${players[index].pontuacao}',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}