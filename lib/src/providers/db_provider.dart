
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  //CREATE Crear registros
  nuevoScanModel(ScanModel nuevoScan) async {
    final sqlInsert = "INSERT Into Scans (id, tipo, valor) "
                      "VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')";
    final db        = await database;
    final result    = await db.rawInsert(sqlInsert); 
    return result;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db     = await database;
    final result = await db.insert('Scans', nuevoScan.toJson());
    return result;
  }
  //SELECT - Obtener información
  Future<ScanModel> getScanId(int id) async {
    final db     = await database;
    final result = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? ScanModel.fromJson(result.first) : null;
  }

  Future<List<ScanModel>> getTodosScan() async {
    final db             = await database;
    final result         = await db.query('Scans');
    List<ScanModel> list = result.isNotEmpty ? result.map((s) => ScanModel.fromJson(s)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final sqlScan        = "SELECT * FROM Scans WHERE tipo='$tipo'";
    final db             = await database;
    final result         = await db.rawQuery(sqlScan);
    List<ScanModel> list = result.isNotEmpty ? result.map((s) => ScanModel.fromJson(s)).toList() : [];
    return list;
  }

  //UPDATE - Actualizar información
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db     = await database;
    final result = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    return result;
  } 

  //DELETE - Eliminar información
  Future<int> deleteScan(int id) async {
    final db     = await database;
    final result = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteAll() async {
    final sqlDelete = 'DELETE FROM Scans';
    final db        = await database;
    final result    = await db.rawDelete(sqlDelete);
    return result;
  }
}