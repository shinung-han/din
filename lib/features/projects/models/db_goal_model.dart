class DbGoalModel {
  final String date;
  final String? image;
  final String? memo;
  final double? rating;
  final String title;

  DbGoalModel({
    required this.date,
    this.image,
    this.memo,
    this.rating,
    required this.title,
  });

  DbGoalModel.empty()
      : date = '',
        image = '',
        memo = '',
        rating = 0.0,
        title = '';

  DbGoalModel copyWith({
    String? date,
    String? image,
    String? memo,
    String? title,
    double? rating,
  }) {
    return DbGoalModel(
      date: date ?? this.date,
      image: image ?? this.image,
      memo: memo ?? this.memo,
      title: title ?? this.title,
      rating: rating ?? this.rating,
    );
  }
}
