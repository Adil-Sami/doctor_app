import 'package:flutter/cupertino.dart';

import '../../../../config.dart';
import '../chat_cards/message_card_loader.dart';

Widget MessageScreenShimmer(){
  return Column(
    children:[
      MessageCardShimmer(senderColor, Alignment.centerRight),
      MessageCardShimmer(receiverColor, Alignment.centerLeft),
      MessageCardShimmer(senderColor, Alignment.centerRight),
      MessageCardShimmer(receiverColor, Alignment.centerLeft),
      MessageCardShimmer(senderColor, Alignment.centerRight),
      MessageCardShimmer(receiverColor, Alignment.centerLeft),
      MessageCardShimmer(senderColor, Alignment.centerRight),
      MessageCardShimmer(receiverColor, Alignment.centerLeft),
      MessageCardShimmer(senderColor, Alignment.centerRight),
    ]
  );
}