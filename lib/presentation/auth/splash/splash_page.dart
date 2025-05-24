import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:minpa_lite/controller/auth_controlller.dart';
import 'package:minpa_lite/core/utils/color_constans.dart';
import 'package:minpa_lite/core/utils/navigate_app.dart';
import 'package:minpa_lite/data/datasources/auth_local_datasource.dart';
import 'package:minpa_lite/data/datasources/db_local_datasource.dart';
import 'package:minpa_lite/data/models/responses/store_model.dart';
import 'package:minpa_lite/data/models/responses/user_model.dart';
import 'package:minpa_lite/presentation/auth/auth_page.dart';
import 'package:minpa_lite/presentation/home/home_page.dart';
import 'package:uuid/uuid.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int persenLoading = 0;
  double loadingHeight = 2.0;
  bool isRegis = false;
  bool isLoadingButton = false;
  final controller = AuthControlller();
  final keyState = GlobalKey<ScaffoldState>();
  Color averageColor(Color a, Color b) {
    return Color.fromARGB(
      ((a.alpha + b.alpha) ~/ 2),
      ((a.red + b.red) ~/ 2),
      ((a.green + b.green) ~/ 2),
      ((a.blue + b.blue) ~/ 2),
    );
  }

  @override
  void initState() {
    super.initState();
    startLoading();
    DBLocalDatasource.instance.getAllUser().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          isRegis = true;
        });
      }
    });
  }

  Future<void> startLoading() async {
    for (int i = 0; i <= 101; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 120));
      setState(() {
        persenLoading = i;
        if (loadingHeight >= 1.17) {
          loadingHeight -= 0.08;
        }
      });
      if (i == 100) {
        print("loading selesai");
        break;
      }
    }

    // lanjut ke halaman berikutnya jika sudah selesai
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: averageColor(ColorConstans.second, ColorConstans.primary),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(
              MediaQuery.sizeOf(context).height / loadingHeight),
          child: Container(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            alignment:
                persenLoading == 100 ? Alignment.topCenter : Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  50,
                ),
                bottomRight: Radius.circular(
                  50,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: persenLoading == 100
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Text(
                  "Minpa Lite 2",
                  style: TextStyle(
                    fontFamily: "sf pro display italic bold",
                    color: ColorConstans.primary,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Teman pencatat penjualan anda",
                  style: TextStyle(
                    fontFamily: "sf pro display",
                    color: ColorConstans.primary,
                    fontSize: 13,
                  ),
                ),
                if (persenLoading >= 98 || loadingHeight <= 1.2) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: AuthPage(
                    key: keyState,
                    con: controller,
                    isRegis: isRegis,
                  )),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isLoadingButton == true) {
                          setState(() {
                            isLoadingButton = false;
                          });
                          return;
                        }
                        if (controller.formKey.currentState!.validate()) {
                          if (isRegis == false) {
                            setState(() {
                              isLoadingButton = true;
                            });

                            final String uniqueId = Uuid().v4();
                            await DBLocalDatasource.instance.saveUser(
                              UserModel(
                                userId: uniqueId,
                                name: controller.nameController.text,
                                phone: controller.phoneController.text,
                                email: controller.emailController.text,
                                password: controller.passwordController.text,
                                bank: controller.bankController.text,
                                account: controller.accountController.text,
                                role: "owner",
                              ),
                            );
                            await AuthLocalDatasource()
                                .getStore()
                                .then((value) {
                              if (value == null) {
                                AuthLocalDatasource().saveStore(
                                  StoreModel(
                                    id: 1,
                                    name: 'Jago Pos',
                                    address:
                                        'Jl. Palagan Raya No. 12, Kabupaten Slamen, Jawa Tengah',
                                  ),
                                );
                              }
                            });
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              isLoadingButton = false;
                            });
                          } else {
                            //
                            final user = await DBLocalDatasource.instance
                                .getUserByEmail(
                                    controller.emailController.text);
                            if (user == null) {
                              print("user tidak ada");
                            } else {
                              if (user.password !=
                                  controller.passwordController.text) {
                                print("password tidak sama");
                              } else {
                                await AuthLocalDatasource().saveUserData(user);

                                // ignore: use_build_context_synchronously
                                NavigateApp()
                                    .pushPageRemove(context, const HomePage());
                              }
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoadingButton == false
                            ? ColorConstans.primary
                            : ColorConstans.grey,
                        foregroundColor: Colors.transparent,
                        elevation: 0,
                        side: BorderSide(color: ColorConstans.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                      ),
                      child: Text(
                        isLoadingButton == false
                            ? isRegis == false
                                ? 'Daftar Sekarang'
                                : "Masuk Sekarang"
                            : "Loading...",
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "sf pro display bold",
                            color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isRegis == true || isLoadingButton == true) {
                        return;
                      }
                      setState(() {
                        isRegis = !isRegis;
                      });
                      controller.formKey.currentState!.reset();
                    },
                    child: Text(
                      isRegis == false
                          ? "Sudah punya akun ? Masuk"
                          : "Belum punya akun ? Daftar",
                      style: TextStyle(
                        color: ColorConstans.primary,
                        fontSize: 13,
                        fontFamily: "sf pro display",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]
              ],
            ),
          )),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: ColorConstans.primaryGradient,
        ),
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "@Fawq Dhakiun",
              style: TextStyle(
                fontFamily: "sf pro display bold",
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
