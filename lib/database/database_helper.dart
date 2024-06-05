import 'dart:async';
import 'dart:io';
import 'package:flutterdemo/models/Question.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterdemo/models/User.dart';
import 'package:flutterdemo/models/Quiz.dart';
import 'package:flutterdemo/models/Option.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quiz_db.db");
    return await openDatabase(path,
        version: 8, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE Quiz (
        quizId INTEGER PRIMARY KEY AUTOINCREMENT,
        quizName TEXT NOT NULL,
        quizImgUrl TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Question (
        questionId INTEGER PRIMARY KEY AUTOINCREMENT,
        quizId INTEGER,
        questionText TEXT NOT NULL,
        FOREIGN KEY (quizId) REFERENCES Quiz (quizId) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Option (
        optionId INTEGER PRIMARY KEY AUTOINCREMENT,
        questionId INTEGER,
        optionText TEXT NOT NULL,
        isCorrect INTEGER NOT NULL,
        FOREIGN KEY (questionId) REFERENCES Question (questionId) ON DELETE CASCADE
      )
    ''');

    // Yeni verileri ekleme
    List<Map<String, dynamic>> quizzes = [
      {
        'quizName': 'General Knowledges',
        'quizImgUrl':
            'https://play-lh.googleusercontent.com/PriDzpFJUw--6ONcR54fhqM95vq7PH1oy2DmkiR9_4CSEyYhPShQEDI5VF1Jz01-ZA'
      },
      {
        'quizName': 'Science',
        'quizImgUrl':
            'https://img.freepik.com/free-vector/colorful-science-objects-icons-vector-set_1308-131708.jpg'
      },
      {
        'quizName': 'History',
        'quizImgUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXWqC3Ra-uwgQTe-NmSJoUq9feDOoA8eFb8Q&s'
      },
      {
        'quizName': 'Geography',
        'quizImgUrl':
            'https://geographicbook.com/wp-content/uploads/2023/06/What-is-Geography.jpg'
      },
      {
        'quizName': 'Literature',
        'quizImgUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS3h-Kv_mrKZiK2ru5FJHtqvD9Fhbpivjzyg&s'
      },
      {
        'quizName': 'Mathematics',
        'quizImgUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVk3_sH_XB7bBAl-xna4TiTeLIyoHuNYobHA&s'
      },
      {
        'quizName': 'Technology',
        'quizImgUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3yjyt18NqaeSXpUWjqrNim7RMCNEpbn4ZQ&s'
      },
      {
        'quizName': 'Movies',
        'quizImgUrl':
            'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/ioUPyn34M7Hc/v0/-1x-1.jpg'
      },
      {
        'quizName': 'Music',
        'quizImgUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTef_b84s52sJo3fBibb7-VGenkRTabstp7Mg&s'
      },
      {
        'quizName': 'Sports',
        'quizImgUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Sport_balls.svg/400px-Sport_balls.svg.png'
      },
    ];

    List<List<Map<String, dynamic>>> allQuestions = [
      // General Knowledge
      [
        {
          'questionText': 'What is the capital of France?',
          'options': [
            {'optionText': 'Paris', 'isCorrect': 1},
            {'optionText': 'London', 'isCorrect': 0},
            {'optionText': 'Berlin', 'isCorrect': 0},
            {'optionText': 'Madrid', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What is the largest mammal?',
          'options': [
            {'optionText': 'Blue Whale', 'isCorrect': 1},
            {'optionText': 'Elephant', 'isCorrect': 0},
            {'optionText': 'Giraffe', 'isCorrect': 0},
            {'optionText': 'Hippopotamus', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'How many continents are there?',
          'options': [
            {'optionText': '7', 'isCorrect': 1},
            {'optionText': '5', 'isCorrect': 0},
            {'optionText': '6', 'isCorrect': 0},
            {'optionText': '8', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who painted the Mona Lisa?',
          'options': [
            {'optionText': 'Leonardo da Vinci', 'isCorrect': 1},
            {'optionText': 'Vincent van Gogh', 'isCorrect': 0},
            {'optionText': 'Pablo Picasso', 'isCorrect': 0},
            {'optionText': 'Claude Monet', 'isCorrect': 0},
          ]
        },
      ],
      // Science
      [
        {
          'questionText': 'Which planet is known as the Red Planet?',
          'options': [
            {'optionText': 'Mars', 'isCorrect': 1},
            {'optionText': 'Earth', 'isCorrect': 0},
            {'optionText': 'Jupiter', 'isCorrect': 0},
            {'optionText': 'Venus', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What is the chemical symbol for water?',
          'options': [
            {'optionText': 'H2O', 'isCorrect': 1},
            {'optionText': 'O2', 'isCorrect': 0},
            {'optionText': 'CO2', 'isCorrect': 0},
            {'optionText': 'H2', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who proposed the theory of relativity?',
          'options': [
            {'optionText': 'Albert Einstein', 'isCorrect': 1},
            {'optionText': 'Isaac Newton', 'isCorrect': 0},
            {'optionText': 'Galileo Galilei', 'isCorrect': 0},
            {'optionText': 'Nikola Tesla', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What is the powerhouse of the cell?',
          'options': [
            {'optionText': 'Mitochondria', 'isCorrect': 1},
            {'optionText': 'Nucleus', 'isCorrect': 0},
            {'optionText': 'Ribosome', 'isCorrect': 0},
            {'optionText': 'Golgi apparatus', 'isCorrect': 0},
          ]
        },
      ],
      // History
      [
        {
          'questionText': 'Who was the first President of the United States?',
          'options': [
            {'optionText': 'George Washington', 'isCorrect': 1},
            {'optionText': 'Thomas Jefferson', 'isCorrect': 0},
            {'optionText': 'Abraham Lincoln', 'isCorrect': 0},
            {'optionText': 'John Adams', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'In which year did World War II end?',
          'options': [
            {'optionText': '1945', 'isCorrect': 1},
            {'optionText': '1944', 'isCorrect': 0},
            {'optionText': '1946', 'isCorrect': 0},
            {'optionText': '1943', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who discovered America?',
          'options': [
            {'optionText': 'Christopher Columbus', 'isCorrect': 1},
            {'optionText': 'Leif Erikson', 'isCorrect': 0},
            {'optionText': 'Amerigo Vespucci', 'isCorrect': 0},
            {'optionText': 'James Cook', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What was the ancient name of Iraq?',
          'options': [
            {'optionText': 'Mesopotamia', 'isCorrect': 1},
            {'optionText': 'Persia', 'isCorrect': 0},
            {'optionText': 'Babylonia', 'isCorrect': 0},
            {'optionText': 'Assyria', 'isCorrect': 0},
          ]
        },
      ],
      // Geography
      [
        {
          'questionText': 'What is the longest river in the world?',
          'options': [
            {'optionText': 'Nile', 'isCorrect': 1},
            {'optionText': 'Amazon', 'isCorrect': 0},
            {'optionText': 'Yangtze', 'isCorrect': 0},
            {'optionText': 'Mississippi', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Which is the smallest continent?',
          'options': [
            {'optionText': 'Australia', 'isCorrect': 1},
            {'optionText': 'Europe', 'isCorrect': 0},
            {'optionText': 'Antarctica', 'isCorrect': 0},
            {'optionText': 'South America', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Mount Everest is located in which mountain range?',
          'options': [
            {'optionText': 'Himalayas', 'isCorrect': 1},
            {'optionText': 'Andes', 'isCorrect': 0},
            {'optionText': 'Rockies', 'isCorrect': 0},
            {'optionText': 'Alps', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Which country has the most natural lakes?',
          'options': [
            {'optionText': 'Canada', 'isCorrect': 1},
            {'optionText': 'USA', 'isCorrect': 0},
            {'optionText': 'India', 'isCorrect': 0},
            {'optionText': 'Brazil', 'isCorrect': 0},
          ]
        },
      ],
      // Literature
      [
        {
          'questionText': 'Who wrote "1984"?',
          'options': [
            {'optionText': 'George Orwell', 'isCorrect': 1},
            {'optionText': 'Aldous Huxley', 'isCorrect': 0},
            {'optionText': 'Ray Bradbury', 'isCorrect': 0},
            {'optionText': 'J.D. Salinger', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who is the author of the Harry Potter series?',
          'options': [
            {'optionText': 'J.K. Rowling', 'isCorrect': 1},
            {'optionText': 'J.R.R. Tolkien', 'isCorrect': 0},
            {'optionText': 'C.S. Lewis', 'isCorrect': 0},
            {'optionText': 'Stephen King', 'isCorrect': 0},
          ]
        },
        {
          'questionText':
              'In which language was "Don Quixote" originally written?',
          'options': [
            {'optionText': 'Spanish', 'isCorrect': 1},
            {'optionText': 'French', 'isCorrect': 0},
            {'optionText': 'English', 'isCorrect': 0},
            {'optionText': 'Italian', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who wrote "Pride and Prejudice"?',
          'options': [
            {'optionText': 'Jane Austen', 'isCorrect': 1},
            {'optionText': 'Emily Brontë', 'isCorrect': 0},
            {'optionText': 'Charlotte Brontë', 'isCorrect': 0},
            {'optionText': 'Mary Shelley', 'isCorrect': 0},
          ]
        },
      ],
      // Mathematics
      [
        {
          'questionText': 'What is the value of Pi to two decimal places?',
          'options': [
            {'optionText': '3.14', 'isCorrect': 1},
            {'optionText': '3.15', 'isCorrect': 0},
            {'optionText': '3.16', 'isCorrect': 0},
            {'optionText': '3.13', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What is the square root of 64?',
          'options': [
            {'optionText': '8', 'isCorrect': 1},
            {'optionText': '6', 'isCorrect': 0},
            {'optionText': '7', 'isCorrect': 0},
            {'optionText': '9', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What is 7 multiplied by 8?',
          'options': [
            {'optionText': '56', 'isCorrect': 1},
            {'optionText': '54', 'isCorrect': 0},
            {'optionText': '58', 'isCorrect': 0},
            {'optionText': '60', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What is the value of the square of 15?',
          'options': [
            {'optionText': '225', 'isCorrect': 1},
            {'optionText': '215', 'isCorrect': 0},
            {'optionText': '235', 'isCorrect': 0},
            {'optionText': '245', 'isCorrect': 0},
          ]
        },
      ],
      // Technology
      [
        {
          'questionText': 'Who is known as the father of computers?',
          'options': [
            {'optionText': 'Charles Babbage', 'isCorrect': 1},
            {'optionText': 'Alan Turing', 'isCorrect': 0},
            {'optionText': 'John von Neumann', 'isCorrect': 0},
            {'optionText': 'Bill Gates', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What does HTTP stand for?',
          'options': [
            {'optionText': 'HyperText Transfer Protocol', 'isCorrect': 1},
            {'optionText': 'HyperText Transmission Protocol', 'isCorrect': 0},
            {'optionText': 'HighText Transfer Protocol', 'isCorrect': 0},
            {'optionText': 'HighText Transmission Protocol', 'isCorrect': 0},
          ]
        },
        {
          'questionText':
              'What is the name of the first electronic general-purpose computer?',
          'options': [
            {'optionText': 'ENIAC', 'isCorrect': 1},
            {'optionText': 'UNIVAC', 'isCorrect': 0},
            {'optionText': 'IBM 701', 'isCorrect': 0},
            {'optionText': 'Colossus', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who founded Microsoft?',
          'options': [
            {'optionText': 'Bill Gates and Paul Allen', 'isCorrect': 1},
            {'optionText': 'Steve Jobs and Steve Wozniak', 'isCorrect': 0},
            {'optionText': 'Larry Page and Sergey Brin', 'isCorrect': 0},
            {'optionText': 'Mark Zuckerberg', 'isCorrect': 0},
          ]
        },
      ],
      // Movies
      [
        {
          'questionText': 'Who directed the movie "Inception"?',
          'options': [
            {'optionText': 'Christopher Nolan', 'isCorrect': 1},
            {'optionText': 'Steven Spielberg', 'isCorrect': 0},
            {'optionText': 'James Cameron', 'isCorrect': 0},
            {'optionText': 'Quentin Tarantino', 'isCorrect': 0},
          ]
        },
        {
          'questionText':
              'Who played the character of Harry Potter in the movie series?',
          'options': [
            {'optionText': 'Daniel Radcliffe', 'isCorrect': 1},
            {'optionText': 'Rupert Grint', 'isCorrect': 0},
            {'optionText': 'Elijah Wood', 'isCorrect': 0},
            {'optionText': 'Tom Holland', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Which movie won the Oscar for Best Picture in 2020?',
          'options': [
            {'optionText': 'Parasite', 'isCorrect': 1},
            {'optionText': '1917', 'isCorrect': 0},
            {'optionText': 'Joker', 'isCorrect': 0},
            {'optionText': 'Once Upon a Time in Hollywood', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who is the highest-grossing actor of all time?',
          'options': [
            {'optionText': 'Samuel L. Jackson', 'isCorrect': 1},
            {'optionText': 'Robert Downey Jr.', 'isCorrect': 0},
            {'optionText': 'Tom Hanks', 'isCorrect': 0},
            {'optionText': 'Harrison Ford', 'isCorrect': 0},
          ]
        },
      ],
      // Music
      [
        {
          'questionText': 'Who is known as the "King of Pop"?',
          'options': [
            {'optionText': 'Michael Jackson', 'isCorrect': 1},
            {'optionText': 'Elvis Presley', 'isCorrect': 0},
            {'optionText': 'Prince', 'isCorrect': 0},
            {'optionText': 'Madonna', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'What is the most played song on Spotify?',
          'options': [
            {'optionText': 'Shape of You by Ed Sheeran', 'isCorrect': 1},
            {'optionText': 'Blinding Lights by The Weeknd', 'isCorrect': 0},
            {'optionText': 'Rockstar by Post Malone', 'isCorrect': 0},
            {'optionText': 'Dance Monkey by Tones and I', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who composed the Four Seasons?',
          'options': [
            {'optionText': 'Antonio Vivaldi', 'isCorrect': 1},
            {'optionText': 'Johann Sebastian Bach', 'isCorrect': 0},
            {'optionText': 'Ludwig van Beethoven', 'isCorrect': 0},
            {'optionText': 'Wolfgang Amadeus Mozart', 'isCorrect': 0},
          ]
        },
        {
          'questionText':
              'Which band is known for the song "Bohemian Rhapsody"?',
          'options': [
            {'optionText': 'Queen', 'isCorrect': 1},
            {'optionText': 'The Beatles', 'isCorrect': 0},
            {'optionText': 'The Rolling Stones', 'isCorrect': 0},
            {'optionText': 'Led Zeppelin', 'isCorrect': 0},
          ]
        },
      ],
      // Sports
      [
        {
          'questionText': 'Which country has won the most FIFA World Cups?',
          'options': [
            {'optionText': 'Brazil', 'isCorrect': 1},
            {'optionText': 'Germany', 'isCorrect': 0},
            {'optionText': 'Italy', 'isCorrect': 0},
            {'optionText': 'Argentina', 'isCorrect': 0},
          ]
        },
        {
          'questionText':
              'Who holds the record for the most home runs in a single MLB season?',
          'options': [
            {'optionText': 'Barry Bonds', 'isCorrect': 1},
            {'optionText': 'Babe Ruth', 'isCorrect': 0},
            {'optionText': 'Hank Aaron', 'isCorrect': 0},
            {'optionText': 'Mark McGwire', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Which country hosted the 2016 Summer Olympics?',
          'options': [
            {'optionText': 'Brazil', 'isCorrect': 1},
            {'optionText': 'China', 'isCorrect': 0},
            {'optionText': 'UK', 'isCorrect': 0},
            {'optionText': 'Russia', 'isCorrect': 0},
          ]
        },
        {
          'questionText': 'Who is known as the "Fastest Man Alive"?',
          'options': [
            {'optionText': 'Usain Bolt', 'isCorrect': 1},
            {'optionText': 'Carl Lewis', 'isCorrect': 0},
            {'optionText': 'Tyson Gay', 'isCorrect': 0},
            {'optionText': 'Justin Gatlin', 'isCorrect': 0},
          ]
        },
      ],
    ];

    for (int i = 0; i < quizzes.length; i++) {
      int quizId = await db.insert('Quiz', {
        'quizName': quizzes[i]['quizName'],
        'quizImgUrl': quizzes[i]['quizImgUrl'],
      });

      List<Map<String, dynamic>> questions = allQuestions[i];

      for (var question in questions) {
        int questionId = await db.insert('Question', {
          'quizId': quizId,
          'questionText': question['questionText'],
        });

        for (var option in question['options']) {
          await db.insert('Option', {
            'questionId': questionId,
            'optionText': option['optionText'],
            'isCorrect': option['isCorrect'],
          });
        }
      }
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Tüm quizleri, soruları ve seçenekleri silme
      await db.delete('Option');
      await db.delete('Question');
      await db.delete('Quiz');

      List<Map<String, dynamic>> quizzes = [
        {
          'quizName': 'General Knowledges',
          'quizImgUrl':
              'https://play-lh.googleusercontent.com/PriDzpFJUw--6ONcR54fhqM95vq7PH1oy2DmkiR9_4CSEyYhPShQEDI5VF1Jz01-ZA'
        },
        {
          'quizName': 'Science',
          'quizImgUrl':
              'https://img.freepik.com/free-vector/colorful-science-objects-icons-vector-set_1308-131708.jpg'
        },
        {
          'quizName': 'History',
          'quizImgUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXWqC3Ra-uwgQTe-NmSJoUq9feDOoA8eFb8Q&s'
        },
        {
          'quizName': 'Geography',
          'quizImgUrl':
              'https://geographicbook.com/wp-content/uploads/2023/06/What-is-Geography.jpg'
        },
        {
          'quizName': 'Literature',
          'quizImgUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS3h-Kv_mrKZiK2ru5FJHtqvD9Fhbpivjzyg&s'
        },
        {
          'quizName': 'Mathematics',
          'quizImgUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVk3_sH_XB7bBAl-xna4TiTeLIyoHuNYobHA&s'
        },
        {
          'quizName': 'Technology',
          'quizImgUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3yjyt18NqaeSXpUWjqrNim7RMCNEpbn4ZQ&s'
        },
        {
          'quizName': 'Movies',
          'quizImgUrl':
              'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/ioUPyn34M7Hc/v0/-1x-1.jpg'
        },
        {
          'quizName': 'Music',
          'quizImgUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTef_b84s52sJo3fBibb7-VGenkRTabstp7Mg&s'
        },
        {
          'quizName': 'Sports',
          'quizImgUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Sport_balls.svg/400px-Sport_balls.svg.png'
        },
      ];

      List<List<Map<String, dynamic>>> allQuestions = [
        // General Knowledge
        [
          {
            'questionText': 'What is the capital of France?',
            'options': [
              {'optionText': 'Paris', 'isCorrect': 1},
              {'optionText': 'London', 'isCorrect': 0},
              {'optionText': 'Berlin', 'isCorrect': 0},
              {'optionText': 'Madrid', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What is the largest mammal?',
            'options': [
              {'optionText': 'Blue Whale', 'isCorrect': 1},
              {'optionText': 'Elephant', 'isCorrect': 0},
              {'optionText': 'Giraffe', 'isCorrect': 0},
              {'optionText': 'Hippopotamus', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'How many continents are there?',
            'options': [
              {'optionText': '7', 'isCorrect': 1},
              {'optionText': '5', 'isCorrect': 0},
              {'optionText': '6', 'isCorrect': 0},
              {'optionText': '8', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who painted the Mona Lisa?',
            'options': [
              {'optionText': 'Leonardo da Vinci', 'isCorrect': 1},
              {'optionText': 'Vincent van Gogh', 'isCorrect': 0},
              {'optionText': 'Pablo Picasso', 'isCorrect': 0},
              {'optionText': 'Claude Monet', 'isCorrect': 0},
            ]
          },
        ],
        // Science
        [
          {
            'questionText': 'Which planet is known as the Red Planet?',
            'options': [
              {'optionText': 'Mars', 'isCorrect': 1},
              {'optionText': 'Earth', 'isCorrect': 0},
              {'optionText': 'Jupiter', 'isCorrect': 0},
              {'optionText': 'Venus', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What is the chemical symbol for water?',
            'options': [
              {'optionText': 'H2O', 'isCorrect': 1},
              {'optionText': 'O2', 'isCorrect': 0},
              {'optionText': 'CO2', 'isCorrect': 0},
              {'optionText': 'H2', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who proposed the theory of relativity?',
            'options': [
              {'optionText': 'Albert Einstein', 'isCorrect': 1},
              {'optionText': 'Isaac Newton', 'isCorrect': 0},
              {'optionText': 'Galileo Galilei', 'isCorrect': 0},
              {'optionText': 'Nikola Tesla', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What is the powerhouse of the cell?',
            'options': [
              {'optionText': 'Mitochondria', 'isCorrect': 1},
              {'optionText': 'Nucleus', 'isCorrect': 0},
              {'optionText': 'Ribosome', 'isCorrect': 0},
              {'optionText': 'Golgi apparatus', 'isCorrect': 0},
            ]
          },
        ],
        // History
        [
          {
            'questionText': 'Who was the first President of the United States?',
            'options': [
              {'optionText': 'George Washington', 'isCorrect': 1},
              {'optionText': 'Thomas Jefferson', 'isCorrect': 0},
              {'optionText': 'Abraham Lincoln', 'isCorrect': 0},
              {'optionText': 'John Adams', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'In which year did World War II end?',
            'options': [
              {'optionText': '1945', 'isCorrect': 1},
              {'optionText': '1944', 'isCorrect': 0},
              {'optionText': '1946', 'isCorrect': 0},
              {'optionText': '1943', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who discovered America?',
            'options': [
              {'optionText': 'Christopher Columbus', 'isCorrect': 1},
              {'optionText': 'Leif Erikson', 'isCorrect': 0},
              {'optionText': 'Amerigo Vespucci', 'isCorrect': 0},
              {'optionText': 'James Cook', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What was the ancient name of Iraq?',
            'options': [
              {'optionText': 'Mesopotamia', 'isCorrect': 1},
              {'optionText': 'Persia', 'isCorrect': 0},
              {'optionText': 'Babylonia', 'isCorrect': 0},
              {'optionText': 'Assyria', 'isCorrect': 0},
            ]
          },
        ],
        // Geography
        [
          {
            'questionText': 'What is the longest river in the world?',
            'options': [
              {'optionText': 'Nile', 'isCorrect': 1},
              {'optionText': 'Amazon', 'isCorrect': 0},
              {'optionText': 'Yangtze', 'isCorrect': 0},
              {'optionText': 'Mississippi', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Which is the smallest continent?',
            'options': [
              {'optionText': 'Australia', 'isCorrect': 1},
              {'optionText': 'Europe', 'isCorrect': 0},
              {'optionText': 'Antarctica', 'isCorrect': 0},
              {'optionText': 'South America', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Mount Everest is located in which mountain range?',
            'options': [
              {'optionText': 'Himalayas', 'isCorrect': 1},
              {'optionText': 'Andes', 'isCorrect': 0},
              {'optionText': 'Rockies', 'isCorrect': 0},
              {'optionText': 'Alps', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Which country has the most natural lakes?',
            'options': [
              {'optionText': 'Canada', 'isCorrect': 1},
              {'optionText': 'USA', 'isCorrect': 0},
              {'optionText': 'India', 'isCorrect': 0},
              {'optionText': 'Brazil', 'isCorrect': 0},
            ]
          },
        ],
        // Literature
        [
          {
            'questionText': 'Who wrote "1984"?',
            'options': [
              {'optionText': 'George Orwell', 'isCorrect': 1},
              {'optionText': 'Aldous Huxley', 'isCorrect': 0},
              {'optionText': 'Ray Bradbury', 'isCorrect': 0},
              {'optionText': 'J.D. Salinger', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who is the author of the Harry Potter series?',
            'options': [
              {'optionText': 'J.K. Rowling', 'isCorrect': 1},
              {'optionText': 'J.R.R. Tolkien', 'isCorrect': 0},
              {'optionText': 'C.S. Lewis', 'isCorrect': 0},
              {'optionText': 'Stephen King', 'isCorrect': 0},
            ]
          },
          {
            'questionText':
                'In which language was "Don Quixote" originally written?',
            'options': [
              {'optionText': 'Spanish', 'isCorrect': 1},
              {'optionText': 'French', 'isCorrect': 0},
              {'optionText': 'English', 'isCorrect': 0},
              {'optionText': 'Italian', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who wrote "Pride and Prejudice"?',
            'options': [
              {'optionText': 'Jane Austen', 'isCorrect': 1},
              {'optionText': 'Emily Brontë', 'isCorrect': 0},
              {'optionText': 'Charlotte Brontë', 'isCorrect': 0},
              {'optionText': 'Mary Shelley', 'isCorrect': 0},
            ]
          },
        ],
        // Mathematics
        [
          {
            'questionText': 'What is the value of Pi to two decimal places?',
            'options': [
              {'optionText': '3.14', 'isCorrect': 1},
              {'optionText': '3.15', 'isCorrect': 0},
              {'optionText': '3.16', 'isCorrect': 0},
              {'optionText': '3.13', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What is the square root of 64?',
            'options': [
              {'optionText': '8', 'isCorrect': 1},
              {'optionText': '6', 'isCorrect': 0},
              {'optionText': '7', 'isCorrect': 0},
              {'optionText': '9', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What is 7 multiplied by 8?',
            'options': [
              {'optionText': '56', 'isCorrect': 1},
              {'optionText': '54', 'isCorrect': 0},
              {'optionText': '58', 'isCorrect': 0},
              {'optionText': '60', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What is the value of the square of 15?',
            'options': [
              {'optionText': '225', 'isCorrect': 1},
              {'optionText': '215', 'isCorrect': 0},
              {'optionText': '235', 'isCorrect': 0},
              {'optionText': '245', 'isCorrect': 0},
            ]
          },
        ],
        // Technology
        [
          {
            'questionText': 'Who is known as the father of computers?',
            'options': [
              {'optionText': 'Charles Babbage', 'isCorrect': 1},
              {'optionText': 'Alan Turing', 'isCorrect': 0},
              {'optionText': 'John von Neumann', 'isCorrect': 0},
              {'optionText': 'Bill Gates', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What does HTTP stand for?',
            'options': [
              {'optionText': 'HyperText Transfer Protocol', 'isCorrect': 1},
              {'optionText': 'HyperText Transmission Protocol', 'isCorrect': 0},
              {'optionText': 'HighText Transfer Protocol', 'isCorrect': 0},
              {'optionText': 'HighText Transmission Protocol', 'isCorrect': 0},
            ]
          },
          {
            'questionText':
                'What is the name of the first electronic general-purpose computer?',
            'options': [
              {'optionText': 'ENIAC', 'isCorrect': 1},
              {'optionText': 'UNIVAC', 'isCorrect': 0},
              {'optionText': 'IBM 701', 'isCorrect': 0},
              {'optionText': 'Colossus', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who founded Microsoft?',
            'options': [
              {'optionText': 'Bill Gates and Paul Allen', 'isCorrect': 1},
              {'optionText': 'Steve Jobs and Steve Wozniak', 'isCorrect': 0},
              {'optionText': 'Larry Page and Sergey Brin', 'isCorrect': 0},
              {'optionText': 'Mark Zuckerberg', 'isCorrect': 0},
            ]
          },
        ],
        // Movies
        [
          {
            'questionText': 'Who directed the movie "Inception"?',
            'options': [
              {'optionText': 'Christopher Nolan', 'isCorrect': 1},
              {'optionText': 'Steven Spielberg', 'isCorrect': 0},
              {'optionText': 'James Cameron', 'isCorrect': 0},
              {'optionText': 'Quentin Tarantino', 'isCorrect': 0},
            ]
          },
          {
            'questionText':
                'Who played the character of Harry Potter in the movie series?',
            'options': [
              {'optionText': 'Daniel Radcliffe', 'isCorrect': 1},
              {'optionText': 'Rupert Grint', 'isCorrect': 0},
              {'optionText': 'Elijah Wood', 'isCorrect': 0},
              {'optionText': 'Tom Holland', 'isCorrect': 0},
            ]
          },
          {
            'questionText':
                'Which movie won the Oscar for Best Picture in 2020?',
            'options': [
              {'optionText': 'Parasite', 'isCorrect': 1},
              {'optionText': '1917', 'isCorrect': 0},
              {'optionText': 'Joker', 'isCorrect': 0},
              {'optionText': 'Once Upon a Time in Hollywood', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who is the highest-grossing actor of all time?',
            'options': [
              {'optionText': 'Samuel L. Jackson', 'isCorrect': 1},
              {'optionText': 'Robert Downey Jr.', 'isCorrect': 0},
              {'optionText': 'Tom Hanks', 'isCorrect': 0},
              {'optionText': 'Harrison Ford', 'isCorrect': 0},
            ]
          },
        ],
        // Music
        [
          {
            'questionText': 'Who is known as the "King of Pop"?',
            'options': [
              {'optionText': 'Michael Jackson', 'isCorrect': 1},
              {'optionText': 'Elvis Presley', 'isCorrect': 0},
              {'optionText': 'Prince', 'isCorrect': 0},
              {'optionText': 'Madonna', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'What is the most played song on Spotify?',
            'options': [
              {'optionText': 'Shape of You by Ed Sheeran', 'isCorrect': 1},
              {'optionText': 'Blinding Lights by The Weeknd', 'isCorrect': 0},
              {'optionText': 'Rockstar by Post Malone', 'isCorrect': 0},
              {'optionText': 'Dance Monkey by Tones and I', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who composed the Four Seasons?',
            'options': [
              {'optionText': 'Antonio Vivaldi', 'isCorrect': 1},
              {'optionText': 'Johann Sebastian Bach', 'isCorrect': 0},
              {'optionText': 'Ludwig van Beethoven', 'isCorrect': 0},
              {'optionText': 'Wolfgang Amadeus Mozart', 'isCorrect': 0},
            ]
          },
          {
            'questionText':
                'Which band is known for the song "Bohemian Rhapsody"?',
            'options': [
              {'optionText': 'Queen', 'isCorrect': 1},
              {'optionText': 'The Beatles', 'isCorrect': 0},
              {'optionText': 'The Rolling Stones', 'isCorrect': 0},
              {'optionText': 'Led Zeppelin', 'isCorrect': 0},
            ]
          },
        ],
        // Sports
        [
          {
            'questionText': 'Which country has won the most FIFA World Cups?',
            'options': [
              {'optionText': 'Brazil', 'isCorrect': 1},
              {'optionText': 'Germany', 'isCorrect': 0},
              {'optionText': 'Italy', 'isCorrect': 0},
              {'optionText': 'Argentina', 'isCorrect': 0},
            ]
          },
          {
            'questionText':
                'Who holds the record for the most home runs in a single MLB season?',
            'options': [
              {'optionText': 'Barry Bonds', 'isCorrect': 1},
              {'optionText': 'Babe Ruth', 'isCorrect': 0},
              {'optionText': 'Hank Aaron', 'isCorrect': 0},
              {'optionText': 'Mark McGwire', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Which country hosted the 2016 Summer Olympics?',
            'options': [
              {'optionText': 'Brazil', 'isCorrect': 1},
              {'optionText': 'China', 'isCorrect': 0},
              {'optionText': 'UK', 'isCorrect': 0},
              {'optionText': 'Russia', 'isCorrect': 0},
            ]
          },
          {
            'questionText': 'Who is known as the "Fastest Man Alive"?',
            'options': [
              {'optionText': 'Usain Bolt', 'isCorrect': 1},
              {'optionText': 'Carl Lewis', 'isCorrect': 0},
              {'optionText': 'Tyson Gay', 'isCorrect': 0},
              {'optionText': 'Justin Gatlin', 'isCorrect': 0},
            ]
          },
        ],
      ];

      for (int i = 0; i < quizzes.length; i++) {
        int quizId = await db.insert('Quiz', {
          'quizName': quizzes[i]['quizName'],
          'quizImgUrl': quizzes[i]['quizImgUrl'],
        });

        List<Map<String, dynamic>> questions = allQuestions[i];

        for (var question in questions) {
          int questionId = await db.insert('Question', {
            'quizId': quizId,
            'questionText': question['questionText'],
          });

          for (var option in question['options']) {
            await db.insert('Option', {
              'questionId': questionId,
              'optionText': option['optionText'],
              'isCorrect': option['isCorrect'],
            });
          }
        }
      }
    }
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('User', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query('User', where: 'username = ?', whereArgs: [username]);
    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query('User', where: 'email = ?', whereArgs: [email]);
    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  Future<int> insertQuiz(Quiz quiz) async {
    Database db = await instance.database;
    return await db.insert('Quiz', quiz.toMap());
  }

  Future<Quiz?> getQuizById(int quizId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query('Quiz', where: 'quizId = ?', whereArgs: [quizId]);
    return results.isNotEmpty ? Quiz.fromMap(results.first) : null;
  }

  Future<List<Quiz>> getAllQuizzes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('Quiz');
    return results.map((quiz) => Quiz.fromMap(quiz)).toList();
  }

  Future<int> insertQuestion(Question question) async {
    Database db = await instance.database;
    return await db.insert('Question', question.toMap());
  }

  Future<List<Question>> getQuestionsByQuizId(int quizId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query('Question', where: 'quizId = ?', whereArgs: [quizId]);
    return results.map((question) => Question.fromMap(question)).toList();
  }

  Future<int> insertOption(Option option) async {
    Database db = await instance.database;
    return await db.insert('Option', option.toMap());
  }

  Future<List<Option>> getOptionsByQuestionId(int questionId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db
        .query('Option', where: 'questionId = ?', whereArgs: [questionId]);
    return results.map((option) => Option.fromMap(option)).toList();
  }

  static final DatabaseHelper instance = DatabaseHelper._internal();
}
