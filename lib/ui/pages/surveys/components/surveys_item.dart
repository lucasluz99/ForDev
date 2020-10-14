import 'package:flutter/material.dart';

class SurveyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        
          borderRadius: BorderRadius.all(Radius.circular(12))),
      
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('20 ago 2020',style: TextStyle(color: Colors.white,fontSize: 16),),
        SizedBox(height: 8,),
        Text('Qual seu framework favorito?',style: TextStyle(color: Colors.white,fontSize: 22)),
      ],),
    );
  }
}