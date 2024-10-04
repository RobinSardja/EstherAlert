import "dart:io";

import "package:flutter/material.dart";
import "package:porcupine_flutter/porcupine.dart";

import "package:porcupine_flutter/porcupine_manager.dart";

class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    late PorcupineManager porcupineManager;
    final platform = Platform.isIOS ? "ios" : "android";
    static const apiKey = String.fromEnvironment("picovoice", defaultValue: "none");

    String message = "Nothing ever happens";

    Future<void> createPorcupineManager() async {
        porcupineManager = await PorcupineManager.fromBuiltInKeywords(
            apiKey,
            [BuiltInKeyword.PORCUPINE],
            (_) => setState( () => message = "WHAT THE FLIP" )
        );

        await porcupineManager.start();
    }

    @override
    void initState() {
        super.initState();

        createPorcupineManager();
    }

    @override
    void dispose() {
        porcupineManager.delete();

        super.dispose();
    }

    @override
    Widget build( BuildContext context ) {
        return Scaffold(
            body: Center( child: Text(message) )
        );
    }
}