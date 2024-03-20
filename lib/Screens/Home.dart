import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List categories=["Filter","Premium","Tamilnadu","None"];
  String val='Filter';
  List Controllers=[];
  List TotalItems=[];
  List colors=[Colors.cyanAccent,const Color.fromARGB(255, 235, 108, 150),Color.fromARGB(255, 245, 222, 8),const Color.fromARGB(255, 171, 28, 18)];
  @override
  void initState() {
    for(int i=0;i<4;i++){
      var s=TextEditingController();
      s.text='0';
    Controllers.add(s);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(title:Text("Online Shopping App"),
      backgroundColor:Colors.blue,
      actions: [Container(color:Colors.white54,height:40,
        child: Padding(
          padding: const EdgeInsets.only(right:5.0,left:5),
          child: DropdownButton(
          hint:Text(val),
          
          items:[for(String i in categories)
          DropdownMenuItem(child:Text(i),value:i,)], onChanged:(item){
            setState(() {
              val = item.toString();
            });
          }),
        ),
      )],)
      ,body:FutureBuilder(future:getdetails(), 
      builder:(BuildContext,dt){
      if(dt.connectionState==ConnectionState.done){
        
        TotalItems=dt.data;
        
        var s=Filter(dt.data,val);  
       return AnimationLimiter(
         child: ListView.builder(itemCount:s.length,
         itemBuilder:(BuildContext,index){
            return AnimationConfiguration.staggeredList(
              position: index,
          duration: const Duration(milliseconds:100),
              child: SlideAnimation(
              delay: Duration(milliseconds:100),
                verticalOffset: 1000.0,
                child: FlipAnimation(duration: Duration(milliseconds:2500),
                delay:Duration(milliseconds:10) ,
                  child: Card(color:colors[index],child:Padding(padding:EdgeInsets.all(10),
                  child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [details('Product_Name : ',s[index]['p_name']),
                       details("Product_Id : ",s[index]['p_id'].toString()),
                      details('Product_Cost : ',s[index]['p_cost'].toString()),
                      details("Product_Category : ",s[index]['p_category']),
                      details("Products_Available : ",s[index]['p_availability'].toString())
                      ],),
                       SizedBox(width:50,height:25,
                      child: TextField(
                        controller:Controllers[s[index]['p_id']-1],
                        keyboardType:TextInputType.number,
                        decoration:InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                   ],
                  ),)),
                ),
              ),
            );
          }   
           ),
       );
      }
      else{
        return Center(child: CircularProgressIndicator());
      }}  
      ),
      floatingActionButton:FloatingActionButton.extended(onPressed: (){
        setState(() {
          getvalues(Controllers);
        });
        return dialog();
      },
       label:Text('Submit'),),
    );
  }
  Widget details(String txt,String name){
    return Padding(
      padding: const EdgeInsets.only(top:8.0,bottom:8),
      child: Row(children: [Text(txt),Text(name)],),
    );
  }
   dialog(){
    return showDialog(context: context, builder:(BuildContext){
      return AnimationConfiguration.staggeredList(
        position:5,
        child: SlideAnimation(
          child: ScaleAnimation(duration:Duration(milliseconds:1000),
        curve:Curves.easeInOut,
            child: AlertDialog(
              content:Container(color:Colors.pink,height:500,child:SingleChildScrollView(
              child:
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(TotalItems.toString(),style:TextStyle(fontSize:18),),
              ),
            ))),
          ),
        ),
      );
    });
  }
  Filter(var list,String val){
    var s=[];
   for(int i=0;i<list.length;i++){
    if(val==list[i]['p_category']){
     s.add(list[i]);
    }
    else if(val.trim()=='Filter'){
    
      s.add(list[i]);
    }
    else if(val=='None' && list[i]['p_category']==''){
      s.add(list[i]);
    }
   }
    
    return s;
   
  }
  Future getdetails() async{
     return rootBundle.loadString('Data/data.json')
        .then((jsonStr) => jsonDecode(jsonStr));
  
}
getvalues(List con){
  print(Controllers.length);
for(int i=0;i<Controllers.length;i++){
TotalItems[i]['Quantity']=Controllers[TotalItems[i]['p_id']-1].text;
}
print(TotalItems);

}
}