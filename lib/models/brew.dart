import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Brew {
  final String name;
  final String sugars;
  final int strength;

  Brew({required this.name, required this.sugars, required this.strength});

}