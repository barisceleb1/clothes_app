import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen> {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserEmail() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email': emailController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        //from flutter app the  connection with api to server - success

        var resBodyOfValidateEmail = jsonDecode(res.body);

        if (resBodyOfValidateEmail['emailFound'] == true) {
          Fluttertoast.showToast(
              msg: 'Email is already in someone else use. Try another email');
        } else {
          //register & save new user record to database
          registerAndSavedUserRecord();
        }
      }
      else{
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (e) 
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSavedUserRecord() async {
    User userModel = User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );
      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);
        if (resBodyOfSignUp['success'] == true)
        {
          Fluttertoast.showToast(
              msg: 'Congratulations, you are Signup Succesfully');
          setState(() {
            nameController.clear();
            emailController.clear();
            passwordController.clear();
          });

        } else {
          Fluttertoast.showToast(msg: 'Error Occurred, Try Again');
        }
      }
    } catch (e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //signup screen header
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: Dimensions.height275,
                  child: Image.asset("assets/signup.png"),
                ),
                //signup screen sign-up form
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
                            offset: Offset(0, Dimensions.minusheight3),
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(Dimensions.height16, Dimensions.height30, Dimensions.height30, Dimensions.height8),
                      child: Column(
                        children: [
                          //name-email-password || signUp-button
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                //name
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) =>
                                      val == '' ? "Please write name" : null,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      hintText: "name...",
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
                                        if (formKey.currentState!.validate()) {
                                          //validate the email
                                          validateUserEmail();
                                        }
                                        else(){
                                          print("Tıklamada hata var");
                                        };
                                      },
                                      borderRadius: BorderRadius.circular(Dimensions.circular30),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.height10,
                                          horizontal: Dimensions.width28,
                                        ),
                                        child: Text(
                                          "SignUp",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimensions.fontSize16),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          //already have an account button
                          SizedBox(height: Dimensions.height16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account"),
                              TextButton(
                                  onPressed: () {
                                    Get.to(LoginScreen());
                                  },
                                  child: Text(
                                    "Login Here",
                                    style:
                                        TextStyle(color: Colors.blue.shade900),
                                  ))
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
