import 'dart:io';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdmanager/Global/database.dart';
import 'package:pdmanager/widgets/snackbar.dart';
import 'package:pdmanager/db/dataFetch.dart';
import 'package:pdmanager/pages/details_Page.dart';
import 'package:pdmanager/pages/homePage.dart';
import 'package:pdmanager/widgets/search.dart';
import 'package:pdmanager/widgets/textField.dart';
import 'dart:math' as Math;

import 'package:url_launcher/url_launcher.dart';

class Company extends StatefulWidget {
  Company({Key? key});

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  final SearchUpdater controller = Get.put(SearchUpdater());

  final TextEditingController companyIconController = TextEditingController();
  final TextEditingController companyLinkController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? image;
  late String imageUrl;
bool exist=false;
  @override
  void initState() {
    super.initState();
    fetchCompanyData();
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    if (img != null) {
      final File imageFile = File(img.path);
      final compressedImageData = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        minHeight: 256,
        minWidth: 256,
        quality: 80,
        format: CompressFormat.png,
      );
      final File compressedImageFile = File(imageFile.path)
        ..writeAsBytesSync(compressedImageData!);
      var selectedImageTwo = XFile(compressedImageFile.path);
      setState(() {
        image = selectedImageTwo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Select Company"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Center(
                  child: Text("Add New Company"),
                ),
                actions: <Widget>[
                  image != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                getImage(ImageSource.gallery);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  //to show image, you type like this.
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: GestureDetector(
                            onTap: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.asset("assets/addImage.png"),
                            ),
                          ),
                        ),
                  textFields(
                      name: 'name',
                      ico: Icons.add_circle_outline_rounded,
                      controller: companyNameController,
                      hint: "company name"),
                  textFields(
                      name: 'link',
                      ico: Icons.link,
                      controller: companyLinkController,
                      hint: "website link"),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Reference reference = FirebaseStorage.instance
                            .ref()
                            .child(companyNameController.text + ".png");

                        var selectedImages = File(image!.path);

                        UploadTask uploadTask =
                            reference.putFile(selectedImages);

                        uploadTask.whenComplete(() async {
                          try {
                            imageUrl = await reference.getDownloadURL();
                          } catch (onError) {}
                        }).then((value) => {
                              fire
                                  .collection("company")
                                  .doc(StringUtils.capitalize(companyNameController.text))
                                  .set({
                                "icon": imageUrl,
                                "id": StringUtils.capitalize(companyNameController.text),
                                "link": companyLinkController.text,
                              }).then((value) {
                                Navigator.pop(context);
                              }),
                            }).then((value) {

                          fetchCompanyData();
                          searchFetchData();
                          CustomSnackBar(
                              msg:
                              "${companyLinkController.text} Added!");
                          Get.offAll(const HomePage());

                        });
                      },
                      child: Container(
                        height: 60,
                        width: 200,
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.green),
                        child: const Center(
                          child: Text(
                            "ADD",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: const Color(0xffE9DDFF),
        label: const Text(
          'Add',
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchTextField(
              fieldValue: (String value) {
                controller.searchText.value = value;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => companyController.fetchCompanyDataLoading.value == true
                ? Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 0.7),
                        itemCount: companyData.length,
                        padding: const EdgeInsets.all(2.0),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {

                              if (search.contains(companyData[index]['id'])) {
                                exist=true;
                              } else {
                                exist=false;
                              }
                              if(exist==false) {
                                fire
                                    .collection("user")
                                    .doc(userUid)
                                    .collection("vault")
                                    .doc(companyData[index]['id'])
                                    .set({
                                  "gmail": FieldValue.arrayUnion([
                                    {
                                      "gmail": "",
                                      "pass": "",
                                    },
                                  ]),
                                  "id": companyData[index]['id'],
                                  "icon": companyData[index]['icon'],
                                }).then((value) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return
                                        AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          title: Center(
                                            child: Text(
                                                companyData[index]['id']),
                                          ),
                                          content:SingleChildScrollView(
                                            child: Column(children: [
                                              Center(
                                                child: Image(
                                                  height: 80,
                                                  width: 80,
                                                  image: CachedNetworkImageProvider(
                                                      companyData[index]['icon']),
                                                ),
                                              ),
                                              textFields(
                                                  name: 'username',
                                                  ico: Icons.person_add,
                                                  controller: usernameController,
                                                  hint: "username/email/phone no."),
                                              textFields(
                                                  name: 'password',
                                                  ico: Icons.password,
                                                  controller: passwordController,
                                                  hint: "password"),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    fire
                                                        .collection("user")
                                                        .doc(userUid)
                                                        .collection("vault")
                                                        .doc(companyData[index]['id'])
                                                        .set({
                                                      "gmail": FieldValue.arrayUnion([
                                                        {
                                                          "gmail": usernameController.text,
                                                          "pass": passwordController.text,
                                                        },

                                                      ]),
                                                      "id": companyData[index]['id'],
                                                      "icon": companyData[index]['icon'],
                                                    }).then((value) {

                                                      fetchData();
                                                      searchFetchData();
                                                      CustomSnackBar(
                                                          msg:
                                                          "${companyData[index]["id"]} added!");

                                                    }).then((value) {
                                                      Get.offAll(const HomePage());
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 60,
                                                    width: 200,
                                                    decoration: ShapeDecoration(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(18.0),
                                                        ),
                                                        color: Colors.green),
                                                    child: const Center(
                                                      child: Text(
                                                        "ADD",
                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                            ],),
                                          ),
                                        );
                                    },
                                  );


                                  // Get.back();
                                });
                              }else{
                                CustomSnackBar(
                                    msg:
                                    "${companyData[index]["id"]} already added!");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    color: Colors.black12),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Image(
                                              image: CachedNetworkImageProvider(
                                                  companyData[index]['icon'])),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                              companyData[index]["id"]),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: (){
                                            launchUrl(Uri.parse( companyData[index]["link"]),);

                                          },
                                          child: Container(
                                            decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8.0),
                                                ),
                                                color: Colors.blue.shade100),
                                            child: Center(
                                                child: const Text(
                                              "vist site",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}

class SearchUpdater extends GetxController {
  RxString searchText = "".obs;
}
