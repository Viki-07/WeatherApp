import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather/dialog_city.dart';
import 'package:weather/models/aqi_model.dart';
import 'package:weather/models/post.dart';
import 'package:weather/models/quotesmodel.dart';
import 'package:weather/remote_aqi.dart';
import 'package:weather/remote_qoute.dart';
import 'package:weather/remote_services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dialog_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();
  String userName = "Vivek";
  var isQuoteLoaded = true;
  var isLoaded = false;
  Post? posts;
  Aqi? aqi;
  QuotesPost? quotesPost;
  @override
  void initState() {
    super.initState();
    getData();
  }

  static const snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(10),
    backgroundColor: Colors.blueGrey,
    content: Text('City not found! Re-enter correct one'),
  );
  static const snackBar1 = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(10),
    backgroundColor: Colors.blueGrey,
    content: Text('City updated Successfully !'),
  );
  getData() async {
    if (cityNameController.text == "") {
      cityNameController.text = "Dehradun";
    }
    if (userNameController.text == "") {
      userNameController.text = "Vivek Maurya";
    }
    posts = (await RemoteService(cityNameController.text).getPosts());
    quotesPost = (await RemoteQuote().getPosts());
    aqi = (await Remote_aqi(posts?.coord.lat.toString() ?? "30.3256",
            posts?.coord.lon.toString() ?? "78.0437")
        .getPosts());
    if (posts == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }
    if (posts != null && quotesPost != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  String aqiStatus(int aqino) {
    if (aqino == 1) {
      return "Good";
    } else if (aqino == 2) {
      return "Fair";
    } else if (aqino == 3) {
      return "Moderate";
    } else if (aqino == 4) {
      return "Poor";
    } else {
      return "Very Poor";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          Center(
              child: Text(
            cityNameController.text.toUpperCase(),
            style: const TextStyle(fontStyle: FontStyle.italic),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => DialogCity(
                            ctx: context,
                            cityNameController: cityNameController,
                            posts: posts,
                            aqi: aqi,
                            getDataCopy: getData,
                          ));
                },
                icon: const Icon(Icons.location_on)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogName(
                            ctx: context,
                            userNameController: userNameController);
                      });
                },
                icon: const Icon(Icons.person)),
          )
        ],
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(child: CircularProgressIndicator()),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              elevation: 5,
              surfaceTintColor: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.bottomLeft,
                      child: Row(children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Good Morning ' +
                                userNameController.text[0].toUpperCase() +
                                userNameController.text.substring(1) +
                                '!',
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () async {
                              setState(() {
                                isQuoteLoaded = false;
                              });
                              await getData();
                              // setState(() async {
                              //   quotesPost = (await RemoteQuote().getPosts());
                              isQuoteLoaded = true;
                              // });
                            },
                          ),
                        ),
                      ])),
                  Visibility(
                      visible: isQuoteLoaded,
                      replacement: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 15, 108, 165),
                        highlightColor: Color.fromARGB(255, 104, 184, 204),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Loading Quote...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                          // alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: AutoSizeText(quotesPost?.content ?? "jj",
                              maxLines: 2,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 20)))
                      // Text(quotesPost?.content ?? "jj",
                      //     style: const TextStyle(
                      //         fontStyle: FontStyle.italic, fontSize: 20))),
                      ),
                  Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01),
                      child: Text("-${quotesPost?.author ?? "jj"}"))
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.001),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.bottomLeft,
                                child: const Text('Today,')),
                            Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                    DateFormat.yMMMd().format(DateTime.now()))),
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://openweathermap.org/img/wn/${posts?.weather[0].icon ?? "11d"}@2x.png",
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(posts?.weather[0].main ?? "Clear",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30)),
                            ),
                            Container(
                                padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                                child: const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 3,
                                )),
                            const Padding(padding: EdgeInsets.all(10)),
                            Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.bottomLeft,
                                child: const Text('Wind')),
                            Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "${(posts?.wind.speed ?? 3.99).toStringAsFixed(2)} km/h",
                                  style: const TextStyle(fontSize: 22),
                                )),
                            Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.bottomLeft,
                                child: const Text('Humidity')),
                            Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "${posts?.main.humidity ?? 60} %",
                                  style: const TextStyle(fontSize: 22),
                                )),
                            Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.bottomLeft,
                                child: const Text('Pressure')),
                            Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "${posts?.main.pressure ?? 77} hPa",
                                  style: const TextStyle(fontSize: 22),
                                )),
                          ],
                        )),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Temp.',
                                style: TextStyle(fontSize: 20),
                              )),
                          Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${(((posts?.main.temp) ?? 288) - 273).toStringAsFixed(1)}°C",
                                style: const TextStyle(fontSize: 40),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: Card(
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                // padding: EdgeInsets.only(top: 30,),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Air \nQuality',
                                  style: TextStyle(fontSize: 25),
                                )),
                            Container(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                alignment: Alignment.center,
                                child: Text(
                                  aqi?.list[0].components['pm10']
                                          ?.toInt()
                                          .toString() ??
                                      "",
                                  style: TextStyle(fontSize: 60),
                                )),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                alignment: Alignment.center,
                                child: Text(
                                  aqiStatus(aqi?.list[0].main.aqi ?? 1),
                                  style: TextStyle(fontSize: 15),
                                )),
                          ],
                        )),
                  )
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
