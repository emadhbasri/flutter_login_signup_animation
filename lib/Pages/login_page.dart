import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/functions.dart';
import '../classes/my_animated_widget.dart';
import '../dataTypes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../State/my_state.dart';

class ProviderLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<MyState>.value(value: MyState()),
        ],
        child: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _controllerLogin;

  late Animation<double> _doubleAnimationLoginH;
  late Animation<double> _doubleAnimationLoginW;
  late Animation<double> _doubleAnimationLoginR;

  late Animation<double> _doubleAnimationSignUpH;
  late Animation<double> _doubleAnimationSignUpW;
  late Animation<double> _doubleAnimationSignUpR;

  late AnimationController _controllerBall;
  late Animation<double> _doubleAnimationBall1;
  late AnimationController _controllerBall1;

  change(LogSign key) {
    if (_currentKey != key) {
      setState(() => _stackwidgets = _stackwidgets.reversed.toList());
      _currentKey = key;
      if (key == LogSign.login) {
        _controllerLogin.reverse();
      } else {
        _controllerLogin.forward();
      }
    }
  }

  List<Widget> _stackwidgets = [];
  LogSign _currentKey = LogSign.login;

  @override
  void initState() {
    statusSet();
    _controllerLogin = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    super.initState();

    _doubleAnimationSignUpW = Tween<double>(begin: doubleWidth(80), end: doubleWidth(90))
        .animate(CurvedAnimation(parent: _controllerLogin, curve: Curves.linear));
    _doubleAnimationSignUpH = Tween<double>(begin: doubleHeight(54), end: doubleHeight(54))
        .animate(CurvedAnimation(parent: _controllerLogin, curve: Curves.linear));
    _doubleAnimationSignUpR =
        Tween<double>(begin: 5, end: 10).animate(CurvedAnimation(parent: _controllerLogin, curve: Curves.linear));

    _doubleAnimationLoginW = Tween<double>(begin: doubleWidth(90), end: doubleWidth(80))
        .animate(CurvedAnimation(parent: _controllerLogin, curve: Curves.linear));
    _doubleAnimationLoginH = Tween<double>(begin: doubleHeight(46), end: doubleHeight(41))
        .animate(CurvedAnimation(parent: _controllerLogin, curve: Curves.linear));

    _doubleAnimationLoginR =
        Tween<double>(begin: 10, end: 5).animate(CurvedAnimation(parent: _controllerLogin, curve: Curves.linear));

    //------------------------------------------------------------
    _controllerBall = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controllerBall1 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _doubleAnimationBall1 =
        Tween<double>(begin: 1, end: 13).animate(CurvedAnimation(parent: _controllerBall1, curve: Curves.linear));
  }

  int currentIndex = 0;
  goEnd() async {
    _controllerBall.repeat(reverse: true, period: const Duration(seconds: 1));
    final state = Provider.of<MyState>(context);
    if (state.type == LogSign.signUp) {
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(const Duration(seconds: 3));
      state.incrementPage();
      _controllerBall1.forward().then((value) {
        Go.pop(context, false);
      });
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(const Duration(seconds: 3));
      bool condition = false;
      if (condition) {
        _controllerBall.stop();
        setState(() => currentIndex = 1);
        state.decrementPage();
      } else {
        _controllerBall.stop();
        setState(() => currentIndex = 2);
        state.incrementPage();
        _controllerBall1.forward().then((value) {
          Go.pushSlideRightAnim(context, ProviderLogin());
          // Go.pop(context, false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MyState>(context);
    if (state.page == 1) goEnd();
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/background.png'))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: state.page,
          alignment: Alignment.center,
          children: <Widget>[
            Stack(
              children: tebeStack(context),
            ),
            Builder(
              builder: (context) {
                if (_controllerBall.isAnimating) {
                  return SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 150,
                    controller: _controllerBall,
                  );
                }
                return const SizedBox();
              },
            ),
            ScaleTransition(
              scale: _doubleAnimationBall1,
              child: Container(
                width: doubleHeight(10),
                height: doubleHeight(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> tebeStack(context) {
    List<Widget> temp;
    if (_stackwidgets.isEmpty) {
      temp = [
        Align(
          alignment: const Alignment(0, 0),
          child: GestureDetector(
            onTap: () => change(LogSign.signUp),
            child: Material(
              color: Colors.transparent,
              elevation: 30,
              child: MyAnimatedWidget(
                controller: _controllerLogin,
                animations: [_doubleAnimationSignUpW, _doubleAnimationSignUpH, _doubleAnimationSignUpR],
                isLogin: false,
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.6),
          child: GestureDetector(
            onTap: () => change(LogSign.login),
            child: Material(
              color: Colors.transparent,
              elevation: 30,
              child: MyAnimatedWidget(
                controller: _controllerLogin,
                animations: [_doubleAnimationLoginW, _doubleAnimationLoginH, _doubleAnimationLoginR],
                isLogin: true,
              ),
            ),
          ),
        ),
      ];
      _stackwidgets = temp;
      return temp;
    } else {
      return _stackwidgets;
    }
  }
}
