import 'package:flutter/material.dart';
import 'package:money_management_app/Screens/HomeScreen/homescreen.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    //ValueListenableBuilder: It builds the widget every time the valueListenable value changes.
    return ValueListenableBuilder(
        // setting the value which it listen on change
        valueListenable: HomeScreen.selectedIndexNotifier,
        builder: (BuildContext ctx, int updatedIndex, Widget? _) {
          return BottomNavigationBar(
            // initial selection index
            currentIndex: updatedIndex, //(selected index)

            // Setting colours
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,

            onTap: (newIndex) {
              // changing the selectedIndexNotifer on Tap on the BottomNavigator
              HomeScreen.selectedIndexNotifier.value = newIndex;
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category'),
            ],
          );
        });
  }
}

// Note

/*
To change the Selection on Tap according 
to the value in the selectedIndexNotifier 
we will have to wrap the BottomNavigationBar with a ValueListenableBuilder  */

//ValueListenableBuilder: It builds the widget every time the valueListenable value changes.

// The above code changes the UI of bottom Navigator only