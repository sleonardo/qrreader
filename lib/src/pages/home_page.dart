import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final scanBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                scanBloc.borrarScanTodos();
              });
            },
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _crearFloatingActionButton(),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          title: Text('Direcciones')
        )
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0: 
        return MapasPage();
      case 1: 
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _crearFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () {
        _scanQR();
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _scanQR() async {

    //http://google.com.co
    //geo:4.676667909195463,-74.04825582941896
    String futureString = 'http://google.com.co'; 
    /* try {
      futureString = await new QRCodeReader()
               .setAutoFocusIntervalInMs(200) // default 5000
               .setForceAutoFocus(true) // default false
               .setTorchEnabled(true) // default false
               .setHandlePermissions(true) // default true
               .setExecuteAfterPermissionGranted(true) // default true
               .scan();
    } catch (e) {
      //futureString = e.toString();
    }
    
    print('Future String: $futureString'); 
    
    if (futureString != null){
      print('Tenemos información');
    } */
    if (futureString != null){
      final scan = ScanModel(valor: futureString);
      scanBloc.agregarScan(scan);
    }
  }
}