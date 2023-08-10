class DateModel {
  DateTime startDate;
  DateTime endDate;
  int period;
  List? goalsTitle;

  DateModel({
    required this.startDate,
    required this.endDate,
    required this.period,
    this.goalsTitle,
  });

  DateModel.empty()
      : startDate = DateTime.now(),
        endDate = DateTime.now(),
        period = 1,
        goalsTitle = [];
}
