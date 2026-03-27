import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    await _db
        .collection(collectionPath)
        .doc(documentId)
        .set(data, SetOptions(merge: merge));
  }

  Future<String> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final ref = await _db.collection(collectionPath).add(data);
    return ref.id;
  }

  Future<Map<String, dynamic>?> getDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    final doc = await _db.collection(collectionPath).doc(documentId).get();
    return doc.data();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    String collectionPath,
  ) {
    return _db.collection(collectionPath).snapshots();
  }
}
