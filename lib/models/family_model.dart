class FamilyModel {
  final int id;
  final String familyName;
  final int walletId;

  FamilyModel({
    required this.id,
    required this.familyName,
    required this.walletId,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};
    final relationships = json['relationships'] ?? {};

    return FamilyModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      familyName: attributes['family_name'] ?? '',
      walletId: relationships['wallet'] != null && relationships['wallet']['data'] != null
          ? int.tryParse(relationships['wallet']['data']['id'].toString()) ?? 0
          : 0,
    );
  }
}
