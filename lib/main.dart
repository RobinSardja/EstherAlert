import "package:flutter/material.dart";

import "package:permission_handler/permission_handler.dart";
import "package:shared_preferences/shared_preferences.dart";

import "profile.dart";
import "home.dart";
import "settings.dart";

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final prefs = await SharedPreferences.getInstance();
    final statuses = await [
        Permission.microphone,
        Permission.sms
    ].request();

    runApp( MainApp( prefs: prefs ) );
}

class MainApp extends StatefulWidget {
    const MainApp({
        super.key,
        required this.prefs
    });

    final SharedPreferences prefs;

    @override
    State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

    int currentIndex = 1;
    final pageController = PageController(
        initialPage: 1
    );

    @override
    Widget build( BuildContext context ) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.red,
                    centerTitle: true,
                    foregroundColor: Colors.white
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    backgroundColor: Colors.red,
                    selectedItemColor: Colors.white
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white
                ),
                inputDecorationTheme: const InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(),
                    floatingLabelStyle: TextStyle(
                        color: Colors.red
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red
                        )
                    )
                ),
                switchTheme: SwitchThemeData(
                    trackColor: WidgetStateProperty.resolveWith( (states) => states.contains(WidgetState.selected) ? Colors.red : null )
                ),
                textButtonTheme: TextButtonThemeData(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll( Colors.red ),
                        foregroundColor: WidgetStatePropertyAll( Colors.white )
                    )
                )
            ),
            home: Scaffold(
                appBar: AppBar(
                    title: const Text( "Senior SOS" )
                ),
                body: PageView(
                    controller: pageController,
                    onPageChanged: (currentPage) => setState( () => currentIndex = currentPage ),
                    children: [
                        ProfilePage( prefs: widget.prefs ),
                        HomePage( prefs: widget.prefs ),
                        SettingsPage( prefs: widget.prefs )
                    ]
                ),
                bottomNavigationBar: BottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (tappedIndex) {
                        setState( () => currentIndex = tappedIndex );
                        pageController.jumpToPage(tappedIndex);
                    },
                    items: const [
                        BottomNavigationBarItem(
                            icon: Icon( Icons.person ),
                            label: "Profile"
                        ),
                        BottomNavigationBarItem(
                            icon: Icon( Icons.home ),
                            label: "Home"
                        ),
                        BottomNavigationBarItem(
                            icon: Icon( Icons.settings ),
                            label: "Settings"
                        )
                    ]
                )
            )
        );
    }
}