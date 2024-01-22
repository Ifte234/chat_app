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
  late final String lastSeen;
  late final String name;
  // late final bool isOnline;
  late final String about;
  late final String email;
  late final String id;
  late final String image;
  late final String createdAt;
  late final String pushToken;

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