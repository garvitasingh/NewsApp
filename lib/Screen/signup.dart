import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var email = "";
  var password = "";
  var name = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  registration() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registered Successfully. Please Login..",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        Login();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("Password Provided is too Weak");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          print("Account Already exists");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.045,),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 40, left: 40, top: 10),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35,),
                    const Text("Create an \nAccount",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.w900
                      ),),
                    const SizedBox(height: 25,),
                    const Text("Name",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900
                      ),),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "John Doe",
                        suffixIcon: Icon(Icons.person, color: Colors.red),
                        suffixIconColor: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 25,),
                    const Text("Email",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900
                      ),),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "johndoe@gmail.com",
                        suffixIcon: Icon(Icons.mail, color: Colors.red),
                        suffixIconColor: Colors.red,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@')) {
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25,),
                    const Text("Contact no ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900
                      ),),
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          child: Image(
                            image: AssetImage("assets/indianFlag.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5,),
                          child: Container(
                            width: 40,
                            height: 25,
                            child: Text(
                              "+91",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: "2999992992",
                              suffixIcon: Icon(Icons.phone, color: Colors.red),
                              suffixIconColor: Colors.red,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25,),
                    const Text("Password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900
                      ),),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        suffixIcon: Icon(Icons.lock_outline, color: Colors.red),
                        suffixIconColor: Colors.red,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an Account ?"),
                        TextButton(
                          onPressed: () => {
                          Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => Home()))
                          },
                          child: const Text('Sign In!', style: TextStyle(color: Colors.red),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50,)
                  ],
                ),
                ),
              ),
              // Spacer(),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
      if (_formKey.currentState!.validate()) {
          setState(() {
            name = nameController.text;
            email = emailController.text;
            password = passwordController.text;
          });
          registration();
        }},
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius:  BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: const Text("REGISTER", style: TextStyle(
              color: Colors.white,
              fontSize: 20
          ),),
        ),
      ),
    );
  }
}
