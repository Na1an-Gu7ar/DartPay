// UserModel stores the basic profile details used by the app.
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String upiId;
  final String token;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.upiId,
    required this.token,
  });

  // fromJson teaches how API/local-storage maps become Dart objects.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      upiId: json['upiId'] as String,
      token: json['token'] as String,
    );
  }

  // toJson teaches how a Dart object can be saved or sent to an API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'upiId': upiId,
      'token': token,
    };
  }
}
