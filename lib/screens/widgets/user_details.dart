import 'package:flutter/material.dart';
import 'package:senger/models/user.dart';
import 'package:senger/provider/user_provider.dart';
import 'package:senger/screens/widgets/cached_image.dart';
import 'package:provider/provider.dart';

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    bool isAboutEdit = false;
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding:EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CachedImage(user.profilePhoto,isRound:true,radius:50),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:Colors.black
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color:Colors.black
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              TextSection(keyname: 'About',keyvalue: 'Life is a journey and everyday is a new begining.',),
              TextSection(keyname: 'Phone',keyvalue: '+917008787850',),
              TextSection(keyname: 'Country',keyvalue: 'India',),
              TextSection(keyname: 'Location',keyvalue: 'Deogarh,Odisha,India,Asia',),
              TextSection(keyname: 'Moto',keyvalue: 'Live like a human serve like a king',),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ],
          )
        ],
      ),
    );
  }
}


class TextSection extends StatelessWidget {
  final String keyname;
  final String keyvalue;
  const TextSection({Key key, this.keyname, this.keyvalue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                      Text(
                        this.keyname,
                        style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0 
                        ),
                      ),
                      Text(
                        '  :  ',
                        style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0 
                        ),
                      ),
                      Container(
                        height: 50,width: MediaQuery.of(context).size.width * 0.6,
                        child: Center(
                          child: Text(
                            this.keyvalue,
                             maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:Colors.grey[800],
                              fontStyle: FontStyle.italic,
                               fontFamily: 'Open Sans',
                               fontSize: 16.0
                            ),
                            ),
                        ),
                      ),
                ],
                ),
                
              )
    );
  }
}