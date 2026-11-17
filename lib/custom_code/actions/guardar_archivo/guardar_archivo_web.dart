import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Web: crea un Blob y lo descarga en el navegador.
Future<String> guardarArchivo(List<int> bytes, String nombreArchivo) async {
  final web.Blob blob = web.Blob(
    [Uint8List.fromList(bytes).toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),
  );
  final String url = web.URL.createObjectURL(blob);
  final web.HTMLAnchorElement enlace =
      web.document.createElement('a') as web.HTMLAnchorElement;
  enlace.href = url;
  enlace.download = nombreArchivo;
  web.document.body?.append(enlace);
  enlace.click();
  enlace.remove();
  web.URL.revokeObjectURL(url);
  return 'descargado como $nombreArchivo';
}
