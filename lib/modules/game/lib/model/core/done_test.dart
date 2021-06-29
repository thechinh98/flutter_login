class DoneTest{
  int? id;
  int? point;
  String? name;

  DoneTest({this.id, this.name, this.point});
  DoneTest.fromJson(Map<String, dynamic> json){
    id = json["id"] as int;
    point = json["point"] as int;
    name = json["name"] as String;
  }
}