// import 'dart:io';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
//
// // import 'package:emoji_picker_flutter/emoji_picker_flutter.daimport 'package:cached_network_image/cached_network_image.dart'rt';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chat_image/chat_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:isolate_image_compress/isolate_image_compress.dart';
// import 'package:love_app/helpers/api/api_service.dart';
// import 'package:love_app/helpers/constant.dart';
// import 'package:love_app/helpers/package/align.dart';
// import 'package:love_app/helpers/package/button.dart';
// import 'package:love_app/helpers/package/card.dart';
// import 'package:love_app/helpers/package/column.dart';
// import 'package:love_app/helpers/package/icon.dart';
// import 'package:love_app/helpers/package/row.dart';
// import 'package:love_app/helpers/package/show_dialog.dart';
// import 'package:love_app/helpers/package/text.dart';
// import 'package:love_app/helpers/package/textFormField.dart';
// import 'package:love_app/helpers/helper.dart';
// import 'package:love_app/helpers/package/wrap.dart';
// import 'package:love_app/services/fcmServices/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:love_app/models/MessageModel.dart';
//
// // import 'package:advance_image_picker/advance_image_picker.dart';
// import 'package:image_picker/image_picker.dart' ;
// import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart' as intl;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:path_provider/path_provider.dart';
// // import 'package:record_mp3/record_mp3.dart';
// // import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
//
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart' show DateFormat, Intl;
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data' show Uint8List;
//
// import '../../db/notes_database.dart';
// import '../../main.dart';
// import '../../models/download_file.dart';
// import '../../services/fcmServices/notifications.dart';
// import 'Calling/dial.dart';
// import 'Calling/incomingCall.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:stream_transform/stream_transform.dart';
// import 'package:visibility_detector/visibility_detector.dart';
//
// import 'package:love_app/helpers/helper.dart';
//
//
// StreamController<String> inputMessageStreamController = StreamController();
//
// ///
// const int tSAMPLERATE = 8000;
//
// /// Sample rate used for Streams
// const int tSTREAMSAMPLERATE = 44000; // 44100 does not work for recorder on iOS
//
// ///
// const int tBLOCKSIZE = 4096;
//
// ///
// enum Media {
//   ///
//   file,
//
//   ///
//   buffer,
//
//   ///
//   asset,
//
//   ///
//   stream,
//
//   ///
//   remoteExampleFile,
// }
//
// ///
// enum AudioState {
//   ///
//   isPlaying,
//
//   ///
//   isPaused,
//
//   ///
//   isStopped,
//
//   ///
//   isRecording,
//
//   ///
//   isRecordingPaused,
// }
//
// //https://github.com/Canardoux/flutter_sound/blob/master/flutter_sound/example/lib/main.dart
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreen createState() => _ChatScreen();
// }
//
// class _ChatScreen extends State<ChatScreen>  {
//   late IO.Socket socket;
//   String onine_or_offline = '';
//   String typing_or_record = '';
//
//   // MedcorderAudio audioModule = new MedcorderAudio();
//   bool canRecord = false;
//   double recordPower = 0.0;
//   double recordPosition = 0.0;
//   bool isRecord = false;
//   bool isPlay = false;
//   double playPosition = 0.0;
//   // String audioFile = "";
//   // String fileUrl = "";
//
//   // String _fileName = 'myAudio.aac';
//   // String _path = "/data/user/0/net.deals101.face2face.love/file/";
//
//   // FlutterSoundRecorder? _recorder;
//   bool _isRecorderInitialized = false;
//
//   StreamSubscription? _recorderSubscription;
//   StreamSubscription? _playerSubscription;
//   StreamSubscription? _recordingDataSubscription;
//
//   FlutterSoundPlayer playerModule = FlutterSoundPlayer();
//   FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
//
//   String _recorderTxt = '00:00';
//   String _playerTxt = '00:00';
//   int _currentPlayerId = 0;
//   List? _playerIds;
//   List? _playerTxts;
//   // Map<int, String>? _playerTimeDetail = {0:'00:00'};
//   // Map<int, IconData>? _playerButtonDetail = {0:Icons.play_arrow};
//   Map<int, dynamic>? _playerDetail = {
//     0:{
//       'time': '00:00',
//       'icon': Icons.play_arrow,
//       'slider_min': 0,
//       'slider_max': 0,
//     }
//   };
//   double? _dbLevel;
//
//   double sliderCurrentPosition = 0.0;
//   double maxDuration = 1.0;
//   Media? _media = Media.remoteExampleFile;
//   Codec _codec = Codec.aacMP4;
//
//   bool? _encoderSupported = true; // Optimist
//   bool _decoderSupported = true; // Optimist
//
//   StreamController<Food>? recordingDataController;
//   IOSink? sink;
//
//   // bool get isRecording => _recorder!.isRecording;
//
//   Future<void> init() async {
//     await openTheRecorder();
//     await _initializeExample();
//
//     // if ((!kIsWeb) && Platform.isAndroid) {
//     //   await copyAssets();
//     // }
//
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration(
//       avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
//       avAudioSessionCategoryOptions:
//       AVAudioSessionCategoryOptions.allowBluetooth |
//       AVAudioSessionCategoryOptions.defaultToSpeaker,
//       avAudioSessionMode: AVAudioSessionMode.spokenAudio,
//       avAudioSessionRouteSharingPolicy:
//       AVAudioSessionRouteSharingPolicy.defaultPolicy,
//       avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
//       androidAudioAttributes: const AndroidAudioAttributes(
//         contentType: AndroidAudioContentType.speech,
//         flags: AndroidAudioFlags.none,
//         usage: AndroidAudioUsage.voiceCommunication,
//       ),
//       androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
//       androidWillPauseWhenDucked: true,
//     ));
//   }
//
//   // Future<void> copyAssets() async {
//   //   var dataBuffer =
//   //   (await rootBundle.load('assets/canardo.png')).buffer.asUint8List();
//   //   var path = '${await playerModule.getResourcePath()}/assets';
//   //   if (!await Directory(path).exists()) {
//   //     await Directory(path).create(recursive: true);
//   //   }
//   //   await File('$path/canardo.png').writeAsBytes(dataBuffer);
//   // }
//
//   String buttonType = "mic";
//   bool _isRecording = false;
//   final List<String?> _path = [
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//     null,
//   ];
//
//   // List<String> assetSample = [
//   //   'assets/samples/sample.aac',
//   //   'assets/samples/sample.aac',
//   //   'assets/samples/sample.opus',
//   //   'assets/samples/sample_opus.caf',
//   //   'assets/samples/sample.mp3',
//   //   'assets/samples/sample.ogg',
//   //   'assets/samples/sample.pcm',
//   //   'assets/samples/sample.wav',
//   //   'assets/samples/sample.aiff',
//   //   'assets/samples/sample_pcm.caf',
//   //   'assets/samples/sample.flac',
//   //   'assets/samples/sample.mp4',
//   //   'assets/samples/sample.amr', // amrNB
//   //   'assets/samples/sample_xxx.amr', // amrWB
//   //   'assets/samples/sample_xxx.pcm', // pcm8
//   //   'assets/samples/sample_xxx.pcm', // pcmFloat32
//   //   '', // 'assets/samples/sample_xxx.pcm', // pcmWebM
//   //   'assets/samples/sample_opus.webm', // opusWebM
//   //   'assets/samples/sample_vorbis.webm', // vorbisWebM
//   // ];
//
//   // List<String> remoteSample = [
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/01.aac', // 'assets/samples/sample.aac',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/01.aac', // 'assets/samples/sample.aac',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/08.opus', // 'assets/samples/sample.opus',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/04-opus.caf', // 'assets/samples/sample_opus.caf',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/05.mp3', // 'assets/samples/sample.mp3',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/07.ogg', // 'assets/samples/sample.ogg',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/10-pcm16.raw', // 'assets/samples/sample.pcm',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/13.wav', // 'assets/samples/sample.wav',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/02.aiff', // 'assets/samples/sample.aiff',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/01-pcm.caf', // 'assets/samples/sample_pcm.caf',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/04.flac', // 'assets/samples/sample.flac',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/06.mp4', // 'assets/samples/sample.mp4',
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/03.amr', // 'assets/samples/sample.amr', // amrNB
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/03.amr', // 'assets/samples/sample_xxx.amr', // amrWB
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/09-pcm8.raw', // 'assets/samples/sample_xxx.pcm', // pcm8
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/12-pcmfloat.raw', // 'assets/samples/sample_xxx.pcm', // pcmFloat32
//   //   '', // 'assets/samples/sample_xxx.pcm', // pcmWebM
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/02-opus.webm', // 'assets/samples/sample_opus.webm', // opusWebM
//   //   'https://flutter-sound.canardoux.xyz/web_example/assets/extract/03-vorbis.webm', // 'assets/samples/sample_vorbis.webm', // vorbisWebM
//   // ];
//
//   Future<void> _initializeExample() async {
//     await playerModule.closePlayer();
//     await playerModule.openPlayer();
//     await playerModule.setSubscriptionDuration(Duration(milliseconds: 10));
//     await recorderModule.setSubscriptionDuration(Duration(milliseconds: 10));
//     await initializeDateFormatting();
//     await setCodec(_codec);
//   }
//
//   Future<void> setCodec(Codec codec) async {
//     _encoderSupported = await recorderModule.isEncoderSupported(codec);
//     _decoderSupported = await playerModule.isDecoderSupported(codec);
//
//     setState(() {
//       _codec = codec;
//     });
//   }
//
//   Future<void> openTheRecorder() async {
//     if (!kIsWeb) {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }
//     }
//     await recorderModule.openRecorder();
//
//     if (!await recorderModule.isEncoderSupported(_codec) && kIsWeb) {
//       _codec = Codec.opusWebM;
//     }
//   }
//
//   void startRecorder() async {
//     init();
//     _isRecording = true;
//     try {
//       // Request Microphone permission if needed
//       if (!kIsWeb) {
//         var status = await Permission.microphone.request();
//         if (status != PermissionStatus.granted) {
//           throw RecordingPermissionException(
//               'Microphone permission not granted');
//         }
//       }
//       var path = '';
//       if (!kIsWeb) {
//         var tempDir = await getTemporaryDirectory();
//         path = '${tempDir.path}/flutter_sound${ext[_codec.index]}';
//       } else {
//         path = '_flutter_sound${ext[_codec.index]}';
//       }
//
//       if (_media == Media.stream) {
//         assert(_codec == Codec.pcm16);
//         if (!kIsWeb) {
//           var outputFile = File(path);
//           if (outputFile.existsSync()) {
//             await outputFile.delete();
//           }
//           sink = outputFile.openWrite();
//         } else {
//           sink = null; // TODO
//         }
//         recordingDataController = StreamController<Food>();
//         _recordingDataSubscription =
//             recordingDataController!.stream.listen((buffer) {
//               if (buffer is FoodData) {
//                 sink!.add(buffer.data!);
//               }
//             });
//         await recorderModule.startRecorder(
//           toStream: recordingDataController!.sink,
//
//           codec: _codec,
//           numChannels: 1,
//           sampleRate: tSTREAMSAMPLERATE, //tSAMPLERATE,
//         );
//       } else {
//         await recorderModule.startRecorder(
//           toFile: path,
//           codec: _codec,
//           bitRate: 8000,
//           numChannels: 1,
//           sampleRate: (_codec == Codec.pcm16) ? tSTREAMSAMPLERATE : tSAMPLERATE,
//         );
//       }
//       recorderModule.logger.d('startRecorder');
//
//       _recorderSubscription = recorderModule.onProgress!.listen((e) {
//         var date = DateTime.fromMillisecondsSinceEpoch(
//             e.duration.inMilliseconds,
//             isUtc: true);
//         var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//
//         setState(() {
//           _recorderTxt = txt.substring(0, 5);
//           _dbLevel = e.decibels;
//         });
//       });
//
//       setState(() {
//         _isRecording = true;
//         _path[_codec.index] = path;
//       });
//       // print(path);
//
//     } on Exception catch (err) {
//       recorderModule.logger.e('startRecorder error: $err');
//       setState(() {
//         stopRecorder();
//         _isRecording = false;
//         cancelRecordingDataSubscription();
//         cancelRecorderSubscriptions();
//       });
//     }
//   }
//
//   void stopRecorder() async {
//     try {
//       await recorderModule.stopRecorder();
//       recorderModule.logger.d('stopRecorder');
//
//       cancelRecorderSubscriptions();
//       cancelRecordingDataSubscription();
//       // print(_path[_codec.index]!);
//       // await ApiServices().uploadReels(File(_path[_codec.index]!));
//       sendMsg(3);
//
//     } on Exception catch (err) {
//       recorderModule.logger.d('stopRecorder error: $err');
//     }
//
//     setState(() {
//       _isRecording = false;
//     });
//   }
//
//   void cancelRecorder() async {
//     try {
//       await recorderModule.stopRecorder();
//       recorderModule.logger.d('stopRecorder');
//
//       cancelRecorderSubscriptions();
//       cancelRecordingDataSubscription();
//       // print(_path[_codec.index]!);
//
//     } on Exception catch (err) {
//       recorderModule.logger.d('stopRecorder error: $err');
//     }
//     setState(() {
//       _isRecording = false;
//     });
//   }
//
//   Future<void>? onStartPlayerPressed(String audioFilePath, int id) {
//     // if (_media == Media.buffer && kIsWeb) {
//     //   return null;
//     // }
//     // if (_media == Media.file ||
//     //     _media == Media.stream ||
//     //     _media == Media.buffer) // A file must be already recorded to play it
//     //     {
//     //   if (_path[_codec.index] == null) return null;
//     // }
//     //
//     // if (_media == Media.stream && _codec != Codec.pcm16) {
//     //   return null;
//     // }
//
//     // Disable the button if the selected codec is not supported
//     // if (!(_decoderSupported || _codec == Codec.pcm16)) {
//     //   return null;
//     // }
//
//     return (playerModule.isStopped) ? startPlayer(audioFilePath, id) : null;
//   }
//
//   Future<void>? onStopPlayerPressed(int id) {
//     return (playerModule.isPlaying || playerModule.isPaused)
//         ? stopPlayer(id)
//         : null;
//   }
//
//   Future<void> startPlayer(String audioFilePath, int id) async {
//     // _playerButtonDetail!.addEntries({id:Icons.pause}.entries);
//     // _currentPlayerId = id;
//     try {
//       Uint8List? dataBuffer;
//       // audioFilePath;
//       var codec = _codec;
//       // if (_media == Media.asset) {
//       //   dataBuffer = (await rootBundle.load(file))
//       //       .buffer
//       //       .asUint8List();
//       // }
//       // else if (_media == Media.file || _media == Media.stream) {
//       //   // Do we want to play from buffer or from file ?
//       //   if (kIsWeb || await fileExists(_path[codec.index]!)) {
//       //     audioFilePath = _path[codec.index];
//       //   }
//       // } else if (_media == Media.buffer) {
//       //   // Do we want to play from buffer or from file ?
//       //   if (await fileExists(_path[codec.index]!)) {
//       //     dataBuffer = await makeBuffer(_path[codec.index]!);
//       //     if (dataBuffer == null) {
//       //       throw Exception('Unable to create the buffer');
//       //     }
//       //   }
//       // } else if (_media == Media.remoteExampleFile) {
//       //   // We have to play an example audio file loaded via a URL
//       //   audioFilePath = remoteSample[_codec.index];
//       // }
//
//       // if (_media == Media.stream) {
//       //   await playerModule.startPlayerFromStream(
//       //     codec: Codec.pcm16, //_codec,
//       //     numChannels: 1,
//       //     sampleRate: tSTREAMSAMPLERATE, //tSAMPLERATE,
//       //   );
//       //   _addListeners();
//       //   setState(() {});
//       //   await feedHim(audioFilePath!);
//       //   //await finishPlayer();
//       //   await stopPlayer();
//       //   return;
//       // } else {
//       //   if (audioFilePath != null) {
//       //     print(12344);
//           await playerModule.startPlayer(
//               fromURI: audioFilePath,
//               codec: codec,
//               sampleRate: tSTREAMSAMPLERATE,
//               whenFinished: () {
//                 playerModule.logger.d('Play finished');
//                 _playerDetail!.addEntries({id:{"time":"00:00","icon":Icons.play_arrow, "slider_min":0.0, "slider_max":0.0}}.entries);
//                 // _playerTimeDetail!.addEntries({id:"00:00"}.entries);
//                 // _playerButtonDetail!.addEntries({id:Icons.play_arrow}.entries);
//                 setState(() {});
//               });
//         // } else if (dataBuffer != null) {
//         //   if (codec == Codec.pcm16) {
//         //     dataBuffer = await flutterSoundHelper.pcmToWaveBuffer(
//         //       inputBuffer: dataBuffer,
//         //       numChannels: 1,
//         //       sampleRate: (_codec == Codec.pcm16 && _media == Media.asset)
//         //           ? 48000
//         //           : tSAMPLERATE,
//         //     );
//         //     codec = Codec.pcm16WAV;
//         //   }
//         //   await playerModule.startPlayer(
//         //       fromDataBuffer: dataBuffer,
//         //       sampleRate: tSAMPLERATE,
//         //       codec: codec,
//         //       whenFinished: () {
//         //         playerModule.logger.d('Play finished');
//         //         setState(() {});
//         //       });
//         // }
//       // }
//       _addListeners(id);
//       setState(() {});
//       playerModule.logger.d('<--- startPlayer');
//     } on Exception catch (err) {
//       playerModule.logger.e('error: $err');
//     }
//   }
//
//   Future<void> stopPlayer(int id) async {
//     // _playerButtonDetail!.addEntries({id:Icons.play_arrow}.entries);
//     try {
//       await playerModule.stopPlayer();
//       playerModule.logger.d('stopPlayer');
//       if (_playerSubscription != null) {
//         await _playerSubscription!.cancel();
//         _playerSubscription = null;
//       }
//       sliderCurrentPosition = 0.0;
//     } on Exception catch (err) {
//       playerModule.logger.d('error: $err');
//     }
//
//     // String time = _playerDetail![id]["time"];
//     // double slider_min = _playerDetail![id]["slider_min"];
//     // double slider_max = _playerDetail![id]["slider_max"];
//     // IconData icon = Icons.play_arrow;
//     setState(() {
//       _playerDetail!.addEntries({id:{"time": _playerDetail![id]["time"], "icon":Icons.play_arrow, "slider_min":_playerDetail![id]["slider_min"], "slider_max":_playerDetail![id]["slider_max"]}}.entries);
//     });
//   }
//
//   void pauseResumePlayer() async {
//     try {
//       if (playerModule.isPlaying) {
//         await playerModule.pausePlayer();
//       } else {
//         await playerModule.resumePlayer();
//       }
//     } on Exception catch (err) {
//       playerModule.logger.e('error: $err');
//     }
//     setState(() {});
//   }
//
//   void _addListeners(int id) {
//     cancelPlayerSubscriptions();
//
//     _playerSubscription = playerModule.onProgress!.listen((e) {
//       maxDuration = e.duration.inMilliseconds.toDouble();
//       if (maxDuration <= 0) maxDuration = 0.0;
//
//       sliderCurrentPosition = min(e.position.inMilliseconds.toDouble(), maxDuration);
//       if (sliderCurrentPosition < 0.0) {
//         sliderCurrentPosition = 0.0;
//       }
//
//       var date = DateTime.fromMillisecondsSinceEpoch(e.position.inMilliseconds, isUtc: true);
//       var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//       // print(txt);
//       setState(() {
//         // _playerTxt = txt.substring(0, 8);
//         // _playerTimeDetail!.addEntries({id:txt.substring(0, 8)}.entries);
//         _playerDetail!.addEntries({id:{"time":txt.substring(0, 5),"icon":Icons.pause,"slider_min":sliderCurrentPosition,"slider_max":maxDuration}}.entries);
//
//       });
//
//     });
//   }
//
//   final int blockSize = 4096;
//   Future<void> feedHim(String path) async {
//     var buffer = await _readFileByte(path);
//     //var buffer = await getAssetData('assets/samples/sample.pcm');
//
//     var lnData = 0;
//     var totalLength = buffer.length;
//     while (totalLength > 0 && !playerModule.isStopped) {
//       var bsize = totalLength > blockSize ? blockSize : totalLength;
//       await playerModule
//           .feedFromStream(buffer.sublist(lnData, lnData + bsize)); // await !!!!
//       lnData += bsize;
//       totalLength -= bsize;
//     }
//   }
//
//   Future<Uint8List> _readFileByte(String filePath) async {
//     var myUri = Uri.parse(filePath);
//     var audioFile = File.fromUri(myUri);
//     Uint8List bytes;
//     var b = await audioFile.readAsBytes();
//     bytes = Uint8List.fromList(b);
//     playerModule.logger.d('reading of bytes is completed');
//     return bytes;
//   }
//
//   Future<bool> fileExists(String path) async {
//     return await File(path).exists();
//   }
//
//   late FocusScopeNode currentFocus;
//
//   List<String> imageFiles = [];
//
//   bool isShowSticker = false;
//
//   String token = '';
//   String your_number = '';
//   int connection_id = 0;
//   int user_id = 0;
//
//   late List<MessageElement>? _messages = [];
//   String scrollDiretion = "";
//   String _currentMessageDate = "";
//
//   final inputMessageFocusNode = FocusNode();
//   final inputMessageTextEditingController = TextEditingController();
//
//   final _controller = ScrollController();
//   int _scrollviewPage = 2; // using in loadmore messages
//   bool _scrollviewLoading = true;
//   bool _scrollviewScollingStatus = false;
//
//   // final partnerNumberFocusNode = FocusNode();
//   // final partnerNumberTextEditingController = TextEditingController();
//   //
//   // final partnerTypeFocusNode = FocusNode();
//   // var currentSelectedPartnerTypeValue;
//   // var partnerType = ["Husband", "Wife", "Fiancee"];
//
//   int alertFormErrorShow = 0;
//
//
//   firebaseMessaging(){
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if(notification != null){
//         if(message.data["type"]=="call"){
//           PushNotificationServices().retrieveClientRequestData(
//               PushNotificationServices().getClientRequestId(message.data),);
//         }
//         else if(message.data["type"]=="text"){
//           flutterLocalNotificationsPlugin.show(
//               notification.hashCode,
//               notification.title,
//               notification.body,
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   channel.id,
//                   channel.name,
//                   channelDescription:
//                   channel.description,
//                   color: Colors.blue,
//                   playSound: true,
//                   icon: '@mipmap/ic_launcher',
//                 ),
//                 iOS: DarwinNotificationDetails(
//                     presentSound: true,
//                     subtitle: notification.body
//                 ),
//               ));
//           // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> UserManagement().handleAuth(),));
//
//         }
//       }
//     });
//
//     // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if(message != null){
//
//         RemoteNotification? notification = message.notification;
//         AndroidNotification? android = message.notification?.android;
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification!.title,
//             notificationDescription,
//
//             // notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription:
//                 channel.description,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher',
//               ),
//               iOS: DarwinNotificationDetails(
//                   presentSound: true,
//                   subtitle: notification.body
//               ),
//             ));
//         if(notification != null){
//           if(message.data["type"]=="call"){
//
//             PushNotificationServices().retrieveClientRequestData(
//                 PushNotificationServices().getClientRequestId(message.data), );
//           }
//           else if(message.data["type"]=="text"){
//             flutterLocalNotificationsPlugin.show(
//                 notification.hashCode,
//                 notification.title,
//                 notification.body,
//                 NotificationDetails(
//                   android: AndroidNotificationDetails(
//                     channel.id,
//                     channel.name,
//                     channelDescription:
//                     channel.description,
//                     color: Colors.blue,
//                     playSound: true,
//                     icon: '@mipmap/ic_launcher',
//                   ),
//                   iOS: DarwinNotificationDetails(
//                       presentSound: true,
//                       subtitle: notification.body
//                   ),
//                 ));
//             // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> UserManagement().handleAuth(),));
//
//           }
//         }
//         final routeFromMessage = message.data["route"];
//
//         // Navigator.of(context).pushNamed(routeFromMessage);
//       }
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if(notification != null){
//         if(message.data["type"]=="call"){
//           flutterLocalNotificationsPlugin.show(
//               notification.hashCode,
//               notification.title,
//               notification.body,
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   channel.id,
//                   channel.name,
//                   channelDescription:
//                   channel.description,
//                   color: Colors.blue,
//                   playSound: true,
//                   icon: '@mipmap/ic_launcher',
//                 ),
//                 iOS: DarwinNotificationDetails(
//                     presentSound: true,
//                     subtitle: notification.body
//                 ),
//               ));
//           PushNotificationServices().retrieveClientRequestData(
//               PushNotificationServices().getClientRequestId(message.data), );
//         }
//         else if(message.data["type"]=="text"){
//           flutterLocalNotificationsPlugin.show(
//               notification.hashCode,
//               notification.title,
//               notification.body,
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//
//                   channel.id,
//                   channel.name,
//                   channelDescription:
//                   channel.description,
//                   color: Colors.blue,
//                   playSound: true,
//                   icon: '@mipmap/ic_launcher',
//                 ),
//                 iOS: DarwinNotificationDetails(
//                     presentSound: true,
//                     subtitle: notification.body
//                 ),
//               ));
//           // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> UserManagement().handleAuth(),));
//
//         }
//       }
//     });
//   }
//   String? notificationTitle, notificationDescription;
//
//   @override
//   void initState() {
//
//     inputMessageStreamController.stream
//       .debounce(Duration(seconds: 3))
//       .listen((s) => {
//         socket.emit('online-emitter', {'connection_id' : connection_id.toString(), 'number': your_number})
//         // print("stop")
//       });
//
//     super.initState();
//
//     // for socket
//     connectToSocket();
//
//
//     isShowSticker = false;
//
//     helper.prefGetString('your_number').then((result){
//       if(result != "") {
//         your_number = result;
//       }
//     });
//     helper.prefGetInt('connection_id').then((result){
//       if(result != 0) {
//         connection_id = result;
//       }
//     });
//     helper.prefGetInt('user_id').then((result){
//       if(result != 0) {
//         user_id = result;
//       }
//     });
//     helper.prefGetString('token').then((result){
//       if(result != "") {
//         token = result;
//         _getMessages(token);
//       }
//     });
//     Notifications().init();
//     firebaseMessaging();
//     // scroll listener.
//     _controller.addListener(_getMessagesLodeMore);
//
//     // input field listener
//     inputMessageFocusNode.addListener(_onInputMessageFocusChange);
//
//     // ask permissions
//     askForPermissions();
//
//     init();
//
//     // for audio message
//     // audioModule.setCallBack((dynamic data) {
//     //   _onEvent(data);
//     // });
//     // _initSettings();
//     //
//     // init();
//
//     // _initSettings();
//     // init();
//   }
//
//   void cancelRecorderSubscriptions() {
//     if (_recorderSubscription != null) {
//       _recorderSubscription!.cancel();
//       _recorderSubscription = null;
//     }
//   }
//
//   void cancelPlayerSubscriptions() {
//     if (_playerSubscription != null) {
//       _playerSubscription!.cancel();
//       _playerSubscription = null;
//     }
//   }
//
//   void cancelRecordingDataSubscription() {
//     if (_recordingDataSubscription != null) {
//       _recordingDataSubscription!.cancel();
//       _recordingDataSubscription = null;
//     }
//     recordingDataController = null;
//     if (sink != null) {
//       sink!.close();
//       sink = null;
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     cancelPlayerSubscriptions();
//     cancelRecorderSubscriptions();
//     cancelRecordingDataSubscription();
//     releaseFlauto();
//     socket.disconnect();
//     socket.dispose();
//   }
//
//   Future<void> releaseFlauto() async {
//     try {
//       await playerModule.closePlayer();
//       await recorderModule.closeRecorder();
//     } on Exception {
//       playerModule.logger.e('Released unsuccessful');
//     }
//   }
//
//   Future askForPermissions() async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.microphone,
//     ].request();
//     // print(statuses[Permission.microphone]);
//   }
//
//   // void startRecorder() async {
//     // try {
//     //   // Request Microphone permission if needed
//     //   if (!kIsWeb) {
//     //     var status = await Permission.microphone.request();
//     //     if (status != PermissionStatus.granted) {
//     //       throw RecordingPermissionException(
//     //           'Microphone permission not granted');
//     //     }
//     //   }
//     //   var path = '';
//     //   if (!kIsWeb) {
//     //     var tempDir = await getTemporaryDirectory();
//     //     path = '${tempDir.path}/flutter_sound${ext[_codec.index]}';
//     //   } else {
//     //     path = '_flutter_sound${ext[_codec.index]}';
//     //   }
//     //
//     //   if (_media == Media.stream) {
//     //     assert(_codec == Codec.pcm16);
//     //     if (!kIsWeb) {
//     //       var outputFile = File(path);
//     //       if (outputFile.existsSync()) {
//     //         await outputFile.delete();
//     //       }
//     //       sink = outputFile.openWrite();
//     //     } else {
//     //       sink = null; // TODO
//     //     }
//     //     recordingDataController = StreamController<Food>();
//     //     _recordingDataSubscription =
//     //         recordingDataController!.stream.listen((buffer) {
//     //           if (buffer is FoodData) {
//     //             sink!.add(buffer.data!);
//     //           }
//     //         });
//     //     await recorderModule.startRecorder(
//     //       toStream: recordingDataController!.sink,
//     //
//     //       codec: _codec,
//     //       numChannels: 1,
//     //       sampleRate: tSTREAMSAMPLERATE, //tSAMPLERATE,
//     //     );
//     //   } else {
//     //     await recorderModule.startRecorder(
//     //       toFile: path,
//     //       codec: _codec,
//     //       bitRate: 8000,
//     //       numChannels: 1,
//     //       sampleRate: (_codec == Codec.pcm16) ? tSTREAMSAMPLERATE : tSAMPLERATE,
//     //     );
//     //   }
//     //   recorderModule.logger.d('startRecorder');
//     //
//     //   _recorderSubscription = recorderModule.onProgress!.listen((e) {
//     //     var date = DateTime.fromMillisecondsSinceEpoch(
//     //         e.duration.inMilliseconds,
//     //         isUtc: true);
//     //     var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//     //
//     //     setState(() {
//     //       _recorderTxt = txt.substring(0, 8);
//     //       _dbLevel = e.decibels;
//     //     });
//     //   });
//     //
//     //   setState(() {
//     //     _isRecording = true;
//     //     _path[_codec.index] = path;
//     //   });
//     // } on Exception catch (err) {
//     //   recorderModule.logger.e('startRecorder error: $err');
//     //   setState(() {
//     //     stopRecorder();
//     //     _isRecording = false;
//     //     cancelRecordingDataSubscription();
//     //     cancelRecorderSubscriptions();
//     //   });
//     // }
//   // }
//
//   // void stopRecorder() async {
//     // try {
//     //   await recorderModule.stopRecorder();
//     //   recorderModule.logger.d('stopRecorder');
//     //   cancelRecorderSubscriptions();
//     //   cancelRecordingDataSubscription();
//     // } on Exception catch (err) {
//     //   recorderModule.logger.d('stopRecorder error: $err');
//     // }
//     // setState(() {
//     //   _isRecording = false;
//     // });
//   // }
//
//   // Future<bool> fileExists(String path) async {
//   //   return await File(path).exists();
//   // }
//
//   /*  Future _initSettings() async {
//       // final String result = await audioModule.checkMicrophonePermissions();
//       // if (result == 'OK') {
//       //   await audioModule.setAudioSettings();
//       //   setState(() {
//       //     canRecord = true;
//       //   });
//       // }
//       // return;
//     }
//
//     Future _startRecord() async {
//       // try {
//       //   DateTime time = new DateTime.now();
//       //   setState(() {
//       //     audioFile = time.millisecondsSinceEpoch.toString();
//       //   });
//       //   final String result = await audioModule.startRecord(audioFile);
//       //   setState(() {
//       //     isRecord = true;
//       //   });
//       //   print('startRecord: ' + result);
//       // } catch (e) {
//       //   audioFile = "";
//       //   print(e);
//       //   print('startRecord: fail');
//       // }
//     }
//
//     Future _stopRecord() async {
//       // try {
//       //   final String result = await audioModule.stopRecord();
//       //   String completePath = '/data/user/0/net.deals101.face2face.love/file/${audioFile}.mp3';
//       //
//       //   File(completePath)
//       //       .create(recursive: true)
//       //       .then((File audioFile) async {
//       //     //write to file
//       //     Uint8List bytes = await audioFile.readAsBytes();
//       //     audioFile.writeAsBytes(bytes);
//       //     print("FILE CREATED AT : "+audioFile.path);
//       //   });
//       //
//       //   print('stopRecord: ' + result);
//       //   setState(() {
//       //     isRecord = false;
//       //   });
//       // } catch (e) {
//       //   print('stopRecord: fail');
//       //   setState(() {
//       //     isRecord = false;
//       //   });
//       // }
//     }
//
//     Future _startStopPlay() async {
//       // if (isPlay) {
//       //   await audioModule.stopPlay();
//       // } else {
//       //   await audioModule.startPlay({
//       //     "file": audioFile,
//       //     "position": 0.0,
//       //   });
//       // }
//     }*/
//
//   void _onEvent(dynamic event) {
//     // print(event['code']);
//     if (event['code'] == 'recording') {
//       double power = event['peakPowerForChannel'];
//       setState(() {
//         recordPower = (60.0 - power.abs().floor()).abs();
//         recordPosition = event['currentTime'];
//       });
//     }
//     if (event['code'] == 'playing') {
//       String url = event['url'];
//       setState(() {
//         // fileUrl = url;
//         playPosition = event['currentTime'];
//         isPlay = true;
//       });
//     }
//     if (event['code'] == 'audioPlayerDidFinishPlaying') {
//       setState(() {
//         playPosition = 0.0;
//         isPlay = false;
//       });
//     }
//   }
//
//   /*Future<bool> checkPermission() async {
//     if (!await Permission.microphone.isGranted) {
//       PermissionStatus status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }*/
//
//   String statusText = "";
//   bool isComplete = false;
//
// /*
//   void startRecord() async {
//     setState(() {
//       isRecord = true;
//     });
//     // bool hasPermission = await checkPermission();
//     // if (hasPermission) {
//       statusText = "Recording...";
//       recordFilePath = await getFilePath();
//       isComplete = false;
//       // RecordMp3.instance.start(recordFilePath, (type) {
//       //   statusText = "Record error--->$type";
//       //   // setState(() {});
//       // });
//     // } else {
//     //   statusText = "No microphone permission";
//     // }
//     // setState(() {});
//   }
// */
//
//   // void pauseRecord() {
//   //   if (RecordMp3.instance.status == RecordStatus.PAUSE) {
//   //     bool s = RecordMp3.instance.resume();
//   //     if (s) {
//   //       statusText = "Recording...";
//   //       setState(() {});
//   //     }
//   //   } else {
//   //     bool s = RecordMp3.instance.pause();
//   //     if (s) {
//   //       statusText = "Recording pause...";
//   //       setState(() {});
//   //     }
//   //   }
//   // }
// /*
//   void stopRecord() {
//     setState(() {
//       isRecord = false;
//     });
//
//     // bool s = RecordMp3.instance.stop();
//     // if (s) {
//     //   statusText = "Record complete";
//     //   isComplete = true;
//     //   setState(() {});
//     // }
//   }*/
//
// /*  void resumeRecord() {
//     // bool s = RecordMp3.instance.resume();
//     // if (s) {
//     //   statusText = "Recording...";
//     //   setState(() {});
//     // }
//   }*/
//
//   late String recordFilePath;
//   // late Source recordFilePath2;
//   //
//   // void play() {
//   //   if (recordFilePath != null && File(recordFilePath).existsSync()) {
//   //     AudioPlayer audioPlayer = AudioPlayer();
//   //     audioPlayer.play(recordFilePath2);
//   //   }
//   // }
//
//   int i = 0;
//
//   Future<String> getFilePath() async {
//     Directory storageDirectory = await getApplicationDocumentsDirectory();
//     String sdPath = storageDirectory.path + "/record";
//     var d = Directory(sdPath);
//     if (!d.existsSync()) {
//       d.createSync(recursive: true);
//     }
//     return sdPath + "/test_${i++}.mp3";
//   }
//
//   // @override
//   // void dispose() {
//   //   super.dispose();
//   //
//   //   // _recorder!.closeAudioSession();
//   //   // _recorder = null;
//   //   _isRecorderInitialized = false;
//   //
//   //
//   //   _controller.removeListener(_getMessagesLodeMore);
//   //
//   //   inputMessageFocusNode.removeListener(_onInputMessageFocusChange);
//   //   inputMessageFocusNode.dispose();
//   // }
//
//   void _getMessages(_token) async {
//     // print("connection_id");
//     // print(connection_id);
//     // List<MessageElement>? _msg = (await ApiService().getMessages(_token, connection_id, _scrollviewPage));
//     // print(_msg.toString());
//     // if(_msg != null) {
//     //   _messages = _msg;
//     // }else{
//     //   _messages = null;
//     // }
//     _messages = (await ApiService().getMessages(_token, connection_id, 1));
//     Future.delayed(const Duration(seconds: 5)).then((value) => setState(() {}));
//   }
//
//   Future<void> _getMessagesLodeMore() async {
//     // print(_controller.position.atEdge);
//     if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
//       setState(() {
//         scrollDiretion = "up"; // reverse true
//       });
//     } else {
//       if (_controller.position.userScrollDirection == ScrollDirection.forward) {
//         // print('User is going up');
//         setState(() {
//           scrollDiretion = "down"; // reverse true
//         });
//       }
//     }
//
//     if (_controller.position.atEdge) {
//       setState(() {
//         _scrollviewLoading = true;
//       });
//       // print(_controller.position.pixels);
//       // bool isTop = _controller.position.pixels == 0;
//       bool top = _controller.position.pixels != 0;
//
//       // print(MediaQuery.of(context).size.height);
//       // if(MediaQuery.of(context).size.height < _controller.position.viewportDimension){
//       //   _scrollviewScollingStatus = true;
//       // }else{
//       //   _scrollviewScollingStatus = false;
//       // }
//       // print(_scrollviewScollingStatus);
//       if (top) {
//         _scrollviewScollingStatus = true;
//         // because scrollview is reverse
//         // print('At the top');
//
//         // load more results
//         List<MessageElement>? __messages = (await ApiService().getMessages(token, connection_id, _scrollviewPage))!;
//         if(__messages.length > 0){
//           setState(() {
//             _messages?.addAll(__messages);
//             _scrollviewLoading = false;
//           });
//         }else{
//           setState(() {
//             _scrollviewLoading = false;
//           });
//         }
//
//         ++_scrollviewPage;
//       } else {
//         _scrollviewScollingStatus = false;
//         // print('At the bottom');
//       }
//     }
//
//   }
//
//   void _onInputMessageFocusChange() {
//     debugPrint("Focus: ${inputMessageFocusNode.hasFocus.toString()}");
//     if(inputMessageFocusNode.hasFocus == true){
//       setState(() {
//         isShowSticker = false;
//       });
//     }
//   }
//
//   void _scrollDown() {
//     _scrollviewScollingStatus = false;
//     _controller.animateTo(
//       _controller.position.minScrollExtent,
//       duration: Duration(seconds: 2),
//       curve: Curves.fastOutSlowIn,
//     );
//   }
//
//   late List<Note> notes;
//   bool isLoading = false;
//   Future refreshNotes() async {
//     setState(() => isLoading = true);
//
//     this.notes = await F2FLoveDatabase.instance.readAllNotes();
//
//     setState(() => isLoading = false);
//   }
//
//   bool isDownloading = false;
//   Widget _messagesWidget(messages){
//     String date = '';
//     List<Widget> widgets = [];
//     for(int i = messages!.length - 1; i >= 0; --i){
//
//       if(_messages![i].message != null){
//         print(_messages![i].file.toString());
//         // print(_messages![i]);
//         int id = _messages![i].id;
//         String msg = _messages![i].message.toString();
//         String file = "https://deals101-nodejs-f2f.zahidaz.com/" + _messages![i].file.toString();
//         String time = helper.getTime(_messages![i].createdAt.toString());
//         String date2 = helper.getDate(_messages![i].createdAt.toString());
//
//         int user = _messages![i].senderId;
//         int? type = _messages![i].type;
//
//         // audio file setting
//         String audio_time = _playerDetail!.containsKey(id) ? _playerDetail![id]["time"].toString() : "00:00";
//         double slider_min = _playerDetail!.containsKey(id) ? double.parse(_playerDetail![id]["slider_min"].toString()) : 0;
//         double slider_max = _playerDetail!.containsKey(id) ? double.parse(_playerDetail![id]["slider_max"].toString()) : 0;
//         IconData ico = _playerDetail!.containsKey(id) ? _playerDetail![id]["icon"] : Icons.play_arrow;
//
//         Widget widget;
//         // print(user_id);
//           if(date != date2 || date == ''){
//             widget = AzText(date2).textColor("#ffffff").method().px(15).py(5).rounded(10).bg("#FF7F2A");
//             widgets.add(widget);
//           }
//
//           int random = new Random().nextInt(200);
//
//           // widget = VisibilityDetector(
//           //   onVisibilityChanged: (visibilityInfo) {
//           //     // debugPrint("visibilityInfo");
//           //     // debugPrint(visibilityInfo.);
//           //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
//           //     if(scrollDiretion == "up" && _currentMessageDate != date2) {
//           //       if(visibilityInfo.visibleBounds.top > 0.0){
//           //         _currentMessageDate = date2;
//           //         setState(() {
//           //
//           //         });
//           //         // debugPrint('Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
//           //       }
//           //     }
//           //     else if(scrollDiretion == "down" && _currentMessageDate != date2) {
//           //       if(0.0 < visibilityInfo.visibleBounds.bottom){
//           //         _currentMessageDate = date2;
//           //         setState(() {
//           //
//           //         });
//           //         // debugPrint('Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
//           //       }
//           //     }
//           //   },
//           //   key: Key('messagekey${id.toString()}${random.toString()}${i.toString()}'),
//           //   child: GestureDetector(
//           //     onLongPress: () async {
//           //       AzShowDialog(
//           //         context,
//           //         [
//           //           // body
//           //           AzColumn([
//           //             AzRow([
//           //               AzIcon(Icons.warning_amber_outlined),
//           //               const SizedBox(width:5),
//           //               AzText('Report').fontSize(16),
//           //             ]),
//           //             Divider(),
//           //             AzRow([
//           //               AzIcon(Icons.delete_outline_outlined),
//           //               const SizedBox(width:5),
//           //               AzText('Delete').fontSize(16),
//           //             ])
//           //           ]).mainAxisAlignmentStart().crossAxisAlignmentStart()
//           //         ],
//           //         [
//           //           // actions buttons
//           //         ]
//           //       ).barrierDismissible(true).show();
//           //     },
//           //     child:Align(
//           //       alignment: user == user_id ? Alignment.topRight : Alignment.topLeft,
//           //       child: ConstrainedBox(
//           //         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.80, minWidth: MediaQuery.of(context).size.width * 0.20,),
//           //         child: AzColumn([
//           //
//           //           if(type == 1)
//           //             AzText(msg).fontSize(16).textColor(user == user_id ? senderMsgColor : receiverMsgColor),
//           //           if(type ==2)
//           //
//           //             SizedBox(
//           //               height:200,
//           //               width: 200,
//           //               child: Image.network(file),
//           //             ),
//           //
//           //           AzText(time).fontSize(12).textColor(user == user_id ? senderMsgColor : receiverMsgColor).mt(5),
//           //
//           //           if(type == 3)
//           //             AzWrap([
//           //               // Wrap(),
//           //               AzRow([
//           //                 CircleAvatar(
//           //                   radius:20,
//           //                   child: IconButton(
//           //                     //_playerIds // _playerTxts
//           //                     icon: Icon(ico, size:20),
//           //                     onPressed: () {
//           //                       _playerDetail!.containsKey(id) && _playerDetail![id]["icon"] == Icons.pause ?
//           //                       onStopPlayerPressed(id) : onStartPlayerPressed(file, id);
//           //                     },
//           //                   ),
//           //                 ),
//           //                 AzColumn([
//           //                   AzText(audio_time).fontSize(14).textColor(user == user_id ? senderMsgColor : receiverMsgColor).method().px(15),
//           //                   // AzText(_playerTimeDetail!.containsKey(id) ? _playerTimeDetail![id].toString() : "00:00").fontSize(20).textColor("#ffffff").method().p(7),
//           //                   SizedBox(
//           //                     height:25,
//           //                     child: Slider(
//           //                         value: min(slider_min,slider_max),
//           //                         min: 0.0,
//           //                         max: slider_max,
//           //                         onChanged: (value) async {
//           //                           // await seekToPlayer(value.toInt());
//           //                         },
//           //                         divisions: slider_max == 0.0 ? 1 : slider_max.toInt()),
//           //                   ),
//           //                 ]).crossAxisAlignmentStart(),
//           //               ]).crossAxisAlignmentStart()
//           //             ]).method().width(250),
//           //
//           //           // show time
//           //
//           //         ]).crossAxisAlignmentEnd().method().p(5).rounded(10).bg(user == user_id ? senderMsgBgColor : receiverMsgBgColor).my(5),
//           //       ),
//           //     )
//           //   ),
//           // );
//         widget = GestureDetector(
//             onLongPress: () async {
//               AzShowDialog(
//                   context,
//                   [
//                     // body
//                     AzColumn([
//                       AzRow([
//                         AzIcon(Icons.warning_amber_outlined),
//                         const SizedBox(width:5),
//                         AzText('Report').fontSize(16),
//                       ]),
//                       Divider(),
//                       AzRow([
//                         AzIcon(Icons.delete_outline_outlined),
//                         const SizedBox(width:5),
//                         AzText('Delete').fontSize(16),
//                       ])
//                     ]).mainAxisAlignmentStart().crossAxisAlignmentStart()
//                   ],
//                   [
//                     // actions buttons
//                   ]
//               ).barrierDismissible(true).show();
//             },
//             child:Align(
//               alignment: user == user_id ? Alignment.topRight : Alignment.topLeft,
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.80, minWidth: MediaQuery.of(context).size.width * 0.20,),
//                 child: AzColumn([
//
//                   if(type == 1)
//                     AzText(msg).fontSize(16).textColor(user == user_id ? senderMsgColor : receiverMsgColor),
//                   if(type ==2)
//
//                     user == user_id ?  SizedBox(
//                       height:MediaQuery.of(context).size.height*0.35,
//                       width: MediaQuery.of(context).size.width*0.6,
//                       child:_messages![i].file.toString().split(".").last=="mp4"?
//                       GestureDetector  (
//                           onTap:(){
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreen(clipname: file,)));
//                           },
//                           child: SingleClips(clipname: file,)):
//                       FullScreenWidget(
//                         child: CachedNetworkImage(
//                           imageUrl:  file,
//                           fit:  BoxFit.cover,
//                           progressIndicatorBuilder: (context, url, downloadProgress) =>
//                               Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
//                           errorWidget: (context, url, error) => Icon(Icons.error),
//                         ),
//                       ),
//                       // child: ChatImage(
//                       //     url: file,
//                       //
//                       //     errorBuilder: (BuildContext context, String errorMsg) {
//                       //       return Text("some error $errorMsg");
//                       //     },
//                       //     imageBuilder: (BuildContext context, Image image) {
//                       //       return  image;
//                       //     }),
//
//                     ):
//                     FutureBuilder<bool>(
//                       future: F2FLoveDatabase.instance.readNote(file.split('/').last),
//                       builder: (context, snapshot) {
//                         return snapshot.hasData? snapshot.data!? SizedBox(
//                           height:MediaQuery.of(context).size.height*0.35,
//                           width: MediaQuery.of(context).size.width*0.6,
//                           child:_messages![i].file.toString().split(".").last=="mp4"?
//                           GestureDetector  (
//                               onTap:(){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreen(clipname: file,)));
//                               },
//                               child: SingleClips(clipname: file,)): FullScreenWidget(
//                             child: CachedNetworkImage(
//                               imageUrl:  file,
//                               fit:  BoxFit.cover,
//                               progressIndicatorBuilder: (context, url, downloadProgress) =>
//                                   Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
//                               errorWidget: (context, url, error) => Icon(Icons.error),
//                             ),
//                           ),
//                           // child: ChatImage(
//                           //     url: file,
//                           //
//                           //     errorBuilder: (BuildContext context, String errorMsg) {
//                           //       return Text("some error $errorMsg");
//                           //     },
//                           //     imageBuilder: (BuildContext context, Image image) {
//                           //       return  image;
//                           //     }),
//
//                         )
//                             :SizedBox(
//                           height:MediaQuery.of(context).size.height*0.35,
//                           width: MediaQuery.of(context).size.width*0.6,
//                           child: Stack(
//                             children: [
//                               Container(height:MediaQuery.of(context).size.height*0.345,
//                                 width: MediaQuery.of(context).size.width*0.6,
//                                 child: _messages![i].file.toString().split(".").last=="mp4"?
//                                 SingleClips(clipname: file,):CachedNetworkImage(
//                                   imageUrl:  file,
//                                   fit:  BoxFit.cover,
//                                   progressIndicatorBuilder: (context, url, downloadProgress) =>
//                                       Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
//                                   errorWidget: (context, url, error) => Icon(Icons.error),
//                                 ),
//                               ),
//                               Container(  height:MediaQuery.of(context).size.height*0.345,
//                             width: MediaQuery.of(context).size.width*0.6,
//                               color: Colors.grey.withOpacity(0.9),
//                                 child: IconButton( onPressed: ()async{
//                                   setState(() {
//                                     isDownloading = true;
//                                   });
//                                   final tempDir = await getTemporaryDirectory();
//                                   final path = '${tempDir.path}/${file.split('/').last}';
//                                   await Dio().download(file,path);
//                                   await GallerySaver.saveImage(path,albumName: "F2F Love");
//                                   final note = Note(
//                                     title: file.split('/').last,
//                                     path: '$path',
//                                   );
//
//                                   await F2FLoveDatabase.instance.create(note);
//                                   setState(() {
//                                     isDownloading=false;
//                                   });
//                                   Get.snackbar("Successful", "File Downloaded Successfully",
//                                   backgroundColor: Colors.green,
//                                     colorText: Colors.white
//                                   );
//                                 },
//
//                                 icon: isDownloading?Center(child: CircularProgressIndicator(),):Icon(Icons.download_for_offline,size: 50,),),
//                               )
//                             ],
//                           ),
//                           // child: ChatImage(
//                           //     url: file,
//                           //
//                           //     errorBuilder: (BuildContext context, String errorMsg) {
//                           //       return Text("some error $errorMsg");
//                           //     },
//                           //     imageBuilder: (BuildContext context, Image image) {
//                           //       return  image;
//                           //     }),
//
//                         ):Center(child: CircularProgressIndicator(),);
//                       }
//                     ),
//
//                   AzText(time).fontSize(12).textColor(user == user_id ? senderMsgColor : receiverMsgColor).mt(5),
//
//                   if(type == 3)
//                     AzWrap([
//                       // Wrap(),
//                       AzRow([
//                         CircleAvatar(
//                           radius:20,
//                           child: IconButton(
//                             //_playerIds // _playerTxts
//                             icon: Icon(ico, size:20),
//                             onPressed: () {
//                               _playerDetail!.containsKey(id) && _playerDetail![id]["icon"] == Icons.pause ?
//                               onStopPlayerPressed(id) : onStartPlayerPressed(file, id);
//                             },
//                           ),
//                         ),
//                         AzColumn([
//                           AzText(audio_time).fontSize(14).textColor(user == user_id ? senderMsgColor : receiverMsgColor).method().px(15),
//                           // AzText(_playerTimeDetail!.containsKey(id) ? _playerTimeDetail![id].toString() : "00:00").fontSize(20).textColor("#ffffff").method().p(7),
//                           SizedBox(
//                             height:25,
//                             child: Slider(
//                                 value: min(slider_min,slider_max),
//                                 min: 0.0,
//                                 max: slider_max,
//                                 onChanged: (value) async {
//                                   // await seekToPlayer(value.toInt());
//                                 },
//                                 divisions: slider_max == 0.0 ? 1 : slider_max.toInt()),
//                           ),
//                         ]).crossAxisAlignmentStart(),
//                       ]).crossAxisAlignmentStart()
//                     ]).method().width(250),
//
//                   // show time
//
//                 ]).crossAxisAlignmentEnd().method().p(5).rounded(10).bg(user == user_id ? senderMsgBgColor : receiverMsgBgColor).my(5),
//               ),
//             )
//         );
//
//
//         /*        if(user == user_id){
//                   widget = AzAlign(
//                       AzColumn([
//                         AzText(msg).fontSize(14).textColor(senderMsgColor),
//                         AzText(time).fontSize(14).textColor(senderMsgColor).mt(5),
//                       ]).crossAxisAlignmentEnd().method().p(5).rounded(10).bg(senderMsgBgColor)
//                   ).topRight().method().my(5);
//
//                 }else{
//                   widget = AzAlign(
//                       AzColumn([
//                         AzText(msg).fontSize(14).textColor(receiverMsgColor),
//                         AzText(time).fontSize(14).textColor(receiverMsgColor).mt(5),
//                       ]).crossAxisAlignmentEnd().method().p(5).rounded(10).bg(receiverMsgBgColor)
//                   ).topLeft().method().my(5);
//                 }*/
//         widgets.add(widget);
//
//         date = date2;
//       }
//     }
//     setState(() {
//       _scrollviewLoading = false;
//     });
//     return AzColumn(widgets);
//   }
//
//   Future<bool> onBackPress() {
//     if (isShowSticker) {
//       setState(() {
//         isShowSticker = false;
//       });
//     } else {
//       // Navigator.pop(context);
//       return Future.value(true);
//     }
//
//     return Future.value(false);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     currentFocus = FocusScope.of(context);
//
//     // print(token);
//
//     // Setup image picker configs
//     // final configs = ImagePickerConfigs();
//
//     // configs.translateFunc = (name, value) => Intl.message(value, name: name); // Use intl function
//
//     // AppBar text color
//     // configs.appBarTextColor = Colors.white;
//     // configs.appBarBackgroundColor = Colors.blue;
//     // // Disable select images from album
//     // // configs.albumPickerModeEnabled = false;
//     // // Only use front camera for capturing
//     // // configs.cameraLensDirection = 0;
//     // // Translate function
//     // configs.translateFunc = (name, value) => Intl.message(value, name: name);
//     // // Disable edit function, then add other edit control instead
//     // configs.adjustFeatureEnabled = false;
//     //
//     // configs.externalImageEditors['external_image_editor_1'] = EditorParams(
//     //     title: 'Editor 2',
//     //     icon: Icons.edit_rounded,
//     //     onEditorEvent: (
//     //         {required BuildContext context,
//     //           required File file,
//     //           required String title,
//     //           int maxWidth = 1080,
//     //           int maxHeight = 1920,
//     //           int compressQuality = 90,
//     //           ImagePickerConfigs? configs}) async =>
//     //         Navigator.of(context).push(MaterialPageRoute(
//     //             fullscreenDialog: true,
//     //             builder: (context) => ImageEdit(
//     //                 file: file,
//     //                 title: title,
//     //                 maxWidth: maxWidth,
//     //                 maxHeight: maxHeight,
//     //                 configs: configs))));
//     // configs.externalImageEditors['external_image_editor_2'] = EditorParams(
//     //     title: 'Editor 2',
//     //     icon: Icons.edit_attributes,
//     //     onEditorEvent: (
//     //         {required BuildContext context,
//     //           required File file,
//     //           required String title,
//     //           int maxWidth = 1080,
//     //           int maxHeight = 1920,
//     //           int compressQuality = 90,
//     //           ImagePickerConfigs? configs}) async =>
//     //         Navigator.of(context).push(MaterialPageRoute(
//     //             fullscreenDialog: true,
//     //             builder: (context) => ImageSticker(
//     //                 file: file,
//     //                 title: title,
//     //                 maxWidth: maxWidth,
//     //                 maxHeight: maxHeight,
//     //                 configs: configs))));
//     //
//     // // Example about label detection & OCR extraction feature.
//     // // You can use Google ML Kit or TensorflowLite for this purpose
//     // configs.labelDetectFunc = (String path) async {
//     //   return <DetectObject>[
//     //     // DetectObject(label: 'dummy1', confidence: 0.75),
//     //     // DetectObject(label: 'dummy2', confidence: 0.75),
//     //     // DetectObject(label: 'dummy3', confidence: 0.75)
//     //   ];
//     // };
//     // configs.ocrExtractFunc =
//     //     (String path, {bool? isCloudService = false}) async {
//     //   if (isCloudService!) {
//     //     return 'Cloud dummy ocr text';
//     //   } else {
//     //     return 'Dummy ocr text';
//     //   }
//     // };
//     //
//     //
//     // // Example about custom stickers
//     // configs.customStickerOnly = true;
//     // configs.customStickers = [
//     //   'assets/icon/cus1.png',
//     //   'assets/icon/cus2.png',
//     //   'assets/icon/cus3.png',
//     //   'assets/icon/cus4.png',
//     //   'assets/icon/cus5.png'
//     // ];
//     //
//     //
//     // // Timer(
//     // // Duration(seconds: 3),
//     // //     () =>
//     // // Navigator.of(context).pushReplacement(MaterialPageRoute(
//     // // builder: (BuildContext context) => HomeScreen()
//     // // )
//     // // )
//     // // );
//     //
//     // // SystemChrome.setEnabledSystemUIOverlays([]);
//     //
//     // // var assetsImage = new AssetImage('assets/images/splashscreen.jpeg'); //<- Creates an object that fetches an image.
//     // // var image = new Image(image: assetsImage, height:  MediaQuery.of(context).size.height, fit:BoxFit.fill); //<- Creates a widget that displays an image.
//     List items = [
//       'msg', 'msg2'
//     ];
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color(0xff2C2C6F),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("F2F Love You",),
//               AzText(typing_or_record).fontSize(10),
//             ],
//           ),
//           actions: [
//             IconButton(
//                 icon: Icon(Icons.call,color: Colors.white), onPressed: () => onJoin("AudioCall")),
//             IconButton(
//                 icon: Icon(Icons.video_call,color: Colors.white),
//                 onPressed: () => onJoin("VideoCall")),
//             PopupMenuButton(
//               // add icon, by default "3 dot" icon
//                 icon: const Icon(Icons.more_vert_outlined, color: Colors.white,),
//                 iconSize: 36,
//                 color: Colors.white,
//                 itemBuilder: (context){
//                   return [
//                     PopupMenuItem<int>(
//                       value: 0,
//                       child: Text("Clear Chat"),
//                     ),
//                     PopupMenuItem<int>(
//                       value: 1,
//                       child: Text("Delete Connection"),
//                     ),
//                   ];
//                 },
//                 onSelected:(value){
//                   if(value == 0){
//                     print("My account menu is selected.");
//                   }else if(value == 1){
//                     print("Settings menu is selected.");
//                   }else if(value == 2){
//                     print("Logout menu is selected.");
//                   }
//                 }
//             ),
//           ],
//         ),
//         // resizeToAvoidBottomInset: false,
//         // resizeToAvoidBottomInset: true,
//         body: WillPopScope(
//           onWillPop: onBackPress,
//           child: GestureDetector(
//             onTap: () {
//               if (!currentFocus.hasPrimaryFocus) {
//                 currentFocus.unfocus();
//               }
//             },
//             child: SafeArea(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("assets/images/chat.jpg"),
//                       fit: BoxFit.cover
//                   ),
//                 ),
//                 child: AzColumn([
//
//                   Expanded(
//                       child: Stack(
//                           children:[
//                             SingleChildScrollView(
//                               controller: _controller,
//                               reverse: true,
//                               child: Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                                   child: _messages == null || _messages!.isEmpty ? const Center(child: CircularProgressIndicator()) :
//                                   AzColumn([
//                                     _scrollviewLoading == true ?  const CircularProgressIndicator() : const Center(),
//                                     _messagesWidget(_messages),
//                                   ])
//
//                               ),
//                             ),
//
//                             if(_currentMessageDate != '')
//                             Positioned.fill(
//                                 top:0,
//                                 child: Align(
//                                   alignment: Alignment.topCenter,
//                                   child: AzText(_currentMessageDate).textColor("#ffffff").method().px(15).py(5).rounded(10).bgOpacity("#000000", 0.4)
//                                 )
//                             ),
//
//                             _scrollviewScollingStatus == true ?
//                             Positioned(
//                                 bottom:0,
//                                 left:15,
//                                 right:15,
//                                 child: AzRow([
//                                   CircleAvatar(
//                                     radius:20,
//                                     child: IconButton(
//                                       icon: const Icon(Icons.arrow_downward_rounded),
//                                       onPressed: () {
//                                         // _scrollviewScollingStatus = false;
//                                         // _controller.jumpTo(0);
//                                         _scrollDown();
//                                       },
//                                     ),
//                                   )
//                                 ])
//                             ) : const Center(),
//                           ]
//                       )
//                   )
//                 ]).crossAxisAlignmentStart(),
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           color: Colors.black12,
//           child: Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: Stack(
//               children: <Widget>[
//                 AzColumn([
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         _SelectedImages(),
//                         Row(
//                           children: [
//                             SizedBox(
//                               child: Card(
//                                 elevation: 0,
//                                 margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                                 child: TextFormField(
//                                   controller: inputMessageTextEditingController,
//                                   focusNode: inputMessageFocusNode,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   keyboardType: TextInputType.multiline,
//                                   maxLines: 5,
//                                   minLines: 1,
//                                   onTap: (){
//
//                                   },
//
//                                   onChanged: (text) {
//
//                                     Future.delayed(const Duration(milliseconds: 3000), () {
//                                       socket.emit('typing-emitter', {'connection_id' : connection_id.toString(), 'number': your_number});
//                                     });
//
//                                     socket.emit('typing-emitter', {'connection_id' : connection_id.toString(), 'number': your_number});
//
//                                     inputMessageStreamController.add("stop");
//
//                                     if(text != ''){
//                                       buttonType = 'msg';
//                                     }else{
//                                       buttonType = 'mic';
//                                     }
//                                     setState(() {
//
//                                     });
//                                   },
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Type a message",
//                                     prefixIcon: IconButton(
//                                       icon: const Icon(Icons.emoji_emotions),
//                                       onPressed: () {
//                                         // inputMessageFocusNode.unfocus();
//                                         currentFocus.unfocus();
//                                         // focusNode.canRequestFocus = false;
//                                         // FocusScope.of(context).unfocus();
//                                         Future.delayed(Duration(milliseconds: 300), () {
//                                           setState(() {
//                                             isShowSticker = !isShowSticker;
//                                           });
//                                         });
//                                       },
//                                     ),
//                                     // prefixIcon: IconButton(
//                                     //   icon: Icon(Icons.emoji_emotions),
//                                     //   onPressed: () {
//                                     //     // focusNode.unfocus();
//                                     //     // focusNode.canRequestFocus = false;
//                                     //     // setState(() {
//                                     //     //   show = !show;
//                                     //     // });
//                                     //   },
//                                     // ),
//                                     suffixIcon: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         // IconButton(
//                                         //     onPressed: () {
//                                         //       // showModalBottomSheet(
//                                         //       //     backgroundColor:
//                                         //       //     Colors.transparent,
//                                         //       //     context: context,
//                                         //       //     builder: (builder) =>
//                                         //       //         bottomSheet()
//                                         //       //     );
//                                         //     },
//                                         //     icon: Icon(Icons.attach_file)),
//                                         // IconButton(
//                                         //     onPressed: () async {
//                                         //       // Get max 5 images
//                                         //       List<ImageObject> objects =
//                                         //       await Navigator.of(context).push(
//                                         //           PageRouteBuilder(pageBuilder:
//                                         //               (context, animation, __) {
//                                         //             return ImagePicker(maxCount: 5);
//                                         //           }));
//                                         //
//                                         //       if (objects.length > 0) {
//                                         //         setState(() {
//                                         //           imageFiles.addAll(objects
//                                         //               .map((e) => e.modifiedPath)
//                                         //               .toList());
//                                         //         });
//                                         //       }
//                                         //     },
//                                         //     icon: const Icon(Icons.add_a_photo)
//                                         // ),
//                                         IconButton(
//                                           icon: Icon(Icons.attach_file),
//                                           onPressed: () {
//                                             showModalBottomSheet(
//                                                 backgroundColor:
//                                                 Colors.transparent,
//                                                 context: context,
//                                                 builder: (builder) =>
//                                                     bottomSheet());
//                                           },
//                                         ),
//                                         IconButton(
//                                           padding: EdgeInsets.zero,
//
//                                           icon: Icon(Icons.camera_alt),
//                                           onPressed: () async{
//                                               await  getImage(await picker.pickImage(source: ImageSource.camera));
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     contentPadding: const EdgeInsets.all(5),
//                                   ),
//                                 ),
//                               ),
//                               width: MediaQuery.of(context).size.width - 60,
//                             ),
//
//                             if(buttonType != 'mic')
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 3, bottom: 3, right: 5, left: 2),
//                                 child: CircleAvatar(
//                                   radius: 25,
//                                   child: IconButton(
//                                     icon: const Icon(
//                                       Icons.send,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () {
//                                       sendMsg(1);
//                                     },
//                                   ),
//                                 ),
//                               ),
//
//                             if(buttonType == 'mic')
//                               Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 3, bottom: 3, right: 5, left: 2),
//                                   child: GestureDetector(
//                                     child: const CircleAvatar(
//                                       radius: 25,
//                                       child: Icon(
//                                         Icons.mic,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     onHorizontalDragEnd: (detail){
//                                       // stop and clear audio
//                                       cancelRecorder();
//                                     },
//                                     // onTap:(){
//                                     //
//                                     // },
//                                     // onTapDown:(detail){
//                                     //
//                                     // },
//                                     onTapDown: (detail) {
//                                       // if (isRecord) {
//                                       //   _stopRecord();
//                                       // } else {
//                                       startRecorder();
//                                       // }
//                                     },
//                                     onTapUp: (detail){
//                                       print(1223);
//                                       // stop and send in msg
//                                       stopRecorder();
//                                     },
//                                   )
//
//                               ),
//
//                           ],
//                         ),
//                         isShowSticker ?
//                         buildSticker()
//                             : Container(),
//                         // show ? emojiselect() : Container(),
//                       ],
//                     ),
//                   ),
//                 ]).mainAxisAlignmentEnd().mainAxisSize(MainAxisSize.min),
//
//                 if(_isRecording)
//                   Positioned(
//                     left: 0.0,
//                     bottom: 0.0,
//                     child: AzColumn([
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   child: Card(
//                                     elevation: 0,
//                                     margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(25)),
//                                     child: AzRow([
//                                       AzRow([
//                                         const Icon(Icons.mic, color: Colors.red),
//                                         // AzText(helper.secondToMinutes(recordPosition)),
//                                         AzText(_recorderTxt),
//                                       ]).mainAxisSize(MainAxisSize.min).method().pr(10),
//                                       AzRow([
//                                         const Icon(Icons.keyboard_arrow_left_sharp),
//                                         AzText("Slide to Cancel"),
//                                       ]).mainAxisSize(MainAxisSize.min).method().pr(10),
//                                     ]).mainAxisAlignmentSpaceBetween().method().p(10),
//                                   ),
//                                   width: MediaQuery.of(context).size.width - 60,
//                                 ),
//                               ],
//                             ), // show ? emojiselect() : Container(),
//                           ],
//                         ),
//                       ),
//                     ]).mainAxisAlignmentEnd().mainAxisSize(MainAxisSize.min),
//                   ),
//               ],
//             ),
//           ),
//         )
//     );
//   }
//
//   Widget buildSticker() {
//
//
//     return Container(
//       height: 250,
//       child: EmojiPicker(
//         onEmojiSelected: (Category? category, Emoji? emoji) {
//           // Do something when emoji is tapped (optional)
//           if(buttonType == 'mic'){
//             setState(() {
//               buttonType = 'msg';
//               //   inputMessageTextEditingController.text = inputMessageTextEditingController.text + emoji!.emoji;
//             });
//           }
//         },
//         onBackspacePressed: () {
//           if(inputMessageTextEditingController.text == ''){
//             setState(() {
//               buttonType = 'msg';
//           //     isShowSticker =!isShowSticker;
//             });
//           }
//           // Do something when the user taps the backspace button (optional)
//         },
//
//         textEditingController: inputMessageTextEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
//         config: Config(
//           columns: 7,
//           emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
//           verticalSpacing: 0,
//           horizontalSpacing: 0,
//           gridPadding: EdgeInsets.zero,
//           initCategory: Category.RECENT,
//           bgColor: Color(0xFFF2F2F2),
//           indicatorColor: Colors.blue,
//           iconColor: Colors.grey,
//           iconColorSelected: Colors.blue,
//           backspaceColor: Colors.blue,
//           skinToneDialogBgColor: Colors.white,
//           skinToneIndicatorColor: Colors.grey,
//           enableSkinTones: true,
//           showRecentsTab: true,
//           recentsLimit: 28,
//           noRecents: const Text(
//             'No Recents',
//             style: TextStyle(fontSize: 20, color: Colors.black26),
//             textAlign: TextAlign.center,
//           ), // Needs to be const Widget
//           loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
//           tabIndicatorAnimDuration: kTabScrollDuration,
//           categoryIcons: const CategoryIcons(),
//           buttonMode: ButtonMode.MATERIAL,
//         ),
//       ),
//     );
//
//   }
//
//   Widget _SelectedImages(){
//     List<Widget> abc = [];
//
//     for(int i = 0; i < imageFiles.length; ++i){
//       // imageFiles
//       abc.add(Text(imageFiles.toString()));
//     }
//
//     return AzColumn(abc);
//   }
//
//   sendMsg(int type) async {
//     // print(type);
//
//     String message = inputMessageTextEditingController.text;
//     inputMessageTextEditingController.text = '';
//
//     String fileName = "";
//     if(type == 3)
//     {
//       fileName = connection_id.toString() + "-" + Random().nextInt(10000).toString() + "-" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp4";
//     }
//     if(type == 2)
//     {
//       fileName = imageName!;
//     }
//
//     MessageElement? msgToSend = MessageElement(
//       id:1,
//       connectionId: connection_id,
//       senderId: user_id,
//       // message: helper.utf8convert(message),
//       message: message,
//       file: fileName,
//       type: type,
//       deliveredAt: null,//DateTime.parse("20200-02-22 06:55:55"),
//       seenAt: null,//DateTime.parse("20200-02-22 06:55:55"),
//       unsendAt: null,//DateTime.parse("20200-02-22 06:55:55"),
//       createdAt: DateTime.now(),//DateTime.parse("20200-02-22 06:55:55"),
//       updatedAt: DateTime.now(),//DateTime.parse("20200-02-22 06:55:55")
//     );
//     if(type==1)
//     _messages?.insert(0, msgToSend);
//
//     setState(() {
//       buttonType = "mic";
//     });
//
//     var headers = {
//       'Content-Type': 'application/json; charset=utf-8',
//       'x-access-token': '$token',
//       // 'charset': 'utf-8'
//     };
//
//     var request = http.MultipartRequest('POST', Uri.parse('https://deals101-nodejs-f2f.zahidaz.com/message/create'));
//
//     // File file = File(_path[_codec.index]!);
//     // String fileName = "";
//     if(type == 3 )
//     {
//       // fileName = connection_id.toString() + "-" + Random().nextInt(10000).toString() + "-" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp4";
//       request.files.add(await http.MultipartFile.fromPath('file', _path[_codec.index]!, filename:fileName));
//     }
//     if(type == 2 )
//     {
//       // fileName = connection_id.toString() + "-" + Random().nextInt(10000).toString() + "-" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp4";
//       request.files.add(await http.MultipartFile.fromPath('file', _image!.path, filename:fileName));
//     }
//
//
//     // request.fields.addAll({
//     //   "file": await http.MultipartFile.fromPath(file.path),
//     // });
//     Map<String,dynamic> _emit = {
//       "id": 1,
//       "connectionId": connection_id,
//       "senderId": 2,//user_id,
//       "message": message,
//       "file": fileName,
//       "type": type,
//       "deliveredAt": null, //DateTime.parse("20200-02-22 06:55:55"),
//       "seenAt": null, //DateTime.parse("20200-02-22 06:55:55"),
//       "unsendAt": null, //DateTime.parse("20200-02-22 06:55:55"),
//       "createdAt": DateTime.now().toString(), //DateTime.parse("20200-02-22 06:55:55"),
//       "updatedAt": DateTime.now().toString(), //DateTime.parse("20200-02-22 06:55:55")
//     };
//
//     // socket.emit('message-emitter', {'connection_id' : connection_id.toString(), 'number': your_number});
//     // var request2 = http.MultipartRequest('GET', Uri.parse('https://www.vkreta.com/index.php?route=api/category/lists'));
//     // // request.files.add(await http.MultipartFile.fromPath('', '/path/to/file'));
//     //
//     // http.StreamedResponse response = await request2.send();
//     //
//     // if (response.statusCode == 200) {
//     //   // print(await response.stream.bytesToString());
//     // }
//     // else {
//     //   // print(resp/onse.reasonPhrase);
//     // }
//
//
//
//    request.fields.addAll({
//       "number": your_number,
//       "connection_id": connection_id.toString(),
//       "msg": message,
//       'type' : type.toString(),
//     });
//     // if(type==2)
//     //   _messages?.insert(0, msgToSend);
//
//     request.headers.addAll(headers);
//     //
//     http.StreamedResponse response = await request.send();
//
//     var responseData = await response.stream.bytesToString();
//     // print(responseData);
//     final decodedMap = json.decode(responseData);
//     print(decodedMap);
//     //
//
//     if (response.statusCode == 200) {
//       setState(() {
//
//       });
//       if(decodedMap['status'] == 1){
//         //  push msg
//
//         if(type==2)
//           _messages?.insert(0, msgToSend);
//         // everything ok
//         setState(() {
//
//         });
//       }
//
//       else{
//         // add resend button
//         // add toast/snackbar
//         AzShowDialog(
//             context,
//             [
//               // body
//               Text(decodedMap['msg'])
//             ],
//             [
//               // actions buttons
//             ]
//         ).okButton("Ok").show();
//       }
//     }else{
//       AzShowDialog(
//           context,
//           [
//             // body
//             Text(decodedMap['msg'])
//           ],
//           [
//             // actions buttons
//           ]
//       ).okButton("Ok").show();
//     }
//
//     socket.emit('message-emitter', {'connection_id' : connection_id.toString(), 'number': your_number, 'message': _emit});
//
//   }
//
//   // for socket
//   connectToSocket() {
//     socket = IO.io('https://deals101-nodejs-f2f.zahidaz.com',<String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//       // 'extraHeaders': {'foo': 'bar'},
//     });
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       socket.emit('join_channel', {'connection_id' : connection_id.toString()});
//       socket.emit('online-emitter', {'connection_id' : connection_id.toString(), 'number': your_number});
//
//       socket.on('online-listener', (event){
//         // print("onine-listener");
//         String number = event['number'];
//         if(number != your_number.toString()) {
//           setState(() {
//             typing_or_record = 'Online';
//             onine_or_offline = 'Online';
//           });
//         }
//       });
//
//       socket.on('offline-listener', (event){
//         String number = event['number'];
//         if(number != your_number.toString()) {
//           setState(() {
//             typing_or_record = '';
//             onine_or_offline = '';
//           });
//         }
//       });
//
//       socket.on('typing-listener', (event){
//         // print(json.decode(event.toString())['number']);
//         // Map obj = jsonDecode(event);
//         String number = event['number'];
//         // print(number);
//         if(number != your_number.toString()){
//           setState(() {
//             typing_or_record = 'Typing...';
//           });
//         }
//       });
//
//       socket.on('message-listener', (event){
//         // print("asd");
//         // print(event.toString());
//         // _messages?.insert(0, event['message']);
//
//         String number = event['number'];
//         if(number != your_number.toString()) {
//           MessageElement? msgToSend = MessageElement(
//               id: 2,
//               //event['message']['id'],
//               connectionId: int.parse(
//                   event['message']['connectionId'].toString()),
//               senderId: int.parse(event['message']['senderId'].toString()),
//               message: event['message']['message'].toString(),
//               file: event['message']['file'],
//               type: int.parse(event['message']['type'].toString()),
//               deliveredAt: event['message']['deliveredAt'] == null
//                   ? event['message']['deliveredAt']
//                   : DateTime.parse(event['message']['deliveredAt']),
//               seenAt: event['message']['seenAt'] == null
//                   ? event['message']['seenAt']
//                   : DateTime.parse(event['message']['seenAt']),
//               unsendAt: event['message']['unsendAt'] == null
//                   ? event['message']['unsendAt']
//                   : DateTime.parse(event['message']['unsendAt']),
//               createdAt: DateTime.parse(event['message']['createdAt']),
//               updatedAt: DateTime.parse(event['message']['updatedAt'])
//           );
//
//           _messages?.insert(0, msgToSend);
//           setState(() {});
//         }
//         // String number = event['number'];
//         // if(number != your_number.toString()) {
//         //   setState(() {
//         //     typing_or_record = '';
//         //     onine_or_offline = '';
//         //   });
//         // }
//       });
//     });
//
//     socket.onConnectError((data) =>  print('socket on connect error' + data.toString()));
//
//     socket.onDisconnect((_) => () {
//       print('socket disconnect');
//       // socket.emit('offline-emitter', {
//       //   'connection_id' : connection_id.toString(), 'number': your_number
//       // });
//
//       setState(() {
//         typing_or_record = '';
//         onine_or_offline = '';
//       });
//
//     });
//   }
//
//   CollectionReference chatReference=FirebaseFirestore.instance.collection("calls");
//   File? _image;
//   String? imageName;
//
//   Future<void> onJoin(callType) async {
//       // await for camera and mic permissions before pushing video page
//
//
//
//
//     var data =await ApiService().getFcmTokens(token, connection_id.toString());
//     String channelId ="cid${connection_id.toString()}" ;
//     var agoraToken =await ApiService().getAgoraToken(channelId);
//     // print("Asd");
//    await PushNotificationServices.sendNotification(data["receiver_fcm"], channelId, "call", "Love App Notification", "Incoming Call", agoraToken["data"]["rtcToken"]);
//       await handleCameraAndMic(callType);
//     await _handleCameraAndMic(Permission.camera);
//     await _handleCameraAndMic(Permission.microphone);
//       // await chatReference.add({
//       //   'type': 'Call',
//       //   'text': callType,
//       //   'sender_id': user_id,
//       //   "connectionId": connection_id,
//       //   'isRead': false,
//       //   'image_url': "",
//       //   'time': FieldValue.serverTimestamp(),
//       // });
//
//       // push video page with given channel name
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DialCall(
//             agoraToken:agoraToken["data"]["rtcToken"],
//               channelName: channelId,
//               receiver: "widget.second",
//               callType: callType),
//         ),
//       );
//   }
//
//   final ImagePicker picker = ImagePicker();
//
//   Future getImage(XFile? pickFile,) async {
//     XFile? pickedFile =  pickFile;
//     var _data;
//
//     // setState(() async {
//     if (pickedFile != null) {
//
//
//       var image = File(pickedFile.path);
//       print( image.path);
//       imageName = pickedFile.name;
//
//       final imageIsolate = IsolateImage.path(image.path);
//       print('isolate_image_compress begin - : ${imageIsolate.data!.length}');
//       Uint8List? _data = await imageIsolate.compress(maxSize: 1 * 1024 * 1024); // 1 MB
//
//       final tempDir = await getTemporaryDirectory();
//       _image= await File('${tempDir.path}/$imageName').create();
//
//
//       await sendMsg(2);
//
//
//       print('isolate_image_compress end - : ${_data!.length}');
//       // print(imageName);
//
//     } else {
//       print('No image selected.');
//     }
//     // });
//     // await uploadDriverFrontImage(index,_data);
//   }
//
//   Future getFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.media
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//
//       print(file.name);
//       print(file.bytes);
//       print(file.size);
//       print(file.extension);
//       print(file.path);
//       imageName = file.name;
//
//       // final imageIsolate = IsolateImage.path(file.path!);
//       // print('isolate_image_compress begin - : ${imageIsolate.data!.length}');
//       // Uint8List? _data = await imageIsolate.compress(maxSize: 1 * 1024 * 1024); // 1 MB
//
//       final tempDir = await getTemporaryDirectory();
//       _image=  File(file.path!);
//
//       // print(_image);
//
//       await sendMsg(2);
//
//
//       // print('isolate_image_compress end - : ${_data!.length}');
//     } else {
//       // User canceled the picker
//     }
//
//     // setState(() async {
//     // });
//     // await uploadDriverFrontImage(index,_data);
//   }
//
//   Widget bottomSheet() {
//     return Container(
//       height: 180,
//       width: MediaQuery.of(context).size.width,
//       child: Card(
//         margin: const EdgeInsets.all(18.0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // iconCreation(
//                   //     Icons.insert_drive_file, Colors.indigo, "Document"),
//                   // SizedBox(
//                   //   width: 40,
//                   // ),
//                   GestureDetector(
//                     onTap: ()async{
//                     await  getImage(await picker.pickImage(source: ImageSource.camera));
//                     Navigator.pop(context);
//
//                     },
//                       child: iconCreation(Icons.camera_alt, Colors.pink, "Camera")),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   GestureDetector(
//                       onTap: ()async{
//                       await  getFile();
//                       Navigator.pop(context);
//                       },
//                       child: iconCreation(Icons.insert_photo, Colors.purple, "Gallery")),
//                 ],
//               ),
//
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     iconCreation(Icons.headset, Colors.orange, "Audio"),
//               //     SizedBox(
//               //       width: 40,
//               //     ),
//               //     iconCreation(Icons.location_pin, Colors.teal, "Location"),
//               //     SizedBox(
//               //       width: 40,
//               //     ),
//               //     iconCreation(Icons.person, Colors.blue, "Contact"),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget iconCreation(IconData icons, Color color, String text) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 30,
//           backgroundColor: color,
//           child: Icon(
//             icons,
//             // semanticLabel: "Help",
//             size: 29,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 12,
//             // fontWeight: FontWeight.w100,
//           ),
//         )
//       ],
//     );
//   }
//
// }
//
// Future<void> _handleCameraAndMic(Permission permission) async {
//   final status = await permission.request();
//   print(status);
// }