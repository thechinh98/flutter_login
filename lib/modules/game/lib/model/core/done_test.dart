class DoneTest{
  int id = 0;
  int point = 0;
  String title = "";

  DoneTest({required this.id,required this.title,required this.point});
  DoneTest.fromJson(Map<String, dynamic> json){
    id = json["id"] as int;
    point = json["point"] as int;
    title = json["name"] as String;
  }
}