class TuitionFee {
  TuitionFee({
    required this.desc,
    required this.dueDate,
    required this.value,
    required this.paymentDate,
    required this.amountPaid,
    required this.debt,
    required this.fine,
  });

  String desc;
  String dueDate;
  double value;
  String paymentDate;
  double amountPaid;
  double debt;
  double fine;

  factory TuitionFee.fromJson(Map<String, dynamic> json) {
    return TuitionFee(
      desc: json['desc'],
      dueDate: json['dueDate'],
      value: json['value'].toDouble(),
      paymentDate: json['paymentDate'],
      amountPaid: json['amountPaid'].toDouble(),
      debt: json['debt'].toDouble(),
      fine: json['fine'].toDouble(),
    );
  }
}
