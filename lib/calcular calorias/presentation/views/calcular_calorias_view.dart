import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/button_calcular_calorias.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/dropdownButtom_genero.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/dropdownButtom_nivelAtividade.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/textFormField_altura.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/textfield_idade.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/textfield_peso.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/tougleButton_objetivo.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalcularCaloriasView extends StatefulWidget {
  const CalcularCaloriasView({super.key});

  @override
  State<CalcularCaloriasView> createState() => _CalcularCaloriasViewState();
}

class _CalcularCaloriasViewState extends State<CalcularCaloriasView> {
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.6,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              /* child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Calcular calorias',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Genero',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                child: DropdownbuttomGenero(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                'Idade',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.4,

                                child: TextFormFieldIdade(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Peso',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextFieldPeso(),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Altura',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextformfieldAltura(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      Text(
                        'Nivel de atividade',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownbuttomNivelatividade(),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Seu objetivo',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TouglebuttonObjetivo(),
                      SizedBox(height: 15),
                      ButtonCalcularCalorias(formkey: _key),
                    ],
                  ),
                ),
              ),*/
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: 20,
            right: 20,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Calcular calorias',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Genero',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.4,
                                    child: DropdownbuttomGenero(),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    'Idade',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.4,

                                    child: TextFormFieldIdade(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Peso',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextFieldPeso(),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Altura',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextformfieldAltura(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          Text(
                            'Nivel de atividade física',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownbuttomNivelatividade(),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Seu objetivo',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TouglebuttonObjetivo(),
                          SizedBox(height: 15),
                          ButtonCalcularCalorias(formkey: _key),
                          ElevatedButton(
                            onPressed: () async {
                              context
                                  .read<CaloriasProvider>()
                                  .setCaloriasConsumidas(caloriasConsumidas: 0);
                              await context
                                  .read<ChatProvider>()
                                  .resetarRefeicoes();
                              context.read<UserProfileProvider>().updateProfile(
                                caloriasConsumidas: 0,
                              );
                            },
                            child: Text('resetar refeições'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
