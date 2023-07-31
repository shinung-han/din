import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 1. 프로필 생성
  Future<void> createProfile(UserProfileModel profile, String? name) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson(name!));
  }

  // 2. 프로필 가져오기
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  // 3. 프로필 수정(업데이트)
  // 3-1. avatar 업데이트
  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(file);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  // 3-2. 닉네임 수정

  // 3-3. 비밀번호 수정
}

final userRepo = Provider((ref) => UserRepository());
