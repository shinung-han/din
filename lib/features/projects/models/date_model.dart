class DateModel {
  DateTime startDate;
  DateTime endDate;
  int period;

  DateModel({
    required this.startDate,
    required this.endDate,
    required this.period,
  });

  DateModel.empty()
      : startDate = DateTime.now(),
        endDate = DateTime.now(),
        period = 1;
}
