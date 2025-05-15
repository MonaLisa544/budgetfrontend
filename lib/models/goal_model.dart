class GoalModel {
  final int id;
  final String goalName;
  final String goalType;
  final String status;
  final double targetAmount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime startDate;
  final DateTime expectedDate;
  final int monthlyDueDay;
  final String description;
  final double progressPercentage;
  final int monthsLeft;
  final String ownerType; // ✅ Flutter талд ownerType гэж нэрлэсэн
  final int walletId; // ✅ relationships-с орж ирэх боломжтой

  GoalModel({
    required this.id,
    required this.goalName,
    required this.goalType,
    required this.status,
    required this.targetAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.startDate,
    required this.expectedDate,
    required this.monthlyDueDay,
    required this.description,
    required this.progressPercentage,
    required this.monthsLeft,
    required this.ownerType,
    required this.walletId,
  });

  /// 🎯 Backend-с ирэх JSON-оос GoalModel үүсгэх
 factory GoalModel.fromJson(Map<String, dynamic> json) {
  final attributes = json['attributes'] ?? {};
  final relationships = json['relationships'] ?? {};

  double parseDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  return GoalModel(
    id: int.tryParse(json['id'].toString()) ?? 0, // 🔥 root-с id
    goalName: attributes['goal_name'] ?? '',
    goalType: attributes['goal_type'] ?? '',
    status: attributes['status'] ?? '',
    targetAmount: parseDouble(attributes['target_amount']),
    paidAmount: parseDouble(attributes['paid_amount']),
    remainingAmount: parseDouble(attributes['remaining_amount']),
    startDate: DateTime.tryParse(attributes['start_date'] ?? '') ?? DateTime.now(),
    expectedDate: DateTime.tryParse(attributes['expected_date'] ?? '') ?? DateTime.now(),
    monthlyDueDay: attributes['monthly_due_day'] ?? 1, // Чиний API-д monthly_due_day байна уу шалгаарай
    description: attributes['description'] ?? '',
    progressPercentage: parseDouble(attributes['progress_percentage']),
    monthsLeft: attributes['months_left'] ?? 0,
    ownerType: attributes['owner_type'] ?? '',  // 🔥 owner_type-г attributes-с авна
    walletId: int.tryParse(relationships['wallet']?['data']?['id']?.toString() ?? '0') ?? 0,
  );
}

  /// 🎯 Flutter-аас backend руу явуулах JSON
  Map<String, dynamic> toJson() {
    return {
      "goal_name": goalName,
      "goal_type": goalType,
      "status": status,
      "target_amount": targetAmount,
      "paid_amount": paidAmount,
      "remaining_amount": remainingAmount,
      "start_date": startDate.toIso8601String(),
      "expected_date": expectedDate.toIso8601String(),
      "monthly_due_day": monthlyDueDay,
      "description": description,
      "progress_percentage": progressPercentage,
      "months_left": monthsLeft,
      "type": ownerType, // ✅ ownerType-г "type" гэж явуулна
      // "wallet_id": walletId, --> create үед wallet_id backend авдаггүй бол хасаарай
    };
  }
}
