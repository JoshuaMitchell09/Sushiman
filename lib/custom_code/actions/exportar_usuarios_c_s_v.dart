// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'guardar_archivo/guardar_archivo.dart';

/// Práctica clase 3 (SC-703): descarga todos los usuarios de la colección
/// `users` en un archivo CSV. En web se descarga en el navegador; en el
/// celular se guarda en la carpeta de documentos de la app.
/// Retorna un mensaje para mostrar en un SnackBar.
Future<String> exportarUsuariosCSV() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> consulta =
        await FirebaseFirestore.instance.collection('users').get();

    if (consulta.docs.isEmpty) {
      return 'No hay usuarios para exportar';
    }

    final List<String> columnas = [
      'uid',
      'email',
      'display_name',
      'phone_number',
      'role',
      'created_time',
    ];

    // Escapa comas, comillas y saltos de línea para no romper el CSV.
    String escapar(dynamic valor) {
      if (valor == null) return '';
      String texto = valor is Timestamp
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(valor.toDate())
          : valor.toString();
      if (texto.contains(',') ||
          texto.contains('"') ||
          texto.contains('\n') ||
          texto.contains('\r')) {
        texto = '"${texto.replaceAll('"', '""')}"';
      }
      return texto;
    }

    final StringBuffer csv = StringBuffer();
    csv.write('${columnas.join(',')}\r\n');
    for (final doc in consulta.docs) {
      final Map<String, dynamic> datos = doc.data();
      datos['uid'] ??= doc.id;
      csv.write('${columnas.map((c) => escapar(datos[c])).join(',')}\r\n');
    }

    // BOM UTF-8 para que Excel muestre bien las tildes.
    final List<int> bytes = [0xEF, 0xBB, 0xBF, ...utf8.encode(csv.toString())];
    final String nombreArchivo =
        'usuarios_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';

    final String destino = await guardarArchivo(bytes, nombreArchivo);
    return 'CSV listo (${consulta.docs.length} usuarios): $destino';
  } catch (e) {
    return 'Error al exportar CSV: $e';
  }
}
