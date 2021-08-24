import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:to_do_app/Screens/add_list.dart';
import 'package:to_do_app/Screens/color_picker.dart';
import 'package:to_do_app/Screens/edit_list.dart';
import 'package:to_do_app/global.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_app/utils/database_handler.dart';
import 'package:to_do_app/utils/sql_Data.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
                builder: (_) => MyHomePage(), settings: settings);
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late database_handler handler = database_handler();

  int x = 0;

  void _update(int n) {
    setState(() {
      x = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          title: Center(
            child: Text(
              "Todo List",
              style: TextStyle(color: Colors.black),
            ),
          ),
          leading: Icon(Icons.icecream_outlined),
          backgroundColor: bodyColor,
          actions: [
            InkWell(
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                    size: 30.0,
                  )),
              onTap: () {
                openSheet();
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: this.handler.retrieveTODO_Data(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ToDoListData>> snapshot) {
            if (handler.count == 0) {
              return Center(
                child: Container(
                  height: height,
                  child: Column(
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Icon(
                                CupertinoIcons.add_circled_solid,
                                size: 50.0,
                                color: Colors.black.withOpacity(0.3),
                              ))),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Tap (+) to add first TO-DO list",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.3),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),

                              )))
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  int tileColor = int.parse(snapshot.data![index].colorData);
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(snapshot.data![index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await this.handler.deleteList(snapshot.data![index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Padding(
                      padding: (index < 1)
                          ? EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0)
                          : EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                      child: ClipRRect(
                        //borderRadius: BorderRadius.circular(20.0),
                        // height: height*0.25,
                        //   margin: (index<1)?EdgeInsets.only(top: 30.0,left: 15.0,right: 15.0):EdgeInsets.only(top: 20.0,left: 15.0,right: 15.0),
                        //   decoration: BoxDecoration(
                        //       borderRadius:
                        //       BorderRadius.all(Radius.circular(30.0))),
                        child: SizedBox(
                          height: height * 0.25,
                          child: Stack(
                            children: [
                              Container(
                                color: Color(tileColor).withOpacity(0.5),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: height * 0.04, bottom: 15.0),
                                  child: ListView(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.025,
                                              left: 8,
                                              right: 8,
                                              bottom: 8),
                                          child: Text(
                                              snapshot.data![index].content,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black
                                                      .withOpacity(0.8))))
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: InkWell(
                                  onTap: () {
                                      showCupertinoModalBottomSheet(
                                          context: context, builder: (context) {
                                        return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState)
                                        =>
                                            EditTOTOList(
                                                id: snapshot.data![index].id,
                                                update: _update,
                                                title: snapshot.data![index]
                                                    .title,
                                                content: snapshot.data![index]
                                                    .content,
                                                colorData: snapshot.data![index].colorData,
                                                day: snapshot.data![index].day,
                                                month: snapshot.data![index].month,
                                                year: snapshot.data![index].year,
                                                hour: snapshot.data![index].hour,
                                                minute: snapshot.data![index].minute,
                                                reminder: snapshot.data![index].minute,
                                            colorIndex: snapshot.data![index].colorIndex,)
                                        );
                                      });

                                  },
                                  child: Container(
                                    height: height * 0.06,
                                    color: Color(tileColor).withOpacity(0.7),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding:
                                              EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                  snapshot.data![index].title,
                                                  style: TextStyle(
                                                      fontSize: 22.0,
                                                      letterSpacing: 1.5,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: (tileColor ==
                                                          Colors.white)
                                                          ? Colors.black
                                                          .withOpacity(0.8)
                                                          : Colors.white
                                                          .withOpacity(
                                                          0.7)))),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 15.0),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                    Alignment.bottomRight,
                                                    child: Text(
                                                        (snapshot.data![index]
                                                            .day)
                                                            .toString() +
                                                            "/" +
                                                            (snapshot
                                                                .data![index]
                                                                .month)
                                                                .toString() +
                                                            "/" +
                                                            (snapshot
                                                                .data![index]
                                                                .year)
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            letterSpacing: 1.5,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: (tileColor ==
                                                                Colors.white)
                                                                ? Colors.black
                                                                .withOpacity(
                                                                0.8)
                                                                : Colors.white
                                                                .withOpacity(
                                                                0.7))),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment
                                                        .topRight,
                                                    child: Row(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: [
                                                          Text("${(snapshot
                                                              .data![index]
                                                              .hour > 12)
                                                              ? snapshot
                                                              .data![index]
                                                              .hour - 12
                                                              : snapshot
                                                              .data![index]
                                                              .hour}:${(snapshot
                                                              .data![index]
                                                              .minute < 10)
                                                              ? "0" + (snapshot
                                                              .data![index]
                                                              .minute)
                                                              .toString()
                                                              : snapshot
                                                              .data![index]
                                                              .minute}",
                                                              style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  letterSpacing:
                                                                  1.5,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  color: (tileColor ==
                                                                      Colors
                                                                          .white)
                                                                      ? Colors
                                                                      .black
                                                                      .withOpacity(
                                                                      0.8)
                                                                      : Colors
                                                                      .white
                                                                      .withOpacity(
                                                                      0.7))),
                                                          Text(" ${(snapshot
                                                              .data![index]
                                                              .hour > 11)
                                                              ? "PM"
                                                              : "AM"}",
                                                              style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  letterSpacing:
                                                                  1.5,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  color: (tileColor ==
                                                                      Colors
                                                                          .white)
                                                                      ? Colors
                                                                      .black
                                                                      .withOpacity(
                                                                      0.8)
                                                                      : Colors
                                                                      .white
                                                                      .withOpacity(
                                                                      0.7))),
                                                        ]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //     ListTile(
                        //   contentPadding: EdgeInsets.all(8.0),
                        //   title: Text(snapshot.data![index].title),
                        //   subtitle: Text(snapshot.data![index].content),
                        // )
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Container(
                  child: Text("demo"),
                ),
              );
            }
          },
        ));
  }

  void openSheet() async {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                AddToDo(
                  update: _update,
                ),
          );
        });
  }


}
