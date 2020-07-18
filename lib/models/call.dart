class Call{
  String callerId;
  String callerName;
  String callerPic;
  String recieverId;
  String recieverName;
  String recieverPic;
  String channelId;
  bool hasDialled;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.recieverId,
    this.recieverName,
    this.recieverPic,
    this.channelId,
    this.hasDialled
  });


  Map<String, dynamic> toMap(Call call){
    Map<String,dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["caller_pic"] = call.callerPic;
    callMap["reciever_id"] = call.recieverId;
    callMap["reciever_name"] = call.recieverName;
    callMap["reciever_pic"] = call.recieverPic;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialed"] = call.hasDialled;

    return callMap;
  }

  Call.fromMap(Map callMap){
    this.callerId = callMap["called_id"];
    this.callerName = callMap["caller_name"];
    this.callerPic = callMap["caller_pic"];
    this.recieverId = callMap["reciever_id"];
    this.recieverName = callMap["reciever_name"];
    this.recieverPic = callMap["reciever_pic"];
    this.channelId = callMap["channel_id"];
    this.hasDialled = callMap["has_dialed"];
  }
}