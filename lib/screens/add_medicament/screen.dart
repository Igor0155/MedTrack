import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/screens/add_medicament/state.dart';
import 'package:meditrack/screens/add_medicament/type.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/shared/components/drop_down_button_formfield.dart';
import 'package:meditrack/shared/components/drop_down_select.dart';
import 'package:meditrack/shared/components/med_appbar.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/shared/components/med_elevated_button.dart';
import 'package:meditrack/shared/components/picker_calendar.dart';
import 'package:meditrack/shared/components/snackbar_message.dart';
import 'package:meditrack/shared/components/text_form_field.dart';
import 'package:meditrack/shared/components/warning.dart';
import 'package:meditrack/shared/helpers/format_date.dart';
import 'package:meditrack/shared/services/client_http_interface.dart';
import 'package:meditrack/shared/types/exception_type.dart';

class AddMedicament extends StatefulWidget {
  const AddMedicament({super.key});

  @override
  State<AddMedicament> createState() => _AddMedicamentState();
}

class _AddMedicamentState extends State<AddMedicament> {
  final originalDate = TextEditingController();
  final expectedPurgeDate = TextEditingController();
  final formatDate = FormatDate();
  final pickerCalendar = PickerCalendar();
  final state = AddMedicamentState(client: getIt.get<IClientHttp>());

