class Usuario {
  Usuario(
    this.nombre,
    this.correo, {
    this.direccion = '',
    this.administrador = false,
  });
  String nombre, correo, direccion;
  bool administrador;
  bool baneado = false;
}
