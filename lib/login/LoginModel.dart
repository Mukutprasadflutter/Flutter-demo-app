class LoginModel {
    String email;
    String firstName;
    int id;
    String lastName;
    String password;
    String token;

    LoginModel({this.email, this.firstName, this.id, this.lastName, this.password, this.token});

    factory LoginModel.fromJson(Map<String, dynamic> json) {
        return LoginModel(
            email: json['email'], 
            firstName: json['firstName'], 
            id: json['id'], 
            lastName: json['lastName'], 
            password: json['password'], 
            token: json['token'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['email'] = this.email;
        data['firstName'] = this.firstName;
        data['id'] = this.id;
        data['lastName'] = this.lastName;
        data['password'] = this.password;
        data['token'] = this.token;
        return data;
    }
}