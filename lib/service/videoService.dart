import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/videoModel.dart';
import 'package:http/http.dart' as http;

class VideoService {
  static const _viewUrl = "$apiUrl/getVideoUrl";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _addUrl = "$apiUrl/add_video";
  static const _updateUrl = "$apiUrl/update_video";

  static List<VideoModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<VideoModel>.from(data.map((item) => VideoModel.fromJson(item)));
  }

  static Future<List<VideoModel>> getData(getLimit) async {
    final limit = getLimit.toString();
    final response = await http.get(Uri.parse("$_viewUrl?limit=$limit"));
    if (response.statusCode == 200) {
      List<VideoModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "youtubeLinks"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static addData(VideoModel videoModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: videoModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(VideoModel videoModel) async {
    final res =
        await http.post(Uri.parse(_updateUrl), body: videoModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
