// lib/views/shopping/shopping_screen.dart
import 'package:devmob_coloc_flutter_project/models/shopping_item.dart';
import 'package:devmob_coloc_flutter_project/providers/auth_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/shopping_service.dart';

class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
  final _itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(shoppingListProvider);
    final colocationId = ref.watch(userColocationIdProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Ajouter un article
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    hintText: "Ajouter un article (lait, pain...)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.add_circle, color: Colors.teal, size: 32),
                onPressed: () {
                  if (_itemController.text.trim().isEmpty ||
                      colocationId == null) return;

                  final user = ref.read(currentUserProvider).value!;
                  final item = ShoppingItem(
                    id: '',
                    name: _itemController.text.trim(),
                    isChecked: false,
                    addedBy: user.uid,
                    addedByName: user.displayName,
                    addedAt: DateTime.now(),
                  );

                  ShoppingService().addItem(colocationId, item);
                  _itemController.clear();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Liste
          Expanded(
            child: itemsAsync.when(
              data: (items) => items.isEmpty
                  ? const Center(child: Text("La liste de courses est vide"))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index] as ShoppingItem;
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: item.isChecked,
                              onChanged: (val) {
                                ShoppingService()
                                    .toggleItem(colocationId!, item.id, val!);
                              },
                            ),
                            title: Text(
                              item.name,
                              style: GoogleFonts.poppins(
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text("Ajouté par ${item.addedByName}"),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text("Erreur")),
            ),
          ),
        ],
      ),
    );
  }
}
