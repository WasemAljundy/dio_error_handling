import 'package:dio_error_handling/app/modules/home/views/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/my_widgets_animator.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          GetBuilder<HomeController>(builder: (_) {
            return Expanded(
              child: MyWidgetsAnimator(
                animationDuration: const Duration(milliseconds: 500),
                transitionBuilder: (p0, p1) => ScaleTransition(
                  scale: p1,
                  child: p0,
                ),
                apiCallStatus: controller.apiCallStatus,
                loadingWidget: () => const Center(
                  child: CupertinoActivityIndicator(),
                ),
                errorWidget: () => ApiErrorWidget(
                  message: Strings.internetError.tr,
                  retryAction: () => controller.getUsers(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                ),
                successWidget: () => ListView(
                  children: [
                    Form(
                      key: controller.formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                        ),
                        child: SearchBar(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white70),
                          leading: const Icon(Icons.search),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 15.h),
                          ),
                          hintText: Strings.search.tr,
                          controller: controller.editController,
                          onChanged: (value) {
                            if (controller.formKey.currentState!.validate()) {
                              controller.getUserBySearch(value);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(controller.users[index].image),
                            radius: 30,
                          ),
                          title: Text(
                              '${controller.users[index].firstName} ${controller.users[index].lastName}'),
                          subtitle: Text(controller.users[index].email),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
