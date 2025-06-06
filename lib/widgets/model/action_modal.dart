import 'package:crud_flutter/models/person.dart';
import 'package:crud_flutter/services/person_service.dart';
import 'package:crud_flutter/util/app_colors.dart';
import 'package:crud_flutter/widgets/line_modal_sheet.dart';
import 'package:crud_flutter/widgets/person_form.dart';
import 'package:flutter/material.dart';

class ActionModal extends StatefulWidget {
  final Person person;
  final Function(Person item) onEditPeson;
  final Function(Person item) onDeletePeson;

  const ActionModal({super.key, required this.person, required this.onDeletePeson, required this.onEditPeson});

  @override
  State<ActionModal> createState() => _ActionModalState();
}

class _ActionModalState extends State<ActionModal> {
  late PersonService _personService;

  @override
  void initState() {
    _personService = PersonService();
    super.initState();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminação'),
          content: Text('Tem certeza que deseja eliminar o usuário ${widget.person.firstName} ${widget.person.lastName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () { Navigator.of(dialogContext).pop();},
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                try {
                  await _personService.delete(widget.person);
                }finally {
                  await widget.onDeletePeson(widget.person);
                }
              },
              child: const Text('Confirmo', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: 200,
      child: Column(
        spacing: 15,
        children: [
          LineModalSheet(),
          _Link(text: "Editar", icon: Icon(Icons.edit_note_sharp, color: AppColors.colorIconInput, ), onTap: () {
            showModalBottomSheet(context: context, builder: (_) {
              return PersonForm(initialPerson: widget.person, onSubmit: (it) async {
                  try{
                   await _personService.update(it);
                   Navigator.pop(context);
                  }finally {
                    widget.onEditPeson(it);
                  }
              });
            });
          },),
           Container(
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(50),
                borderRadius: BorderRadius.circular(40)
              ),
                child: _Link(text: "Eliminar", icon: Icon(Icons.delete, color: AppColors.colorIconInput,), onTap: () {
                  _showDeleteConfirmationDialog(context);
                },)
            ),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function() onTap;

  const _Link({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(text),
        trailing: icon,
      ),
    );
  }
}

