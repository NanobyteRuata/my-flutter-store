import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();

}

class _SearchWidgetState extends State<SearchWidget> {

  TextEditingController searchInputController = new TextEditingController();
  FocusNode focusNode = FocusNode();

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          focusNode: focusNode,
          controller: searchInputController,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          onChanged: _onSearchTextChanged,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              filled: true,
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white54),
              fillColor: Colors.grey[800],
              suffixIcon: InkWell(
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onTap: () =>  _goBack(context),
              )),
        ),
      ),
      body: Container(child: !isSearching ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.search, color: Colors.grey, size: 60,), Text("Search", style: TextStyle(color: Colors.grey),)],),) :
        Center(child: Text(searchInputController.text),),),
    );
  }

  void _goBack(context) {
    searchInputController.text = "";
    Navigator.pop(context);
  }

  void _onSearchTextChanged(String text) {
    bool tempIsSearching;
    if(text.length > 0) {
      tempIsSearching = true;
    } else {
      tempIsSearching = false;
    }

    setState(() {
      isSearching = tempIsSearching;
    });
  }

}