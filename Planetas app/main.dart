import 'package:flutter/material.dart';
import 'package:myapp/modelos/planeta.dart';
import 'package:myapp/telas/tela_planeta.dart';
import 'controles/controles_planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'app planetas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _atualizarPlanetas();
  }

  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaPlaneta(
              isIncluir: true,
              planeta: Planeta.vazio(),
              onFinalizado: () {
                _atualizarPlanetas();
              },
            ),
      ),
    );
  }

  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaPlaneta(
              isIncluir: false,
              planeta: planeta,
              onFinalizado: () {
                _atualizarPlanetas();
              },
            ),
      ),
    );
  }

  void _excluirPlaneta(int? id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmação"),
        content: const Text("Tem certeza que deseja excluir este planeta?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await _controlePlaneta.excluirPlaneta(id);
              _atualizarPlanetas();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Planeta excluído com sucesso!")),
              );
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
            title: Text(planeta.nome),
            subtitle: Text(planeta.apelido!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _alterarPlaneta(context, planeta),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _excluirPlaneta(planeta.id),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _incluirPlaneta(context),
        tooltip: 'Adicionar planeta',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
