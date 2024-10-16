
import 'package:demoadmin/screens/appointmentScreen/chat/partils/picture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../config.dart';
import '../../../../model/ChatModel.dart';
import '../chat_cards/message_card.dart';
import '../chat_cards/message_card_attachment.dart';
import '../chat_cards/message_card_call.dart';
import '../chat_cards/message_card_custom_offer.dart';
import '../chat_cards/message_card_image.dart';
import '../chat_cards/message_card_lab_test.dart';
import '../chat_cards/message_card_prescription.dart';


class OwnMessageCard extends StatefulWidget {
  ChatClass? data;
  final appointmentDetails;
  final uId;
  final doctId;
  final pEmail;

  OwnMessageCard({Key? key, this.data, this.appointmentDetails, required this.uId, required this.doctId, required this.pEmail}) : super(key: key);

  @override
  State<OwnMessageCard> createState() => _OwnMessageCardState();
}

class _OwnMessageCardState extends State<OwnMessageCard> {

  var _openResult = 'Unknown';

  Future<void> openFile() async {
     var filePath = widget.data!.message;
    final result = await OpenFilex.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  @override
  Widget build(BuildContext context) {

     DateTime? timestamp = widget.data!.createdAt;
    return Align(
      alignment: widget.data!.sender.toString() == "2" ? Alignment.centerRight :  Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.data!.type.toString() != "8" ? MediaQuery.of(context).size.width - 55 : MediaQuery.of(context).size.width,
          minWidth: 150,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: widget.data!.type.toString() != "8" ? widget.data!.sender.toString() == "2" ? Color(senderColor) : Color(receiverColor) : Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              if (widget.data!.type.toString() == "1")
                MessageCard(context, widget, timestamp)
              else if (widget.data!.type.toString() == "6")
                MessageCardPrescription(context, widget, timestamp)
              else if (widget.data!.type.toString() == "7")
                MessageCardLabTest(context, widget, timestamp)
              else if (widget.data!.type.toString() == "8")
                MessageCardCall(context, widget, timestamp, widget.appointmentDetails,
                    uId: widget.uId,
                    doctId: widget.doctId,
                    pEmail: widget.pEmail
                )
              else if (widget.data!.type.toString() == "2")
                MessageCard(context, widget, timestamp)
              else if (widget.data!.type.toString() == "3")
                MessageCardAttachment(context, widget, timestamp)
              else if (widget.data!.type.toString() == "4")
                MessageCardImage(context, widget, timestamp)
              else if (widget.data!.type.toString() == "10")
                MessageCardCustomOffer(context, widget, timestamp)
              else
                Center(),

              if (widget.data!.type.toString() != "8")
                Positioned(
                  // top: 20,
                  bottom: 0,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(timestamp!),
                        // widget.data!.createdAt.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],

                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Icon(
                      //   Icons.done_all,
                      //   color: Colors.grey[600],
                      //   size: 20,
                      // ),
                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
