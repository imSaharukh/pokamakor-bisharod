import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model.dart';

class DetailsPage extends StatelessWidget {
  final File imagePath;
  final String lable;
  final DataModel dataModel;
  final num confidence;

  const DetailsPage(this.imagePath, this.lable, this.dataModel, this.confidence,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'পোকা মাকড় বিশারদ',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
      ),
      body: Container(
        // color: Color.fromRGBO(68, 190, 255, 0.8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color(0xffD8DBD2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.file(
                imagePath,
                fit: BoxFit.fitWidth,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Text((confidence * 100).toStringAsFixed(2).toString() + "%",
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              //stylish text
              Divider(),

              Text("রোগের নাম",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              //replace all number with bangla number
              Text(
                dataModel.name
                    .replaceAll(RegExp(r"[0-9]"), "")
                    .replaceAll("-", ""),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              Divider(),
              Divider(),
              Text("উপসর্গ",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Text(dataModel.simtom,
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              Divider(),
              Divider(),
              Text("জৈব নিয়ন্ত্রণ",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Text(dataModel.joiboniyantron,
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              Divider(),
              Divider(),
              Text("রাসায়নিক নিয়ন্ত্রণ",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Text(dataModel.rasioniknyontron,
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              Divider(),
              Divider(),
              Text("প্রতিরোধমূলক ব্যবস্থা",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Text(dataModel.bebostha,
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
