import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suhail_project/data_model.dart';

DataModel? model;
int indexList = 0;
late List<DataModel> modelList;

Future<List<DataModel>> getData() async {
  modelList = [];

  // Use await to wait for the completion of the Firestore query
  await FirebaseFirestore.instance.collection('quizQA').get().then((value) {
    for (var item in value.docs) {
      DataModel model = DataModel.fromJson(item.data());
      modelList.add(model);
      print(model);
    }
  });

  return modelList;
}

// Function to retrieve a single model and store it in the 'model' variable
DataModel? getSingleModel() {
  if (modelList.isNotEmpty) {
    model = modelList[indexList++];
    indexList = (indexList + 1) %
        modelList.length; // Move to the next model in a circular manner

    // Reset the index to 0 if it reaches the end of the list
    if (indexList == 0) {
      // You can add additional logic here if needed
    }

    return model;
  } else {
    return null; // Handle the case where the modelList is empty
  }
}
