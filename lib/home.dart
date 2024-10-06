import "dart:io";

import "package:flutter/material.dart";

import "package:flutter_sms/flutter_sms.dart";
import "package:geolocator/geolocator.dart";
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
    late String emergencyContactNumber;
    late bool textEmergencyContacts;
    late String username;

    late PorcupineManager porcupineManager;
    final platform = Platform.isIOS ? "ios" : "android";
    static const apiKey = String.fromEnvironment("picovoice", defaultValue: "none");

    bool safe = false;
    bool danger = false;

    Future<void> createPorcupineManager() async {
        porcupineManager = await PorcupineManager.fromKeywordPaths(
            apiKey,
            [
                "assets/I-can--t-get-up_en_${platform}_v3_0_0.ppn"
            ],
            (_) async {
                setState( () => danger = true );
                if( blinkFlashlight ) {
                    startBlinkingFlashlight();
                }
                if( textEmergencyContacts ) {
                    await Geolocator.isLocationServiceEnabled();
                    final position = await Geolocator.getCurrentPosition(
                        locationSettings: LocationSettings(
                            accuracy: LocationAccuracy.bestForNavigation,
                            distanceFilter: 100
                        )
                    );
                    await sendSMS(
                        message: "Senior SOS! $username needs your help at this location: www.google.com/maps/search/${position.latitude},${position.longitude}/@${position.latitude},${position.longitude}",
                        recipients: [ emergencyContactNumber.replaceAll( RegExp(r"\D"), "" ) ],
                        sendDirect: true
                    );
                }
            }
        );

        await porcupineManager.start();
    }

    void startBlinkingFlashlight() async {
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
        emergencyContactNumber = widget.prefs.getString( "emergencyContactNumber" ) ?? defaultData.emergencyContactNumber;
        textEmergencyContacts = widget.prefs.getBool( "textEmergencyContacts" ) ?? defaultData.textEmergencyContacts;
        username = widget.prefs.getString( "username" ) ?? defaultData.username;

        createPorcupineManager();
    }

    @override
    void dispose() async {
        await porcupineManager.delete();
        await TorchLight.disableTorch();

        super.dispose();
    }

    @override
    Widget build( BuildContext context ) {
        return Scaffold(
            body: Center( child: Image.asset( safe ? "assets/off.png" : danger ? "assets/activated.png" : "assets/listening.png" ) ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    setState( () {
                        safe = !safe;
                        danger = false;
                    });
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