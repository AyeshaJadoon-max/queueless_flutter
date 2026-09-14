class AppService {
  final String id;
  final String organizationId;
  final String name;
  final int averageServiceTime; // in minutes

  AppService({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.averageServiceTime,
  });

  factory AppService.fromMap(Map<String, dynamic> data, String documentId) {
    return AppService(
      id: documentId,
      organizationId: data['organizationId'] ?? '',
      name: data['name'] ?? '',
      averageServiceTime: data['averageServiceTime'] ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'name': name,
      'averageServiceTime': averageServiceTime,
    };
  }
}
