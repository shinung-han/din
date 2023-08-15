import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:din/features/projects/models/date_model.dart';
import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // hasProject false -> true로
  Future<void> updateProjectStatus(String uid, bool hasProject) async {
    await _db.collection("users").doc(uid).update({"hasProject": hasProject});
  }

  // hasProject 정보 가져오기
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
      "goalsTitle": goals.map((goal) => goal.title).toList(),
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
            .set({'data': goalDate});

        await projectDoc
            .collection('goals')
            .doc(goalDate)
            .collection(goal.title)
            .add({
          'date': goalDate,
          'title': goal.title,
          'image': imageUrl ?? "",
          'memo': "",
          'rating': 0.0,
        });
      }
      date = date.add(const Duration(days: 1));
    }
  }

  Future<String?> getProjectDocIdByCondition(String userId) async {
    QuerySnapshot snapshot =
        await _db.collection("users").doc(userId).collection("project").get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<String?> getGoalDocIdByCondition(
    String userId,
    String projectId,
    String goalTitle,
  ) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);

    QuerySnapshot snapshot = await _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .collection("goals")
        .doc(formattedDate)
        .collection(goalTitle)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<DateModel?> getProjectDate(String userId, String docId) async {
    DocumentSnapshot doc = await _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(docId)
        .get();

    if (doc.exists) {
      return DateModel(
        startDate: doc.get("startDate").toDate(),
        endDate: doc.get("endDate").toDate(),
        period: doc.get("period"),
        goalsTitle: doc.get("goalsTitle"),
      );
    }
    return null;
  }

  Future<List<DbGoalModel>> fetchGoalsOfToday(
      String userId, String projectId) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);

    DocumentSnapshot? goalDoc = await _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .collection("goals")
        .doc(formattedDate)
        .get();

    if (!goalDoc.exists) {
      return [];
    }

    DocumentSnapshot subCollectionNames = await _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .get();

    Map<String, dynamic>? data =
        subCollectionNames.data() as Map<String, dynamic>?;

    List<String> goalsTitleList = List<String>.from(data!["goalsTitle"]);

    List<DbGoalModel> goals = [];

    for (String subCollectionName in goalsTitleList) {
      QuerySnapshot subCollectionSnapshot =
          await goalDoc.reference.collection(subCollectionName).get();
      for (var subDoc in subCollectionSnapshot.docs) {
        goals.add(
          DbGoalModel(
              date: subDoc['date'],
              image: subDoc['image'],
              memo: subDoc['memo'],
              rating: subDoc['rating'],
              title: subDoc['title']),
        );
      }
    }
    return goals;
  }

  Future<void> deleteProject(String uid, String projectId) async {
    DocumentReference projectDocRef =
        _db.collection("users").doc(uid).collection("project").doc(projectId);

    QuerySnapshot goalsSnapshot = await projectDocRef.collection("goals").get();
    for (DocumentSnapshot ds in goalsSnapshot.docs) {
      await ds.reference.delete();
    }

    await projectDocRef.delete();
  }

  Future<void> saveRating(
    String userId,
    String projectId,
    String goalTitle,
    double rating,
    String goalId,
  ) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);

    _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .collection("goals")
        .doc(formattedDate)
        .collection(goalTitle)
        .doc(goalId)
        .update({"rating": rating});
  }

  Future<void> writeMemo(
    String userId,
    String projectId,
    String goalTitle,
    String memo,
    String goalId,
  ) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);

    _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .collection("goals")
        .doc(formattedDate)
        .collection(goalTitle)
        .doc(goalId)
        .update({"memo": memo});
  }

  Future<void> updateTitle(
    String userId,
    String oldTitle,
    String newTitle,
  ) async {
    QuerySnapshot projects =
        await _db.collection("users").doc(userId).collection("project").get();

    WriteBatch batch = _db.batch();

    for (var project in projects.docs) {
      List<String> goalsTitles = List<String>.from(
          (project.data() as Map<String, dynamic>)['goalsTitle'] ?? []);

      int index = goalsTitles.indexOf(oldTitle);
      if (index != -1) {
        goalsTitles[index] = newTitle;
      }

      batch.update(project.reference, {'goalsTitle': goalsTitles});

      QuerySnapshot days = await project.reference.collection("goals").get();

      for (var day in days.docs) {
        CollectionReference goalCollection = day.reference.collection(oldTitle);

        QuerySnapshot goalDocuments = await goalCollection.get();

        for (var goal in goalDocuments.docs) {
          batch.update(goal.reference, {"title": newTitle});

          Map<String, dynamic> data = goal.data() as Map<String, dynamic>;
          batch.set(day.reference.collection(newTitle).doc(goal.id),
              {...data, 'title': newTitle});
          batch.delete(goal.reference);
        }
      }
    }

    await batch.commit();
  }

  Future<String> updateImage(
    String userId,
    String title,
    String? oldImageUrl,
    File newImageFile,
  ) async {
    Reference newImageRef =
        _storage.ref('project/$userId/${newImageFile.path.split('/').last}');

    UploadTask uploadTask = newImageRef.putFile(newImageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
    String newImageUrl = await snapshot.ref.getDownloadURL();

    QuerySnapshot projects =
        await _db.collection("users").doc(userId).collection("project").get();

    WriteBatch batch = _db.batch();

    for (var project in projects.docs) {
      List<String> goalsTitles = List<String>.from(
          (project.data() as Map<String, dynamic>)['goalsTitle'] ?? []);

      if (goalsTitles.contains(title)) {
        QuerySnapshot days = await project.reference.collection("goals").get();

        for (var day in days.docs) {
          CollectionReference goalCollection = day.reference.collection(title);

          QuerySnapshot goalDocuments = await goalCollection.get();

          for (var goal in goalDocuments.docs) {
            batch.update(goal.reference, {"image": newImageUrl});
          }
        }
      }
    }

    await batch.commit();

    if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
      Reference oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);

      await oldImageRef.delete();
    }

    return newImageUrl;
  }
}

final projectRepo = Provider((ref) => ProjectRepository());
