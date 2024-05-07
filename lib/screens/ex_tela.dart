import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gymapp/_comum/minhas_cores.dart';
import 'package:flutter_gymapp/models/ex_modelo.dart';
import 'package:flutter_gymapp/models/sentimento_modelo.dart';

class ExercicioTela extends StatelessWidget {
  ExercicioTela({super.key});

  final ExercicioModels exercicioModels = ExercicioModels(
      id: "Ex001",
      name: "Remada maldita dos infernos",
      treino: "treino A",
      comoFazer: "reza fir kkkkk");

  final List<SentimentoModel> listaSentimentos = [
    SentimentoModel(
        id: "SE001", sentindo: "Pouca ativação", data: "2024-05-03"),
    SentimentoModel(id: "SE002", sentindo: "Dor nas perna", data: "2024-05-03"),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MinhasCores.rosaTopoGradiente,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              exercicioModels.name,
              style: const TextStyle(fontWeight: FontWeight.bold, 
              fontSize: 22),
            ),
            Text(
              exercicioModels.treino,
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Foi Clicadooo");
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: MinhasCores.rosaClaro, borderRadius: BorderRadius.circular(16)),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Enviar Foto"),
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Tirar foto")),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Como Fazer?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(exercicioModels.comoFazer),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(color: Colors.black),
            ),
            const Text(
              "Como estou me sentindo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(listaSentimentos.length, (index) {
                SentimentoModel estouSentindo = listaSentimentos[index];
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(estouSentindo.sentindo),
                  subtitle: Text(estouSentindo.data),
                  leading: const Icon(Icons.double_arrow_rounded),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.black,
                    onPressed: () {
                      print("DELETAR ${estouSentindo.sentindo}");
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
