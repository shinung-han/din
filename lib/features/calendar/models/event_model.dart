class EventModel {
  final String title;
  final String? image;
  final String? memo;
  final double rating;
  final String? date;

  EventModel({
    required this.title,
    this.image,
    this.memo,
    required this.rating,
    required this.date,
  });

  EventModel copyWith({
    String? title,
    String? image,
    String? memo,
    double? rating,
    String? date,
  }) {
    return EventModel(
      title: title ?? this.title,
      image: image ?? this.image,
      memo: memo ?? this.memo,
      rating: rating ?? this.rating,
      date: date ?? this.date,
    );
  }
}
