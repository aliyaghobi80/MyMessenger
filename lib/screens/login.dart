import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../constant.dart';
import '../constant_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController valCodeController = TextEditingController();

  bool isWaitingForCode = false;
  String myVerificationId = '-1';
  late String phoneNum;
  bool isButtonShow = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();


  @override
  void initState() {

    super.initState();
    if (auth.currentUser != null) {
      Future.delayed(
        const Duration(milliseconds: 500),
            () {
          kNavigate(context, 'profile');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 100,
                    child: IntlPhoneField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'without zero',
                        contentPadding: EdgeInsets.all(17),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        icon: Icon(
                          Icons.phone,
                          color: kGrayColor,
                        ),
                      ),
                      initialCountryCode: 'IR',
                      dropdownDecoration: BoxDecoration(
                          border: Border(
                              right:
                              BorderSide(color: Colors.white, width: 1))),
                      onChanged: (phone) {
                        phoneNum = phone.completeNumber;
                        if (phoneNum.substring(3, 4) == '0') {
                          setState(() {
                            isButtonShow = false;
                          });
                        } else if (phoneNum.length < 13) {
                          setState(() {
                            isButtonShow = false;
                          });
                        } else {
                          setState(() {
                            isButtonShow = true;
                          });
                        }
                      },
                    )),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: isWaitingForCode,
                  child: SizedBox(
                    height: 70,
                    child: TextFormField(
                      validator: (val) {
                        return validateMobile(valCodeController.text);
                      },
                      controller: valCodeController,
                      keyboardType: TextInputType.phone,
                      decoration: kMyInputDecoration.copyWith(
                        hintText: 'Code',
                        focusColor: Colors.yellow
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Visibility(
                  visible: isButtonShow,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        elevation: 4,
                        shadowColor: Colors.white,
                        side: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        padding:
                        EdgeInsets.symmetric(horizontal: 50,vertical: 10)),
                    onPressed: onButtonPressed,
                    child: Text(
                      !isWaitingForCode ? 'Send Code' : 'Submit',
                      style: kTextStyleButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onButtonPressed() async {
    String phone = phoneNum;
    print(phone);
    String code = valCodeController.text;


    // send code to phone
    if (isWaitingForCode == false) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print(['-----------------------------------------------------']);
          print('verified');
          print(credential);
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(['-----------------------------------------------------']);
          print('failed');
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } //
          else {
            print(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print(['-----------------------------------------------------']);
          print('code sent');
          print(verificationId);
          setState(() {
            isWaitingForCode = true;
          });
          myVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(['-----------------------------------------------------']);
          print('code auto retrieval timeout');
          print(verificationId);
        },
      );
    } // do login with the sent code
    else {
      if (myVerificationId != '-1') {
        print('****************************************************');
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: myVerificationId, smsCode: code);

        // Sign the user in (or link) with the credential
        UserCredential userCredential =
        await auth.signInWithCredential(credential);
        print(userCredential.user);
        print(auth.currentUser);
        if (auth.currentUser != null) {
         kNavigate(context, 'profile');
        }else{
          kNavigate(context, 'login');
        }
      } //
      else {
        print('sth is wrong');
      }
    }
  }
}
