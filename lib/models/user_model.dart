

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? profilePhotoUrl; // nullable
  final int? familyId; // optional
  final int? walletId; // optional

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.profilePhotoUrl,
    this.familyId,
    this.walletId,
  });

  // Factory to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};
    final relationships = json['relationships'] ?? {};

    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      firstName: attributes['firstName'] ?? '',
      lastName: attributes['lastName'] ?? '',
      email: attributes['email'] ?? '',
      role: attributes['role'] ?? '',
      profilePhotoUrl: attributes['profile_photo'],
      familyId: relationships['family'] != null && relationships['family']['data'] != null
          ? int.tryParse(relationships['family']['data']['id'].toString())
          : null,
      walletId: relationships['wallet'] != null && relationships['wallet']['data'] != null
          ? int.tryParse(relationships['wallet']['data']['id'].toString())
          : null,
    );
  }

  // Method to convert UserModel to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'profile_photo': profilePhotoUrl,
      'family_id': familyId,
      'wallet_id': walletId,
    };
  }
}
