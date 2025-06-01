import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditrack/screens/home/type/medicament.dart';

class MedicamentFireService {
  final CollectionReference _medicamentRef = FirebaseFirestore.instance.collection('medicine');

  Future<void> adicionarMedicamento(MedicamentRepositoryFire medicamento) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Usuário não autenticado.");

    await _medicamentRef.add(medicamento.toJson(uid));
  }

  Future<List<MedicamentRepositoryFire>> buscarMedicamentos() async {
    List<MedicamentRepositoryFire> medicamentos = List.of([]);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Usuário não autenticado.");

    final snapshot = await _medicamentRef.where('author_uid', isEqualTo: uid).get();
    for (var doc in snapshot.docs) {
      if (doc.data() != null) {
        medicamentos.add(
          MedicamentRepositoryFire.fromJson(doc.data() as Map<String, dynamic>, doc.id),
        );
      }
    }
    return medicamentos;
  }

  Future<List<int>> buscarTodosMedicamentosIds() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Usuário não autenticado.");

    final snapshot = await _medicamentRef.where('author_uid', isEqualTo: uid).get();
    return snapshot.docs
        .map((doc) => MedicamentRepositoryFire.fromJson(doc.data() as Map<String, dynamic>, doc.id).medicineId)
        .toList();
  }

  Future<MedicamentRepositoryFire?> buscarMedicamentoPorId(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Usuário não autenticado.");

    final doc = await _medicamentRef.doc(id).get();
    if (doc.exists && doc['author_uid'] == uid) {
      return MedicamentRepositoryFire.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null; // Retorna null se o documento não existir ou não pertencer ao usuário
  }

  Future<void> atualizarMedicamento(MedicamentRepositoryFire medicamento) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Usuário não autenticado.");
    if (medicamento.authorUid != uid) {
      throw Exception("Permissão negada: este documento não pertence ao usuário atual.");
    }

    var doc = _medicamentRef.doc(medicamento.id);
    if (!doc.id.isNotEmpty) {
      throw Exception("Documento não encontrado.");
    }
    return await doc.update(medicamento.toJson(uid));
  }

  Future<void> deletarMedicamento(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Usuário não autenticado.");

    final doc = await _medicamentRef.doc(id).get();
    if (!doc.exists || doc['author_uid'] != uid) {
      throw Exception("Permissão negada: este documento não pertence ao usuário atual.");
    }

    return await _medicamentRef.doc(id).delete();
  }
}
