
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

launchURL(BuildContext context, ScanModel scanModel) async {
  
  if (scanModel.tipo == 'http'){
    if (await canLaunch(scanModel.valor)) {
      await launch(scanModel.valor);
    } else {
      throw 'Could not launch ${scanModel.valor}';
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scanModel);
  }
}
