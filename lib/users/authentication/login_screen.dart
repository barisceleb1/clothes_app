import 'dart:convert';

import 'package:clothes_app/admin/admin_login.dart';
import 'package:clothes_app/admin/admin_upload_items.dart';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/signup_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_fragments.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUserNow()async{
try
    {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          'user_email': emailController.text.trim(),
          'user_password': passwordController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        print("Giriş başarılı");
        if (resBodyOfLogin['success'] == true)
        {
          Fluttertoast.showToast(
              msg: 'you are logged-in Succesfully');
          User userInfo = User.fromJason(resBodyOfLogin["userData"]);
//save userInfo local storage using shared preferences
          await RememberUserPrefs.storeUserInfo(userInfo);
          Future.delayed(Duration(milliseconds: 2000),(){
            Get.to(DashboardOfFragments());


          });
        }
        else
          {
          Fluttertoast.showToast(msg: 'Incorrect Credentials.\n Please write correct password or email and Try Again');
        }
      }
      else{
        Fluttertoast.showToast(msg: "Status is not 200");
      }

    }
    catch(erorrMsg){
print("Error:: "+erorrMsg.toString());
    }

  }


  @override
  Widget build(BuildContext context) {
    print("Şu anki yükskelik:"+ MediaQuery.of(context).size.height.toString());
    return Scaffold(
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: Dimensions.height275,
                  child: Image.asset("assets/clothes.jpg"),
                ),
                //Login Screen sign-in form
                Padding(
                  padding: EdgeInsets.all(Dimensions.height16),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.circular60)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black26,
                            offset: Offset(0, -3),
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(Dimensions.height30, Dimensions.height30, Dimensions.height30, Dimensions.height8),
                      child: Column(
                        children: [
                          //email-password-login-button
                          Form(
                            key: formKey,
                            child: Column(

                              children: [
                                //email
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  validator: (val) =>
                                      val == '' ? "Please write email" : null,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "email...",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(Dimensions.circular30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(Dimensions.circular30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(Dimensions.circular30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(Dimensions.circular30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          )),
                                      contentPadding:
                                           EdgeInsets.symmetric(
                                              horizontal: Dimensions.width14, vertical: Dimensions.height6)),
                                ),
                                 SizedBox(
                                  height: Dimensions.height18,
                                ),

                                //password
                                Obx(
                                  () => TextFormField(
                                    keyboardType:TextInputType.visiblePassword,
                                    controller: passwordController,
                                    obscureText: isObsecure.value,
                                    validator: (val) => val == ''
                                        ? "Please write password"
                                        : null,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.vpn_key_sharp,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: Obx(() => GestureDetector(
                                              onTap: () {
                                                isObsecure.value =
                                                    !isObsecure.value;
                                              },
                                              child: Icon(
                                                isObsecure.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black,
                                              ),
                                            )),
                                        hintText: "password...",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(Dimensions.circular30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(Dimensions.circular30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(Dimensions.circular30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(Dimensions.circular30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        contentPadding:
                                             EdgeInsets.symmetric(
                                                horizontal: Dimensions.width14, vertical: Dimensions.height6)),
                                  ),
                                ),
                               SizedBox(
                                  height: Dimensions.height18,
                                ),
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(Dimensions.circular30),
                                  child: InkWell(
                                      onTap: () {
                                        if(formKey.currentState!.validate()){
                                          loginUserNow();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(Dimensions.circular30),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.height10,
                                          horizontal: Dimensions.width28,
                                        ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimensions.fontSize16),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          //don't have an account button
                          SizedBox(height: Dimensions.height16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account"),
                              TextButton(onPressed: (){
                                Get.to(SignUpScreen());


                              } , child: Text("Sign Up Here",style: TextStyle(color:Colors.blue.shade900),) )
                            ],
                          ),
                          Text("Or",style: TextStyle(
                            fontSize: Dimensions.fontSize16,
                          ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Are you an admin ?"),
                              TextButton(onPressed: (){
                                Get.to(AdminLoginScreen());


                              } , child: Text("Click Here",style: TextStyle(color:Colors.blue.shade900,fontSize: Dimensions.fontSize16),) )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

}



