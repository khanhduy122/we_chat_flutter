class UserProfile{
  String? id;
  String? name;
  String? image;
  String? phone;
  UserProfile({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
  });

  UserProfile.fromJson(Map<String, dynamic> json){
    image = json['image'];
    name = json['name'];
    id = json['id'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    data['phone'] = phone;
    return data;
  }
}


  