class Message {
  String? fromid;
  String? msg;
  String? read;
  String? sent;
  String? told;
  String? type;

  Message({this.fromid, this.msg, this.read, this.sent, this.told, this.type});

  Message.fromJson(Map<String, dynamic> json) {
    fromid = json['fromid'];
    msg = json['msg'];
    read = json['read'];
    sent = json['sent'];
    told = json['told'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromid'] = this.fromid;
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['sent'] = this.sent;
    data['told'] = this.told;
    data['type'] = this.type;
    return data;
  }
}