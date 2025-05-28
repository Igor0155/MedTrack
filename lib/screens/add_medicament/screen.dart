import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/screens/add_medicament/state.dart';
import 'package:meditrack/screens/add_medicament/type.dart';
import 'package:meditrack/screens/home/state.dart';
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
import 'package:meditrack/shared/extensions/to_title_case.dart';
import 'package:meditrack/shared/helpers/format_date.dart';
import 'package:meditrack/shared/services/client_http_interface.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';
import 'package:meditrack/shared/types/exception_type.dart';
import 'package:meditrack/shared/types/medicines.dart';

class CreateMedicine extends StatefulWidget {
  final MedicamentStateNotifier stateFire;
  const CreateMedicine({super.key, required this.stateFire});

  @override
  State<CreateMedicine> createState() => _CreateMedicineState();
}

class _CreateMedicineState extends State<CreateMedicine> {
  final originalDate = TextEditingController();
  final expectedPurgeDate = TextEditingController();
  final formatDate = FormatDate();
  final pickerCalendar = PickerCalendar();
  final state = AddMedicamentState(client: getIt.get<IClientHttp>(), clientMedicine: getIt.get<DioClientMedicine>());
  final _listPharmaceuticalForm = [
    PharmaceuticalForm(key: 'CMP', label: 'Comprimido'),
    PharmaceuticalForm(key: 'CAP', label: 'Cápsula'),
    PharmaceuticalForm(key: 'SOL', label: 'Solução Oral'),
    PharmaceuticalForm(key: 'INJ', label: 'Injetável'),
    PharmaceuticalForm(key: 'OUT', label: 'Outro'),
  ]; // Forma farmacêutica (comprimido, cápsula, solução oral, injetável etc.)
  final _formKey = GlobalKey<FormState>();
  final input = MedicamentRepositoryFire(
      authorUid: "", medicineId: 0, medicineName: '', description: '', dosage: '', duration: '', formaFarm: '', id: '');

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      if (mounted) await state.loadMedicaments();
    });
  }

  Future<bool> _formCreateSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await widget.stateFire.add(input);

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
                  return warning(label: state.medExceptionMessage, fun: () async => await state.loadMedicaments());
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
                                MedDropDownSelectItems<MedicineDto>(
                                  list: state.getMedicaments?.results ?? [],
                                  initalSelectedItems: List.of([]),
                                  label: 'Medicamento Prescrito',
                                  getLabel: (item) => item.name.toTitleCase(),
                                  getKey: (item) => item.id,
                                  getLeadingIcon: (icon) {
                                    return const Icon(Icons.medication_sharp);
                                  },
                                  onSearchRemote: (searchText) async {
                                    try {
                                      return await state.searchMedicine(searchText);
                                    } on Exception catch (e) {
                                      if (context.mounted) {
                                        context.showSnackBarError('Erro ao buscar medicamentos: $e');
                                      }
                                      return List<MedicineDto>.of([]);
                                    }
                                  },
                                  onItemSelected: (selectedItem) async {
                                    if (selectedItem.selected.isNotEmpty) {
                                      input.medicineId = selectedItem.selected.first;
                                      input.medicineName = selectedItem.item?.name.toTitleCase() ?? '';
                                    }
                                  },
                                  validator: input.isRequired(),
                                ),

                                const SizedBox(height: 20),
                                medTextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                      final RegExp regExp = RegExp(r'^-?\d*$');

                                      if (regExp.hasMatch(newValue.text)) {
                                        return newValue;
                                      }
                                      return oldValue;
                                    }),
                                  ],
                                  labelText: 'Dosagem (ex: 500 mg, 10 mg/mL ou 1 comprimido)',
                                  onSaved: (newValue) {
                                    input.dosage = newValue!;
                                  },
                                  validator: input.isRequired(),
                                ),
                                const SizedBox(height: 20),
                                medDropdownButtonFormField(
                                    label: 'Forma Farmacêutica',
                                    items: _listPharmaceuticalForm.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                          value: value.key,
                                          child: Text(value.label,
                                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)));
                                    }).toList(),
                                    onChanged: (String? value) {},
                                    onSaved: (newValue) {
                                      if (newValue != null && newValue.isNotEmpty) {
                                        input.formaFarm = newValue;
                                      }
                                    },
                                    validator: input.isRequired()),
                                const SizedBox(height: 20),

                                // frequencia (horas) timer medTextFormField

                                // duração dias timer medTextFormField

                                //observação

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
                                medTextFormField(
                                  keyboardType: TextInputType.text,
                                  labelText: 'Observação',
                                  maxLines: 4,
                                  maxLength: 300,
                                  buildCounter: (context,
                                      {required currentLength, required isFocused, required maxLength}) {
                                    return Text("$currentLength/$maxLength", style: const TextStyle(fontSize: 12));
                                  },
                                  onSaved: (newValue) {
                                    input.description = newValue!;
                                  },
                                  validator: input.isRequired(),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: double.infinity,
                                    child: MedElevatedButton.primary(
                                      label: 'Salvar',
                                      onPressed: () async {
                                        try {
                                          var result = await _formCreateSubmit();
                                          if (result == true) {
                                            if (!context.mounted) return;
                                            context.showSnackBarSuccess('Medicamento adicionado.');
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
