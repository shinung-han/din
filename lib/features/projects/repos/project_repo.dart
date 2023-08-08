import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Project 가져오기(유무 확인)

  // Project hasProject -> true로 업데이트
  Future<void> createProject(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  // Project 삭제
}

final projectRepo = Provider((ref) => ProjectRepository());
