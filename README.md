# Thank U Music

Front-end en Flutter y Dart para web, Android e iOS, basado en los mockups del proyecto. Diseño sencillo con rojo, fondo claro, tarjetas y menú lateral.

## Ejecutar

Con Flutter 3.47.8 o compatible instalado:

```sh
flutter pub get
flutter run -d chrome
```

Para Android usa un emulador o dispositivo y `flutter run`. Para compilar y ejecutar iOS se necesita macOS con Xcode; la carpeta `ios/` está incluida, pero no se ha compilado en Windows.

## Recorrer la demo

La pantalla inicial incluye **Entrar como usuario** y **Entrar como administrador**. El menú lateral permite recorrer las opciones de cada rol.

- Inicio de sesión, registro y aviso de recuperación pendiente de API.
- Inicio con búsqueda, lectura ampliable, etiquetas y comentarios.
- Perfil editable.
- Registro de administradores, búsqueda de usuarios, cambio de rol y estado.
- Crear y editar publicaciones, seleccionar entre tres portadas y moderar comentarios.

El inicio de sesión es simulado: acepta un correo registrado en la demo y cualquier texto de seis caracteres como contraseña. No valida credenciales ni almacena contraseñas. No debe usarse como autenticación real.

Todos los cambios viven en memoria y se reinician al recargar. Los roles solo sirven para presentar las vistas, no son una medida de seguridad. Al conectar la API, el servidor deberá autenticar y autorizar cada operación.

## Estructura

- `lib/data/blog_store.dart`: modelos y estado de ejemplo; punto de partida para sustituir por un repositorio API.
- `lib/screens/`: autenticación, inicio, publicaciones, perfil y usuarios.
- `lib/widgets/common.dart`: componentes visuales y validación reutilizables.
- `lib/main.dart`: tema y entrada de la app.
- `assets/logo.jpeg`: logo facilitado por el usuario.

Las portadas son gráficos sencillos con iconos locales. El selector usa tres opciones de ejemplo; la carga de fotos y cambio de avatar quedan para la integración posterior. No hay servicios externos, base de datos ni correo real.

## Comprobar

```sh
flutter analyze
flutter test
flutter build web
```

Las pruebas cubren validación de login, búsqueda, creación de publicaciones, comentarios y tamaños de pantalla móviles.

## Estado de validación

Dart analyze: sin incidencias. No se pudo completar flutter test ni flutter build web en el entorno de creación por problemas de ejecución y acceso a temporales. Ejecutar ambos comandos en el entorno de desarrollo antes de publicar. Android e iOS no compilados.

