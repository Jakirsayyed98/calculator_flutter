import 'package:flutter/material.dart';
import 'calculatorassets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String number1=""; //0-9
  String operand=""; // +,-,*,/
  String number2="";//0-9


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        bottom: false,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Output Widget

            SingleChildScrollView(
              reverse: true,
              child: Container(
                padding: EdgeInsets.all(10),
                  alignment: Alignment.bottomRight,
                  child: Text("$number1$operand$number2".isEmpty?"0":"$number1$operand$number2",style: TextStyle(color: Colors.white,fontSize: 48,fontWeight: FontWeight.bold),textAlign: TextAlign.end,)),
            ),

            // Button Widget
            Wrap(
              children: Btns.calculatorBtns.map((values)=>SizedBox(
                  height:screenSize.width/5 ,
                  width: values==Btns.n0? screenSize.width/2:screenSize.width/4,
                  child: BuildButton(values)),).toList(),
            )
          ],
        ),
      ),
    );
  }


  Widget BuildButton(String value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color:getButtonColor(value),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: BorderSide(color: Colors.white24)),
        child: InkWell(
            onTap: () {
                ClickOnBtn(value);
            },
            child: Center(child: Text(value,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),))),
      ),
    );
  }


  void ClickOnBtn(String value){

    if(value==Btns.del){
      deleteNum();
      return;
    }else if(value==Btns.cls){
      clearAll();
      return;
    }else if(value==Btns.per){
      percentageCalculate();
      return;
    } else if (value == Btns.calculate){

      calculateValues();
      return;
    }

    append(value);

  }

  void calculateValues(){
    if(number1.isEmpty) return;
    if(operand.isEmpty) return;
    if(number2.isEmpty) return;
    double num1= double.parse(number1);
    double num2= double.parse(number2);

    double result = 0.0;
    switch (operand){
      case Btns.add:{
        result = num1+num2;
        break;
      }
      case Btns.subtract:{
        result = num1-num2;
        break;
      }
      case Btns.multiply:{
        result = num1*num2;
        break;
      }
      case Btns.divide:{
        result = num1/num2;
        break;
      }
      default:;
    }

    setState(() {
      number1 = "$result";

      if(number1.endsWith(".0")){
        number1 = number1.substring(0,number1.length-2);
      }
      operand="";
      number2="";

    });
  }

  void percentageCalculate(){
    if(number1.isNotEmpty && number2.isNotEmpty && operand.isNotEmpty){
      calculateValues();
    }

    if(operand.isNotEmpty){
      return;
    }

    final number = double.parse(number1)/100;
    number1 ="$number";
    operand="";
    number2="";
    setState(() {

    });

  }
  void clearAll(){
    number1="";
    number2="";
    operand="";
    setState(() {

    });
  }

  void deleteNum(){
    if(number2.isNotEmpty){
      number2 = number2.substring(0,number2.length-1);
    }else if(operand.isNotEmpty){
      operand = "";
    }else  if(number1.isNotEmpty){
      number1 = number1.substring(0,number1.length-1);
    }

    setState(() {

    });
  }

  void append(String value){

    if(value!=Btns.dot && int.tryParse(value)==null){

      if(operand.isNotEmpty && number2.isNotEmpty){
        calculateValues();
      }

      operand=value;
    } else if(number1.isEmpty || operand.isEmpty){

      if(value==Btns.dot && number1.contains(Btns.dot)){
        return;
      }
      if(value==Btns.dot &&( number1.isEmpty || number1==Btns.n0)){
        value = "0.";
      }
      number1 +=value;

    }else if(number2.isEmpty || operand.isNotEmpty){

      if(value==Btns.dot && number2.contains(Btns.dot)){
        return;
      }
      if(value==Btns.dot &&( number2.isEmpty || number2==Btns.n0)){
        value = "0.";
      }
      number2 +=value;

    }

    setState(() {

    });

  }

  Color getButtonColor(String value){
    return  [Btns.del,Btns.cls].contains(value)?Colors.blueGrey:[Btns.per,Btns.multiply,Btns.divide,Btns.subtract,Btns.add,Btns.calculate].contains(value)?Colors.orange:Colors.black87;
  }
}
