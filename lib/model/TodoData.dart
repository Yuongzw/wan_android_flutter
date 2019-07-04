import 'dart:convert' show json;

class TodoData {

  int errorCode;
  String errorMsg;
  DataBean data;

  TodoData.fromParams({this.errorCode, this.errorMsg, this.data});

  factory TodoData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TodoData.fromJson(json.decode(jsonStr)) : new TodoData.fromJson(jsonStr);

  TodoData.fromJson(jsonRes) {
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : new DataBean.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }
}

class DataBean {

  int type;
  List<ListBean> doneList;
  List<ListBean> todoList;

  DataBean.fromParams({this.type, this.doneList, this.todoList});

  DataBean.fromJson(jsonRes) {
    type = jsonRes['type'];
    doneList = jsonRes['doneList'] == null ? null : [];

    for (var doneListItem in doneList == null ? [] : jsonRes['doneList']){
      doneList.add(doneListItem == null ? null : new ListBean.fromJson(doneListItem));
    }

    todoList = jsonRes['todoList'] == null ? null : [];

    for (var todoListItem in todoList == null ? [] : jsonRes['todoList']){
      todoList.add(todoListItem == null ? null : new ListBean.fromJson(todoListItem));
    }
  }

  @override
  String toString() {
    return '{"type": $type,"doneList": $doneList,"todoList": $todoList}';
  }
}

class TodoBean {

  int completeDate;
  int date;
  int id;
  int priority;
  int status;
  int type;
  int userId;
  String completeDateStr;
  String content;
  String dateStr;
  String title;

  TodoBean.fromParams({this.completeDate, this.date, this.id, this.priority, this.status, this.type, this.userId, this.completeDateStr, this.content, this.dateStr, this.title});

  TodoBean.fromJson(jsonRes) {
    completeDate = jsonRes['completeDate'];
    date = jsonRes['date'];
    id = jsonRes['id'];
    priority = jsonRes['priority'];
    status = jsonRes['status'];
    type = jsonRes['type'];
    userId = jsonRes['userId'];
    completeDateStr = jsonRes['completeDateStr'];
    content = jsonRes['content'];
    dateStr = jsonRes['dateStr'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"date": $date,"id": $id,"priority": $priority,"status": $status,"type": $type,"userId": $userId,"completeDateStr": ${completeDateStr != null?'${json.encode(completeDateStr)}':'null'},"content": ${content != null?'${json.encode(content)}':'null'},"dateStr": ${dateStr != null?'${json.encode(dateStr)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

class ListBean {

  int date;
  List<TodoBean> todoList;

  ListBean.fromParams({this.date, this.todoList});

  ListBean.fromJson(jsonRes) {
    date = jsonRes['date'];
    todoList = jsonRes['todoList'] == null ? null : [];

    for (var todoListItem in todoList == null ? [] : jsonRes['todoList']){
      todoList.add(todoListItem == null ? null : new TodoBean.fromJson(todoListItem));
    }
  }

  @override
  String toString() {
    return '{"date": $date,"todoList": $todoList}';
  }
}

