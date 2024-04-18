
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'drawer.dart';
import 'SqlDb.dart';


class Calender extends StatefulWidget {
  const Calender({super.key});
  


  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  List<Appointment> _appointments = <Appointment>[];
  List<Appointment> _selectedAppointments = <Appointment>[];
  List<Map<dynamic, dynamic>> _events = [];

  @override
  void initState() {
    getdata();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedAppointments = _getAppointmentsForDate(DateTime.now());
      });
    });
  }


  void getdata() async {
    Future<List<Map<dynamic, dynamic>>> eventData = SqlDb().readData('SELECT * FROM event');
    List<Map<dynamic, dynamic>> list =  await eventData;
    _events = list;
    _appointments = _getAppointments();
    setState(() {
        _selectedAppointments = _getAppointmentsForDate(DateTime.now());
      });
  }


  List<Appointment> _getAppointments() {
    var colors = {
      "devoir" : Colors.blue,
      "examen" :Colors.green,
      "projet" :Colors.red,
      "activités des club":Colors.purple,
      "remarques générale":Colors.black,
    };    

    List<Appointment> appointements = [];

    _events.forEach((element) {
      appointements.add(Appointment(
        startTime: DateTime(int.parse(element['year']), int.parse(element['month']), int.parse(element["day"])),
        endTime: DateTime(0, 0, 0),
        subject: element["title"],
        color: colors[element["type"]] ?? Colors.black,
        notes: element["id"].toString(),
      ));
    });
    
    return appointements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color.fromARGB(255, 0, 60, 67),
                        ),
                      onPressed: () {
                        Navigator.pop(context);
                      },

                    ),
                  ],
                  title:const Text(
                    "Aide",
                    style: TextStyle(color: Color.fromARGB(255, 0, 60, 67)),
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Devoir",
                            style: TextStyle( 
                              color: Colors.blue,
                              fontSize: 20,
                              
                            ),
                            ),
                          Icon(
                            Icons.task,
                            color: Colors.blue,
                          ),
                          
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Examen",
                            style: TextStyle( 
                              color: Colors.green,
                              fontSize: 20,
                              
                            ),
                            ),
                          Icon(
                            Icons.note_alt,
                            color: Colors.green,
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Projet",
                            style: TextStyle( 
                              color: Colors.red,
                              fontSize: 20,
                              
                            ),
                            ),
                          Icon(
                            Icons.receipt_long,
                            color: Colors.red,
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activités des club",
                            style: TextStyle( 
                              color: Colors.purple,
                              fontSize: 20,
                              
                            ),
                            ),
                          Icon(
                            Icons.groups,
                            color: Colors.purple,
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Remarques générale",
                            style: TextStyle( 
                              color: Colors.black,
                              fontSize: 20,
                              
                            ),
                            ),
                          Icon(
                            Icons.campaign,
                            color: Colors.black,
                          ),
                        ]
                      ),
                    ],
                  ),
                );
                });
            },
            icon: const Icon(Icons.help),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("CALENDRIER",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 0, 60, 67),
      ),
      drawer: mydrawer(context),
      body: Column(
        children: [
          Expanded(
            child: SfCalendar(
              todayHighlightColor: const Color.fromARGB(255, 19, 93, 102),
              selectionDecoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 19, 93, 102),
                  width: 2
                ),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
              backgroundColor: Colors.white,
              view: CalendarView.month,
              showNavigationArrow: true,
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: Color.fromARGB(255, 19, 93, 102),
                textStyle: TextStyle(color: Colors.white),
              ),
              dataSource: MeetingDataSource(_appointments),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              ),
              onSelectionChanged: (CalendarSelectionDetails details) {
                setState(() {
                  _selectedAppointments =
                      _getAppointmentsForDate(details.date!);
                });
              },
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: _selectedAppointments.length,
              itemBuilder: (context, index) {
                final Appointment appointment = _selectedAppointments[index];
                final String formattedDate =
                    DateFormat('yyyy-MM-dd').format(appointment.startTime);
                var icons = {
                  Colors.blue : Icons.task,
                  Colors.green :Icons.note_alt,
                  Colors.red :Icons.receipt_long,
                  Colors.purple :Icons.groups,
                  Colors.black :Icons.campaign,
                }; 
                return Padding(
                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,top: 8.0),
                    child: ListTile(
                        trailing: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                _deleteevent(appointment.notes);     
                              },
                              icon: const Icon(Icons.delete)
                            ),
                        leading: Icon(
                          icons[appointment.color],
                          color: Colors.white,
                          ),
                        contentPadding: const EdgeInsets.only(left:16,right:10),
                        title: Text(appointment.subject),
                        subtitle: Text(formattedDate),
                        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: appointment.color,
                        textColor: Colors.white,
                        onTap: () {
                        },
                      ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }


  List<Appointment> _getAppointmentsForDate(DateTime date) {
    return _appointments.where((appointment) {
      return appointment.startTime.day == date.day &&
          appointment.startTime.month == date.month &&
          appointment.startTime.year == date.year;
    }).toList();
  }

  Future<void> _deleteevent(id) async {
    final db = SqlDb();
    await db.deleteData('''
      DELETE FROM event
      WHERE id=?;
    ''', [id]);

    setState(() {
      getdata();
    }); 
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
