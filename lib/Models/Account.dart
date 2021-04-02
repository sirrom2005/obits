/*
* @Author Rohan Morris
* @Date 07/04/2020
* User account class
* */

class Account {
  final int id;
  final String authToken;
  final String name;
  final String email;
  final String last_login_at;
  final String avatar_url;
  final String message;

  Account({this.id, this.authToken, this.name, this.email, this.last_login_at, this.avatar_url, this.message});

  factory Account.fromJson(Map<String, dynamic> json){
    try {
      return new Account(
        id: json['id'],
        authToken: json['authToken'],
        name: json['name'],
        email: json['email'],
        last_login_at: json['last_login_at'],
        avatar_url: json['avatar_url'],
        message: json['message'],
      );
    }on Exception{
      throw Exception("Null error");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id"            : this.id,
      "authToken"     : this.authToken,
      "name"          : this.name,
      "email"         : this.email,
      "last_login_at" : this.last_login_at,
      "avatar_url"    : this.avatar_url,
      "message"       : this.message,
    };
  }
}