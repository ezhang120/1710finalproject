#lang forge

// Player
abstract sig Player {}
one sig P1, P2 extends Player {}
// sig Piece {
//     owner: Player
// }

// Board
sig State {
    board: pfunc Int -> Int -> Player // first int is the square we are on. 2 = outer, 1 = middle, 0 = inner
    turn: one Player // Denotes person who is going to move
    // mills: set set Int -> Int // a set of set of integer pairs, where pairs specify the slot. inner sets of size 3.
}

// Trace of Game
sig Trace {
    inital_state: one State
    next: pfunc State -> State
}

pred wellformed {
    // each square has slots 0 to 7
    all s: State | all square: Int | all i: Int {
        s.board[square][i] => (i >= 0 and i <= 7 and square >= 0 and square <= 2)
    }
}

fun countPiecesPlayer[s: State, p: Player]: Int {
    add[add[#{i: Int | s.board[0][i] == p}, #{i: Int | s.board[1][i] == p}], #{i: Int | s.board[2][i] == p}]
}

pred starting[s: State] {
    // 1 player has 3 tokens on the board, the other player has 4 to 9 tokens on the board.
    (countPiecesPlayer[s, P1] == 3 and (countPiecesPlayer[s, P2] >= 4 and countPiecesPlayer[s, P2] <= 9))
    or
    (countPiecesPlayer[s, P2] == 3 and (countPiecesPlayer[s, P1] >= 4 and countPiecesPlayer[s, P1] <= 9))
}

pred P1Turn[s: State] {
    s.turn == P1
}

pred P2Turn[s: State] {
    s.turn == P2
}

pred move[pre: State, p: Player, post: State] {
    // Guard
    not gameOver[pre]
    p = P1 implies P1Turn[pre]
    p = P2 implies P2Turn[pre]

    // Action
    pre.turn != post.turn -- change turn to next player

    // TODO only a single piece of player moves
    // rest stays the same
    // figure out if the piece is odd or even
    // if it is inner square odd piece cannot move inward
    // if it is outer square the odd pieces cannot move outward
    // the pieces 

    some square, i: Int | {
        pre.board[square][i] = p
        no post.board[square][i]
        some square1, i1 | {
            no pre.board[square1][i1]
            some post.board[square1][i1]
            square1
            i1 = remainder[add(i+1), 8] or remainder[add(i-1), 8]
        }
    no pre.board[square][i]

        post. = p
    }
}

// get move and check if piece there or not
// checked if open or not

// // different types of moves? or allowed moves. maybe a flying more and moving move

// pred loser[s: State, p: Player] {
//      countPiecesPlayer[s, p] == 2
// }

// pred gameOver[s: State] {
//     some p: Player | loser[s, p]
//     // TODO or no legal moves
// }

pred doNothing[pre: State, post: State] {
    // Guard
    gameOver[pre]

    // Action
    pre.board = post.board
    pre.turn = post.turn
}

pred traces {
    -- initial board is a starting board (rules of Nine Men Morris)
    starting[Trace.initialState]
    -- initial board is initial in the sequence (trace)
    not (some sprev: State | Trace.next[sprev] = Trace.initialState)
    --"next” enforces move predicate (valid transitions!)
    all s: State | {
        some Trace.next[s] implies {
            (some p: Player | move[s, p, Trace.next[s]])
            or
            (doNothing[s, Trace.next[s]])
        }
        
    }
}


// TODO LIST (cause I like lists)
// write move
// write game over