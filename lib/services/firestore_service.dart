import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organization_model.dart';
import '../models/service_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of organizations
  Stream<List<Organization>> streamOrganizations() {
    return _db.collection('organizations').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Organization.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Stream of services for an organization
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

  Future<void> seedDummyData() async {
    final snapshot = await _db.collection('organizations').limit(1).get();
    if (snapshot.docs.isEmpty) {
      await _db.collection('organizations').add({
        'name': 'City General Hospital',
        'description': 'Main city hospital',
        'address': '123 Main St, Downtown',
        'type': 'Hospital',
        'rating': '4.8 (1.2k reviews)',
        'isOpen': true,
      });
      await _db.collection('organizations').add({
        'name': 'Green Valley Clinic',
        'description': 'Local clinic',
        'address': '45 Oak Ridge Blvd',
        'type': 'Clinic',
        'rating': '4.5 (800 reviews)',
        'isOpen': true,
      });
    }
  }
}
