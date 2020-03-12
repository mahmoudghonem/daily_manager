import 'package:daily_manager/ui/screens/notesScreen.dart';
import 'package:daily_manager/ui/screens/tasksScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool isNote = true;
  int _currentPage = 0;
  PageController _pageViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Daily Manager'),
      ),
      body: PageView(
        controller: _pageViewController,
        scrollDirection: Axis.horizontal,
        onPageChanged: onPageChanged,
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          NotesScreen(),
          TasksScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).primaryColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.note,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.playlist_add_check,
              ),
              title: Container(height: 0.0),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _currentPage,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddingNewScreen(),
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageViewController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  void navigationTapped(int page) {
    _pageViewController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._currentPage = page;
      if (page == 1) {
        isNote = false;
      } else {
        isNote = true;
      }
    });
  }

  openAddingNewScreen() {
    if (isNote == true) {
      openNewNote();
    } else if (isNote == false) {
      openNewTask();
    }
  }

  openNewNote() {
    Navigator.pushNamed(context, '/newNoteScreen');
  }

  openNewTask() {
    Navigator.pushNamed(context, '/newTaskScreen');
  }
}
