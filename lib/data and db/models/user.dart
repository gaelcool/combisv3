// lib/models/user.dart
class AppUser {
  final int id;
  final String email;
  final String username;
  final String nombre;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<int> favoriteRouteIds;  // IDs de rutas favoritas

  AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.nombre,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    this.favoriteRouteIds = const [],
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as int,
      email: map['email'] as String,
      username: map['username'] as String,
      nombre: map['nombre'] as String,
      isAdmin: (map['is_admin'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'nombre': nombre,
      'is_admin': isAdmin ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}