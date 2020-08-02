import 'package:flutter/material.dart';
import 'package:senger/constants/strings.dart';
import 'package:senger/models/logs.dart';
import 'package:senger/resources/localdb/repository/log_respository.dart';
import 'package:senger/screens/widgets/cached_image.dart';
import 'package:senger/screens/widgets/quite_box.dart';
import 'package:senger/utils/utils.dart';
import 'package:senger/widgets/custom_tile.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {

  getIcon(String callStatus){
    Icon _icon;
    double _iconSize = 15;
    switch(callStatus){
      case CALL_STATUS_DIALED:
        _icon = Icon(
          Icons.call_made,
          size:_iconSize,
          color:Colors.green
        );
        break;

        case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          size:_iconSize,
          color:Colors.red
        );
        break;
      
        
        case CALL_STATUS_REJECTED:
        _icon = Icon(
          Icons.call_to_action,
          size:_iconSize,
          color:Colors.red
        );
        break;

        default:
        _icon = Icon(
          Icons.call_received,
          size:_iconSize,
          color:Colors.green
        );
        break;

    }

    return Container(
      margin:EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future:LogRepository.getLogs(),
      builder:(context,AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(snapshot.hasData){
            List<dynamic> logList = snapshot.data;

            if(logList.isNotEmpty){
                return ListView.builder(
                  itemCount: logList.length,
                  itemBuilder:(context,index){
                    Log _log = logList[index];
                    bool hasDialed = _log.callStatus == CALL_STATUS_DIALED;
                    return CustomTile(
                      leading: CachedImage(
                        hasDialed ? _log.receiverPic : _log.callerPic,
                        isRound: true,
                        radius: 45,
                      ), 
                      mini: false,
                      title:Text(
                        hasDialed ? _log.receiverName : _log.callerName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color:Colors.black
                        ),
                      ), 
                      icon:getIcon(_log.callStatus),
                      subtitle:Text('heh',
                        // Utils.formatDateString(_log.timestamp),
                        style: TextStyle(
                          fontSize: 13.0
                        )
                      ),
                      onLongPress: ()=> showDialog(
                        context: context,
                        builder:(context)=>AlertDialog(
                          title: Text("Delete this log ?"),
                          content: Text("Are you sure you want to delete this log ?"),
                          actions:<Widget>[
                            FlatButton(
                              onPressed: ()async{
                                Navigator.maybePop(context);
                                await LogRepository.deleteLogs(index);
                                if(mounted){
                                  setState(() {
                                    
                                  });
                                }
                              },
                              child: Text("Yes")
                              ),
                               FlatButton(
                              onPressed: ()async{
                                Navigator.maybePop(context);
                              },
                              child: Text("No")
                              )
                          ]
                        )
                        ),
                      );
                  }

                  );
            }
            return QuietBox(
                header: "This is where all your call logs are listed", 
                bodytext: "Make calls to your friends and famiily on a click without any extra cost"
            );
        }

        return Center(
          child: Text('No Call Logs',style: TextStyle(color:Colors.black),),
        );
      }
    );
  }
}