import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/api/cuota_api.dart';
import 'package:royal_prestige/src/model/api_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<ApiModel> login(String user, String passwd) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/validar_sesion');

      final resp = await http.post(url, body: {
        'usuario_nickname': '$user',
        'usuario_contrasenha': '$passwd',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);

      final int code = decodedData['result']['code'];
      ApiModel loginModel = ApiModel();
      loginModel.code = code.toString();
      loginModel.message = decodedData['result']['message'];

      if (code == 1) {
        final cuotaApi = CuotaApi();

        await cuotaApi.getCuotas();
        StorageManager.saveData('idUser', decodedData['data']['c_u']);
        StorageManager.saveData('idPerson', decodedData['data']['c_p']);
        StorageManager.saveData('userNickname', decodedData['data']['_n']);
        StorageManager.saveData('userEmail', decodedData['data']['u_e']);
        StorageManager.saveData('userImage', decodedData['data']['u_i']);
        StorageManager.saveData('personName', decodedData['data']['p_n']);
        StorageManager.saveData('personSurname', decodedData['data']['p_p']);
        StorageManager.saveData('personSecondSurname', decodedData['data']['p_m']);
        StorageManager.saveData('personDNI', decodedData['data']['dni']);
        StorageManager.saveData('idRoleUser', decodedData['data']['ru']);
        StorageManager.saveData('personCargo', decodedData['data']['u_c']);
        StorageManager.saveData('roleName', decodedData['data']['rn']);
        StorageManager.saveData('token', decodedData['data']['tn']);

        return loginModel;
      } else {
        return loginModel;
      }
    } catch (e) {
      ApiModel api = ApiModel();
      api.code = '2';
      api.message = 'Ocurrió un error';
      print('Erro Api Login: $e');
      return api;
    }
  }

  Future<ApiModel> consultarUsuario() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Admin/consultar_estado_usuario');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);

      final int code = decodedData['result']['code'];
      ApiModel loginModel = ApiModel();
      loginModel.code = code.toString();
      loginModel.message = decodedData['result']['message'];
      return loginModel;
    } catch (e) {
      ApiModel api = ApiModel();
      api.code = '2';
      api.message = 'Ocurrió un error';
      print('Erro Api Login: $e');
      print(e);
      return api;
    }
  }
}
