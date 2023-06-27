import 'package:first/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme_provider.dart';
import '../../widgets/drawer.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: const HeaderWidget(),
      drawer: const DrawerWidget(
        currentPage: 'Chat',
      ),
      body: Container(
          decoration: BoxDecoration(
            color: theme.isDarkModeEnabled
                ? theme.dark['backgroundColor']
                : theme.light['backgroundColor'],
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(reverse: true, children: const <Widget>[
                  // Text("Hola"),
                  // ListBody(
                  //   reverse: true,
                  //   children: ,
                  // ),
                ]),
              ),
              Container(
                height: 100,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  //put border radius only on the top
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: theme.isDarkModeEnabled
                      ? theme.dark['backgroundColor']
                      : theme.light['backgroundColor'],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          fillColor: Color.fromARGB(245, 223, 219, 219),
                          filled: true,
                          hintText: 'Escribe algo',
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send),
                        color: theme.isDarkModeEnabled
                            ? theme.dark['iconColorLight']
                            : theme.light['iconColorLight'],
                        iconSize: 30.0),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
