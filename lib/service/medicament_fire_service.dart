import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditrack/screens/home/type/medicament.dart';

class MedicamentFireService {
  final CollectionReference _medicamentRef = FirebaseFirestore.instance.collection('medicine');

  Future<void> adicionarMedicamento(Medicament medicamento) {
    return _medicamentRef.add(medicamento.toJson());
  }

  Stream<List<Medicament>> listarMedicamentos() {
    return _medicamentRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Medicament.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> atualizarMedicamento(Medicament medicamento) {
    return _medicamentRef.doc(medicamento.id).update(medicamento.toJson());
  }

  Future<void> deletarMedicamento(String id) {
    return _medicamentRef.doc(id).delete();
  }
}
