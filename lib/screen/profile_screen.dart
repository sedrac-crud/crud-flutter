import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_flutter/blocks/auth_person_cubit.dart';
import 'package:crud_flutter/services/auth_person_service.dart';
import 'package:crud_flutter/util/app_colors.dart';
import 'package:crud_flutter/widgets/auth_person_form.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthPersonService _authPersonService;

  @override
  void initState() {
    _authPersonService = AuthPersonService();
    super.initState();
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sair da Aplicação'),
          content: const Text('Tem certeza que deseja sair da aplicação?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                SystemNavigator.pop();
              },
              child: const Text('Sim', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authPersonCubit = context.watch<AuthPersonCubit>();
    final person = context.watch<AuthPersonCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil", style: GoogleFonts.lexend(fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(context: context, builder: (_) {
                return AuthPersonForm(initialAuthPerson: person, onSubmit: (item){
                  try{
                    _authPersonService.update(item).then((it) {
                      authPersonCubit.setPerson(it);
                    }).catchError((e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível editar o usuário'),));
                    });
                  }finally {
                    Navigator.pop(context);
                  }
                },);
              });
            },
            icon: Icon(Icons.edit, color: AppColors.colorIconInput),
          ),

          IconButton(
            onPressed: () {
              _showExitConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'person_image_${person.id}',
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: person.image,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${person.firstName} ${person.lastName}",
              style: GoogleFonts.lexend(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              '@${person.username}',
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              person.username,
              style: GoogleFonts.lato(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              icon: Icons.email,
              label: 'Email',
              value: person.email,
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.person_outline,
              label: 'Gênero',
              value: person.gender == 'male'
                  ? 'Masculino'
                  : (person.gender == 'female' ? 'Feminino' : 'Outro'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
