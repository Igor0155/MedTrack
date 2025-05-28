import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditrack/screens/home/type/medicament.dart';

class MedicamentFireService {
  final CollectionReference _medicamentRef = FirebaseFirestore.instance.collection('medicine');
  final _user = FirebaseAuth.instance.currentUser;

  Future<void> adicionarMedicamento(MedicamentRepositoryFire medicamento) async {
    await _medicamentRef.add(medicamento.toJson(_user?.uid ?? ''));
    return;
  }

  Stream<List<MedicamentRepositoryFire>> listarMedicamentos() {
    return _medicamentRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MedicamentRepositoryFire.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> atualizarMedicamento(MedicamentRepositoryFire medicamento) {
    return _medicamentRef.doc(medicamento.id).update(medicamento.toJson(_user?.uid ?? ''));
  }

  Future<void> deletarMedicamento(String id) {
    return _medicamentRef.doc(id).delete();
  }
}
