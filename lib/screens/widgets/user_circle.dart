import 'package:flutter/material.dart';
import 'package:senger/provider/user_provider.dart';
import 'package:senger/screens/widgets/user_details_container.dart';
import 'package:senger/utils/universal_variables.dart';
import 'package:senger/utils/utils.dart';
import 'package:provider/provider.dart';

class UserCircle extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
     final UserProvider userProvider = Provider.of<UserProvider>(context);
  
    return GestureDetector(
          onTap: ()=> showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
             builder: (context) => UserDetailsContainer(),
             isScrollControlled: true,
             ),
          child: Container(
          height:40,
          width:40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color:Colors.white,
            border: Border.all(
              color: Colors.black,
            width: 2,
          ),
          ),
          
          child:Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  Utils.getInitials(userProvider.getUser.name),
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color:UniversalVaribales.lightBlueColor,
                    fontSize: 13
                  )
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height:12,
                  width:12,
                  decoration: BoxDecoration(
                    shape:BoxShape.circle,
                    border:Border.all(
                      color:Colors.white,
                      width:2,
                    ),
                    color:UniversalVaribales.onlineDotColor,
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
