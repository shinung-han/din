class EventModel {
  final String title;
  final String? image;
  final String? memo;
  final double rating;

  EventModel({
    required this.title,
    this.image,
    this.memo,
    required this.rating,
  });

  EventModel copyWith({
    String? title,
    String? image,
    String? memo,
    double? rating,
  }) {
    return EventModel(
      title: title ?? this.title,
      image: image ?? this.image,
      memo: memo ?? this.memo,
      rating: rating ?? this.rating,
    );
  }
}
