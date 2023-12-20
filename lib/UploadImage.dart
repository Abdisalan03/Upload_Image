import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StreamFirebase extends StatefulWidget {
  const StreamFirebase({super.key});

  @override
  State<StreamFirebase> createState() => _StreamFirebaseState();
}

class _StreamFirebaseState extends State<StreamFirebase> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

// text controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // image picker code
  final ImagePicker _picker = ImagePicker();
  File? _image;
  chooseImages() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image
            .path); //this will make tghe fn not null and galary will be opened
      });
    }
  }

  // add data to firebase firestore and the image to firebase storage without calling database service

  addData() async {
    if (_image != null) {
      try {
        final Uint8List data = await _image!.readAsBytes();
        final String base64Image = base64Encode(data);
        final String fileName = _image!.path.split("/").last;
        final String imageType = fileName.split(".").last;
        final String image = "data:image/$imageType;base64,$base64Image";

        // add image to firebase storage
        await FirebaseStorage.instance.ref("images/$fileName").putFile(_image!);

        // add data to firebase firestore
        await FirebaseFirestore.instance.collection("user").add({
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "image": image,
        });

        // clear text controller
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Stream Firebase",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: "Roboto",
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // profile
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: _image == null
                              ? null
                              : FileImage(_image!) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          top: 100,
                          child: IconButton(
                            onPressed: () {
                              chooseImages();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // phone no
                  TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone no";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter your phone no",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please upload image"),
                            ),
                          );
                          return;
                        }
                        if (formKey.currentState!.validate()) {
                          try {
                            addData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Data added successfully"),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                      ),
                      child: const Text("Submit")),
                  const Divider(
                    height: 50,
                    thickness: 2,
                    color: Colors.blue,
                  ),

                  // stream builder
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }
                      if (snapshot.hasData) {
                        final List<QueryDocumentSnapshot> data =
                            snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> arg =
                                data[index].data() as Map<String, dynamic>;
                            return ListTile(
                              leading: arg['image'] == null
                                  ? const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: null,
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(arg['image']),
                                    ),
                              title: Text(arg['name']),
                              subtitle: Text(arg['email']),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
