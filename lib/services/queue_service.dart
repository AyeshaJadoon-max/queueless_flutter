import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/queue_model.dart';
import '../models/token_model.dart';

class QueueService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Join a queue
  Future<QueueToken> joinQueue({
    required String userId,
    required String organizationId,
    required String serviceId,
  }) async {
    // 1. Transaction to update Queue Data (currentToken, waitingCount) and create Token
    return await _db.runTransaction((transaction) async {
      // Find the queue document or create it
      final query = await _db.collection('queues').where('serviceId', isEqualTo: serviceId).get();
      
      DocumentReference queueRef;
      QueueData queueData;
      
      if (query.docs.isEmpty) {
        queueRef = _db.collection('queues').doc();
        queueData = QueueData(
          id: queueRef.id,
          serviceId: serviceId,
          currentToken: 0,
          waitingCount: 0,
          updatedAt: DateTime.now(),
        );
        transaction.set(queueRef, queueData.toMap());
      } else {
        queueRef = query.docs.first.reference;
        final doc = query.docs.first;
        queueData = QueueData.fromMap(doc.data(), doc.id);
      }

      // 2. Generate new token details
      final newWaitingCount = queueData.waitingCount + 1;
      final assignedTokenNumber = queueData.currentToken + newWaitingCount;

      // Update queue counts
      transaction.update(queueRef, {
        'waitingCount': newWaitingCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 3. Create QueueToken
      final tokenRef = _db.collection('queue_tokens').doc();
      final newToken = QueueToken(
        id: tokenRef.id,
        tokenNumber: assignedTokenNumber,
        userId: userId,
        serviceId: serviceId,
        organizationId: organizationId,
        status: 'Waiting',
        createdAt: DateTime.now(),
      );

      transaction.set(tokenRef, newToken.toMap());
      
      return newToken;
    });
  }

  // Calculate estimated wait time based on avg service time
  int calculateWaitTime(int position, int avgServiceTimeMins) {
    return position * avgServiceTimeMins;
  }

  // Stream current active token for a user
  Stream<QueueToken?> streamActiveToken(String userId) {
    return _db
        .collection('queue_tokens')
        .where('userId', isEqualTo: userId)
        .where('status', isNotEqualTo: 'Completed')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return QueueToken.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
      }
      return null;
    });
  }

  // Stream user history
  Stream<List<QueueToken>> streamTokenHistory(String userId) {
    return _db
        .collection('queue_tokens')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Completed')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => QueueToken.fromMap(d.data(), d.id)).toList());
  }

  // Stream queue data for a service
  Stream<QueueData?> streamQueueData(String serviceId) {
    return _db
        .collection('queues')
        .where('serviceId', isEqualTo: serviceId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return QueueData.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
      }
      return null;
    });
  }
}
