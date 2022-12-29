import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'details.dart';
import 'model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera

  @override
  void initState() {
    //initS is the first function that is executed by default when this class is called
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults:
          5, //the amout of categories our neural network can predict (here no. of animals)
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (output == null || output.isEmpty) {
      //show error in sn
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('কোন ফলাফল পাওয়া যায়নি'),
        ),
      );
      return;
    }
    setState(() {
      _output = output!;
      _loading = false;
    });
    log(output.toString());
  }

  loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<DataModel> getData() async {
    var data = await rootBundle.loadString("assets/csvjson.json");
    var dataModel = dataModelFromJson(data);
    return dataModel.elementAt(_output[0]['index']);
  }

  pickImage() async {
    //this function to grab the image from camera
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    await classifyImage(_image);
    var data = await getData();
    //push to details page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
            _image, _output[0]['label'], data, _output[0]['confidence']),
      ),
    );
  }

  pickGalleryImage() async {
    //this function to grab the image from gallery
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    await classifyImage(_image);
    //push to details page
    var data = await getData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
            _image, _output[0]['label'], data, _output[0]['confidence']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          //png image
          IconButton(
            icon: Image.asset(
              'assets/ju.png',
              height: 30,
              width: 30,
            ),
            onPressed: () {},
          ),
        ],
        title: Text(
          'পোকা মাকড় বিশারদ',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
          child: Column(
            children: [
              Container(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Color(0xffD8DBD2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Center(
                          child: _loading == true
                              ? null //show nothing if no picture selected
                              : Container(),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset("assets/ss.png"),
                            GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                // width: MediaQuery.of(context).size.width - 200,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 17),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'ছবি তুলুন করুন',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: pickGalleryImage,
                              child: Container(
                                // width: MediaQuery.of(context).size.width - 200,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 17),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'গ্যালারি থেকে ছবি নির্বাচন করুন',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  //open url
                  launch(
                      'https://www.accuweather.com/en/bd/dhaka/28143/weather-forecast/28143');
                },
                child: Container(
                  width: 600,
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
                  decoration: BoxDecoration(
                    color: Color(0xffBE9EDF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text('ঢাকা \n30 ডিগ্রি সেন্টিগ্রেড',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  //open url
                  launch(
                      'http://www.bmda.gov.bd/site/page/dbd79668-bd37-4e84-a396-b599bc0b040b/%E0%A6%AA%E0%A7%8D%E0%A6%B0%E0%A6%B6%E0%A6%BF%E0%A6%95%E0%A7%8D%E0%A6%B7%E0%A6%A8-%E0%A6%93-%E0%A6%9A%E0%A6%BE%E0%A6%B7%E0%A6%BE%E0%A6%AC%E0%A6%BE%E0%A6%A6-%E0%A6%B8%E0%A6%82%E0%A6%95%E0%A7%8D%E0%A6%B0%E0%A6%BE%E0%A6%A8%E0%A7%8D%E0%A6%A4-%E0%A6%AE%E0%A7%8D%E0%A6%AF%E0%A6%BE%E0%A6%A8%E0%A7%81%E0%A7%9F%E0%A6%BE%E0%A6%B2');
                },
                child: Container(
                  width: 600,
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
                  decoration: BoxDecoration(
                    color: Color(0xffBE9EDF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Text('চাষাবাদ সম্পর্কিত সকল তথ্য এখানে পাবেন',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
