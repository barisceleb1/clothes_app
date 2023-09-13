import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}
