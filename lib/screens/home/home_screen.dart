import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/screens/home/home_screen_controller.dart';
import 'package:thunderapp/screens/list_products/list_products_screen.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/app_text_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/user_storage.dart';
import '../../components/utils/horizontal_spacer_box.dart';
import '../my store/edit_store_screen.dart';
import 'components/item_card_holder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Início',
                    style: kTitle2.copyWith(color: Colors.white),
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Divider(
                        height: size.height * 0.03,
                        color: Colors.transparent,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 18, bottom: 10, left: 26, right: 26),
                        alignment: AlignmentDirectional.topStart,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: controller.bancaModel?.id == null
                                  ? null
                                  : Image.network(
                                      '$kBaseURL/bancas/${controller.bancaModel?.id}/imagem',
                                      headers: {
                                        "Authorization":
                                            "Bearer ${controller.userToken}"
                                      },
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        );
                                      },
                                    ).image,
                              radius: 38,
                            ),
                            const HorizontalSpacerBox(size: SpacerSize.small),
                            SizedBox(
                              width: size.width * 0.61,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  controller.bancaModel == null
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Container(
                                          width: size.width * 0.38,
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Olá, ${controller.bancaModel?.nome}",
                                              style: TextStyle(
                                                  fontSize: size.height * 0.032,
                                                  fontWeight: FontWeight.w500,
                                                  color: kSecondaryColor),
                                            ),
                                          ),
                                        ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                fullscreenDialog: true,
                                                builder: (_) => EditStoreScreen(
                                                    controller.bancaModel)));
                                      },
                                      icon: Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: kPrimaryColor,
                                        size: size.height * 0.04,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.6,
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: size.width,
                                  height: size.height * 0.2,
                                  child: ItemCardHolder(
                                    icon: Icons.storefront,
                                    title: 'Produtos',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ListProductsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.41,
                                      height: size.height * 0.2,
                                      child: ItemCardHolder(
                                        icon: Icons.list_alt_sharp,
                                        title: 'Pedidos',
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Screens.orders);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.41,
                                      height: size.height * 0.2,
                                      child: ItemCardHolder(
                                        icon: Icons.history_outlined,
                                        title: 'Histórico',
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Screens.report);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.9,
                            child: PrimaryButton(
                              text: 'Sair',
                              onPressed: () async {
                                UserStorage userStorage = UserStorage();
                                userStorage.clearUserCredentials();
                                Navigator.popAndPushNamed(
                                    context, Screens.signin);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}
