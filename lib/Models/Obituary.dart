/*
* @Author Rohan Morris
* @Date 18/05/2020
* User Orituary/Events class
* */
class Orituary {
  final int id;
  final String fullName;
  final String avatarUrl;
  final String bambuserResourceUrl;
  final List<Events> events;

  Orituary({this.id, this.fullName, this.avatarUrl, this.bambuserResourceUrl, this.events});
}

class Events{
  final int id;
  final String eventType;
  final String date;
  final String time;

  Events({this.id, this.eventType, this.date, this.time});
}