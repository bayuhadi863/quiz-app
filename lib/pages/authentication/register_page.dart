import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/authentication/register_controller.dart';
import 'package:quiz_app/utils/constants/colors.dart';
import 'package:quiz_app/utils/validators/validation.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: MyColors.primary, // Atur warna latar belakang menjadi biru
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.09),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up Now",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Join Quizard and explore quizzes!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Setengah tinggi layar
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.75, // 3/4 tinggi layar
                decoration: const BoxDecoration(
                  color:
                      Colors.white, // Atur warna latar belakang menjadi merah
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(30.0), // Border rounded pada atas kiri
                    topRight:
                        Radius.circular(30.0), // Border rounded pada atas kanan
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        key: controller.registerFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.name,
                              validator: (value) =>
                                  Validators.validateName(value),
                              style: const TextStyle(color: Color(0xFF080A23)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Name',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF080A23)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Tambahkan enabledBorder untuk border saat non-aktif
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ), // Border saat non-aktif
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: controller.email,
                              validator: (value) =>
                                  Validators.validateEmail(value),
                              style: const TextStyle(color: Color(0xFF080A23)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF080A23)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Tambahkan enabledBorder untuk border saat non-aktif
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ), // Border saat non-aktif
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Obx(
                              () => TextFormField(
                                controller: controller.password,
                                validator: (value) =>
                                    Validators.validateEmptyText(
                                        'Password', value),
                                obscureText: controller.hidePassword.value,
                                style:
                                    const TextStyle(color: Color(0xFF080A23)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF080A23)),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => controller.hidePassword
                                        .value = !controller.hidePassword.value,
                                    icon: Icon(
                                      controller.hidePassword.value
                                          ? FeatherIcons.eyeOff
                                          : FeatherIcons.eye,
                                      size: 20,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // Tambahkan enabledBorder untuk border saat non-aktif
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ), // Border saat non-aktif
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 18),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed: () => controller.isLoading.isTrue
                                      ? null // Menonaktifkan button saat isLoading bernilai true
                                      : controller.signup(),
                                  style: ButtonStyle(
                                    backgroundColor: controller.isLoading.isTrue
                                        ? MaterialStateProperty.all(
                                            MyColors.primary.withOpacity(
                                                0.5)) // Atur opasitas warna latar belakang
                                        : MaterialStateProperty.all(
                                            MyColors.primary),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: controller.isLoading.isTrue
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Sign Up',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 80.0,
                            // ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          Transform.translate(
                            offset: const Offset(-5.0, 0.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: Color(0xFF6465F0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
