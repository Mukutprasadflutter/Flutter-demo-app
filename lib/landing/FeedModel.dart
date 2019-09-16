class FeedModel {
  String complexity;
  String firstName;
  int inCookingList;
  String lastName;
  String name;
  String photo;
  String preparationTime;
  int recipeId;
  String serves;
  String ytUrl;

  FeedModel({this.complexity, this.firstName, this.inCookingList, this.lastName, this.name, this.photo, this.preparationTime, this.recipeId, this.serves, this.ytUrl});

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      complexity: json['complexity'],
      firstName: json['firstName'],
      inCookingList: json['inCookingList'],
      lastName: json['lastName'],
      name: json['name'],
      photo: json['photo'] != null ? (json['photo']) : "",
      preparationTime: json['preparationTime'],
      recipeId: json['recipeId'],
      serves: json['serves'],
      ytUrl: json['ytUrl'] != null ? (json['ytUrl']) : "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complexity'] = this.complexity;
    data['firstName'] = this.firstName;
    data['inCookingList'] = this.inCookingList;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['preparationTime'] = this.preparationTime;
    data['recipeId'] = this.recipeId;
    data['serves'] = this.serves;
    if (this.photo != null) {
      data['photo'] = this.photo;
    }
    if (this.ytUrl != null) {
      data['ytUrl'] = this.ytUrl;
    }
    return data;
  }
}