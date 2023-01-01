import 'package:flutter/material.dart';

class DialogCity extends StatefulWidget {
  DialogCity(
      {super.key,
      required this.ctx,
      required this.cityNameController,
      required this.posts,
      required this.aqi,
      required this.getDataCopy});
  late final cityNameController;
  final ctx;
  final posts;
  final aqi;
  Function getDataCopy;
  // var getData;
  @override
  State<DialogCity> createState() => _DialogCityState();
}

class _DialogCityState extends State<DialogCity> {
  void updateCity(value) {
    setState(() {
      widget.cityNameController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(widget.ctx).size.height * 0.19,
          width: MediaQuery.of(widget.ctx).size.width * 0.99,
          // width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: widget.cityNameController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          widget.cityNameController.clear();
                        }),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Enter City',
                  ),
                  onSubmitted: (value) {
                    updateCity(value);
                  },
                ),
              ),
              // OutlinedButton(
              //   onPressed: ()  {
              //     if (kDebugMode) {
              //       print('on pressed triggered');
              //     }
              //     Navigator.pop(context);
              //     setState(() async {
              //       await widget.getDataCopy;
              //     });
              //   },
              //   child: const Text("Submit"),
              // ),
              OutlinedButton(
                // onPressed: ()async {
                //   setState(() async{
                //     widget.cityNameController;
                //   });
                // },
                onPressed: () {
                  widget.getDataCopy();
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
