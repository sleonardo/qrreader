import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
           },
          )
        ],
      ),
      body: _crearFlutterMap(context, scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(BuildContext context, ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(context, scan)
      ],
    );
  }

  TileLayerOptions _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
                   '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        //Maps type: streets, dark, light, outdoors, satellite
        'id': 'mapbox.$tipoMapa',
        'accessToken': 'pk.eyJ1Ijoic2xlb25hcmRvOSIsImEiOiJjazBsMWtyYmkwcmh5M25uajl1c2dsYjdzIn0.WcebjLDwpt_5Ee9KC9VWWQ'
      }
    );
  }

  _crearMarcadores(BuildContext context, ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          height: 100.0,
          width: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
               Icons.location_on,
               size: 45.0,
               color: Theme.of(context).primaryColor
            ),
          ),
        )
      ]
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        //Maps type: streets, dark, light, outdoors, satellite
        switch (tipoMapa) {
          case 'streets' :
            tipoMapa = 'dark';  
            break;
          case 'dark' :
            tipoMapa = 'light';
            break;
          case 'light' :
            tipoMapa = 'outdoors';
            break;
          case 'outdoors' :
            tipoMapa = 'satellite';
            break;
          default:
            tipoMapa = 'streets';
            break;
        }
        setState(() {});
       },
    );
  }
}