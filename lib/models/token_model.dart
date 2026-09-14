import 'package:cloud_firestore/cloud_firestore.dart';

class QueueToken {
  final String id;
  final int tokenNumber;
  final String userId;
  final String serviceId;
  final String organizationId;
  final String status; // 'Waiting', 'Completed', 'Skipped'
  final DateTime createdAt;
  final DateTime? completedAt;

  QueueToken({
    required this.id,
    required this.tokenNumber,
    required this.userId,
    required this.serviceId,
    required this.organizationId,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory QueueToken.fromMap(Map<String, dynamic> data, String documentId) {
    return QueueToken(
      id: documentId,
      tokenNumber: data['tokenNumber'] ?? 0,
      userId: data['userId'] ?? '',
      serviceId: data['serviceId'] ?? '',
      organizationId: data['organizationId'] ?? '',
      status: data['status'] ?? 'Waiting',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tokenNumber': tokenNumber,
      'userId': userId,
      'serviceId': serviceId,
      'organizationId': organizationId,
      'status': status,
      'createdAt': createdAt, // Can use FieldValue.serverTimestamp() when creating
      if (completedAt != null) 'completedAt': completedAt,
    };
  }
}
