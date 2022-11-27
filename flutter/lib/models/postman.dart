class Postman {
  final int id;
  final String name;
  final int likeNum;
  final int dislikeNum;
  final int taskFinishedNum;
  final String creditStatus;
  final String phone;

  Postman(
      {required this.id,
      required this.name,
      required this.likeNum,
      required this.dislikeNum,
      required this.taskFinishedNum,
      required this.creditStatus,
      required this.phone});

  factory Postman.fromJson(Map<String, dynamic> json) {
    return Postman(
        id: json['id'],
        name: json['name'],
        likeNum: json['likeNum'],
        dislikeNum: json['dislikeNum'],
        taskFinishedNum: json['taskFinishedNum'],
        creditStatus: json['creditState'],
        phone: json['phone']);
  }
}
