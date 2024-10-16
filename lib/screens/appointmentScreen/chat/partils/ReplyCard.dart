// import 'package:demoadmin/screens/appointmentScreen/chat/partils/picture.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../../model/ChatModel.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
//
// class ReplyCard extends StatelessWidget {
//   ChatClass? data;
//    ReplyCard({ Key? key,this.data}) : super(key: key);
//
//   _launchURL() async {
//     var url = data!.message;
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   var _openResult = 'Unknown';
//
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime? timestamp = data!.createdAt;
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//            maxWidth: MediaQuery.of(context).size.width - 55,
//         ),
//         child: Card(
//           elevation: 1,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           // color: Color(0xffdcf8c6),
//           // color: Colors.red,
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//           child: Stack(
//             children: [
//               if (data!.type == "1")
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                     right: 30,
//                     top: 5,
//                     bottom: 20,
//                   ),
//                   child: Text(
//                     data!.message,
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 )
//               else if (data!.type == "2")
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                     right: 30,
//                     top: 5,
//                     bottom: 20,
//                   ),
//                   child: Text(
//                     data!.message,
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 )
//               else if (data!.type == "3")
//                   InkWell(
//                     onTap: (){
//                       _launchURL();
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 1,
//                         // right: 30,
//                         top: 1,
//                         bottom: 1,
//                       ),
//                       child:Container(
//                         child: Container(
//                           width: 200.0,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(9.0),
//                             border: Border.all(color: Color(0xffdcf8c6),width: 4),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.file_copy_outlined,color: Colors.red,),
//                                 SizedBox(width: 10,),
//                                 Text('Download File',style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),),
//
//                               ],
//                             ),
//
//                           ) ,
//                         ),
//                       ),
//                     ),
//                   )
//                 else if (data!.type == "4")
//                     InkWell(
//                       onTap: (){
//                         Get.to(Picture(data!.message));
//                       },
//                       child: Container(
//                         child: Container(
//                           width: 400.0,
//                           height: 300.0,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(9.0),
//                               border: Border.all(color: Color(0xffdcf8c6),width: 4),
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                     data!.message,
//                                   ),
//                                   fit: BoxFit.cover)),
//                         ),
//                       ),
//                     )
//                   else
//                     Center(),
//
//               Positioned(
//                 top: 20,
//                 bottom: 0,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     Text(
//                       DateFormat('HH:mm').format(timestamp!),
//                       // widget.data!.createdAt.toString(),
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     // Icon(
//                     //   Icons.done_all,
//                     //   color: Colors.grey[600],
//                     //   size: 20,
//                     // ),
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
