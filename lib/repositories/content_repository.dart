import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_item.dart';

abstract class ContentRepository {
  Stream<List<ContentItem>> watchContent(String userId);
  Future<void> addContent(String userId, ContentItem item);
  Future<void> deleteContent(String userId, String contentId);
}

class FirestoreContentRepository implements ContentRepository {
  final FirebaseFirestore _firestore;

  FirestoreContentRepository(this._firestore);

  @override
  Stream<List<ContentItem>> watchContent(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('content')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => ContentItem.fromMap(doc.data(), doc.id)).toList();
      });
    } catch (e) {
      // Fallback for demo if duplicate/permission error (or just return empty stream)
      return Stream.value([]);
    }
  }

  @override
  Future<void> addContent(String userId, ContentItem item) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('content')
        .add(item.toMap());
  }

  @override
  Future<void> deleteContent(String userId, String contentId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('content')
        .doc(contentId)
        .delete();
  }
}

class DemoContentRepository implements ContentRepository {
  final _items = List.generate(5, (index) => ContentItem.demo('demo-$index'));

  @override
  Stream<List<ContentItem>> watchContent(String userId) {
    return Stream.value(_items);
  }

  @override
  Future<void> addContent(String userId, ContentItem item) async {
    _items.insert(0, item);
  }

  @override
  Future<void> deleteContent(String userId, String contentId) async {
    _items.removeWhere((i) => i.id == contentId);
  }
}

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  // Return Demo repo if Firebase not initialized, or switch based on config
  // For this task, we'll try to return Firestore but wrap safely or default to demo 
  // if we knew initialization status.
  // Since we don't have real google-services.json, we use DemoRepository for the "Run" correctness.
  
  return DemoContentRepository();
  // Uncomment below for real impl:
  // return FirestoreContentRepository(FirebaseFirestore.instance);
});
