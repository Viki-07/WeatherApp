import 'package:flutter/material.dart';
import 'main.dart';

class DialogName extends StatefulWidget {
  DialogName({super.key, required this.ctx, required this.userNameController});
  late final userNameController;
  final ctx;

  @override
  State<DialogName> createState() => _DialogNameState();
}

class _DialogNameState extends State<DialogName> {
  // set userNameController => widget.userNameController.text;
  @override

  // String cityName="";
  void updateName(value) {
    setState(() {
      widget.userNameController = value;
    });
  }

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
                  controller: widget.userNameController,
                  onSubmitted: (value) {
                    // widget.userNameController
                    updateName(value);
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          widget.userNameController.clear();
                        }),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Enter User Name',
                  ),
                ),
              ),
              OutlinedButton(
                // onPressed: ()async {
                //   setState(() {
                //     widget.userNameController;
                //   Navigator.pop(context);
                //   });
                // },
                onPressed: () {
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
