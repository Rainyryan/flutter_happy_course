import 'package:flutter/material.dart';

import 'rest.dart';
import 'rest_card.dart';
import 'rest_model.dart';

import 'dart:io';
import './speech/flutter_tts.dart';
import './speech/generated_plugin_registrant.dart';
import './speech/socket_stt.dart';
import './speech/socket_tts.dart';
import './speech/sound_player.dart';
import './speech/sound_recorder.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String? selectedCategory = 'taipei';
  String searchString = '';

  final recorder = SoundRecorder();

  TextEditingController taiwaneseController = TextEditingController();
  TextEditingController chineseController = TextEditingController();
  TextEditingController recognitionController = TextEditingController();


  // Use to choose language of speech recognition
  String recognitionLanguage = "Taiwanese";

  @override
  void initState(){
    super.initState();
    recorder.init();
  }

  @override
  void dispose(){
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('成大附近的餐廳', style: TextStyle(fontSize: 30)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite');
              },
              icon: const Icon(Icons.favorite),
            ),
          ]),
      body: Column(
        children: [
          //  Placeholder(fallbackHeight: 30),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  DropdownButton(
                    value: selectedCategory,
                    onChanged: (String? newCategory) {
                      setState(() {
                        selectedCategory = newCategory;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'taipei',
                        child: Text(
                          'Taipei',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'chiayi',
                        child: Text(
                          'Chiayi',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'hwalian',
                        child: Text(
                          'Hwalian',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'tainan',
                        child: Text(
                          'Tainan',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Bangkok',
                        child: Text(
                          'Bangkok',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          FutureBuilder(
              future: RestModel.getRest(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final restaurants = snapshot.data as List<Rest>;
                  return Expanded(
                      child: ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          return RestCard(
                            imagePath: restaurants.elementAt(index).imagePath,
                            title: restaurants.elementAt(index).title,
                            plot: restaurants.elementAt(index).title,
                          );
                        },
                      ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }

  // build the button of recorder
  Widget buildRecord() {
    // whether is recording
    final isRecording = recorder.isRecording;
    // if recording => icon is Icons.stop
    // else => icon is Icons.mic
    final icon = isRecording ? Icons.stop : Icons.mic;
    // if recording => color of button is red
    // else => color of button is white
    final primary = isRecording ? Colors.red : Colors.white;
    // if recording => text in button is STOP
    // else => text in button is START
    final text = isRecording ? 'STOP' : 'START';
    // if recording => text in button is white
    // else => color of button is black
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(175, 50),
        primary: primary,
        onPrimary: onPrimary,
      ),
      icon: Icon(icon),
      label: Text(
        text,
        // 設定字體大小及字體粗細（bold粗體，normal正常體）
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      // 當 Iicon 被點擊時執行的動作
      onPressed: () async {
        // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
        Directory tempDir = await path_provider.getTemporaryDirectory();
        // define file directory
        String path = '${tempDir.path}/SpeechRecognition.wav';
        // 控制開始錄音或停止錄音
        await recorder.toggleRecording(path);
        // When stop recording, pass wave file to socket
        if (!recorder.isRecording) {
          if (recognitionLanguage == "Taiwanese") {
            // if recognitionLanguage == "Taiwanese" => use Minnan model
            // setTxt is call back function
            // parameter: wav file path, call back function, model
            await Speech2Text().connect(path, setTxt, "Minnan");
            // glSocket.listen(dataHandler, cancelOnError: false);
          } else {
            // if recognitionLanguage == "Chinese" => use MTK_ch model
            await Speech2Text().connect(path, setTxt, "MTK_ch");
          }
        }
        // set state is recording or stop
        setState(() {
          recorder.isRecording;
        });
      },
    );
  }

  // set recognitionController.text function
  void setTxt(taiTxt) {
    setState(() {
      recognitionController.text = taiTxt;
    });
  }

  Widget buildOutputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: recognitionController, // 設定 controller
        enabled: false, // 設定不能接受輸入
        decoration: const InputDecoration(
          fillColor: Colors.white, // 背景顏色，必須結合filled: true,才有效
          filled: true, // 重點，必須設定為true，fillColor才有效
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // 設定邊框圓角弧度
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadio() {
    return Row(children: <Widget>[
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          value: 'Taiwanese',
          // Set option name、color
          title: const Text(
            'Taiwanese',
            style: TextStyle(color: Colors.white),
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: recognitionLanguage,
          // 設定選種顏色
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              // 將 recognitionLanguage 設為 Taiwanese
              recognitionLanguage = "Taiwanese";
            });
          },
        ),
      ),
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          value: 'Chinese',
          // Set option name、color
          title: const Text(
            'Chinese',
            style: TextStyle(color: Colors.white),
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: recognitionLanguage,
          // 設定選種顏色
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              // 將 recognitionLanguage 設為 Taiwanese
              recognitionLanguage = "Chinese";
            });
          },
        ),
      ),
    ]);
  }
}

