import "package:flutter/material.dart";

void main() {
    runApp( const MainApp() );
}

class MainApp extends StatefulWidget {
    const MainApp({super.key});

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
                    backgroundColor: Colors.green,
                    centerTitle: true,
                    foregroundColor: Colors.yellow
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    backgroundColor: Colors.green,
                    selectedItemColor: Colors.yellow
                )
            ),
            home: Scaffold(
                appBar: AppBar(
                    title: const Text( "EstherAlert" )
                ),
                body: PageView(
                    controller: pageController,
                    onPageChanged: (currentPage) => setState( () => currentIndex = currentPage ),
                    children: const [
                        Center( child: Text( "Account" ) ),
                        Center( child: Text( "Home" ) ),
                        Center( child: Text( "Settings" ) )
                    ],
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
                            label: "Account"
                        ),
                        BottomNavigationBarItem(
                            icon: Icon( Icons.home ),
                            label: "Home"
                        ),
                        BottomNavigationBarItem(
                            icon: Icon( Icons.settings ),
                            label: "Settings"
                        )
                    ],
                ),
            )
        );
    }
}