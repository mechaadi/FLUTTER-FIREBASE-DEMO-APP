import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Productlist extends StatelessWidget {


  List timeHistoryBubbles = [
  {"code": "3M", "name": "3 Months"},
  {"code": "6M", "name": "6 Months"},
  {"code": "1y", "name": "1 Year"},
  {"code": "2y", "name": "2 Years"},
];

String timeBubble = "3M";


@override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return new Scaffold(
      appBar: AppBar(
          title: const Text('AppBar'),
      ),

      body : SlidingUpPanel(
        maxHeight: 400,
      borderRadius: radius,
      panel: Center(
        child:
        SingleChildScrollView(
          physics: ScrollPhysics(parent: PageScrollPhysics()),
          child: Padding(child:Column(
            children: <Widget>[
              // true ?   Text(
              //        timeHistoryBubbles.firstWhere((timeBubblez) => timeBubble == timeBubblez["code"]), style: TextStyle(color: Colors.black),
              //       ) : Text("LODA"),
            

           Text("Avocado", style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 10.0),
                        Text("\$1.80 / Kg", style: TextStyle(
                            fontSize: 16.0
                        ),),
                        Row(
                          children: <Widget>[
                            Text("100 gms for 1-2 pieces", style: TextStyle(
                                color: Colors.grey.shade700
                            ),),
                            Spacer(),
                            Icon(Icons.camera_enhance, size: 14.0, color: Colors.pink.shade300,),
                            Text("160"),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Slider(
                          onChanged: (value){},
                          min: 1,
                          max: 5,
                          value: 1.5,
 
                        ),
                        Row(
                          children: <Widget>[
                            Text("1.5 kg (12-14 pieces approx.)", style: TextStyle(
                                color: Colors.grey.shade700
                            )),
                            Spacer(),
                            Text("\$ 2.70", style: TextStyle(
                                fontSize: 16.0
                            ),),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(width: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                              color: Colors.pink.shade200,
                              textColor: Colors.white,
                              child: Text("Add to Cart"),
                              onPressed: (){},
                            )
                        ),
                        SizedBox(height: 10.0),
                        Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),
                        Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),
                        Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),

                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),

                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),

                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),
                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),
                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),
                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),
                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),
                         Center(child: Icon(Icons.keyboard_arrow_up)),
                        Center(child: Text("Know More", style: TextStyle(
                            color: Colors.pink.shade300
                        ),),),

         
        ],), padding: EdgeInsets.all(20),)),
      ),
      body: Center(
        child: Column(children: <Widget>[
         Container(
            height: MediaQuery.of(context).size.height / 2.6,
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/a7atestdatabase.appspot.com/o/postImages%2Flion.jpg?alt=media&token=155b1e3b-de4e-4bfc-afd8-b7f029e1c360"),fit: BoxFit.cover)
            ),
          ),

        ],),
      ),
    ),
  );
  
  
  }
}

