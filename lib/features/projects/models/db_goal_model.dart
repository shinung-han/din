class DbGoalModel {
  final String date;
  final String? image;
  final String? rating;
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
        rating = "",
        title = '';
}
