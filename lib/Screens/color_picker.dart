import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:to_do_app/Screens/add_list.dart';
import 'package:to_do_app/global.dart';

class colorPicker extends StatefulWidget {
  final ValueChanged<int> update;

  const colorPicker({Key? key,required this.update}) : super(key: key);

  @override
  _colorPickerState createState() => _colorPickerState();


}

class _colorPickerState extends State<colorPicker> {
  int cc = Colors.blue.value;



  final List<Map> myProducts=[
    {

      "color": (Color(0xffffffff).value).toString()
    },
    {

      "color": (Color(0xffbc3efa).value).toString()
    },
    {

      "color": (Color(0xfffd6565).value).toString()
    },
    {

      "color": (Color(0xffff4343).value).toString()
    },
    {

      "color": (Color(0xffe82121).value).toString()
    },
    {

      "color":(Color(0xff7f72fa).value).toString()
    },
    {

        "color":(Color(0xff5043fa).value).toString()
    },
    {

      "color":(Color(Colors.blue.value).value).toString()
    },
    {

      "color":(Color(0xff3227b8).value).toString()
    },
    {

      "color":(Color(0xfffac767).value).toString()
    },
    {

      "color":(Color(0xfffcba3e).value).toString()
    },
    {

      "color":(Color(0xffc48a28).value).toString()
    },

  ];

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Container(
        child: Column(
          children: [
            Container(
              height: height * 0.07,
              color: backGoundColor.withOpacity(0.8),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){index = 0;widget.update(1);},
                      child: Row(
                        children: [
                          Padding(padding:EdgeInsets.only(left: 10,top: 8,bottom: 10,),child: Icon(Icons.arrow_back_ios_outlined,color: TileColor,size: 22.0,)),
                          Text("Event",style: TextStyle(color: TileColor,fontSize: 16),)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                          Center(child: Text("Color",style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 17.0,fontWeight: FontWeight.bold),))
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),

            //Colors generator


            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: height*0.04),
                child: GridView.builder(
                  itemCount: myProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(


                      crossAxisSpacing: 20,
                      crossAxisCount: 3),

                  itemBuilder: (BuildContext context, int index) {
                   Color color = Color(int.parse(myProducts[index]['color']));
                    return Padding(
                      padding: EdgeInsets.all(height*0.02),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            colorSecetedIndex = index;
                            ChoosentileColor = color;
                            debugPrint("Kashif"+index.toString());
                            widget.update(1);
                            //widget.update(2);
                          });
                        },
                        child: Container(
                          height: height*0.085,
                          width: height*0.085,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color:(index == colorSecetedIndex)?color.withOpacity(0.5):color
                          ),
                          child:  Center(
                            child: Container(
                              height: height*0.068,
                              width: height*0.068,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color:color
                              ),
                              child: (index == 0)?Center(child: Text("X",style: TextStyle(fontSize: 40.0,color: Colors.grey.withOpacity(0.5)),)):Text(" "),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),



          ],
        ),

      ),
    );
  }
}
