import 'dart:convert';

import 'package:clothes_app/admin/admin_upload_items.dart';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/authentication/signup_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_fragments.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AdminLoginScreen extends StatefulWidget {
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();

}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginAdminNow()async{
    try
    {
      var res = await http.post(
        Uri.parse(API.adminLogin),
        body: {
          'admin_email': emailController.text.trim(),
          'admin_password': passwordController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        print("Giriş başarılı");
        if (resBodyOfLogin['success'] == true)  
        {
          Fluttertoast.showToast(
              msg: 'Dear Admin, you are logged-in Succesfully');

          Future.delayed(const Duration(milliseconds: 2000),(){
            Get.to(AdminUplodItemsScreen());


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
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.height30),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: Dimensions.height275,
                    child: Image.asset("assets/admin_last.png"),
                  ),
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
                                          loginAdminNow();
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

                          SizedBox(height: Dimensions.height16),
                          //I am not an button - button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("I am not an admin"),
                              TextButton(onPressed: (){
                                Get.to(LoginScreen());


                              } , child: Text("Click Here",style: TextStyle(color:Colors.blue.shade900),) )
                            ],
                          ),
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



