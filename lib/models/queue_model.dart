import 'package:cloud_firestore/cloud_firestore.dart';

class QueueData {
  final String id;
  final String serviceId;
  final int currentToken;
  final int waitingCount;
  final DateTime updatedAt;

  QueueData({
    required this.id,
    required this.serviceId,
    required this.currentToken,
    required this.waitingCount,
    required this.updatedAt,
  });

  factory QueueData.fromMap(Map<String, dynamic> data, String documentId) {
    return QueueData(
      id: documentId,
      serviceId: data['serviceId'] ?? '',
      currentToken: data['currentToken'] ?? 0,
      waitingCount: data['waitingCount'] ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'currentToken': currentToken,
      'waitingCount': waitingCount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
