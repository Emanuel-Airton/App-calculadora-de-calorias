import 'package:app_calorias_diarias/calcular%20calorias/domain/models/calorias_model.dart';
import 'package:app_calorias_diarias/chat/domain/models/macronutrientes.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:hive/hive.dart';

class AuthModel {
  String? userName;
  String? userEmail;
  String? photoUrl;
  String? userId;
  AuthUserModel? authUserModel;

  AuthModel({
    this.userName,
    this.userEmail,
    this.photoUrl,
    this.userId,
    AuthUserModel? authUserModel,
  }) : authUserModel = authUserModel ?? AuthUserModel.dadosCompletos();

  factory AuthModel.fromJson({
    required String? userName,
    required String? userEmail,
    String? photoUrl,
    required String? userId,
  }) {
    return AuthModel(
      userName: userName,
      userEmail: userEmail,
      photoUrl: photoUrl,
      userId: userId,
      // authUserModel: AuthUserModel.dados(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'userEmail': userEmail,
      'photo': photoUrl,
      'userId': userId,
      'authUserModel': authUserModel?.toMap(),
    };
  }
}

@HiveType(typeId: 2)
class AuthUserModel extends HiveObject {
  @HiveField(0)
  String? genero;

  @HiveField(1)
  double? peso;

  @HiveField(2)
  double? altura;

  @HiveField(3)
  int? idade;

  @HiveField(4)
  String? nivelAtividade;

  @HiveField(5)
  String? objetivo;

  @HiveField(6)
  MacronutrientesModel? macronutrientesDiarios;

  @HiveField(7)
  CaloriasModel? caloriasModel;

  @HiveField(8)
  PlanoAlimentar? planoAlimentar;

  AuthUserModel.dados({
    this.genero,
    this.peso,
    this.altura,
    this.idade,
    this.nivelAtividade,
    this.objetivo,
  });

  AuthUserModel.dadosCompletos({
    this.genero,
    this.peso,
    this.altura,
    this.idade,
    this.nivelAtividade,
    this.objetivo,
    this.macronutrientesDiarios,
    this.caloriasModel,
    this.planoAlimentar,
  });
  factory AuthUserModel.fromMap({Map? readMap}) {
    return AuthUserModel.dadosCompletos(
      genero: readMap?['genero'],
      peso: readMap?['peso'],
      altura: readMap?['altura'],
      idade: readMap?['idade'],
      nivelAtividade: readMap?['nivelAtividade'],
      objetivo: readMap?['objetivo'],
      macronutrientesDiarios: readMap?['macronutrientesDiarios'],
      caloriasModel: readMap?['caloriasModel'],
      planoAlimentar: readMap?['planoAlimentar'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'genero': genero,
      'peso': peso,
      'altura': altura,
      'idade': idade,
      'nivelAtividade': nivelAtividade,
      'objetivo': objetivo,
      'macronutrientesDiarios': macronutrientesDiarios,
      'caloriasModel': caloriasModel,
      'planoAlimentar': planoAlimentar,
    };
  }

  String authString() {
    return 'idade:{$idade}, peso:{$peso}, altura:{$altura}, genero:{$genero}, nivel de atividade:{$nivelAtividade}, objetivo: {$objetivo}, calorias ${macronutrientesDiarios?.calorias.toString()}';
  }
}

class AuthUserModelAdapter extends TypeAdapter<AuthUserModel> {
  @override
  final int typeId = 0;

  @override
  AuthUserModel read(BinaryReader reader) {
    return AuthUserModel.fromMap(readMap: reader.readMap());
  }

  @override
  void write(BinaryWriter writer, AuthUserModel obj) {
    writer.writeMap(obj.toMap());
  }
}
