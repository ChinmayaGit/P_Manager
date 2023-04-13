import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

dynamic userData;
dynamic companyData;
dynamic searchData;

FirebaseFirestore fire = FirebaseFirestore.instance;
String userUid = FirebaseAuth.instance.currentUser!.uid;

FetchDataLoading fetchController = Get.put(FetchDataLoading());
FetchCompanyDataLoading companyController = Get.put(FetchCompanyDataLoading());

List<String> search = [];

class FetchDataLoading extends GetxController {
  RxBool fetchDataLoading = false.obs;
}

class FetchCompanyDataLoading extends GetxController {
  RxBool fetchCompanyDataLoading = false.obs;
}


fetchData() async {
  QuerySnapshot querySnapshot =
      await fire.collection("user").doc(userUid).collection("vault").get();
  userData = querySnapshot.docs;
  fetchController.fetchDataLoading.value = true;
}

fetchCompanyData() async {
  if (companyController.fetchCompanyDataLoading.value == false) {
    QuerySnapshot querySnapshot = await fire.collection("company").get();
    companyData = querySnapshot.docs;
    companyController.fetchCompanyDataLoading.value = true;
  }
}

searchFetchData() async {
  QuerySnapshot querySnapshot =
      await fire.collection("user").doc(userUid).collection("vault").get();
  searchData = querySnapshot.docs;
  print(searchData.length);
  for (int i = 0; i < searchData.length; i++) {
    search.add(searchData[i]["id"]);
  }
}
