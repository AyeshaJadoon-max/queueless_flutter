class Organization {
  final String id;
  final String name;
  final String description;
  final String address;
  final String type;
  final String rating;
  final bool isOpen;

  Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.type,
    required this.rating,
    required this.isOpen,
  });

  factory Organization.fromMap(Map<String, dynamic> data, String documentId) {
    return Organization(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '123 Main St',
      type: data['type'] ?? 'Hospital',
      rating: data['rating'] ?? '4.5',
      isOpen: data['isOpen'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'type': type,
      'rating': rating,
      'isOpen': isOpen,
    };
  }
}
