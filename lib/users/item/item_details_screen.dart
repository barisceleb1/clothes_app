import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetailsScreen extends StatefulWidget {

  final itemInfo;

  const ItemDetailsScreen({this.itemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        //----item image----
        children: [
           FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder:
            const AssetImage("assets/place_holder.png"),
            image: NetworkImage(widget.itemInfo.image!),
            imageErrorBuilder:
                (context, error, stackTraceError) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),

          //--------item information-------
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          )

        ],
      ),
    );
  }

  itemInfoWidget()
  {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width ,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.height30),
          topRight: Radius.circular(Dimensions.height30),

        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0,-3),
            blurRadius: Dimensions.height6,
            color: Colors.grey
          )
        ]
      ),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.height18,),

          Center(
            child: Container(
              height: Dimensions.height8,
              width: Dimensions.width140,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(Dimensions.height30),
              ),

            ),
          ),
          SizedBox(height: Dimensions.height30,),
          //----name---
          Text(
            widget.itemInfo!.name!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Dimensions.height18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Dimensions.height10,),

          //rating + rating num
          //tags
          //price
          //item counter
         const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //rating + rating num
              //tags
              //price
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //rating + rating num
                  Row(
                    children: [

                    ],
                  )

                ],
              ),
                //item counter
              ),
            ],


          )

          //size

        ],
      ),

    );
  }
}
