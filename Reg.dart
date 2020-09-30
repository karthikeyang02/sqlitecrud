
class Reg {

  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  String _phone;

  Reg(this._title, this._date, this._priority, this._description, this._phone);

  Reg.withId(this._id, this._title, this._date, this._priority,
      this._description, this._phone);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;
  String get phone => _phone;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set phone(String newPhone){
    if(newPhone.length <= 255){
      this._phone = newPhone;
    }
  }

  //Converting to Map Object

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['phone'] = _phone;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Reg.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._phone = map['phone'];
    this._priority = map['priority'];
    this._date = map['date'];
  }

}