  final _formKey = GlobalKey<FormState>();
  final input = Medicament(name: '', description: '', dosage: '', duration: '', formaFarm: '', quantity: '', id: '');
  List<String> selectedMarkersCuids = [];
  bool isFirstListMarkers = true;
  bool isFirstOriginalDate = true;
  bool isFirstExpectedPurgeDate = true;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      try {
        if (mounted) await state.searchMedicaments();
      } on Exception catch (e) {
        if (!mounted) return;
        context.showSnackBarError(e.toString());
      }
    });
  }

  Future<bool> _formUpdateSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // var result = await state.update(widget.props.fsFileCuid, inputUpdateDto);
      // if (result) {
      //   widget.props.state.changeNameChildren(widget.props.fsFileCuid, inputUpdateDto.newFileName);
      //   return result;
      // }
      return false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: medAppBar(title: 'Adicionar Medicamento'),
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: ListenableBuilder(
              listenable: state,
              builder: (context, _) {
                if (state.isLoading == true && state.isMedException == false) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isMedException == true) {
                  return warning(label: state.medExceptionMessage, fun: () async => await state.searchMedicaments());
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3, spreadRadius: 0.1),
                            BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2, spreadRadius: 0.3)
                          ]),
                          child: const Divider(height: 0)),
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // nome medicamento D3DropDownSelectItems

                                // MedDropDownSelectItems<MedicamentBularioDto>(
                                //   list: state.getMedicaments?.medicaments ?? [],
                                //   initalSelectedItems: const [],
                                //   label: 'Medicamento',
                                //   getLabel: (item) => '${item.nomeComercial} - ${item.principioAtivo}',
                                //   getKey: (item) => item.id,
                                //   getLeadingIcon: (icon) {
                                //     //return GEDocsIcons.icon(icon.active ? "unlock" : "lock");
                                //     return const Icon(Icons.lock_open);
                                //   },
                                //   onItemSelected: (selectedItem) async {},
                                // ),

                                //dosagem () medTextFormField

                                // forma farmaceutica D3DropDownformfield

                                // frequencia (horas) timer medTextFormField

                                // duração dias timer medTextFormField

                                //observação

                                medTextFormField(
                                  labelText: 'Nome',
                                  autofocus: true,
                                  onSaved: (newValue) {
                                    input.name = newValue!;
                                  },
                                  //validator: inputUpdateDto.isValidName(),
                                ),
                                const SizedBox(height: 20),
                                // if (state.getInfoFile?.scanned == true)
                                //   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                //     medDropdownButtonFormField(
                                //         value: state.getInfoFile?.pageType,
                                //         label: 'Tipo de página',
                                //         items: _listItemsPageType.map<DropdownMenuItem<String>>((value) {
                                //           return DropdownMenuItem(
                                //               value: value.key,
                                //               child: Text(value.label,
                                //                   overflow: TextOverflow.ellipsis,
                                //                   style: const TextStyle(fontSize: 14)));
                                //         }).toList(),
                                //         onChanged: (String? value) {},
                                //         onSaved: (newValue) {
                                //           if (newValue != null && newValue.isNotEmpty) {
                                //             inputUpdateDto.pageType = newValue;
                                //           }
                                //         },
                                //         validator:
                                //             state.getInfoFile?.scanned == true ? inputUpdateDto.isValidName() : null),
                                //     const SizedBox(height: 20)
                                //   ]),
                                SizedBox(
                                    width: 248,
                                    child: medTextFormField(
                                      labelText: 'Data original',
                                      onSaved: (newValue) {
                                        // if (newValue != null && originalDate.text.isNotEmpty) {
                                        //   inputUpdateDto.originalDate =
                                        //       formatDate.formatStringDateForAmericanStandard(originalDate.text);
                                        // }
                                      },
                                      onChanged: (value) {
                                        originalDate.text = formatDate.formatDateWithOnChange(value);
                                        originalDate.selection =
                                            TextSelection.fromPosition(TextPosition(offset: originalDate.text.length));
                                      },
                                      keyboardType: TextInputType.datetime,
                                      controller: originalDate,
                                      buildCounter: (context,
                                              {required currentLength, required isFocused, required maxLength}) =>
                                          const SizedBox(),
                                      maxLength: 10,
                                      suffixIcon: IconButton(
                                          icon: const Icon(Icons.calendar_month_outlined),
                                          onPressed: () async {
                                            var date = await pickerCalendar.pickerCalendar(
                                                context: context, controller: originalDate);
                                            if (date != null) {
                                              setState(() {
                                                originalDate.value =
                                                    TextEditingValue(text: formatDate.formatDate(date.toString()));
                                              });
                                            }
                                          }),
                                      //validator: inputUpdateDto.isValidDate(),
                                    )),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: 248,
                                    child: medTextFormField(
                                      labelText: 'Data previsão expurgo',
                                      onSaved: (newValue) {
                                        // if (newValue != null && expectedPurgeDate.text.isNotEmpty) {
                                        //   inputUpdateDto.expectedPurgeDate =
                                        //       formatDate.formatStringDateForAmericanStandard(expectedPurgeDate.text);
                                        // }
                                      },
                                      onChanged: (value) {
                                        expectedPurgeDate.text = formatDate.formatDateWithOnChange(value);
                                        expectedPurgeDate.selection = TextSelection.fromPosition(
                                            TextPosition(offset: expectedPurgeDate.text.length));
                                      },
                                      keyboardType: TextInputType.datetime,
                                      controller: expectedPurgeDate,
                                      buildCounter: (context,
                                              {required currentLength, required isFocused, required maxLength}) =>
                                          const SizedBox(),
                                      maxLength: 10,
                                      suffixIcon: IconButton(
                                          icon: const Icon(Icons.calendar_month_outlined),
                                          onPressed: () async {
                                            var date = await pickerCalendar.pickerCalendar(
                                                context: context,
                                                controller: expectedPurgeDate,
                                                firstDate: formatDate.getTomorrowDate());
                                            if (date != null) {
                                              setState(() {
                                                expectedPurgeDate.value =
                                                    TextEditingValue(text: formatDate.formatDate(date.toString()));
                                              });
                                            }
                                          }),
                                      //  validator: inputUpdateDto.isValidDate(),
                                    )),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: double.infinity,
                                    child: MedElevatedButton.primary(
                                      label: 'Salvar',
                                      onPressed: () async {
                                        try {
                                          var result = await _formUpdateSubmit();
                                          if (result == true) {
                                            if (!context.mounted) return;
                                            context.showSnackBarSuccess('Informações atualizada.');
                                            if (context.mounted) {
                                              context.pop();
                                            }
                                          }
                                        } on MedTrackException catch (e) {
                                          if (!context.mounted) return;
                                          context.showSnackBarError(e.toString());
                                        }
                                      },
                                    )),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                }
              },
            )),
      ),
    );
  }
}
