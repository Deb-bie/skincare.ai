import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myskiin/services/data_manager/hive_models/hive_assessment_model.dart';

class AssessmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'assessments';


  Future<void> upsertAssessment(String userId, HiveAssessmentModel assessment) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection(_collection)
          .doc(assessment.id);

      await docRef.set(
        assessment.toFirebaseMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to upsert assessment: $e');
    }
  }

}