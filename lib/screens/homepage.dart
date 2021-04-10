import 'package:flutter/material.dart';
import 'package:flutter_app/database_helper.dart';
import 'package:flutter_app/screens/taskpage.dart';
import 'package:flutter_app/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  var seconds;

  _getSystemTime() {
    DateTime now = new DateTime.now();
    if (DateTime.now().second < 10) {
      return '${DateTime.now().hour} : ${DateTime.now().minute} : 0${DateTime.now().second}';
    } else if (DateTime.now().minute < 10) {
      return '${DateTime.now().hour} : 0${DateTime.now().minute} : ${DateTime.now().second}';
    } else if (DateTime.now().hour < 10) {
      return '0${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}';
    }
    return '${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}';
  }

  _getSystemDate() {
    DateTime date = new DateTime.now();
    return '${DateTime.now().day} / ${DateTime.now().month.toString()} / ${DateTime.now().year}';
  }

  _getSystemDay() {
    DateTime date = new DateTime.now();
    var day = DateTime.now().weekday;
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
    }
  }

  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => setState(
              () {
                seconds = DateTime.now().second / 60;
              },
            ));
  }

  @override
  void initState() {
    super.initState();
    seconds = DateTime.now().second / 60;
    _triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image(
                              image: AssetImage('assets/images/logo.png'),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              'Saa Re Kaam',
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          _getSystemTime(),
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          _getSystemDate(),
                        ),
                        Text(
                          _getSystemDay(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Taskpage(
                                        task: snapshot.data[index],
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(
                                task: null,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image(
                      image: AssetImage(
                        "assets/images/add_icon.png",
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
