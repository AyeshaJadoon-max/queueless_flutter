import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organization_model.dart';
import '../models/service_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of organizations from Firestore
  Stream<List<Organization>> streamOrganizations() {
    return _db.collection('organizations').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Organization.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Stream of services for an organization from Firestore
  Stream<List<AppService>> streamServices(String organizationId) {
    return _db
        .collection('services')
        .where('organizationId', isEqualTo: organizationId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AppService.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Seed default data if database collections are empty
  Future<void> seedDummyData() async {
    final snapshot = await _db.collection('organizations').limit(1).get();
    if (snapshot.docs.isEmpty) {
      // 1. Add Hospitals / Clinics
      final doc1 = await _db.collection('organizations').add({
        'name': 'City General Hospital',
        'description': 'Main city hospital with multi-specialty OPDs',
        'address': '123 Main St, Downtown',
        'type': 'Hospital',
        'rating': '4.8 (1.2k reviews)',
        'isOpen': true,
      });

      final doc2 = await _db.collection('organizations').add({
        'name': 'Green Valley Clinic',
        'description': 'Specialized outpatient & diagnostic clinic',
        'address': '45 Oak Ridge Blvd',
        'type': 'Clinic',
        'rating': '4.5 (800 reviews)',
        'isOpen': true,
      });

      // 2. Add Services for City General Hospital
      await _db.collection('services').add({
        'organizationId': doc1.id,
        'name': 'General OPD',
        'averageServiceTime': 5,
      });
      await _db.collection('services').add({
        'organizationId': doc1.id,
        'name': 'Lab Reports & Blood Test',
        'averageServiceTime': 4,
      });
      await _db.collection('services').add({
        'organizationId': doc1.id,
        'name': 'Radiology & X-Ray',
        'averageServiceTime': 10,
      });

      // 3. Add Services for Green Valley Clinic
      await _db.collection('services').add({
        'organizationId': doc2.id,
        'name': 'General Consultation',
        'averageServiceTime': 5,
      });
      await _db.collection('services').add({
        'organizationId': doc2.id,
        'name': 'Dental Checkup',
        'averageServiceTime': 15,
      });

      // 4. Initialize Queue records
      await _db.collection('queues').add({
        'serviceId': 'General OPD',
        'currentToken': 1,
        'waitingCount': 3,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _db.collection('queues').add({
        'serviceId': 'General Consultation',
        'currentToken': 1,
        'waitingCount': 2,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
