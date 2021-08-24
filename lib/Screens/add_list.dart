import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:to_do_app/Screens/color_picker.dart';
import 'package:to_do_app/global.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/utils/database_handler.dart';
import 'package:to_do_app/utils/sql_Data.dart';



class AddToDo extends StatefulWidget {
  ValueChanged<int> update;
  //int index = 0;
  AddToDo({Key? key, required this.update}) : super(key: key);

  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  Color titleColor = Colors.white;
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _contentController =
  new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();
  late database_handler handler;

  @override
  void initState() {
    super.initState();
    this.handler = database_handler();
  }


  DateTime minDateTime = DateTime.now();
  DateTime dateTime = DateTime.now();
  Duration duration = Duration(hours: 1, minutes: 6);
  DateTime times = DateTime.now();

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));

    return '$hours:$minutes';
  }


  bool _reminderController = false;

  Future<bool> _onWillPop() async {
    if (index > 0) {
      index = 0;
      resetfun();
      return false;
    } else {
      return true;
    }
  }

  List? pages;
  int x = 0;

  void resetfun() {
    setState(() {
      x = 1;
    });
  }

  void _update(int n) {
    setState(() {
      x = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    pages = [AddPage(), colorPicker(update: _update)];
    return WillPopScope(child: pages![index], onWillPop: _onWillPop);
  }

  Widget AddPage() {

    return Material(
      child: Container(
        color: Colors.grey.shade200,
        height: height,
        child: Column(
          children: [
            Container(
              height: height * 0.07,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.white,

              //Navigation Buttons For Add Screen
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(11.0),
                        child: InkWell(
                          onTap: () {
                            setDefault();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.blue.shade700, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Text(
                          "Event",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(13.0),
                        child: InkWell(
                          onTap: () {
                            if(_formKey.currentState!.validate()){
                              this.handler.initializeDB()
                                  .whenComplete(() async {
                                await this.addNewList();
                                setState(() {
                                  setDefault();
                                  Navigator.pop(context);
                                });
                              });

                            }
                            else {

                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: [

                    //Title TexField
                    Container(
                      margin:
                      EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
                      height: height * 0.07,
                      decoration: BoxDecoration(
                          color: titleColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _titleController,
                          cursorColor: ChoosentileColor.withOpacity(0.5),
                          style: TextStyle(
                              fontSize: 20.0,
                              letterSpacing: 2,
                              color: Colors.black,
                              fontWeight: FontWeight.bold

                          ),
                          validator: (val) {
                            if (val!.length == 0) {

                              setState(() {
                                titleColor = Colors.red.withOpacity(0.5);
                              });
                              return "this field in mandetory";
                            } else {
                              return null;
                            }
                          },
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Title!",
                            hintStyle: TextStyle(
                                fontSize: 20.0,
                                letterSpacing: 2,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    //Content Field
                    Container(
                      margin:
                      EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
                      height: height * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                      child: TextField(

                          controller: _contentController,
                          cursorColor: ChoosentileColor.withOpacity(0.5),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Type Here"),
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.black54)),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 1;
                          resetfun();
                        });
                      },
                      child: Container(
                        margin:
                        EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
                        height: height * 0.08,
                        decoration: BoxDecoration(
                            color: ChoosentileColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0))),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Color",
                                      style: TextStyle(
                                          color:
                                          (ChoosentileColor == Colors.white)
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 17.0),
                                    ))),
                            Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.withOpacity(0.7),
                                      size: 20.0,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),


                    //Day and time Setter
                    Container(
                      margin:
                      EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
                      height: height * 0.144,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        children: [
                          //Day Selector
                          InkWell(
                              onTap: () {
                                _showDayPicker();
                              },
                              child: ListTile(
                                title: Text("Day", style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17.0),),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Text("${dateTime.day}/${dateTime
                                          .month}/${dateTime.year}",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15.0),),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.withOpacity(0.7),
                                      size: 20.0,
                                    ),
                                  ],
                                ),

                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Divider(
                                height: 0.0,
                                thickness: 1,
                              )),

                          //Time selector
                          InkWell(
                              onTap: () {
                                _showTimePicker();
                              },
                              child: ListTile(
                                title: Text("Time", style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17.0),),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Text("${(times.hour > 12)
                                        ? times.hour - 12
                                        : times.hour}:${(times.minute < 10)
                                        ? "0" + (times.minute).toString()
                                        : times.minute}", style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15.0),),

                                    Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Text(
                                          " ${(times.hour > 11) ? "PM" : "AM"}",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          )),
                                    ),

                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.withOpacity(0.7),
                                      size: 20.0,
                                    ),
                                  ],
                                ),


                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
                      height: height * 0.07,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                      child:
                      Container(
                        child: ListTile(
                          title: const Text(
                            "Reminder",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17.0),
                          ),
                          trailing: CupertinoSwitch(
                            activeColor: (ChoosentileColor == Colors.white)
                                ? Colors.green
                                : ChoosentileColor,
                            value: _reminderController,
                            onChanged: (bool value) {
                              setState(() {
                                _reminderController = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _reminderController = !_reminderController;
                            });
                          },
                        ),

                      ),


                    ),


                    Container(
                      height: height * 0.1,

                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDayPicker() async {
    return showCupertinoModalPopup(
        context: context, builder: (BuildContext context) =>
        CupertinoActionSheet(
          title: Text("Select Day", style: TextStyle(fontSize: 20.0),),
          actions: [
            CupertinoActionSheetAction(onPressed: () {}, child: SizedBox(
              height: height * 0.2,
              child: CupertinoDatePicker(
                minimumDate: minDateTime,
                maximumYear: 2025,
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (dateTime) =>
                    setState(() => this.dateTime = dateTime),
              ),
            ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Done", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ));
  }

  Future<void> _showTimePicker() async {
    return showCupertinoModalPopup(
        context: context, builder: (BuildContext context) =>
        CupertinoActionSheet(
          title: Text("Select Time", style: TextStyle(fontSize: 20.0),),
          actions: [
            CupertinoActionSheetAction(onPressed: () {}, child: SizedBox(
                height: height * 0.2,
                child: TimePickerSpinner(
                  is24HourMode: false,
                  normalTextStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black45
                  ),
                  highlightedTextStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black87
                  ),
                  spacing: 10,
                  itemHeight: 50,
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    setState(() {
                      times = time;
                    });
                  },
                )
            )
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Done", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ));
  }

  Future<int> addNewList() async {

      String Titletext = this._titleController.text;
      String str = Titletext[0].toUpperCase();
      Titletext = Titletext.substring(1);
      Titletext = str+Titletext;

      ToDoListData addList = ToDoListData(title: Titletext,
          content: this._contentController.text,
          colorData: (ChoosentileColor.value).toString(),
          day: dateTime.day,
          month: dateTime.month,
          year: dateTime.year,
          hour: times.hour,
          minute: times.minute,
          reminder: (this._reminderController) ? 1 : 0,
          colorIndex: colorSecetedIndex);
      List<ToDoListData> DataToAddInList = [addList];
      widget.update(1);
      return await this.handler.insertList(DataToAddInList);

  }

  setDefault(){
    ChoosentileColor = Colors.blue;
    colorSecetedIndex = 0;
  }
}


