import 'package:flutter/material.dart';
import 'package:vokrug/UI/app_bar.dart';
import 'package:vokrug/db/database.dart';
import 'package:vokrug/models/messages.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({Key key, this.userId}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(userId);
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  final int userId;
  Future<List<Message>> _messagesList;
  String _messageText;
  bool isUpdate = false;
  int messageIdForUpdate;

  _HomePageState(this.userId);

  @override
  void initState() {
    super.initState();
    updateMessageList();
  }

  updateMessageList() {
    setState(() {
      _messagesList = DBProvider.db.getMessages(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MyAppBar(),
          Form(
            key: _formStateKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 30, right: 100),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Текст',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      suffixIcon: IconButton(
                        icon: isUpdate ? Icon(Icons.check_circle_outline): Icon(Icons.add_circle_outline),
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          if (isUpdate) {
                            if (_formStateKey.currentState.validate()) {
                              _formStateKey.currentState.save();
                              DBProvider.db
                                  .updateMessage(Message(
                                  id: messageIdForUpdate, text: _messageText))
                                  .then((data) {
                                setState(() {
                                  isUpdate = false;
                                });
                              });
                            }
                          } else {
                            if (_formStateKey.currentState.validate()) {
                              _formStateKey.currentState.save();
                              DBProvider.db.insertMessage(
                                  Message(id: null, text: _messageText, userId: userId));
                            }
                          }
                          _messageController.text = '';
                          updateMessageList();
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter text';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _messageText = value;
                    },
                    controller: _messageController,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: _messagesList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data);
                }
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return Text('No Data Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<Message> messages) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('MESSAGE'),
            ),
            DataColumn(
              label: Text('OPTIONS'),
            ),
          ],
          rows: messages
              .map(
                (message) => DataRow(cells: [
                  DataCell(
                    Text(message.text),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isUpdate = true;
                              messageIdForUpdate = message.id;
                            });
                            _messageController.text = message.text;
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            DBProvider.db.deleteMessage(message.id);
                            updateMessageList();
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }
}

