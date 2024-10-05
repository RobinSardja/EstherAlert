import "package:flutter/material.dart";

import "package:shared_preferences/shared_preferences.dart";

import "default_data.dart";

class SettingsPage extends StatefulWidget {
    const SettingsPage({
        super.key,
        required this.prefs
    });

    final SharedPreferences prefs;

    @override
    State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

    late bool blinkFlashlight;
    late bool textEmergencyContacts;

    @override
    void initState() {
        super.initState();

        blinkFlashlight = widget.prefs.getBool( "blinkFlashlight" ) ?? defaultData.blinkFlashlight;
        textEmergencyContacts = widget.prefs.getBool( "textEmergencyContacts" ) ?? defaultData.textEmergencyContacts;
    }

    @override
    Widget build( BuildContext context ) {
        return Scaffold(
            body: Center(
                child: ListView(
                    shrinkWrap: true,
                    children: [
                        ListTile(
                            title: const Text( "Blink flashlight" ),
                            trailing: Switch(
                                value: blinkFlashlight,
                                onChanged: (value) {
                                    setState( () => blinkFlashlight = value );
                                    widget.prefs.setBool( "blinkFlashlight", value );
                                }
                            )
                        ),
                        ListTile(
                            title: const Text( "Text emergency contacts" ),
                            trailing: Switch(
                                value: textEmergencyContacts,
                                onChanged: (value) {
                                    setState( () => textEmergencyContacts = value );
                                    widget.prefs.setBool( "textEmergencyContacts", value );
                                }
                            )
                        )
                    ]
                )
            )
        );
    }
}