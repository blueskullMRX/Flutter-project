import 'package:flutter/material.dart';
import 'calender.dart';
import 'event.dart';

Drawer mydrawer(context) {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const SizedBox(
          child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 60, 67),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.edit_calendar,
                    color: Colors.white,
                    size: 80,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Calendrier",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Universitaire",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        draweritem(
            context, Icons.calendar_month, ' Calendrier ', const Calender()),
        draweritem(
            context, Icons.task, ' Devoirs ', const EventPage(type: "devoir")),
        draweritem(context, Icons.note_alt, ' Examens ',
            const EventPage(type: "examen")),
        draweritem(context, Icons.receipt_long, ' Projets ',
            const EventPage(type: "projet")),
        draweritem(context, Icons.groups, ' Activités des clubs ',
            const EventPage(type: "activités des club")),
        draweritem(context, Icons.campaign, ' Remarques générales ',
            const EventPage(type: "remarques générale")),
      ],
    ),
  );
}

ListTile draweritem(context, icon, title, page) {
  return ListTile(
    textColor: const Color.fromARGB(255, 0, 60, 67),
    iconColor: const Color.fromARGB(255, 0, 60, 67),
    splashColor: const Color.fromARGB(255, 227, 254, 247),
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },
  );
}

AppBar myappbar(title) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: const Color.fromARGB(255, 0, 60, 67),
  );
}
