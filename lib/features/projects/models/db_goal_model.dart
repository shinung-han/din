class DbGoalModel {
  final String date;
  final String? image;
  final double? rating;
  final String title;

  DbGoalModel({
    required this.date,
    this.image,
    this.rating,
    required this.title,
  });

  DbGoalModel.empty()
      : date = '',
        image = '',
        rating = 0.0,
        title = '';

  DbGoalModel copyWith({
    String? date,
    String? image,
    String? title,
    double? rating,
  }) {
    return DbGoalModel(
      date: date ?? this.date,
      image: image ?? this.image,
      title: title ?? this.title,
      rating: rating ?? this.rating,
    );
  }
}
