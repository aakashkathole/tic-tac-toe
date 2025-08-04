import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> _board = List.filled(9, '');
  String _currentPlayer = 'X';
  String? _winner;
  List<int> _winningIndices = [];

  void _handleTap(int index) {
    if (_board[index] != '' || _winner != null) return;

    setState(() {
      _board[index] = _currentPlayer;
      _checkWinner();
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
    });
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      final a = pattern[0], b = pattern[1], c = pattern[2];
      if (_board[a] != '' &&
          _board[a] == _board[b] &&
          _board[b] == _board[c]) {
        setState(() {
          _winner = _board[a];
          _winningIndices = [a, b, c];
        });
        return;
      }
    }

    if (!_board.contains('')) {
      setState(() {
        _winner = 'Draw';
      });
    }
  }

  void _restartGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _winner = null;
      _winningIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
         backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _winner != null
                ? _winner == 'Draw'
                ? 'Game Draw!'
                : '$_winner Wins!'
                : 'Current Player: $_currentPlayer',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Center(child: _buildBoard()),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: _restartGame,
            child: const Text('Restart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.yellow,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.yellow, width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildBoard() {
    return SizedBox(
      width: 300,
      height: 300,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final isWinningCell = _winningIndices.contains(index);
          return GestureDetector(
            onTap: () => _handleTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border.all(),
                color: isWinningCell ? Colors.blue : Colors.yellow,
              ),
              child: Center(
                child: Text(
                  _board[index],
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _board[index] == 'X'
                        ? Colors.black
                        : _board[index] == 'O'
                        ? Colors.black
                        : Colors.transparent, // You can also use Colors.black or gray
                  ),
                ),

              ),
            ),
          );
        },
      ),
    );
  }
}
