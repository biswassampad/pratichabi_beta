import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import '../enum/user_state.dart';

class Utils {
    final _picker = ImagePicker();
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  // this is new

  Future<File> pickImage({@required ImageSource source}) async{
   final pickedFile = await _picker.getImage(source: source);
  final File file = File(pickedFile.path);
  print(file);
    return await compressImage(file);
  }

  Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    return new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
  
  static int stateToNum(UserState userState){
    switch(userState){
      case UserState.Offline:
      return 0;

      case UserState.Online:
      return 1;

      default:
      return 2;
    }
  }

  static UserState numToState(int number){
    switch(number){
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }
  }


  static String formatDateString(String dateString){
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/mm/yy');

    return formatter.format(dateTime);

  }


  }