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
}
