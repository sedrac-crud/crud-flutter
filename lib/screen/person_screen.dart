import 'package:crud_flutter/services/person_service.dart';
import 'package:crud_flutter/widgets/button.dart';
import 'package:crud_flutter/widgets/model/action_modal.dart';
import 'package:crud_flutter/widgets/person_form.dart';
import 'package:crud_flutter/widgets/select_filter.dart';
import 'package:crud_flutter/widgets/input_search.dart';
import 'package:crud_flutter/widgets/image_oval.dart';
import 'package:crud_flutter/util/app_colors.dart';
import 'package:crud_flutter/models/_import.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  TextEditingController _searchController = TextEditingController();
  late Future<PersonPageable> _personFuture;
  late PersonService _personService;
  bool _filterVisible = false;
  String? _field;

  @override
  void initState() {
    _personService = PersonService();
    _personFuture = _personService.getPageable();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _getUsers(){
    setState(() { _personFuture = _personService.getPageable(); });
  }

  /*
  * Pesquisa sobre os utilizadores já encontrado
  * */
  void _filterUsers() async {
    final String searchText = _searchController.text.trim();
    final _responseData = await _personFuture;
    final _users = _responseData.users.where((it) => "${it.username}|${it.firstName}|${it.lastName}|${it.email}".toLowerCase().contains(searchText.toLowerCase()) ).toList();
    setState(() {
      _personFuture = Future.value(
          PersonPageable(users: _users, total: _users.length, limit: 0, skip: 0)
      );
    });
  }

  void _performSearch() async {
    final String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      if(_field == null) {
        _filterUsers();
        return;
      }

      final _responseFuture = _personService.getPageableFilter(_field!,  searchText);
      PersonPageable _responseData = await _responseFuture;
      if(_responseData.users.length > 0) {
        setState(() { _personFuture = _responseFuture; });
        return;
      }
      _filterUsers();
    } else {
      _getUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários", style: GoogleFonts.lexend(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () {
              _searchController = TextEditingController();
              _field = null;
              _getUsers();
            },
            icon: Icon(Icons.repeat, color: AppColors.colorIconInput),
          ),
          IconButton(
            onPressed: () {
                showModalBottomSheet(context: context, builder: (_) {
                  return PersonForm(onSubmit: (item) async {
                    try {
                      final _responseData = await _personFuture;
                      final p = await _personService.store(item);
                      final _users = [ p, ... _responseData.users];
                      setState(() {
                        _personFuture = Future.value(PersonPageable(
                            users: _users, total: _users.length, limit: 0, skip: 0)
                        );
                      });
                    }catch(error){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível criar o usuário'),));
                    }finally{
                      Navigator.pop(context);
                    }
                  });
                });
            },
            icon: Icon(Icons.add_circle, color: AppColors.colorIconInput),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InputSearch(
              controller: _searchController,
              onSubmitted: _performSearch,
              onPressedPrefixIcon: () => setState(() => _filterVisible = !_filterVisible),
            ),
            if (_filterVisible) ...[
              const SizedBox(height: 20),
              SelectFilter(onValueChange: (v) => setState(() => _field = v)),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<PersonPageable>(
                future: _personFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar usuários: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final users = snapshot.requireData.users;
                    if (users.isEmpty) {
                      return Center(
                        child: Text('Nenhum usuário encontrado\n Recarrega as informação clicando no botão acima', textAlign: TextAlign.center,),
                      );
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final it = users[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: ImageOval(image: it.image),
                              title: Text( "${it.firstName} ${it.lastName}", style: GoogleFonts.lexend(fontWeight: FontWeight.w500,),),
                              subtitle: Text(it.email,style: const TextStyle(fontSize: 12, color: Colors.grey,),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  showModalBottomSheet(context: context, builder: (_) {
                                    return ActionModal(person: it,
                                      onEditPeson: (item) async {
                                        final _responseData = await _personFuture;
                                        final _users = _responseData.users.map((it) => it.id == item.id ? item : it).toList();
                                        setState(() {
                                          _personFuture = Future.value(PersonPageable(users: _users, total: _users.length, limit: 0, skip: 0));
                                        });
                                      },
                                      onDeletePeson: (item) async {
                                        final _responseData = await _personFuture;
                                        final _users = _responseData.users.where((it) => it.id != item.id).toList();
                                        setState(() {
                                          _personFuture = Future.value(PersonPageable(users: _users, total: _users.length, limit: 0, skip: 0));
                                        });
                                      },
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Nenhum dado disponível.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
