import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class UploadImageService {
//uploadImages method upload the image using asset
  static Future<String> uploadImages(image, {name}) async {
    final imagePath = await getFilePath(image); //get image path
    final uri = Uri.parse("$apiUrl/upload_image.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = name == null ? image.name : name;
    var pic = await http.MultipartFile.fromPath("image", imagePath);
    request.files.add(pic);
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      return "error";
    }
  }

  static Future<String> uploadImages2(imagePath, {name}) async {
    // final imagePath = await getFilePath(image); //get image path
    final uri = Uri.parse("$apiUrl/upload_image.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = name == null ? imagePath.name : name;
    var pic = await http.MultipartFile.fromPath("image", imagePath);
    request.files.add(pic);
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      return "error";
    }
  }

//uploadImagesPath method upload the image using path
  static Future<String> uploadImagesPath(imagePath) async {
    //final imagePath=await getFilePath(image);
    final uri = Uri.parse("$apiUrl/upload_image.php");
    var request = http.MultipartRequest('POST', uri);
    // request.fields['name']=image.name;
    var pic = await http.MultipartFile.fromPath("image", imagePath);
    request.files.add(pic);
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      return "error";
    }
  }


  static getFilePath(images) async {
    File file = await getImageFileFromAssets(images);

    return file.path;
  }
}

Future<File> getImageFileFromAssets(asset) async {
  final byteData = await asset.getByteData();

  final tempFile =
  File("${(await getTemporaryDirectory()).path}/${asset.name}");
  final file = await tempFile.writeAsBytes(
    byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),);

  return file;
}


