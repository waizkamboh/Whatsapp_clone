

class UserModel {
  final String? name;
  final String? uid;
  final String? profilePic;
  final bool? isOnline;
  final String? phoneNumber;
  final List<String>? groupId;
  UserModel({
     this.name,
     this.uid,
     this.profilePic,
     this.isOnline,
     this.phoneNumber,
     this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}