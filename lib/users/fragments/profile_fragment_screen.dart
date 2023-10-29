
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileFragmentScreen extends StatelessWidget {
  final CurrentUser _currentUser = Get.put(CurrentUser());
signOutUser()async
{
  var resultResponse = await Get.defaultDialog(
      onConfirm: (){Get.back(result: "loggedOut");},
      onCancel: (){},
      title:"Logout",
      backgroundColor: Colors.grey.shade600,
      buttonColor: Colors.red,
      textCancel:"No",
      textConfirm: "Yes",
      cancelTextColor: Colors.white,
      confirmTextColor: Colors.white,
      middleText: "Have you received your parcel?",

      barrierDismissible: false



  );
// If you want to use alert dialog, you can use the comment below.

  /*Get.dialog(
    AlertDialog(
      backgroundColor: Colors.grey,
      title: Text(
        "Logout",
        style: TextStyle(
          fontSize: Dimensions.fontSize18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Are you sure?\n you want to logout from app?"
      ),
      actions: [
        TextButton(onPressed: (){
          Get.back();
        }, child:
        Text(
          "No",style: TextStyle(color: Colors.black),
        ),),
        TextButton(onPressed: (){
          Get.back(result: "loggedOut");
        }, child:
        Text(
          "Yes",style: TextStyle(color: Colors.black),
        ),),
      ],
    ),
  );*/
  if(resultResponse == "loggedOut"){
    //delete-remove the user data from phone local storage
    RememberUserPrefs.removeUserInfo().then((value){
      Get.off(LoginScreen());
    });
  }
}
Widget userInfoItemProfile(IconData iconData, String userData)
{
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Dimensions.circular12),
      color: Colors.grey,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: Dimensions.width16,
      vertical: Dimensions.height8,
    ),
    child: Row(
      children: [
Icon(
  iconData,
  size: Dimensions.height30,
  color: Colors.black,
),
         SizedBox(width: Dimensions.width15),
        Text(userData,
        style: TextStyle(
          fontSize: Dimensions.fontSize15
        ),)
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(Dimensions.height30),
      children: [
        Center(
          child: Image.asset("assets/personel_image.png",width:Dimensions.width240,),

        ),
       SizedBox(height: Dimensions.height20,),
        userInfoItemProfile(Icons.person, _currentUser.user.user_name),
        SizedBox(height: Dimensions.height20,),
        userInfoItemProfile(Icons.email, _currentUser.user.user_email),
        SizedBox(height: Dimensions.height20,),
        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(Dimensions.height8),
            child: InkWell(
              onTap: (){
                signOutUser();
              },
              borderRadius: BorderRadius.circular(Dimensions.height30),
              child: Padding(padding:EdgeInsets.symmetric(
                horizontal: Dimensions.height20,
                vertical: Dimensions.height12
              ),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.fontSize16
                  ),
                ),
              ),
            ),
          ),
        )
      ],



    );
  }
}
