import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/home_app_bar.dart';
import 'package:shop/components/image_toast.dart';
import 'package:shop/contents/shop_content.dart';
import 'package:shop/contents/tasks_content.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/app_logger.dart';
import 'package:shop/utils/constants.dart';
import 'package:shop/utils/list_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUser());
  }

  Future<void> _loadUser() async {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    if (userProvider.user != null) {
      return;
    }
    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    if (homeProvider.isProcessing) {
      return;
    }
    homeProvider.isProcessing = true;
    _fToast.init(context);
    _showInformationToast();
    try {
      await userProvider.loadUser();
    } catch (e) {
      logger.e(e);
      _showErrorToast();
    } finally {
      homeProvider.isProcessing = false;
    }
    final int? taskCount = userProvider.user?.tasksCount;
    if (taskCount != null && taskCount == 0) {
      _showWelcomeToast();
    }
  }

  void _showInformationToast() {
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: ListUtils.getRandom(Constants.facts.imageAssetNames),
        text: 'Did you know?' +
            '\n${ListUtils.getRandom(Constants.facts.messages)}',
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }

  void _showErrorToast() {
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: ListUtils.getRandom(Constants.errorImageAssetNames),
        text: 'It was not possible to load your tasks. Please try again' +
            ' later.',
        type: ImageToastType.error,
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }

  void _showWelcomeToast() {
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: 'assets/images/welcome.png',
        text: 'Welcome to Pe Dro List!\nCreate your first task and take the' +
            ' first step towards becoming the best in Santa Fe! 🤜🤛\n\n1' +
            ' completed task gives you' +
            ' ${Constants.prizePerCompletedTaskInCoins}' +
            ' coin${Constants.prizePerCompletedTaskInCoins == 1 ? '' : 's'}.' +
            '\n1 overdue task takes away' +
            ' ${Constants.lostLivesCountPerOverdueTask} fuel' +
            ' point${Constants.lostLivesCountPerOverdueTask == 1 ? '' : 's'}' +
            '.\nIf the number of fuel points is 0, Pedro will no longer' +
            ' appear! 😱',
      ),
      toastDuration: Duration(seconds: 2 * Constants.toastDuration.inSeconds),
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(final BuildContext context) {
    const List<Widget> contents = <Widget>[
      TasksContent(),
      ShopContent(),
    ];
    return GestureDetector(
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: Consumer<HomeProvider>(
          builder: (_, final HomeProvider homeProvider, __) =>
              homeProvider.subcontent ??
              contents[homeProvider.bottomNavigationBarIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 3,
              ),
            ),
          ),
          child: SizedBox(
            height: 80,
            child: Consumer<HomeProvider>(
              builder: (_, final HomeProvider homeProvider, __) =>
                  BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.moped_outlined,
                      size: 30,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      size: 23,
                    ),
                    label: 'Shop',
                  ),
                ],
                onTap: _selectContent,
                currentIndex: homeProvider.bottomNavigationBarIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                unselectedItemColor: Theme.of(context).colorScheme.secondary,
                selectedFontSize: 20,
                unselectedFontSize: 18,
              ),
            ),
          ),
        ),
        drawer: const AppDrawer(),
      ),
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    );
  }

  void _selectContent(final int index) {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    homeProvider.bottomNavigationBarIndex = index;
  }
}
