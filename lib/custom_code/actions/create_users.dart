// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart'; // base de datos Firestore
import 'package:firebase_auth/firebase_auth.dart'; // manejar usuarios: crear, autenticar, editar, eliminar
import 'package:firebase_core/firebase_core.dart'; // inicializar Firebase

/// Práctica clase 3 (SC-703): crea un usuario en Firebase Authentication y
/// en la colección `users` SIN cerrar la sesión del administrador.
///
/// Se usa una instancia SECUNDARIA de Firebase: si se usara el "Create
/// Account" normal, el usuario nuevo tomaría la sesión del admin.
///
/// Argumentos (no se usan `email`/`password` porque chocan con nombres
/// reservados): [correo], [pass] y [randomDocGen] (nombre de la instancia).
/// Retorna un mensaje para mostrar en un SnackBar.
Future<String> createUsers(
  String correo,
  String pass,
  String randomDocGen,
) async {
  String mensaje = "Usuario creado";
  DateTime createdTime = DateTime.now();

  // Instancia secundaria. Se le agrega la hora para que el nombre nunca se
  // repita (si se repite, Firebase lanza "duplicate app").
  FirebaseApp app = await Firebase.initializeApp(
    name: '${randomDocGen}_${DateTime.now().microsecondsSinceEpoch}',
    options: Firebase.app().options,
  );

  try {
    UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(
      email: correo.trim(),
      password: pass,
    );

    String? uid = userCredential.user?.uid;

    if (uid != null) {
      final CollectionReference<Map<String, dynamic>> usuarios =
          FirebaseFirestore.instance.collection('users');

      await usuarios.doc(uid).set(<String, dynamic>{
        'uid': uid,
        'email': correo.trim(),
        'display_name': '',
        'phone_number': '',
        'role': 'usuario',
        'created_time': createdTime,
      });

      return mensaje;
    } else {
      return "Error creando el usuario";
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email inválido';
      case 'email-already-in-use':
        return 'El correo electrónico ya está registrado';
      case 'weak-password':
        return 'La contraseña debe tener al menos seis caracteres';
      case 'operation-not-allowed':
        return 'El registro con correo y contraseña no está habilitado en Firebase';
      default:
        return 'Error no localizado: ${e.code}';
    }
  } catch (e) {
    return 'Error inesperado: $e';
  } finally {
    // Cierra la instancia secundaria; la sesión del admin no se toca.
    await app.delete();
  }
}
