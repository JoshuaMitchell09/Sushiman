import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/pages/usuarios_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'listar_usuario_dinamico_model.dart';
export 'listar_usuario_dinamico_model.dart';

/// Lista en tiempo real los documentos de la colección `users`.
/// - Botón "+": navega a Crear usuario (custom action createUsers).
/// - Botón descarga: custom action exportarUsuariosCSV.
/// - Lápiz: Update Document (Editar usuario dinámico).
/// - Basurero: Delete Document.
class ListarUsuarioDinamicoWidget extends StatefulWidget {
  const ListarUsuarioDinamicoWidget({super.key});

  static String routeName = 'ListarUsuarioDinamico';
  static String routePath = '/listarUsuarioDinamico';

  @override
  State<ListarUsuarioDinamicoWidget> createState() =>
      _ListarUsuarioDinamicoWidgetState();
}

class _ListarUsuarioDinamicoWidgetState
    extends State<ListarUsuarioDinamicoWidget> {
  late ListarUsuarioDinamicoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListarUsuarioDinamicoModel());
    // Si no hay sesión, se manda al login.
    if (FirebaseAuth.instance.currentUser == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.goNamed(LoginWidget.routeName);
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _descargarCSV() async {
    setState(() => _model.exportando = true);
    _model.resultadoCSV = await actions.exportarUsuariosCSV();
    if (!mounted) return;
    setState(() => _model.exportando = false);
    showSnackbar(context, _model.resultadoCSV!);
  }

  Future<void> _eliminar(String uid, String email) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text('¿Desea eliminar a $email?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      if (mounted) showSnackbar(context, 'Usuario eliminado');
    } catch (e) {
      if (mounted) showSnackbar(context, 'No se pudo eliminar: $e');
    }
  }

  Future<void> _cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) context.goNamed(LoginWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: appBarUsuarios(
        context,
        titulo: 'Usuarios',
        onAtras: () => context.goNamed(HomeWidget.routeName),
        acciones: [
          IconButton(
            tooltip: 'Descargar CSV',
            onPressed: _model.exportando ? null : _descargarCSV,
            icon: _model.exportando
                ? const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.0, color: Colors.white),
                  )
                : const Icon(Icons.download_rounded),
          ),
          IconButton(
            tooltip: 'Crear usuario',
            onPressed: () => context.pushNamed(CrearUsuarioWidget.routeName),
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'No se pudo cargar la lista:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: theme.bodyMedium,
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: theme.primary),
              );
            }
            final docs = snapshot.data!.docs.toList()
              ..sort((a, b) {
                final ta = a.data()['created_time'];
                final tb = b.data()['created_time'];
                if (ta is Timestamp && tb is Timestamp) {
                  return tb.compareTo(ta); // más recientes primero
                }
                return 0;
              });
            if (docs.isEmpty) {
              return Center(
                child: Text(
                  'Todavía no hay usuarios.\nToque + para crear uno.',
                  textAlign: TextAlign.center,
                  style: theme.bodyLarge,
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12.0),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data();
                final email = (data['email'] ?? '') as String;
                final nombre = (data['display_name'] ?? '') as String;
                final rol = (data['role'] ?? 'usuario') as String;
                final creado = data['created_time'];
                return Card(
                  elevation: 1.0,
                  color: theme.secondaryBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.primary10,
                      foregroundColor: theme.primary,
                      child: Text(
                        (nombre.isNotEmpty ? nombre : email)
                            .characters
                            .first
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(
                      nombre.isNotEmpty ? nombre : email,
                      style: theme.titleSmall,
                    ),
                    subtitle: Text(
                      [
                        if (nombre.isNotEmpty) email,
                        'Rol: $rol',
                        if (creado is Timestamp)
                          'Creado: ${DateFormat('dd/MM/yyyy HH:mm').format(creado.toDate())}',
                      ].join('\n'),
                      style: theme.bodySmall,
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Editar',
                          icon: Icon(Icons.edit_rounded,
                              color: theme.primaryText),
                          onPressed: () => context.pushNamed(
                            EditarUsuarioDinamicoWidget.routeName,
                            queryParameters: {'userId': doc.id},
                          ),
                        ),
                        IconButton(
                          tooltip: 'Eliminar',
                          icon:
                              Icon(Icons.delete_rounded, color: theme.error),
                          onPressed: () => _eliminar(doc.id, email),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
