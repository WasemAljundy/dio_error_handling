import 'package:dio_error_handling/app/data/models/User.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../utils/constants.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class HomeController extends GetxController {
  // hold data coming from api
  late List<dynamic> users;
  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  getUsers() async {
    await BaseClient.safeApiCall(
      Constants.users,
      RequestType.get,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) {
        var array = response.data['data'];
        Logger().i(array.runtimeType);
        users = array.map((jsonObject) => User.fromJson(jsonObject)).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
        return users;
      },
      onError: (error) {
        // show error message to user
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  getUserBySearch(String name) async {
    await BaseClient.safeApiCall(
      Constants.searchUser,
      RequestType.post,
      queryParameters: {
        'first_name': name
      },
      onSuccess: (response) {
        var array = response.data['data'];
        Logger().i(array.runtimeType);
        users = array.map((jsonObject) => User.fromJson(jsonObject)).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
        return users;
      },
      onError: (error) {
        if (name.isEmpty) {
          return users;
        }
        update();
      },
    );
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }
}
