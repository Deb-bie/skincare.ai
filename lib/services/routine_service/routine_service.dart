import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_manager/hive_models/routines/hive_routine_model.dart';

class RoutineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'routines';


  Future<void> upsertRoutine(String userId, HiveRoutineModel routine) async {
    try {
      final docRef =  _firestore
          .collection('users')
          .doc(userId)
          .collection(_collection)
          .doc(routine.id);

      await docRef.set(
        routine.toFirebaseMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to upsert routine: $e');
    }
  }
}






