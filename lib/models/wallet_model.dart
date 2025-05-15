class WalletModel {
  final int id;
  final double balance;
  final String ownerType;
  final int ownerId;

  WalletModel({
    required this.id,
    required this.balance,
    required this.ownerType,
    required this.ownerId,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
  final attributes = json['attributes'] ?? {};

  return WalletModel(
    id: json['id'] is int 
        ? json['id'] 
        : int.tryParse(json['id'].toString()) ?? 0,
    balance: (attributes['balance'] is num ? (attributes['balance'] as num) : 0).toDouble(),
    ownerType: attributes['owner_type'] ?? '',
    ownerId: attributes['owner_id'] is int 
        ? attributes['owner_id'] 
        : int.tryParse(attributes['owner_id'].toString()) ?? 0,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'owner_type': ownerType,
      'owner_id': ownerId,
    };
  }
}