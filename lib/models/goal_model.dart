class GoalModel {
  int? id;
  String goalName;
  String goalType;
  String status;
  double targetAmount;
  double savedAmount;        // <-- "saved_amount"
  String startDate;          // эсвэл DateTime startDate;
  String expectedDate;       // эсвэл DateTime expectedDate;
  int monthlyDueDay;
  double monthlyDueAmount;
  String description;
  double remainingAmount;
  int monthsLeft;
  String walletType;
  List<MonthlyStatus> monthlyStatuses; 

  GoalModel({
    this.id,
    required this.goalName,
    required this.goalType,
    this.status = "active",
    required this.targetAmount,
    this.savedAmount = 0,
    required this.startDate,
    required this.expectedDate,
    required this.monthlyDueDay,
    this.monthlyDueAmount = 0,
    required this.description,
    this.remainingAmount = 0,
    this.monthsLeft = 0,
    required this.walletType,
    this.monthlyStatuses = const [],
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final attr = json['attributes'] ?? json;
     final monthlyStatusesJson = attr['monthly_statuses'] ?? attr['monthlyStatuses'] ?? [];
    return GoalModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? attr['id'],
      goalName: attr['goal_name'] ?? '',
      goalType: attr['goal_type'] ?? '',
      status: attr['status'] ?? '',
      targetAmount: double.tryParse(attr['target_amount'].toString()) ?? 0,
      savedAmount: double.tryParse(attr['saved_amount'].toString()) ?? 0,
      startDate: attr['start_date'] ?? '',
      expectedDate: attr['expected_date'] ?? '',
      monthlyDueDay: attr['monthly_due_day'] is int
          ? attr['monthly_due_day']
          : int.tryParse(attr['monthly_due_day'].toString()) ?? 1,
      monthlyDueAmount: double.tryParse(attr['monthly_due_amount'].toString()) ?? 0,
      description: attr['description'] ?? '',
      remainingAmount: double.tryParse(attr['remaining_amount']?.toString() ?? '0') ?? 0,
      monthsLeft: attr['months_left'] is int
          ? attr['months_left']
          : int.tryParse(attr['months_left']?.toString() ?? '0') ?? 0,
      walletType: attr['wallet_type'] ?? '',
      monthlyStatuses: monthlyStatusesJson is List
          ? monthlyStatusesJson.map((e) => MonthlyStatus.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'goal_name': goalName,
        'goal_type': goalType,
        'status': status,
        'target_amount': targetAmount,
        'saved_amount': savedAmount,
        'start_date': startDate,
        'expected_date': expectedDate,
        'monthly_due_day': monthlyDueDay,
        'monthly_due_amount': monthlyDueAmount,
        'description': description,
        // 'remaining_amount': remainingAmount,
        // 'months_left': monthsLeft,
        'wallet_type': walletType,
      };
}

// Тусдаа MonthlyStatus model:
class MonthlyStatus {
  int id;
  String month;
  String status; // pending, success, fail
  double paidAmount;

  MonthlyStatus({
    required this.id,
    required this.month,
    required this.status,
    required this.paidAmount,
  });

  factory MonthlyStatus.fromJson(Map<String, dynamic> json) {
    return MonthlyStatus(
      id: json['id'],
      month: json['month'],
      status: json['status'],
      paidAmount: double.tryParse(json['paid_amount']?.toString() ?? '0') ?? 0,
    );
  }
}
