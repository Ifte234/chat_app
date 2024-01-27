class ChatUser {
  ChatUser({
    required this.lastSeen,
    required this.name,
    // required this.isOnline,
    required this.about,
    required this.email,
    required this.id,
    required this.image,
    required this.createdAt,
    required this.pushToken,
  });
  late String lastSeen;
  late String name;
  // late bool isOnline;
  late String about;
  late String email;
  late String id;
  late String image;
  late String createdAt;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json){
    lastSeen = json['last_seen'] ?? '';
    name = json['name']?? '';
    // isOnline = json['is_online'] ?? '';
    about = json['about'] ?? '';
    email = json['email'] ?? '';
    id = json['id'] ?? '';
    image = json['image'] ?? '';
    createdAt = json['created_at'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['last_seen'] = lastSeen;
    data['name'] = name;
    // data['is_online'] = isOnline;
    data['about'] = about;
    data['email'] = email;
    data['id'] = id;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['push_token'] = pushToken;
    return data;
  }
}