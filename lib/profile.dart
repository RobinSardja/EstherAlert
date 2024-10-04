import "package:flutter/material.dart";

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

    late String username;

    @override
    void initState() {
        super.initState();

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
                        )
                    ]
                )
            )
        );
    }
}