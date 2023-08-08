import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Project 가져오기(유무 확인)

  // 2. Project 생성
  // [ ] hasProject -> true로 업데이트
  // [ ] project 컬렉션 생성
  // [ ] 요일별로 리스트 생성해서 넣기
  // [ ] 이미지 넣기
  // Future<void> createProject(String uid, Map<String, dynamic> data) async {
  //   await _db.collection("users").doc(uid).update(data);
  // }

  // hasProject false -> true로 변경 (with. chatGPT)
  Future<void> updateProjectStatus(String uid, bool hasProject) async {
    await _db.collection("users").doc(uid).update({"hasProject": hasProject});
  }

  // 유저 정보 가져오기(chat)
  Future<UserProfileModel?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _db.collection("users").doc(uid).get();
    if (doc.exists) {
      return UserProfileModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Project 삭제
}

final projectRepo = Provider((ref) => ProjectRepository());
