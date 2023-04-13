import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdmanager/Global/database.dart';
import 'package:pdmanager/db/dataFetch.dart';
import 'package:pdmanager/pages/details_Page.dart';
import 'package:pdmanager/pages/new_Company.dart';
import 'package:pdmanager/widgets/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = '';

  @override
  void initState() {
    fetchData();
    searchFetchData();
    fetchCompanyData();
    super.initState();
  }

  // final FetchData tpController = Get.put(FetchData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("My Vault"),
        centerTitle: true,
        actions: [

          Icon(Icons.filter_list_rounded),
          SizedBox(
            width: 20,
          ),
    GestureDetector(
    onTap: ()async{
      await FirebaseAuth.instance.signOut();
    },
    child: Icon(Icons.logout,color: Colors.red,)),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchTextField(
                fieldValue: (String value) {
                  setState(() {
                    text = value;
                  });
                },
              ),
            ),
            SingleChildScrollView(
              child: Obx(
                () => fetchController.fetchDataLoading.value == true
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:   userData .length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {

                              // print(userData[0]["gmail"].length-1);
                              Get.to(DetailsPage(dataLength:userData [index]["gmail"].length,backIndex: index,));
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12,5.0,12,5.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: Get.height / 8,
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
                                                            userData [index]
                                                                ['icon'])),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            userData [index]["id"].toString(),

                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),),
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
                        child: const CircularProgressIndicator(),
                      ),
              ),
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
      elevation: 0,
        onPressed: () {
         Get.to(() =>Company());
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
