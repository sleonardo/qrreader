import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapasPage extends StatelessWidget {

  final scanBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder <List<ScanModel>>(
      stream: scanBloc.scanStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final scan = snapshot.data;
        if (scan.length == 0) {
          return Center(child: 
            Text('No hay información')
          ); 
        }
        return ListView.builder(
          itemCount: scan.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direccion) => scanBloc.borrarScan(scan[i].id),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),
              title: Text(scan[i].valor),
              subtitle: Text('ID: ${scan[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}