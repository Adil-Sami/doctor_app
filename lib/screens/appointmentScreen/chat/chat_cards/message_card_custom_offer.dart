import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:demoadmin/screens/appointmentScreen/chat/partils/picture.dart';

import '../../../../utilities/colors.dart';

Widget MessageCardCustomOffer(context, widget, timestamp){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Custom Offer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        SizedBox(height: 2,),
        // Text('DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription',
        //   maxLines: 2,
        //   overflow: TextOverflow.ellipsis,
        //   style: TextStyle(
        //     // fontWeight: FontWeight.bold,
        //       fontSize: 14,
        //       color: Colors.grey.shade500
        //   ),),
        // SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Total Amount: ',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
            Spacer(),
            Text('₹ ${widget.data!.customOffer.price}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Installment every x Month:',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
            Spacer(),
            Text('${widget.data!.customOffer.everyXMonths} Months',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Number of Installment:',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
            Spacer(),
            Text('${widget.data!.customOffer.installments}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
          ],
        ),

        SizedBox(height: 5,),
        Divider(height: 25, thickness: 3, color: Colors.white,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Amount to Pay:',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
            Spacer(),
            Text('₹ ${widget.data!.customOffer.currentInstallment.price}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
          ],
        ),
        SizedBox(height: 10,),
      ],
    ),
  );
}
