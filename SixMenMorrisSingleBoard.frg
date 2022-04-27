#lang forge

// Player
abstract sig Player {}
one sig P1, P2 extends Player {}

// Board
sig State {
    board: pfunc Int -> Int -> Player,
    turn: one Player
}

pred wellformed {
    all s: State | all square: Int | all i: Int {
        some s.board[square][i] => (i >= 0 and i <= 7 and square >= 0 and square <= 1)
    }
}

fun countPiecesPlayer[s: State, p: Player]: Int {
    add[add[#{i: Int | s.board[0][i] = p}, #{i: Int | s.board[1][i] = p}], #{i: Int | s.board[2][i] = p}]
}

pred starting[s: State] {
    // 1 player has 3 tokens on the board, the other player has 4 to 9 tokens on the board.
    (countPiecesPlayer[s, P1] = 3 and (countPiecesPlayer[s, P2] >= 4 and countPiecesPlayer[s, P2] <= 6))
    or
    (countPiecesPlayer[s, P2] = 3 and (countPiecesPlayer[s, P1] >= 4 and countPiecesPlayer[s, P1] <= 6))
}

pred P1Turn[s: State] {
    s.turn = P1
}

pred P2Turn[s: State] {
    s.turn = P2
}

pred loser[s: State, p: Player] {
     countPiecesPlayer[s, p] = 2
}

pred gameOver[s: State] {
    some p: Player | loser[s, p]
    // TODO or no legal moves, isnt that basically move pred not work?
}

option verbose 2
run {
    wellformed
    all s: State | starting[s]
} for exactly 4 Int, exactly 1 State