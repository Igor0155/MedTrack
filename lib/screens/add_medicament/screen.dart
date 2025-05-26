import 'package:flutter/material.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/shared/components/med_appbar.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/shared/components/snackbar_message.dart';
import 'package:meditrack/shared/helpers/format_date.dart';
import 'package:meditrack/shared/types/exception_type.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final originalDate = TextEditingController();
  final expectedPurgeDate = TextEditingController();
  final formatDate = FormatDate();
  // final pickerCalendar = PickerCalendar();

  final _formKey = GlobalKey<FormState>();
  final input = Medicament(name: '', description: '', dosage: '', duration: '', formaFarm: '', quantity: '', id: '');
  List<String> selectedMarkersCuids = [];
  bool isFirstListMarkers = true;
  bool isFirstOriginalDate = true;
  bool isFirstExpectedPurgeDate = true;

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
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isGEDocsException == true) {
                  return warning(
                      label: state.gedocsExceptionMessage,
                      fun: () async => await state.detailsFile(widget.props.fsFileCuid));
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
                                d3TextFormField(
                                  labelText: 'Nome',
                                  autofocus: true,
                                  onSaved: (newValue) {
                                    input.name = "${newValue!}";
                                  },
                                  validator: inputUpdateDto.isValidName(),
                                ),
                                const SizedBox(height: 20),
                                if (state.getInfoFile?.scanned == true)
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    d3DropdownButtonFormField(
                                        value: state.getInfoFile?.pageType,
                                        label: 'Tipo de página',
                                        items: _listItemsPageType.map<DropdownMenuItem<String>>((value) {
                                          return DropdownMenuItem(
                                              value: value.key,
                                              child: Text(value.label,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 14)));
                                        }).toList(),
                                        onChanged: (String? value) {},
                                        onSaved: (newValue) {
                                          if (newValue != null && newValue.isNotEmpty) {
                                            inputUpdateDto.pageType = newValue;
                                          }
                                        },
                                        validator:
                                            state.getInfoFile?.scanned == true ? inputUpdateDto.isValidName() : null),
                                    const SizedBox(height: 20)
                                  ]),
                                SizedBox(
                                    width: 248,
                                    child: d3TextFormField(
                                        labelText: 'Data original',
                                        onSaved: (newValue) {
                                          if (newValue != null && originalDate.text.isNotEmpty) {
                                            inputUpdateDto.originalDate =
                                                formatDate.formatStringDateForAmericanStandard(originalDate.text);
                                          }
                                        },
                                        onChanged: (value) {
                                          originalDate.text = formatDate.formatDateWithOnChange(value);
                                          originalDate.selection = TextSelection.fromPosition(
                                              TextPosition(offset: originalDate.text.length));
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
                                        validator: inputUpdateDto.isValidDate())),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: 248,
                                    child: d3TextFormField(
                                        labelText: 'Data previsão expurgo',
                                        onSaved: (newValue) {
                                          if (newValue != null && expectedPurgeDate.text.isNotEmpty) {
                                            inputUpdateDto.expectedPurgeDate =
                                                formatDate.formatStringDateForAmericanStandard(expectedPurgeDate.text);
                                          }
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
                                        validator: inputUpdateDto.isValidDate())),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: double.infinity,
                                    child: D3ElevatedButton.primary(
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
                                        } on MediTrackException catch (e) {
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
              }),
        ),
      ),
    );
  }
}
