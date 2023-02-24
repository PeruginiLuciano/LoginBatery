
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nav_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final path= "Bateria1";
  late num _voltaje; 
  late num _amperaje;
   bool isLoading = false;
  final databaseReference = FirebaseDatabase.instance.ref();
  late Icon bateria;
  @override
  void initState(){
    
    cargarEstados();
    super.initState();
          
  }  
  // Referencia a la base de datos


  cargarEstados() {
    setState(() {
      databaseReference.child(path).onValue.listen((event ) {
            _voltaje = (event.snapshot.value as Map)["Voltaje"];
           _amperaje = (event.snapshot.value as Map)["Amperaje"];
            isLoading = true;
            setState(() {
              if (_voltaje < 10){
                bateria=Icon(Icons.battery_0_bar_rounded,size: 300,);
              }else{bateria=Icon(Icons.battery_full_rounded,size: 300,);}
            });
          });
            
    });
  }

  @override
  
  Widget build(BuildContext context) {
    
    try{
      print("de nuevo aquie");
      
      return WillPopScope(
        
        onWillPop: ()=> _onBackButtonPress(context), 
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 13, 82, 138),
        
          drawer: NavBar(1),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 7, 63, 11),
            title: Text("Inicio",
                style: TextStyle(fontSize: 20)),
          ),
          body: 
          Center(
            child:isLoading 
            ? Column(
              children: [
                SizedBox(height: 50,),
                Container(
                    width: 200,height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    borderRadius: BorderRadius.circular(25.0),

                    ),
                    child: Center(child: Text(_voltaje.toString()+"  V",style: TextStyle(color: Color.fromARGB(255, 2, 39, 247),fontSize: 45,fontWeight: FontWeight.bold),)),
                  
                  
                ),
                SizedBox(height: 20,),
                Container(
                    width: 200,height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    borderRadius: BorderRadius.circular(25.0),
                  
                    ),
                child: Center(child: Text(_amperaje.toString()+"  A",style: TextStyle(color: Colors.red,fontSize: 45,fontWeight: FontWeight.bold),)),
                ),
                SizedBox(height: 50,),
                 _voltaje< 25 ? Icon( Icons.battery_1_bar,size: 300, color: Color.fromARGB(255, 61, 7, 3),)
                 :_voltaje>50 ? Icon( Icons.battery_full,size: 300,color: Color.fromARGB(255, 1, 1, 24),)
                 : Icon( Icons.battery_charging_full_outlined,size: 300,color:Color.fromARGB(255, 6, 70, 8))
              ],
            )
            : 
            
            Center(
              
              
             child: CircularProgressIndicator()
            ,)
            
          )
          

      )
      );
    
    }catch (e) {
    print(e.runtimeType);
    return WillPopScope(
        
        onWillPop: ()=> _onBackButtonPress(context), 
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 13, 82, 138),
        
          drawer: NavBar(1),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 18, 82, 21),
            title: Text("JAJAJA",
                style: TextStyle(fontSize: 20)),
          ),
          body: 
          Center(child: Text("Error"),)
        ),
    );
  }
  }
  _onBackButtonPress(BuildContext context) async  {
    bool exitApp = await showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: const Text("Cerrar Aplicacion"),
        content: const Text("¿Esta seguro que quiere cerrar la aplicación?"),
        actions:<Widget> [
          TextButton(onPressed:(){Navigator.of(context).pop(false);} , child: const Text("Cancelar")),
          TextButton(onPressed:(){exit(0);} , child: const Text("Si"))
        ],
      );
    });
  
  }
}