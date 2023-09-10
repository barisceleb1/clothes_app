import 'dart:convert';
import 'dart:io';

import 'package:clothes_app/admin/admin_login.dart';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AdminUplodItemsScreen extends StatefulWidget {
  @override
  State<AdminUplodItemsScreen> createState() => _AdminUplodItemsScreenState();
}

class _AdminUplodItemsScreenState extends State<AdminUplodItemsScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? pickedImageXFile;
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";

  //defaultScreen methods
  captureImageWithPhoneCamera() async {
    pickedImageXFile = await picker.pickImage(source: ImageSource.camera);
    Get.back();
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() => pickedImageXFile);
  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              backgroundColor: Colors.black87,
              title: const Text(
                "Item Image",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    captureImageWithPhoneCamera();
                  },
                  child: const Text(
                    "Capture with phone Camera",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    pickImageFromPhoneGallery();
                  },
                  child: const Text(
                    "Pick Image From Phone Gallery",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ]);
        });
  }

  //defaultScreen methods ends here
  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.deepPurpleAccent])),
        ),
        automaticallyImplyLeading: false,
        title: Text("Welcome Admin"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.black, Colors.deepPurple])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                color: Colors.white60,
                size: Dimensions.height200,
              ),
              Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(Dimensions.circular30),
                child: InkWell(
                    onTap: () {
                      showDialogBoxForImagePickingAndCapturing();
                    },
                    borderRadius: BorderRadius.circular(Dimensions.circular30),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height10,
                        horizontal: Dimensions.width28,
                      ),
                      child: Text(
                        "Add New Item",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.fontSize16),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  //UploadItemFormScreen methods
  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "7e4bdc2797ee2dc";

    var imageFile = await http.MultipartFile.fromPath(
        'image', pickedImageXFile!.path,
        filename: imageName);

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();
    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);
    // print("Result::\n"+resultFromImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();
    saveItemInfoToDatabese();


    //  print("imageLink\n"+imageLink);
    //  print("deleteHash:\n"+deleteHash);
  }
  saveItemInfoToDatabese()async{

    List<String> tagsList = tagsController.text.split(",");
    List<String> sizesList = sizesController.text.split(",");
    List<String> colorsList = colorsController.text.split(",");
try{
  var response = await http.post(Uri.parse(
API.uploadNewItem),
  body:
      {
        'item_id':'1',
        'name':nameController.text.trim().toString(),
        'rating':ratingController.text.trim().toString(),
            'tags':tagsList.toString() ,
            'price':priceController.text.trim().toString(),
            'sizes':sizesList.toString(),
            'colors':colorsList.toString(),
            'description':descriptionController.text.trim().toString(),
            'image':imageLink.toString(),

      }
  );
  if(response.statusCode == 200){
    var resBodyOfUploadItem= jsonDecode(response.body);
    if(resBodyOfUploadItem['success'] == true)
    {
    Fluttertoast.showToast(msg: "New item uploaded successfully");
    setState(()=> pickedImageXFile=null);
    Get.to(AdminUplodItemsScreen());
    }
    else
      {
          Fluttertoast.showToast(msg:"Item not uploaded. Error, Try again" );
      }
  }
  else{
    Fluttertoast.showToast(msg: "Status is not 200");
  }

}
catch(errorMsg)
{
print("Error:: "+ errorMsg.toString());
}

  }

  Widget uploadItemFormScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.deepPurpleAccent])),
        ),
        title: Text("Upload Form"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              setState((){
                pickedImageXFile=null;
                nameController.clear();
                ratingController.clear();
                tagsController.clear();
                priceController.clear();
                sizesController.clear();
                colorsController.clear();
                descriptionController.clear();

              } );
              Get.to(AdminUplodItemsScreen());
            },
            icon: Icon(Icons.clear)),
        actions: [
          TextButton(
              onPressed: () {
                Fluttertoast.showToast(msg: "Uploading now...");
                uploadItemImage();
              },
              child: Text(
                "Done",
                style: TextStyle(color: Colors.green.shade500),
              ))
        ],
      ),
      body: ListView(
        children: [
          //image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(
                      File(pickedImageXFile!.path),
                    ),
                    fit: BoxFit.cover)),
          ),
          //upload item form
          Padding(
            padding: EdgeInsets.all(Dimensions.height16),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimensions.circular60)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black26,
                      offset: Offset(0, -3),
                    )
                  ]),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Dimensions.height30,
                    Dimensions.height30,
                    Dimensions.height30,
                    Dimensions.height8),
                child: Column(
                  children: [
                    //email-password-login-button
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //item name
                          TextFormField(
                            controller: nameController,
                            validator: (val) =>
                                val == '' ? "Please write item name" : null,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.title,
                                  color: Colors.black,
                                ),
                                hintText: "item name...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width14,
                                    vertical: Dimensions.height6)),
                          ),
                          SizedBox(
                            height: Dimensions.height18,
                          ),
                          //item ratings
                          TextFormField(
                            controller: ratingController,
                            validator: (val) =>
                                val == '' ? "Please give item rating" : null,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.rate_review,
                                  color: Colors.black,
                                ),
                                hintText: "item rating...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width14,
                                    vertical: Dimensions.height6)),
                          ),
                          SizedBox(
                            height: Dimensions.height18,
                          ),
                          //item tags
                          TextFormField(
                            controller: tagsController,
                            validator: (val) =>
                                val == '' ? "Please write item tags" : null,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.tag,
                                  color: Colors.black,
                                ),
                                hintText: "item tags...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width14,
                                    vertical: Dimensions.height6)),
                          ),
                          SizedBox(
                            height: Dimensions.height18,
                          ),
                          //item price
                          TextFormField(
                            controller: priceController,
                            validator: (val) =>
                                val == '' ? "Please write item price" : null,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.price_change_outlined,
                                  color: Colors.black,
                                ),
                                hintText: "item price...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width14,
                                    vertical: Dimensions.height6)),
                          ),
                          SizedBox(
                            height: Dimensions.height18,
                          ),
                          //item sizes
                          TextFormField(
                            controller: sizesController,
                            validator: (val) =>
                                val == '' ? "Please write item sizes" : null,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.picture_in_picture,
                                  color: Colors.black,
                                ),
                                hintText: "item size...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width14,
                                    vertical: Dimensions.height6)),
                          ),
                          SizedBox(
                            height: Dimensions.height18,
                          ),
                          //item colors
                          TextFormField(
                            controller: colorsController,
                            validator: (val) =>
                                val == '' ? "Please write item colors" : null,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.color_lens,
                                  color: Colors.black,
                                ),
                                hintText: "item rating...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width14,
                                    vertical: Dimensions.height6)),
                          ),
                          SizedBox(
                            height: Dimensions.height18,
                          ),
                          //item description
                          TextFormField(
                            controller: descriptionController,
                            validator: (val) => val == ''
                                ? "Please write item description"
                                : null,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.description,
                                  color: Colors.black,
                                ),
                                hintText: "item rating...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.circular30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width14,
                                    vertical: Dimensions.height6)),
                          ),
                          SizedBox(
                            height: Dimensions.height18,
                          ),

                          //password

                          SizedBox(
                            height: Dimensions.height18,
                          ),
                          Material(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.circular(Dimensions.circular30),
                            child: InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate())
                                  {
                                    Fluttertoast.showToast(msg: "Uploading now...");
                                    uploadItemImage();
                                  }
                                },
                                borderRadius: BorderRadius.circular(
                                    Dimensions.circular30),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.height10,
                                    horizontal: Dimensions.width28,
                                  ),
                                  child: Text(
                                    "Upload Now",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimensions.fontSize16),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}
