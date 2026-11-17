import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Android / iOS / escritorio: guarda el archivo en la carpeta de documentos
/// de la app y devuelve la ruta.
Future<String> guardarArchivo(List<int> bytes, String nombreArchivo) async {
  final Directory carpeta = await getApplicationDocumentsDirectory();
  final File archivo = File('${carpeta.path}/$nombreArchivo');
  await archivo.writeAsBytes(bytes, flush: true);
  return archivo.path;
}
