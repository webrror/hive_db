import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _items = []; // TO STORE ITEMS FROM THE HIVE DB

  final _shoppingBox = Hive.box('ShoppingBag');
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();

  void _refreshItems() {
    final data = _shoppingBox.keys.map((index) {
      final value = _shoppingBox.get(index);
      return {
        "key": index,
        "name": value["name"],
        "quantity": value["quantity"]
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  // Create new item
  Future<void> _addItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems(); // update the UI
  }

  // Update item
  Future<void> _updateItem(int key, Map<String, dynamic> newItem) async {
    await _shoppingBox.put(key, newItem);
    _refreshItems(); // update the UI
  }

  // Delete item
  Future<void> _deleteItem(int key) async {
    await _shoppingBox.delete(key);
    _refreshItems(); // update the UI
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  showFormSheet(BuildContext context, int? itemKey) {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element["key"] == itemKey);
      name.text = existingItem["name"];
      quantity.text = existingItem["quantity"];
    }
    if (itemKey == null) {
      name.text = '';
      quantity.text = '';
    }
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      isScrollControlled: true,
      elevation: 2,
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemKey == null ? 'Add a new item' : 'Update item',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        padding: EdgeInsets.zero,
                        width: 30,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(FluentIcons.dismiss_20_filled),
                          padding: EdgeInsets.zero,
                          //constraints: const BoxConstraints(),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    textInputAction: TextInputAction.next),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: quantity,
                    minLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                    ],
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    textInputAction: TextInputAction.done),
                const SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).primaryIconTheme.color,
                          minimumSize: const Size(100, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        if (itemKey == null) {
                          // Add new item
                          if (itemKey == null) {
                            _addItem({
                              "name": name.text,
                              "quantity": quantity.text
                            }).then((value) => Fluttertoast.showToast(
                                msg: 'Added successfully',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM));
                          }
                          name.text = '';
                          quantity.text = '';
                          Navigator.pop(context);
                        }
                        if (itemKey != null) {
                          _updateItem(itemKey, {
                            "name": name.text,
                            "quantity": quantity.text
                          }).then((value) => Fluttertoast.showToast(
                              msg: 'Updated successfully',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM));
                          name.text = '';
                          quantity.text = '';
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        itemKey == null ? 'Add' : 'Update',
                        //style: TextStyle(color: Theme.of(context).textTheme.headlineSmall!.color),
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Example"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final currentItem = _items[index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          currentItem["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text.rich(TextSpan(
                          style: const TextStyle(fontSize: 16),
                          children: [
                            const TextSpan(text: 'Qty. '),
                            TextSpan(text: currentItem["quantity"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          ]
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Edit button
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showFormSheet(context, currentItem["key"]);
                                }),
                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteItem(currentItem["key"]).then((value) => Fluttertoast.showToast(
                                  msg: 'Item deleted',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: _items.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormSheet(context, null);
        },
        shape: const CircleBorder(),
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }
}
