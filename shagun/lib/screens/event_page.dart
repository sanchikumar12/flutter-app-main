import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:miniapp/constants.dart';
import 'package:miniapp/helpers/pdf_helper.dart';
import 'package:miniapp/screens/form_screen.dart';
import 'package:printing/printing.dart';

import '../helpers/form_helper.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.eventRef}) : super(key: key);
  final DocumentReference eventRef;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Stream<QuerySnapshot> _guestsStream;
  late Future<DocumentSnapshot> _eventFuture;
  Map<String, dynamic>? eventData;
  List<Map<String, dynamic>> guestData = [];

  @override
  void initState() {
    _eventFuture = widget.eventRef.get();
    _guestsStream = widget.eventRef.collection('guests').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: addGuest,
            child: const Icon(Icons.person_add),
          ),
          appBar: AppBar(
            title: const Text('Event'),
            actions: [
              IconButton(onPressed: editEvent, icon: const Icon(Icons.edit)),
              IconButton(onPressed: exportTable, icon: const Icon(Icons.picture_as_pdf)),
            ],
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/event_bg.jpeg"), fit: BoxFit.fill)),
            child: Scrollbar(
              controller: ScrollController(),
              child: SingleChildScrollView(
                primary: true,
                child: Container(
                  padding: kDefaultPadding,
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: _eventFuture,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return const Text("Document does not exist");
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            eventData = snapshot.data!.data() as Map<String, dynamic>;

                            return Table(
                              border: TableBorder.all(color: Colors.green, width: 1.5),
                              children: [
                                buildRow('With blessings of', eventData!['guru']),
                                buildRow('Event:', eventData!['name']),
                                buildRow('Hosted by', eventData!['host']),
                                buildRow('Date:', DateFormat('EEEE, MMM d, yyyy').format(eventData!['date'].toDate())),
                                buildRow('Venue:', eventData!['venue']),
                                TableRow(children: [
                                  const Text('Photo:'),
                                  eventData!['photo'] != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            //to show image, you type like this.
                                            eventData!['photo'],
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context).size.width,
                                            height: 300,
                                          ),
                                        )
                                      : Container()
                                ])
                              ],
                            );
                          }

                          return const CircularProgressIndicator();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: const Text(
                          'Guests',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _guestsStream,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          int index = 0;
                          guestData.clear();
                          int noOFGift = 0;
                          for (int i = 0; i < int.parse(snapshot.data!.size.toString()); i++) {
                            print(snapshot.data!.docs[i]["gift"]);
                            /*int b = 0;
                            if (snapshot.data!.docs[i]["gift"] != "") {
                              noOFGift = noOFGift + 1;
                            }*/
                            noOFGift+=int.parse(snapshot.data!.docs[i]["no_of_gift"].toString());
                          }
                          return Column(
                            children: [
                              Text('No. of guest: ${snapshot.data?.size}'),
                              Text('No. of gift: $noOFGift'),
                              Scrollbar(
                                controller: ScrollController(),
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                      columnSpacing: 10,
                                      columns: const [
                                        DataColumn(label: Text('')),
                                        DataColumn(label: Text('S. No.')),
                                        DataColumn(label: Text('Guest list')),
                                        DataColumn(label: Text('Nickname')),
                                        DataColumn(label: Text('Relation')),
                                        DataColumn(label: Text('Gift')),
                                        DataColumn(label: Text('NoOfGift')),
                                        DataColumn(label: Text('Cash')),
                                        DataColumn(label: Text('Jewellery'))
                                      ],
                                      rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                        guestData.add(data);

                                        return DataRow(cells: [
                                          DataCell(IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () => showConfirmationDialog(document.reference),
                                            icon: const Icon(Icons.delete),
                                          )),
                                          DataCell(Center(child: Text('${++index}',textAlign: TextAlign.center))),
                                          DataCell(Center(child: Text(data['guest_list'],textAlign: TextAlign.center))),
                                          DataCell(Center(child: Text(data['nickname'],textAlign: TextAlign.center))),
                                          DataCell(Center(child: Text(data['relation'],textAlign: TextAlign.center))),
                                          DataCell(Center(child: Text(data['gift'],textAlign: TextAlign.center))),
                                          DataCell(Center(child: Text(data['no_of_gift'].toString(),textAlign: TextAlign.center))),
                                          DataCell(Center(child: Text(data['cash'],textAlign: TextAlign.center))),
                                          DataCell(Center(child: Text(data['jewellery'],textAlign: TextAlign.center))),
                                        ]);
                                      }).toList()),
                                ),
                              )
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  TableRow buildRow(String label, String value) {
    return TableRow(
      children: [Text("$label ", style: const TextStyle(fontSize: 15.0)), Text(value ?? '', style: const TextStyle(fontSize: 15.0))],
    );
  }

  void addGuest() {
    TextEditingController guestListController = TextEditingController();
    TextEditingController nicknameController = TextEditingController();
    TextEditingController relationController = TextEditingController();
    TextEditingController giftController = TextEditingController();
    TextEditingController cashController = TextEditingController();
    TextEditingController jewelleryController = TextEditingController();
    int noOFGiftAdd = 1;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add a guest'),
                content: Scrollbar(
                  controller: ScrollController(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormHelper.buildTextField('Guest list', controller: guestListController),
                        FormHelper.buildTextField('Nickname', controller: nicknameController),
                        FormHelper.buildTextField('Relation', controller: relationController),
                        const SizedBox(height: 10),
                        const Text("Total Gift", style: TextStyle(fontSize: 14,color: Colors.black54)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  if(giftController.text.isNotEmpty){
                                    setState(() {
                                      noOFGiftAdd += 1;
                                    });
                                  }

                                },
                                child: Container(height: 30, width: 30, alignment: Alignment.center, child: const Text(" + ", style: TextStyle(fontSize: 18)))),
                            Text("${giftController.text.isEmpty ? 0 : noOFGiftAdd}"),
                            InkWell(
                                onTap: () {
                                  if (noOFGiftAdd > 0) {
                                    setState(() {
                                      noOFGiftAdd -= 1;
                                    });
                                  }
                                },
                                child: Container(height: 30, width: 30, alignment: Alignment.center, child: const Text(" - ", style: TextStyle(fontSize: 22)))),
                          ],
                        ),
                        //FormHelper.buildTextField('Gift', controller: giftController),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              if(giftController.text.isEmpty){
                                noOFGiftAdd=1;
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Gift",
                          ),
                          controller: giftController,
                        ),
                        FormHelper.buildTextField('Cash', controller: cashController, keyboardType: TextInputType.number),
                        FormHelper.buildTextField('Jewellery', controller: jewelleryController)
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        widget.eventRef.collection('guests').add({
                          'guest_list': guestListController.text,
                          'nickname': nicknameController.text,
                          'relation': relationController.text,
                          'gift': giftController.text,
                          'no_of_gift':giftController.text.isEmpty?0: noOFGiftAdd,
                          'cash': cashController.text,
                          'jewellery': jewelleryController.text
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'))
                ],
              );
            },
          );
        });
  }

  void exportTable() async {
    context.loaderOverlay.show();
    final pdf = await PdfHelper.exportEvent(eventData, guestData);
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'event${widget.eventRef.id}.pdf');
    if (mounted) {
      context.loaderOverlay.hide();
    }
  }

  void editEvent() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FormScreen(
              eventId: widget.eventRef.id,
            )));
  }

  showConfirmationDialog(DocumentReference<Object?> reference) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete the guest"),
            content: const Text("Would you like to delete the guest ?"),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                  onPressed: () => deleteGuest(reference),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  deleteGuest(DocumentReference<Object?> reference) {
    reference.delete();
    Navigator.of(context).pop();
  }
}
