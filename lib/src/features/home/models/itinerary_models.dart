class Itinerary {
  final String title;
  final String startDate;
  final String endDate;
  final List<ItineraryDay> days;

  Itinerary({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  factory Itinerary.fromJson(Map<String, dynamic> j) => Itinerary(
    title: j['title'] as String,
    startDate: j['startDate'] as String,
    endDate: j['endDate'] as String,
    days: (j['days'] as List).map((d) => ItineraryDay.fromJson(d)).toList(),
  );
}

class ItineraryDay {
  final String date;
  final String summary;
  final List<ItineraryItem> items;

  ItineraryDay({
    required this.date,
    required this.summary,
    required this.items,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> j) => ItineraryDay(
    date: j['date'] as String,
    summary: j['summary'] as String,
    items: (j['items'] as List).map((i) => ItineraryItem.fromJson(i)).toList(),
  );
}

class ItineraryItem {
  final String time;
  final String activity;
  final String location;

  ItineraryItem({
    required this.time,
    required this.activity,
    required this.location,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> j) => ItineraryItem(
    time: j['time'] as String,
    activity: j['activity'] as String,
    location: j['location'] as String,
  );
}
