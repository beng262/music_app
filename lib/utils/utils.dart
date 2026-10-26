import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../view_model/controller/file_list_controller.dart';
import 'dart:async' show Future;
class Utils {
 static final controller = Get.put(FilesController());

  static Future<bool> permissionRequest()async{

    var status = await Permission.storage.status;
    if (status.isDenied) {
      var temp = await Permission.storage.status;
      if(temp.isGranted){
        return true;
      }else {
        return false;
      }
    }
    else
    {
      return true;
    }

  }


  static getFileLength(String filePath)async{
    final player=AudioPlayer();
    try {
      await player.setFilePath(filePath).then((value){
        String prefix=player.duration!.inMinutes.toString();
        String postFix=(player.duration!.inSeconds % 60).toString();
        if(prefix.length<2){
          prefix='0$prefix';
        }
        if(postFix.length<2){
          postFix='0$postFix';
        }
        controller.audioLength.add('$prefix:$postFix');
      });
    } finally {
      await player.dispose();
    }
  }
}