class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'user' or 'admin'
  final String? organizationId; // Applicable if role is 'admin'

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.organizationId,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      organizationId: data['organizationId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      if (organizationId != null) 'organizationId': organizationId,
    };
  }
}
