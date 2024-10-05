import "dart:io";

import "package:flutter/material.dart";

import "package:porcupine_flutter/porcupine_manager.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:torch_light/torch_light.dart";

import "default_data.dart";

class HomePage extends StatefulWidget {
    const HomePage({
        super.key,
        required this.prefs
    });

    final SharedPreferences prefs;

    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    late bool blinkFlashlight;

    late PorcupineManager porcupineManager;
    final platform = Platform.isIOS ? "ios" : "android";
    static const apiKey = String.fromEnvironment("picovoice", defaultValue: "none");
    String message = "Nothing ever happens";

    bool safe = false;

    Future<void> createPorcupineManager() async {
        porcupineManager = await PorcupineManager.fromKeywordPaths(
            apiKey,
            [
                "assets/I-can--t-get-up_en_${platform}_v3_0_0.ppn"
            ],
            (_) {
                setState( () => message = "WHAT THE FLIP" );
                if( blinkFlashlight ) {
                    startBlinkingFlashlight();
                }
            }
        );

        await porcupineManager.start();
    }

    Future<void> startBlinkingFlashlight() async {
        final isTorchAvailable = await TorchLight.isTorchAvailable();
        if( isTorchAvailable ) {
            while( !safe ) {
                await TorchLight.enableTorch();
                await Future.delayed( Duration( milliseconds: 250 ) );
                await TorchLight.disableTorch();
                await Future.delayed( Duration( milliseconds: 250 ) );
            }
        }
    }

    @override
    void initState() {
        super.initState();

        blinkFlashlight = widget.prefs.getBool( "blinkFlashlight" ) ?? defaultData.blinkFlashlight;

        createPorcupineManager();
    }

    @override
    void dispose() {
        porcupineManager.delete();
        TorchLight.disableTorch();

        super.dispose();
    }

    @override
    Widget build( BuildContext context ) {
        return Scaffold(
            body: Center( child: Text(message) ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    setState( () => safe = !safe );
                    if( !safe ) {
                        TorchLight.disableTorch();
                    }
                },
                child: Icon( safe ? Icons.check : Icons.shield )
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
    }
}