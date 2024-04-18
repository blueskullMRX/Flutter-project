import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';
import 'SqlDb.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key,required this.type});
  final String type;
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Future<List<Map>> _eventData;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _eventData = SqlDb().readData('SELECT * FROM event where type=?',[widget.type]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar('${widget.type}s'.toUpperCase()),
      drawer: mydrawer(context),
      body: FutureBuilder(
        future: _eventData,
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {

            return ListView.builder(
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < snapshot.data!.length)
                  {
                  var event = snapshot.data![index];
                  String date = DateFormat('yyyy-MM-dd').format(DateTime(int.parse(event["year"]),int.parse(event["month"]), int.parse(event["day"])));
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,top: 8.0),
                    child: ListTile(
                        contentPadding: const EdgeInsets.only(left:16,right:10),
                        trailing: Wrap(
                          children: <Widget>[
                            IconButton(
                              color: Colors.white,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return eventdialog(edit:true,event:event);
                                });              
                              },
                              icon: const Icon(Icons.edit)
                            ),
                            IconButton(
                              color: Colors.white,
                              onPressed: () {
                                _deleteevent(event["id"]);       
                              },
                              icon: const Icon(Icons.delete)
                            )
                          ],
                        ),
                        title: Text(event['title'] ?? 'Aucun titre'),
                        subtitle: Text(date),
                        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: const Color.fromARGB(255, 19, 93, 102),
                        textColor: Colors.white,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                            return eventdialog(edit:true,event:event);
                          });
                        },
                      ),
                  );
                }else{
                  return const SizedBox(
                    height: 300,
                  );
                }
                },
              );
          } 
          
          else {
            return Center(child: Text("Aucun ${widget.type} trouvé !"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 227, 254, 247),
        foregroundColor: const Color.fromARGB(255, 0, 60, 67),

        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return eventdialog(edit:false);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AlertDialog eventdialog({edit,event}) {
    String title;
    if(edit){
      title = "Modification";
      titleController.text = event["title"];
      yearController.text = event["year"];
      monthController.text = event["month"];
      dayController.text = event["day"];
    }else{
      title = "Création";
    }
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(255, 0, 60, 67)),
        ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Titre d'événement",
              ),
              validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champ obligatoire';
                      }
                      return null;
                    },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: dayController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Jour"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Obligatoire';
                      }else if (int.parse(value) > 30 || int.parse(value) < 1) {
                        return 'invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: monthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Mois"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Obligatoire';
                      }else if (int.parse(value) > 12 || int.parse(value) < 1) {
                        return 'invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Année"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Obligatoire';
                      }else if (int.parse(value) > 2100 || int.parse(value) < 2020) {
                        return 'invalide';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          color: const Color.fromARGB(255, 0, 60, 67),
          onPressed: () {
            Navigator.pop(context);
            clearcontrollers();
          },
          icon: const Icon(Icons.close)),
        IconButton(
          color: const Color.fromARGB(255, 0, 60, 67),
          onPressed: () {
            if(edit){
              _modifyevent(event["id"]);
            }else{
              _addevent(); 
            }             
          },
          icon: const Icon(Icons.check)
        ),
      ],
    );
  }

  Future<void> _addevent() async {
    if (_formKey.currentState!.validate()) {
      final db = SqlDb();
      await db.insertData('''
        INSERT INTO event (title, day, month, year, type)
        VALUES (?, ?, ?,?,?)
      ''', [
        titleController.text,
        dayController.text,
        monthController.text,
        yearController.text,
        widget.type
      ]);

      Navigator.pop(context, true);
      setState(() {
        _eventData = SqlDb().readData('SELECT * FROM event where type=?',[widget.type]);
      });
      clearcontrollers();
    }
  }

  Future<void> _modifyevent(id) async {
    if (_formKey.currentState!.validate()) {
      final db = SqlDb();
      await db.updateData('''
        UPDATE event SET title = ?, day = ?, month = ? , year = ? WHERE id = ?
      ''', [
        titleController.text,
        dayController.text,
        monthController.text,
        yearController.text,
        id,
      ]);

      Navigator.pop(context, true);
      setState(() {
        _eventData = SqlDb().readData('SELECT * FROM event where type=?',[widget.type]);
      });
      clearcontrollers();
    }
  }

  Future<void> _deleteevent(id) async {
    final db = SqlDb();
    await db.deleteData('''
      DELETE FROM event
      WHERE id=?;
    ''', [id]);

    setState(() {
      _eventData = SqlDb().readData('SELECT * FROM event where type=?',[widget.type]);
    }); 
  }

  void clearcontrollers(){
    titleController.clear();
    dayController.clear();
    yearController.clear();
    monthController.clear(); 
  }

  @override
  void dispose() {
    titleController.dispose();
    dayController.dispose();
    yearController.dispose();
    monthController.dispose();    
    super.dispose();
  }
}
