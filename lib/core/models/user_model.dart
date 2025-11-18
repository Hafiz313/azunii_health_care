import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? profilePicture;

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  bool? isGoogleUser;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.profilePicture,
    this.createdAt,
    this.isGoogleUser = false,
  });

  // From JSON (Firestore)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      createdAt: json['createdAt']?.toDate(),
      isGoogleUser: json['isGoogleUser'] ?? false,
    );
  }

  // To JSON (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
      'isGoogleUser': isGoogleUser,
    };
  }

  // From Google Sign-In
  factory UserModel.fromGoogleUser({
    required String id,
    required String name,
    required String email,
    String? profilePicture,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      profilePicture: profilePicture,
      createdAt: DateTime.now(),
      isGoogleUser: true,
    );
  }
}