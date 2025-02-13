import 'package:myapp/modelos/planeta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ControlePlaneta {
  static Database? _bd;

  Database get bd {
    if (_bd != null) return _bd!;
    _bd = _initBD('planetas.db') as Database?;
    return _bd!;
  }

  Future<Database> _initBD(String localAquivo) async {
    final caminhoBD = getDatabasesPath();
    final caminho = join(await caminhoBD, localAquivo);
    return await openDatabase(caminho, version: 1, onCreate: _criarBD);
  }

  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
          CREATE TABLE planetas(
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             nome TEXT NOT NULL,
             tamanho REAL NOT NULL,
             distancia REAL NOT NULL,
             apelido TEXT
             );
             ''';
    await bd.execute(sql);
  }

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final result = await db.query('planetas');
    return result.map((map) => Planeta.fromMap(map)).toList();
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert('Planetas', planeta.toMap());
  }

  Future<int> excluirPlaneta(int? id) async {
    final db = await bd;
    return await db.delete(
      'Planetas',
       where: 'id = ?',
       whereArgs: [id]);
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return db.update(
      'Planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }
}
