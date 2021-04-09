
final String tableTopic = "Topic";
final String columnId = "id";
final String columnTitle = "title";
final String columnParentId = 'parentId';
final String columnQuestionNum = 'questionNum';
final String imageColumn = "image";
final String descriptionColumn = "shortDes";
final String typeColumn = "type";
final String practiceModeColumn = "practiceMode";
final String indexesColumn = "indexes";
final String createTopicTable = 'create table IF NOT EXIST $tableTopic ('
    '$columnId text primaryKey,'
    '$columnTitle text not null'
    '$columnParentId text not null,'
    '$columnQuestionNum integer not null,'
    '$imageColumn text,'
    '$descriptionColumn text, '
    '$typeColumn integer,'
    '$practiceModeColumn integer,'
    '$indexesColumn integer )';