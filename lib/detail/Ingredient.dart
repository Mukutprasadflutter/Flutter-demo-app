class Ingredient {
  int id;
  String ingredient;

  Ingredient({this.id, this.ingredient});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      ingredient: json['ingredient'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ingredient'] = this.ingredient;
    return data;
  }
}
