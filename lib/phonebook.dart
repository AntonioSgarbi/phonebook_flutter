import 'package:avaliacao3/contact_dao.dart';
import 'package:flutter/material.dart';

import 'contact.dart';

class PhoneBook extends StatefulWidget {
  const PhoneBook({super.key});

  @override
  State<PhoneBook> createState() => _PhoneBook();
}

class _PhoneBook extends State<PhoneBook> {
  final ContactDao dao = ContactDao();
  List<Contact> contacts = [];

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  _PhoneBook() {
    dao.connect().then((value) => {load()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agenda Telefônica")),
      body: Column(children: [
        fieldName(),
        fieldPhone(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buttonSave(),
            buttonDel(),
            buttonClear(),
          ],
        ),
        listView()
      ]),
    );
  }

  load() {
    dao.list().then((value) {
      setState(() => {
        contacts = value,
        name.text = '',
        phone.text = '',
      });
    });
  }

  fieldName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(labelText: 'Nome'),
        controller: name,
      ),
    );
  }

  fieldPhone() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(labelText: 'Telefone'),
        controller: phone,
      ),
    );
  }

  buttonSave() {
    return ElevatedButton(
        onPressed: () {
          if (name.text.trim() != '') {
            var c = Contact(name: name.text, phone: phone.text);
            dao.insert(c).then((value) {
              load();
            });
          }
        },
        child: const Text("Gravar"));
  }

  buttonDel() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          dao.delete(name.text.trim()).then((value) => load());
        },
        child: const Text('Excluir'));
  }

  buttonClear() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
        onPressed: () {
          setState(() {
            name.text = '';
            phone.text = '';
          });
        },
        child: const Text('Limpar'));
  }

  listView() {
    return Expanded(
      child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                contacts[index].name,
                style: const TextStyle(fontSize: 20.0, color: Colors.red),
              ),
              subtitle: Text(contacts[index].phone),
              onTap: () {
                setState(() {
                  name.text = contacts[index].name;
                  phone.text = contacts[index].phone;
                });
              },
            );
          }),
    );
  }
}
