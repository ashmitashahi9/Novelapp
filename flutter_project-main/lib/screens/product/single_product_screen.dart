import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_baz/models/favorite_model.dart';
import 'package:n_baz/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({Key? key}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleProductViewModel>(
        create: (_) => SingleProductViewModel(), child: SingleProductBody());
  }
}

class SingleProductBody extends StatefulWidget {
  const SingleProductBody({Key? key}) : super(key: key);

  @override
  State<SingleProductBody> createState() => _SingleProductBodyState();
}

class _SingleProductBodyState extends State<SingleProductBody> {
  late SingleProductViewModel _singleProductViewModel;
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? productId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _singleProductViewModel =
          Provider.of<SingleProductViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        productId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }

  Future<void> getData(String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.getFavoritesUser();
      await _singleProductViewModel.getProducts(productId);
    } catch (e) {}
    _ui.loadState(false);
  }

  Future<void> favoritePressed(
      FavoriteModel? isFavorite, String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.favoriteAction(isFavorite, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Favorite updated.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong. Please try again.")));
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SingleProductViewModel, AuthViewModel>(
        builder: (context, singleProductVM, authVm, child) {
      return singleProductVM.product == null
          ? Scaffold(
        backgroundColor: Color(0xff767474),
              body: Container(
                child: Text("Error"),
              ),
            )
          : singleProductVM.product!.id == null
              ? Scaffold(
                  body: Center(
                    child: Container(
                      child: Text("Please wait..."),
                    ),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black54,
                    actions: [
                      Builder(builder: (context) {
                        FavoriteModel? isFavorite;
                        try {
                          isFavorite = authVm.favorites.firstWhere(
                              (element) =>
                                  element.productId ==
                                  singleProductVM.product!.id);
                        } catch (e) {}

                        return IconButton(
                            onPressed: () {
                              print(singleProductVM.product!.id!);
                              favoritePressed(
                                  isFavorite, singleProductVM.product!.id!);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite != null
                                  ? Colors.red
                                  : Colors.white,
                            ));
                      })
                    ],
                  ),
                  backgroundColor: Color(0xFFf5f5f4),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(
                          singleProductVM.product!.imageUrl.toString(),
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/images/logo.png',
                              height: 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(color: Colors.white70),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rs. " +
                                      singleProductVM.product!.productPrice
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  singleProductVM.product!.productName
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  singleProductVM.product!.productDescription
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                );
    });
  }
}
