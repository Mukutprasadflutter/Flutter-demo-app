class FavouriteModel {
    String complexity;
    String firstName;
    String lastName;
    String name;
    String photo;
    String preparationTime;
    int recipeId;
    String serves;

    FavouriteModel({this.complexity, this.firstName, this.lastName, this.name, this.photo, this.preparationTime, this.recipeId, this.serves});

    factory FavouriteModel.fromJson(Map<String, dynamic> json) {
        return FavouriteModel(
            complexity: json['complexity'], 
            firstName: json['firstName'], 
            lastName: json['lastName'], 
            name: json['name'], 
            photo: json['photo'] != null ? (json['photo']) : "",
            preparationTime: json['preparationTime'], 
            recipeId: json['recipeId'], 
            serves: json['serves'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['complexity'] = this.complexity;
        data['firstName'] = this.firstName;
        data['lastName'] = this.lastName;
        data['name'] = this.name;
        data['preparationTime'] = this.preparationTime;
        data['recipeId'] = this.recipeId;
        data['serves'] = this.serves;
        if (this.photo != null) {
            data['photo'] = this.photo;
        }
        return data;
    }
}