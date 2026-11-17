# Práctica clase 3 — SC-703 (semana 11)

Rama: `practica-clase3`. **No** se trabaja en la rama `flutterflow`, porque
FlutterFlow la sobrescribe cada vez que hace push.

## Qué se agregó

| Archivo | Qué es |
|---|---|
| `lib/custom_code/actions/create_users.dart` | **Custom action `createUsers`** (correo, pass, randomDocGen → String). Crea el usuario en Authentication con una instancia secundaria de Firebase (no cierra la sesión del admin) y lo guarda en la colección `users`. Errores traducidos al español. |
| `lib/custom_code/actions/exportar_usuarios_c_s_v.dart` | **Custom action `exportarUsuariosCSV`** (→ String). Descarga la colección `users` en CSV (web: descarga del navegador; celular: carpeta de documentos). |
| `lib/pages/login/` | Inicio de sesión del administrador (+ botón para crear el primer admin). |
| `lib/pages/listar_usuario_dinamico/` | Lista en tiempo real de `users` con botones **+** (crear), **descargar CSV**, **editar**, **eliminar** y **cerrar sesión**. |
| `lib/pages/crear_usuario/` | Ventana de la práctica: correo + contraseña con validación y botón **Crear usuario** → `createUsers`. |
| `lib/pages/editar_usuario_dinamico/` | Update Document: nombre, teléfono y rol. |
| `lib/pages/usuarios_ui.dart` | Estilos compartidos (borde azul, radio, padding 10, ancho 85 %). |
| `pubspec.yaml` | Dependencias `firebase_auth`, `cloud_firestore`, `web`. |

Flujo: **Home → menú ☰ → Login → Listar usuario dinámico → + → Crear usuario**.

## Configuración necesaria en Firebase (proyecto `iiic2026lunes-2da9d`)
1. **Authentication → Sign-in method → Correo electrónico/contraseña: Habilitar.**
2. **Firestore Database → Crear base de datos.**
3. Reglas mínimas para la práctica (Firestore → Reglas):
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{uid} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

## En FlutterFlow (lo que califica el profesor)
FlutterFlow **no importa** páginas desde GitHub. Para que aparezcan en el editor:
- Custom actions: Custom Code → Add → Action, mismo nombre, argumentos y
  return value que arriba, y pegar el código desde la línea `import 'package:cloud_firestore...`
  (en FlutterFlow, para el CSV usar la versión de un solo archivo con el paquete `download`).
- Ventanas: crearlas con el editor siguiendo el mismo diseño.

## Probado
- `flutter analyze`: sin errores.
- `flutter build web --release`: compila.
- No se probó contra Firebase real (sin acceso a red desde el entorno de desarrollo).
