class Message {
  int id, userId;
  String text;

  Message({this.id, this.text, this.userId});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['text'] = text;
    map['userId'] = userId;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    text = map['text'];
    userId = map['userId'];
  }
}