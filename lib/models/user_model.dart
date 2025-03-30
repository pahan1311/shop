class UserModel {
  final String uid;
  final String email;
  final String role;
  final String name;
  final String? photoUrl; // Add this if you want to use it

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
      photoUrl: map['photoUrl'],
    );
  }
}