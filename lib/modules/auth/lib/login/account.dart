class Account{
  String username;
  String password;
  Account({this.username, this.password});
  Account.fromMap(Map<String, dynamic> map){
    username = map['username'];
    password = map['password'];
  }
}