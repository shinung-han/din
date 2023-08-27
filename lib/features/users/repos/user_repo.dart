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
  Future<String> uploadAvatar(
      File file, String oldFileName, String userId) async {
    if (oldFileName != "") {
      final fileNamePart =
          await extractFileNameWithTimestamp(oldFileName, userId);
      final oldFileRef = _storage.ref().child("avatars/$fileNamePart");
      await oldFileRef.delete().catchError((error) {
        print("Error deleting old avatar: $error");
      });
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newFileName = "${userId}_$timestamp";

    final fileRef = _storage.ref().child("avatars/$newFileName");
    await fileRef.putFile(file);

    final avatarUrl = await fileRef.getDownloadURL();

    await updateUser(userId, {'avatarUrl': avatarUrl});

    return await fileRef.getDownloadURL();
  }

  String extractFileNameWithTimestamp(String url, String userId) {
    int startIndex = url.indexOf(userId);
    int endIndex = url.indexOf('?alt');
    if (startIndex != -1 && endIndex != -1) {
      return url.substring(startIndex, endIndex);
    }
    return '';
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  // 3-2. 유저 네임 수정
  Future<void> updateProfile(
    String uid,
    Map<String, dynamic>? data,
  ) async {
    await _db.collection("users").doc(uid).update(data!);
  }
}

final userRepo = Provider((ref) => UserRepository());
