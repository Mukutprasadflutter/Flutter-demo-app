import 'Ingredient.dart';
import 'Instruction.dart';

class FeedDetail {
  String complexity;
  String firstName;
  List<Ingredient> ingredients;
  List<Instruction> instructions;
  String lastName;
  String name;
  String photo;
  String preparationTime;
  String serves;

  FeedDetail(
      {this.complexity,
      this.firstName,
      this.ingredients,
      this.instructions,
      this.lastName,
      this.name,
      this.photo,
      this.preparationTime,
      this.serves});

  factory FeedDetail.fromJson(Map<String, dynamic> json) {
    return FeedDetail(
      complexity: json['complexity']!= null ? json['complexity'] : "",
      firstName: json['firstName'] != null ? json['firstName'] : "",
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((i) => Ingredient.fromJson(i))
              .toList()
          : null,
      instructions: json['instructions'] != null
          ? (json['instructions'] as List)
              .map((i) => Instruction.fromJson(i))
              .toList()
          : null,
      lastName: json['lastName'] != null ? json['lastName'] : "",
      name: json['name'] != null ? json['name'] : "",
      photo: json['photo'] != null ? json['photo'] : "",
      preparationTime: json['preparationTime']!= null ? (json['preparationTime']) : "",
      serves: json['serves']!= null ? (json['serves']) : "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complexity'] = this.complexity;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['preparationTime'] = this.preparationTime;
    data['serves'] = this.serves;
    if (this.ingredients != null) {
      data['ingredients'] = this.ingredients.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
