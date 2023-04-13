import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdmanager/Global/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdmanager/widgets/snackbar.dart';
import 'package:pdmanager/db/dataFetch.dart';
import 'package:pdmanager/widgets/textField.dart';

class DetailsPage extends StatefulWidget {
  final int dataLength;
  final int backIndex;

  DetailsPage({Key? key, required this.dataLength, required this.backIndex})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState() ;
}

class _DetailsPageState extends State<DetailsPage> {
  final FetchDataLoading tpController = Get.put(FetchDataLoading());
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();


  List<bool> show = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.dataLength; i++) {
      show.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(userData[widget.backIndex]['id']),
        centerTitle: true,
        actions: const [
          Icon(Icons.filter_list_rounded),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => tpController.fetchDataLoading.value == true
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.dataLength,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: const Text(
                                    "Are You Sure You Want to Delete It!",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            fire
                                                .collection("user")
                                                .doc(userUid)
                                                .collection("vault")
                                                .doc(userData[widget.backIndex]
                                                    ['id'])
                                                .update({
                                              "gmail": FieldValue.arrayRemove([
                                                {
                                                  "gmail":
                                                      userData[widget.backIndex]
                                                              ["gmail"][index]
                                                          ["gmail"],
                                                  "pass":
                                                      userData[widget.backIndex]
                                                              ["gmail"][index]
                                                          ["pass"],
                                                },
                                              ]),
                                            }).then((value) {
                                              fetchData();
                                              Navigator.pop(context);
                                            });
                                            Get.back();
                                          },
                                          child: Container(
                                            height: 60,
                                            width: 200,
                                            decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                color: Colors.green),
                                            child: const Center(
                                                child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            )),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            height: 60,
                                            width: 200,
                                            decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                color: Colors.red),
                                            child: const Center(
                                                child: Text(
                                              "No",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            )),
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Container(
                                  height: Get.height / 7,
                                  decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      color: Colors.black12),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          userData[widget
                                                                  .backIndex]
                                                              ['icon'])),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("username:"),
                                              Expanded(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onLongPress: () {
                                                    Clipboard.setData(
                                                      ClipboardData(
                                                        text: userData[widget
                                                                    .backIndex]
                                                                ["gmail"][index]
                                                            ["gmail"],
                                                      ),
                                                    );
                                                    CustomSnackBar(
                                                        msg:
                                                            "Username Copied!");
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        userData[widget
                                                                    .backIndex]
                                                                ["gmail"][index]
                                                            ["gmail"],
                                                      ),
                                                      const Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Clipboard.setData(
                                                            ClipboardData(
                                                              text: userData[widget
                                                                          .backIndex]
                                                                      ["gmail"][
                                                                  index]["gmail"],
                                                            ),
                                                          );
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Username Copied!",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors
                                                                      .black12,
                                                              textColor:
                                                                  Colors.black,
                                                              fontSize: 16.0);
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              ShapeDecoration(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                  color: Colors
                                                                      .white),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Text(
                                                              "copy",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Text("password:"),
                                              Expanded(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onLongPress: () {
                                                    Clipboard.setData(
                                                      ClipboardData(
                                                        text: userData[widget
                                                                    .backIndex]
                                                                ["gmail"][index]
                                                            ["pass"],
                                                      ),
                                                    );
                                                    CustomSnackBar(
                                                        msg:
                                                            "Password Copied!");
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      show[index] == true? Text(
                                                        userData[widget
                                                            .backIndex]
                                                        ["gmail"]
                                                        [index]["pass"],
                                                      ):Text("••••••••"),
                                                      // Visibility(
                                                      //   visible: show[index],
                                                      //   child:
                                                      // ),
                                                      const Spacer(),
                                                      show[index] == true
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  show[index] =
                                                                      false;
                                                                });
                                                              },
                                                              child: Container(
                                                                child: Icon(Icons
                                                                    .visibility_outlined),
                                                              ))
                                                          : GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  show[index] =
                                                                      true;
                                                                });
                                                              },
                                                              child: Container(
                                                                child: Icon(Icons
                                                                    .visibility_off_outlined),
                                                              )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Clipboard.setData(
                                                            ClipboardData(
                                                              text: userData[widget
                                                                          .backIndex]
                                                                      ["gmail"][
                                                                  index]["pass"],
                                                            ),
                                                          );
                                                          CustomSnackBar(
                                                              msg:
                                                                  "Password Copied!");
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              ShapeDecoration(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                  color: Colors
                                                                      .white),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Text(
                                                              "copy",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return
                // CreateId(id:userData[widget.backIndex]['id'],icon:userData[widget.backIndex]['icon']);
                AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Center(
                  child: Text(
                      userData[widget.backIndex]['id']),
                ),
                actions: <Widget>[
                  Center(
                    child: Image(
                      height: 80,
                      width: 80,
                      image: CachedNetworkImageProvider(
                          userData[widget.backIndex]['icon']),
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
                            .doc(userData[widget.backIndex]['id'])
                            .update({
                          "gmail": FieldValue.arrayUnion([
                            {
                              "gmail": usernameController.text,
                              "pass": passwordController.text,
                            },
                          ]),
                        }).then((value) {
                          fetchData();
                          Get.back();Get.back();

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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class CreateId extends StatelessWidget {
// final String id;
//  final String icon;
//  CreateId({Key? key,required this.id,required this.icon}) : super(key: key);
//  final TextEditingController usernameController = TextEditingController();
//
//  final TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       title: Center(
//         child: Text(
//             id),
//       ),
//       content:SingleChildScrollView(
//         child: Column(children: [
//           Center(
//             child: Image(
//               height: 80,
//               width: 80,
//               image: CachedNetworkImageProvider(
//                   icon),
//             ),
//           ),
//           textFields(
//               name: 'username',
//               ico: Icons.person_add,
//               controller: usernameController,
//               hint: "username/email/phone no."),
//           textFields(
//               name: 'password',
//               ico: Icons.password,
//               controller: passwordController,
//               hint: "password"),
//           const SizedBox(
//             height: 30,
//           ),
//           Center(
//             child: GestureDetector(
//               onTap: () {
//                 fire
//                     .collection("user")
//                     .doc(userUid)
//                     .collection("vault")
//                     .doc(usernameController.text)
//                     .update({
//                   "gmail": FieldValue.arrayUnion([
//                     {
//                       "gmail":usernameController.text,
//                       "pass": passwordController.text,
//                     },
//                   ]),
//                 }).then((value) {
//                   fetchData();
//                   Navigator.pop(context);
//                 });
//               },
//               child: Container(
//                 height: 60,
//                 width: 200,
//                 decoration: ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18.0),
//                     ),
//                     color: Colors.green),
//                 child: const Center(
//                   child: Text(
//                     "ADD",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//         ],),
//       ),
//     );
//   }
// }
