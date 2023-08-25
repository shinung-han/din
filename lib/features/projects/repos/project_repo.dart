import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:din/features/calendar/models/event_model.dart';
import 'package:din/features/projects/models/date_model.dart';
import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // hasProject false -> true로
  Future<void> updateProjectStatus(
      String uid, bool hasProject, DateTime startDate) async {
    await _db.collection("users").doc(uid).update(
      {"hasProject": hasProject, "startDate": startDate},
    );
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
      String imageUrl = await _uploadAndGetImageUrl(imageFile, userId);
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
    await updateProjectStatus(
      userId,
      true,
      startDate,
    );

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

        await projectDoc.collection('goals').doc(goalDate).set({'data': date});

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

  Future<Map<String, List<DbGoalModel>>> fetchGoalsOfTodayAndWeek(
      String userId, String projectId) async {
    DateTime now = DateTime.now();
    String formattedDateToday = DateFormat('yyyyMMdd').format(now);

    // 주의 시작과 끝 날짜 계산
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    // print(startOfWeek);
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    // print(endOfWeek);
    // String formattedStartDateOfWeek =
    //     DateFormat('yyyyMMdd').format(startOfWeek);
    // String formattedEndDateOfWeek = DateFormat('yyyyMMdd').format(endOfWeek);

    Map<String, List<DbGoalModel>> result = {
      'today': await fetchGoalsByDate(userId, projectId, formattedDateToday),
      'week': [],
    };

    for (var date = startOfWeek;
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      String formattedDate = DateFormat('yyyyMMdd').format(date);
      List<DbGoalModel> dailyGoals =
          await fetchGoalsByDate(userId, projectId, formattedDate);
      result['week']!.addAll(dailyGoals);
    }

    return result;
  }

  Future<List<DbGoalModel>> fetchGoalsByDate(
      String userId, String projectId, String date) async {
    DocumentSnapshot? goalDoc = await _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .collection("goals")
        .doc(date)
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
            title: subDoc['title'],
          ),
        );
      }
    }
    return goals;
  }

  Future<Map<DateTime, List<EventModel>>> fetchEventEverything(
      String userId, String projectId) async {
    DocumentSnapshot projectDoc = await _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .get();

    if (!projectDoc.exists) {
      throw Exception("Project not found");
    }

    Map<String, dynamic>? data = projectDoc.data() as Map<String, dynamic>?;
    DateTime startDate = data?["startDate"].toDate();
    DateTime endDate = data?["endDate"].toDate();

    List<DbGoalModel> allGoals =
        await _fetchGoalsForMonth(userId, projectId, startDate, endDate);

    Map<DateTime, List<EventModel>> eventSource = {};

    for (DbGoalModel goal in allGoals) {
      DateTime goalDate = DateTime.parse(goal.date); // 문자열을 DateTime으로 변환
      if (eventSource.containsKey(goalDate)) {
        // DateTime key가 이미 존재할 경우 해당 리스트에 EventModel를 추가합니다.
        eventSource[goalDate]!.add(EventModel(
          title: goal.title,
          image: goal.image,
          memo: goal.memo,
          rating: goal.rating!,
        ));
      } else {
        // 새로운 DateTime key를 추가하고 EventModel 리스트를 초기화합니다.
        eventSource[goalDate] = [
          EventModel(
            title: goal.title,
            image: goal.image,
            memo: goal.memo,
            rating: goal.rating!,
          )
        ];
      }
    }

    return eventSource;
  }

  Future<List<DbGoalModel>> _fetchGoalsForMonth(String userId, String projectId,
      DateTime monthStart, DateTime monthEnd) async {
    // Convert dates to the required format
    String formattedStart = DateFormat('yyyyMMdd').format(monthStart);
    String formattedEnd = DateFormat('yyyyMMdd').format(monthEnd);

    // Fetch the 'goals' documents for the given month range
    QuerySnapshot goalDocsForMonth = await _db
        .collection("users")
        .doc(userId)
        .collection("project")
        .doc(projectId)
        .collection("goals")
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: formattedStart)
        .where(FieldPath.documentId, isLessThanOrEqualTo: formattedEnd)
        .get();

    if (goalDocsForMonth.docs.isEmpty) {
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

    for (DocumentSnapshot goalDoc in goalDocsForMonth.docs) {
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
              title: subDoc['title'],
            ),
          );
        }
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

    Reference userStorageRef = _storage.ref('project/$uid');
    ListResult result = await userStorageRef.listAll();

    for (Reference ref in result.items) {
      await ref.delete();
    }
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

  Future<String> _uploadAndGetImageUrl(File imageFile, String userId) async {
    Reference imageRef =
        _storage.ref('project/$userId/${imageFile.path.split('/').last}');
    TaskSnapshot snapshot = await imageRef.putFile(imageFile);
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _updateGoalImages(
      String userId, String title, String newImageUrl) async {
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
  }

  Future<String> updateImage(
    String userId,
    String title,
    String? oldImageUrl,
    File newImageFile,
  ) async {
    String newImageUrl = await _uploadAndGetImageUrl(newImageFile, userId);

    await _updateGoalImages(userId, title, newImageUrl);

    if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
      Reference oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
      await oldImageRef.delete();
    }

    return newImageUrl;
  }
}

final projectRepo = Provider((ref) => ProjectRepository());

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
