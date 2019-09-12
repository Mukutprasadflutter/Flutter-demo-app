class FeedModel {
  String complexity;
  String firstName;
  String lastName;
  String name;
  String photo;
  String preparationTime;
  String serves;
  int recipeId;

  FeedModel(
      {this.complexity,
      this.firstName,
      this.lastName,
      this.name,
      this.photo,
      this.preparationTime,
      this.serves,
      this.recipeId});

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
        complexity: json['complexity'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        name: json['name'],
        photo: json['photo'] != null ? (json['photo']) : "",
        preparationTime: json['preparationTime'],
        serves: json['serves'],
        recipeId: json['recipeId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complexity'] = this.complexity;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['preparationTime'] = this.preparationTime;
    data['serves'] = this.serves;
    data['recipeId'] = this.recipeId;
    if (this.photo != null) {
      data['photo'] = this.photo;
    }
    return data;
  }
}
