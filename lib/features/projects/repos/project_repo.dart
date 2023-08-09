import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<String?> _uploadImage(String userId, File imageFile) async {
    try {
      final ref =
          _storage.ref('project/$userId/${imageFile.path.split('/').last}');
      final uploadTask = await ref.putFile(imageFile);
      // 업로드된 이미지의 URL 얻기
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("이미지 업로드 중 오류: $e");
      return null;
    }
  }

  Future<void> createProjectWithGoals(
    String userId,
    DateTime startDate,
    DateTime endDate,
    int period,
    List<GoalModel> goals,
  ) async {
    await updateProjectStatus(userId, true);

    DocumentReference projectDoc =
        await _db.collection("users").doc(userId).collection("project").add({
      'startDate': startDate,
      'endDate': endDate,
      'period': period,
    });

    DateTime date = startDate;

    while (date.isBefore(endDate) || date.isAtSameMomentAs(endDate)) {
      for (var goal in goals) {
        String goalDate = DateFormat('yyyyMMdd').format(date);
        String? imageUrl;
        if (goal.image != null) {
          imageUrl = await _uploadImage(userId, goal.image!);
        }

        await projectDoc
            .collection('goals')
            .doc(goalDate)
            .collection(goal.title)
            .add({
          'date': goalDate,
          'title': goal.title,
          'image': imageUrl ?? "",
          'rating': "",
        });
      }
      date = date.add(const Duration(days: 1));
    }
  }
}

final projectRepo = Provider((ref) => ProjectRepository());
