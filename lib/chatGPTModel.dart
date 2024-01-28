import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:suhail_project/firebase_options.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async'; // to wait for 20s every 3 requests from the API

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
int requestCount = 0; // variable to count the number of requests

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await generateQuizQuestions();
}

// 1. Getting the documents IDs
Future<List<String>> getAllDocumentIds() async {
  List<String> documentIds = [];

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('quizContent').get();

    if (querySnapshot.docs.isNotEmpty) {
      // Iterate through the documents and add their IDs to the list
      querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        documentIds.add(doc.id);
      });
    }

    return documentIds;
  } catch (e) {
    print('Error: $e');
    throw e;
  }
}

// 2. Iterating through the quizContent collection documents to fetch contents and store them in a list
Future<List<String>> fetchAllQuizContent(List<String> documentIds) async {
  List<String> contents = [];

  try {
    for (String documentId in documentIds) {
      // Replace 'quizContent' with your collection name
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('quizContent').doc(documentId).get();

      if (documentSnapshot.exists) {
        // Access the 'content' field in the document
        var content = documentSnapshot.data()?['content'];
        contents.add(content as String); // Explicit cast to String
      } else {
        contents.add('Document not found');
      }
    }

    return contents;
  } catch (e) {
    print('Error: $e');
    throw e;
  }
}

//3. Generating QAs for all the docs based on the list of contents fetched
Future<void> generateQuizQuestions() async {
  try {
    List<String> documentIds = await getAllDocumentIds();
    List<String> contents = await fetchAllQuizContent(documentIds);

    // Iterate through the contents
    for (String content in contents) {
      await generateQuizQuestionModel(
          content); // storing the QAs will be called inside it

      // Increment the API requests count
      requestCount++;

      // Check if it's time to wait (every 3 requests)
      if (requestCount % 3 == 0) {
        print('Waiting for 20 seconds...');
        await Future.delayed(Duration(seconds: 25));
      }
    }
  } catch (error) {
    // Handle error
    print('Error: $error');
  }
}

// 3a. Generate QA for a single doc based on content
Future<String> generateQuizQuestionModel(String todaysQuizContent) async {
  OpenAI.apiKey = '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';

  try {
    final completion = await OpenAI.instance.completion.create(
      model: "text-davinci-003",
      prompt:
          "In Arabic, generate an easy 3 true or false question about $todaysQuizContent, write the question as a fact, Write it in the format \" (Question Number)-(The fact)-(the Correct Answer)# \" if true write (T) if false write (F)",
      maxTokens: 500,
    );

    String generatedQuestion = completion.choices[0].text;
    print(generatedQuestion);

    List<String> questions = [];
    List<String> answers = [];

    int questionNumber = 0;

    for (String question in generatedQuestion.split('#')) {
      // if (question == "#") continue;

      questionNumber++;
      String quizQuestion = question.substring(3, question.indexOf('('));
      String quizAnswer = question.contains("T") ? "T" : "F";

      // Add question and answer to their respective lists
      questions.add(quizQuestion);
      answers.add(quizAnswer);

      print('Question: $quizQuestion');
      print('Answer: $quizAnswer');
      print('Question Number: $questionNumber');

      if (questionNumber == 3) break;
    }

    // Calling the method to store a single quiz questions/answers
    await storeQuizQuestionsAndAnswers(questions, answers);

    return generatedQuestion;
  } catch (error) {
    print('Error: $error');
    throw error;
  }
}

// 3b. store a single QA in a collection quizQA as 2 lists Questions and Answers
Future<void> storeQuizQuestionsAndAnswers(
    List<String> questions, List<String> answers) async {
  try {
    // Create a map to represent the data you want to store
    Map<String, dynamic> quizData = {
      'questions': questions,
      'answers': answers,
      'timestamp':
          FieldValue.serverTimestamp(), // Add a timestamp for reference
    };

    // Add the data to the 'quizQA' collection
    await _firestore.collection('quizQA').add(quizData);
  } catch (e) {
    print('Error storing quiz data: $e');
    throw e;
  }
}
