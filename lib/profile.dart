import "package:flutter/material.dart";

import "package:flutter_native_contact_picker/flutter_native_contact_picker.dart";
import "package:shared_preferences/shared_preferences.dart";

import "default_data.dart";

class ProfilePage extends StatefulWidget {
    const ProfilePage({
        super.key,
        required this.prefs
    });

    final SharedPreferences prefs;

    @override
    State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

    final contactPicker = FlutterNativeContactPicker();

    late String emergencyContactName;
    late String emergencyContactNumber;
    late String username;

    @override
    void initState() {
        super.initState();

        emergencyContactName = widget.prefs.getString( "emergencyContactName" ) ?? defaultData.emergencyContactName;
        emergencyContactNumber = widget.prefs.getString( "emergencyContactNumber" ) ?? defaultData.emergencyContactNumber;
        username = widget.prefs.getString( "username" ) ?? defaultData.username;
    }

    @override
    Widget build( BuildContext context ) {
        return Scaffold(
            body: Center(
                child: ListView(
                    shrinkWrap: true,
                    children: [
                        ListTile(
                            title: TextField(
                                decoration: InputDecoration(
                                    labelText: "Name: $username"
                                ),
                                onSubmitted: (value) {
                                    setState( () => username = value );
                                    widget.prefs.setString( "username", username );
                                }
                            )
                        ),
                        ListTile(
                            title: TextButton(
                                onPressed: () async {
                                    final contact = await contactPicker.selectContact();
                                    setState( () {
                                        emergencyContactName = contact?.fullName ?? "";
                                        emergencyContactNumber = contact?.phoneNumbers?[0] ?? "";
                                    });
                                    widget.prefs.setString( "emergencyContactName", emergencyContactName );
                                    widget.prefs.setString( "emergencyContactNumber", emergencyContactNumber );
                                },
                                child: Text( emergencyContactName.isEmpty ? "Select emergency contact" : "Emergency contact: $emergencyContactName $emergencyContactNumber" )
                            )
                        )
                    ]
                )
            )
        );
    }
}