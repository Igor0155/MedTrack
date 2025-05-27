import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/shared/components/med_elevated_button.dart';

class MedDropDownSelectItems<T> extends StatefulWidget {
  final Key? keyFormField;
  final bool isMultiSelect;
  final String label;
  final bool enabled;
  final List initalSelectedItems;
  final List<T> list;
  final String Function(T item) getLabel;
  final dynamic Function(T item) getKey;
  final Widget Function(T item)? getLeadingIcon;
  final String? Function(String?)? validator;
  final ValueChanged<List>? onItemSelected;
  final TextOverflow? overflow;

  const MedDropDownSelectItems({
    super.key,
    this.keyFormField,
    this.isMultiSelect = false,
    required this.initalSelectedItems,
    required this.onItemSelected,
    required this.label,
    this.enabled = true,
    required this.list,
    required this.getLabel,
    required this.getKey,
    this.validator,
    this.getLeadingIcon,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  State<MedDropDownSelectItems<T>> createState() => _MedDropDownSelectItemsState<T>();
}

class _MedDropDownSelectItemsState<T> extends State<MedDropDownSelectItems<T>> {
  final controller = TextEditingController();
  List selectedItems = List.of([]);

  @override
  void initState() {
    super.initState();
    selectedItems.clear();
    selectedItems = widget.initalSelectedItems;

    if (widget.initalSelectedItems.isNotEmpty && !widget.isMultiSelect) {
      // vai cair aqui se o item inicial selecionado e nao for uma selecão multipla
      if (widget.initalSelectedItems.length == 1 && widget.initalSelectedItems.first.runtimeType == T.runtimeType) {
        // Só vai cair aqui se o item inicial selecionado for um objeto e não for uma seleção multipla
        controller.text = widget.getLabel(widget.initalSelectedItems.first);
      } else if (widget.initalSelectedItems.length == 1 && widget.initalSelectedItems.first.isNotEmpty) {
        // caso ele for um objeto eu busco o objeto na lista passada para pegar a label dele
        final obj = widget.list.firstWhere(
          (item) => widget.getKey(item) == widget.initalSelectedItems.first,
          orElse: () => null as T,
        );
        controller.text = widget.getLabel(obj);
      } else {
        controller.text = '';
      }
    } else {
      controller.text = '';
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _showModalSelect(BuildContext context, List<T> list, String label) {
    setState(() {
      selectedItems = widget.initalSelectedItems;
    });

    return showModalBottomSheet(
        useSafeArea: true,
        clipBehavior: Clip.hardEdge,
        scrollControlDisabledMaxHeightRatio: 0.6,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          return _MedDropDownList<T>(
            isMultiSelect: widget.isMultiSelect,
            label: label,
            list: list,
            selectedItems: selectedItems,
            getLabel: widget.getLabel,
            getKey: widget.getKey,
            getLeadingIcon: widget.getLeadingIcon,
            overflow: widget.overflow,
            onItemsSelected: (selected) {
              setState(() {
                // lista de itens selecionados recebe a nova lista de itens selecionados
                selectedItems = selected;
              });
              // caso for selecão unica
              if (!widget.isMultiSelect) {
                // verifica se o item selecionado nao esta nulo
                if (widget.onItemSelected != null) {
                  widget.onItemSelected!(selected);
                }
                if (selected.isNotEmpty) {
                  // verifica se a key do item selecionado é igual a key do item da lista
                  final selectedKey = selected.first;
                  final selectedItem = widget.list.firstWhere(
                    (item) => widget.getKey(item) == selectedKey,
                    orElse: () => null as T,
                  );
                  // se for diferente de nulo o controller recebe o label do item selecionado
                  if (selectedItem != null) {
                    controller.text = widget.getLabel(selectedItem);
                  } else {
                    controller.text = '';
                  }
                } else {
                  controller.text = '';
                }
                Navigator.pop(context);
              } else {
                controller.text = '';
                if (widget.onItemSelected != null) {
                  widget.onItemSelected!(selected);
                }
              }
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: widget.keyFormField,
              controller: controller,
              keyboardAppearance: Brightness.dark,
              readOnly: true,
              decoration: InputDecoration(
                  enabled: widget.enabled,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  labelStyle: const TextStyle(fontSize: 14),
                  labelText: widget.label,
                  hintStyle: const TextStyle(fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
              style: const TextStyle(fontSize: 14),
              onTap: widget.enabled
                  ? () async {
                      await _showModalSelect(context, widget.list, widget.label);
                    }
                  : null,
              validator: widget.validator,
            ),
          ],
        ),
      );
    });
  }
}

class _MedDropDownList<T> extends StatefulWidget {
  final String label;
  final List<T> list;
  final bool isMultiSelect;
  final ValueChanged<List>? onItemsSelected;
  final List selectedItems;
  final String Function(T item) getLabel;
  final dynamic Function(T item) getKey;
  final Widget Function(T item)? getLeadingIcon;
  final TextOverflow? overflow;

  const _MedDropDownList({
    required this.label,
    required this.list,
    required this.selectedItems,
    required this.isMultiSelect,
    required this.getLabel,
    required this.onItemsSelected,
    required this.getKey,
    required this.getLeadingIcon,
    required this.overflow,
  });

  @override
  State<_MedDropDownList<T>> createState() => _MedDropDownListState<T>();
}

class _MedDropDownListState<T> extends State<_MedDropDownList<T>> {
  final duration = const Duration(milliseconds: 300);

  bool isInitSearch = false;
  late TextEditingController filterController;
  late List<T> filteredOptions;

  Timer? debounce;
  @override
  void initState() {
    super.initState();
    filterController = TextEditingController();
    filteredOptions = [...widget.list];
  }

  // buscar o texto dentro da lista de opções
  void onSearchTextChanged(String searchText) {
    if (filterController.text.isEmpty) {
      setState(() {
        isInitSearch = false;
      });
    } else {
      setState(() {
        isInitSearch = true;
      });
    }

    if (debounce?.isActive ?? false) debounce?.cancel();
    // verificar para não fazer chamada toda hora
    debounce = Timer(duration, () {
      if (searchText.isEmpty) {
        setState(() {
          filteredOptions = widget.list;
        });
      } else {
        searchText = searchText.toLowerCase();

        List<T> newList = widget.list.where((objData) {
          return widget.getLabel(objData).toLowerCase().contains(searchText);
        }).toList();
        setState(() {
          filteredOptions = newList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: SizedBox(width: 30, child: Divider(thickness: 3, height: 5))),
                  ListTile(
                      enabled: false,
                      title: Text(widget.label.isEmpty ? 'Selecine' : widget.label,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                        controller: filterController,
                        onChanged: onSearchTextChanged,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Pesquisar',
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: Icon(Icons.search_rounded))),
                  ),
                  if (widget.isMultiSelect)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MedElevatedButton.secondaryOutline(
                              label: 'Desmarcar Todos',
                              onPressed: () async {
                                widget.selectedItems.clear();
                                widget.onItemsSelected!(widget.selectedItems);
                                setState(() {});
                              },
                              visualDensity: VisualDensity.compact),
                          MedElevatedButton.primary(
                              label: 'Marcar Todos',
                              visualDensity: VisualDensity.compact,
                              onPressed: isInitSearch
                                  ? null
                                  : () {
                                      widget.selectedItems.clear();
                                      for (var element in widget.list) {
                                        widget.selectedItems.add(widget.getKey(element));
                                      }
                                      widget.onItemsSelected!(widget.selectedItems);
                                      setState(() {});
                                    }),
                        ],
                      ),
                    ),
                  const Divider(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredOptions.length,
                  itemBuilder: (context, index) {
                    // pegar o item
                    final item = filteredOptions[index];
                    // verificar se o item está selecionado
                    final isSelected = widget.selectedItems.contains(widget.getKey(item));

                    return ListTile(
                        visualDensity: const VisualDensity(vertical: -2),
                        onTap: () {
                          // selecionar apenas 1 item
                          if (!widget.isMultiSelect) {
                            // limpa a lista para selecionar apenas 1 item
                            widget.selectedItems.clear();

                            if (isSelected) {
                              // se estiver selecionado remove ele da lista
                              widget.selectedItems.remove(widget.getKey(item));
                            } else {
                              // se nao estiver seleiconado adiciona ele
                              widget.selectedItems.add(widget.getKey(item));
                            }
                            //  retorna caso nao seja nulo
                            if (widget.onItemsSelected != null) {
                              widget.onItemsSelected!(widget.selectedItems);
                            }
                          } else {
                            if (isSelected) {
                              // se estiver selecionado remove ele da lista
                              widget.selectedItems.remove(widget.getKey(item));
                            } else {
                              // se nao estiver seleiconado adiciona ele
                              widget.selectedItems.add(widget.getKey(item));
                            }

                            if (widget.onItemsSelected != null) {
                              widget.onItemsSelected!(widget.selectedItems); // Chama o callback com a lista atualizada
                            }
                          }
                          setState(() {});
                        },
                        selected: isSelected,
                        selectedTileColor: Theme.of(context).colorScheme.onSecondaryFixed.withOpacity(0.4),
                        selectedColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        leading: widget.getLeadingIcon != null ? widget.getLeadingIcon!(item) : null,
                        trailing: isSelected ? const Icon(Icons.check, size: 18) : null,
                        title: Text(widget.getLabel(filteredOptions[index]),
                            overflow: widget.overflow,
                            style:
                                TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.surfaceContainerHighest)));
                  }),
            ),
          ]),
          floatingActionButton: widget.isMultiSelect
              ? FloatingActionButton(
                  onPressed: () {
                    context.pop();
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary),
                )
              : null),
    );
  }
}
