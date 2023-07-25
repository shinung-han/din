import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. 프로필 생성
  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  // 2. 프로필 가져오기

  // 3. 프로필 수정(업데이트)
  // 3-1. avatar 업데이트

  // 3-2. 닉네임 수정

  // 3-3. 비밀번호 수정
}

final userRepo = Provider((ref) => UserRepository());
