
import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;

class UploadFile {
  static Future<String> uploadFiles(files) async {
    print("start file uploading");
    final filePath = files.path; //await getFilePath(files); //get image path
    final uri = Uri.parse("$apiUrl/upload_file.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = files.name;
    var pic = await http.MultipartFile.fromPath("image", filePath);
    request.files.add(pic);
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print("stop file uploading");
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      return "error";
    }
  }

  // static getFilePath(images) async {
  //   var path = await FlutterAbsolutePath.getAbsolutePath(
  //       images.identifier); //get path of the image from asset
  //   return path;
  // }

}
