import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal() {
    //Obtener scans de la Base de datos
    obtenerScan();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();
  Stream<List<ScanModel>> get scanStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scanStreamHttp => _scansController.stream.transform(validarHttp);

  dispose(){
    _scansController?.close();
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScan();
  }

  obtenerScan() async {
    _scansController.sink.add( await DBProvider.db.getTodosScan());
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScan();
  }

  borrarScanTodos() async {
    await DBProvider.db.deleteAll();
    //_scansController.sink.add([]);
    obtenerScan();
    
  }
}