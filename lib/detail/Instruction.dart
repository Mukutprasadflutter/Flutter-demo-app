class Instruction {
  int id;
  String instruction;

  Instruction({this.id, this.instruction});

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      id: json['id'],
      instruction: json['instruction'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['instruction'] = this.instruction;
    return data;
  }
}
