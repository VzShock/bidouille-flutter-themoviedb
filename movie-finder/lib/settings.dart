import 'package:dashboard_tmp/widgets/custom_app_bar.dart';
import 'package:dashboard_tmp/widgets/pop_snackbar.dart';
import 'package:flutter/material.dart';

class MySettingsPage extends StatefulWidget {
  MySettingsPage({Key? key}) : super(key: key);

  @override
  _MySettingsPage createState() => _MySettingsPage();
}

class _MySettingsPage extends State<MySettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: [
            const GradientAppBar('The Movie Finder', true),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Spacer(),
              Center(
                child: FittedBox(
                    child: ElevatedButton(
                  child: Text(
                    "DELETE ACCOUNT",
                    style: TextStyle(fontSize: 40),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.disabled)) {
                            return 0;
                          }
                          return 10;
                        },
                      )),
                  onPressed: () {
                    popSnackBar(context, "Deleting account...", Colors.red);
                    print("DELETING ACCOUNT");
                  },
                )),
              ),
              SizedBox(height: 40)
            ],
          ),
        ),
      ],
    ));
  }
}
