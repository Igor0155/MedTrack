import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/screens/auth/login/components/auto_login.dart';
import 'package:meditrack/screens/auth/login/components/commom_widget.dart';
import 'package:meditrack/screens/auth/login/components/enter_credentials.dart';
import 'package:meditrack/screens/auth/login/service.dart';
import 'package:meditrack/screens/auth/login/type.dart';
import 'package:meditrack/shared/components/snackbar_message.dart';
import 'package:meditrack/shared/stores/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final service = ServiceLogin();
  final _formKey = GlobalKey<FormState>();
  final inputLoginDto = InputLoginDto(login: "", password: "", isSaveInputLogin: false, name: '');
  bool isButtondisableClick = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Verifica se existe um login salvo
      await checkLoginMethod();
    });
  }

  Future<void> checkLoginMethod() async {
    // Verifica se existe um login salvo no decodificador
    final result = await service.authConfigState.checkUserLoginInSecureStorage();
    // Se existir, preenche os campos de login, senha e nome
    if (result != null) {
      // Preenche os campos de login e senha e nome
      inputLoginDto.name = result.n;
      inputLoginDto.login = result.u;
      inputLoginDto.password = result.p;
      inputLoginDto.isSaveInputLogin = true;
    }
  }

  // Função para realizar o login e validar as permissões do usuário
  Future<void> loginAnValidateUserPermissions(BuildContext context) async {
    try {
      // Chama o endpoint de login e retorna o token
      var result = await service.loginServiceExecute(inputLoginDto);

      if (!context.mounted) return;
      // Adicionando o token no authProvider
      ref.read(authProvider.notifier).login(result.token);

      final authState = ref.watch(authProvider);
      // adicionando as permissoes no D3Can
      // ref
      //     .read(d3CanProvider.notifier)
      //     .addAllPermissions(authState.infoToken?.permissions ?? []);

      // Salvando o nome do usuário no local storage
      await service.loginController.assignUsernameIfLocalDataExists(authState.infoToken?.name ?? '');

      if (!context.mounted) return;
      // validações
      if (result.changePasswordNextLogin != true) {
        if (authState.isAuthenticated) {
          if (authState.infoToken!.type == "CTM") {
            context.replace('/home');
          } else {
            context.showSnackBarInfo(
                'Você está logando com um usuário de ${authState.infoToken!.type == 'CPN' ? 'empresa' : authState.infoToken!.type == 'SYS' ? 'administrador do sistema' : 'grupo de cliente'}.',
                const Duration(seconds: 10));
            if (authState.infoToken!.type == 'CGR') {
              context.replace('/select_customer');
            } else {
              context.replace('/select_company');
            }
          }
        } else {
          context.showSnackBarError('Você não está autenticado. Contate a TI');
        }
      } else {
        context.showSnackBarInfo(
            'Detectamos o uso de uma senha padrão em sua conta. Para garantir a sua segurança, é essencial estabelecer uma nova senha pessoal e única.');
        context.replace('/auth_change_password', extra: inputLoginDto);
      }
    } on Exception catch (e) {
      service.authConfigState.setLoading(false);
      if (!context.mounted) return;
      context.showSnackBarError(e.toString());
      await changeLoginAccess();
    }
  }

  // chamando a função de mudar o método de login para o usuário digitar o login e a senha
  Future<void> changeLoginAccess() async {
    await service.authConfigState.changeMethodLoginSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
          listenable: service.authConfigState,
          builder: (context, child) {
            if (service.authConfigState.isLoading) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Center(child: CircularProgressIndicator()));
            } else if (service.authConfigState.containsLoginSaved) {
              return commomWidget(
                formKey: _formKey,
                logoUrl: 'service.authConfigState.systemConfig?.company.logoUrl',
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AutoLogin(
                      inputLoginDto: inputLoginDto,
                      onPressedButtonAccess: () async {
                        if (isButtondisableClick) return;
                        setState(() {
                          isButtondisableClick = true;
                        });
                        await loginAnValidateUserPermissions(context);
                        setState(() {
                          isButtondisableClick = false;
                        });
                      },
                      childButtonAccess: (isButtondisableClick)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).colorScheme.onSurface, strokeAlign: 2, strokeWidth: 2)))
                          : null,
                      onPressedButtonChange: () async {
                        await changeLoginAccess();
                      }),
                ),
                fixedSizedAndMaxHeight: true,
              );
            } else {
              return SingleChildScrollView(
                child: commomWidget(
                  formKey: _formKey,
                  logoUrl: 'service.authConfigState.systemConfig?.company.logoUrl',
                  child: Container(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        EnterCredentials(
                          onSavedLogin: (newValue) => inputLoginDto.login = newValue!.toLowerCase(),
                          validatorLogin: inputLoginDto.isValidLogin(),
                          onSavedPassword: (newValue) => inputLoginDto.password = newValue!,
                          validatorPassword: inputLoginDto.isValidPassword(),
                          isSaveLoginSwitch: inputLoginDto.isSaveInputLogin,
                          onItemSelected: (value) {
                            inputLoginDto.isSaveInputLogin = value;
                          },
                          onPressedButtonAccess: () async {
                            if (isButtondisableClick) return;
                            setState(() {
                              isButtondisableClick = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await loginAnValidateUserPermissions(context);
                            }
                            setState(() {
                              isButtondisableClick = false;
                            });
                          },
                          childButtonAccess: (isButtondisableClick)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          strokeAlign: 2,
                                          strokeWidth: 2)))
                              : null,
                          onPressButtonForgotPassword: () {
                            context.go('/forgot_password');
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 16, top: 30),
                          alignment: Alignment.center,
                          child:
                              Text('© Tecnologia CélulaTech', style: TextStyle(color: Colors.grey[700], fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
