#lang forge

// Player
abstract sig Player {}
sig P1, P2 extends Player {}

// Board
sig State {
    inner_square: pfunc Int -> Player
    middle_square: pfunc Int -> Player
    outer_square: pfunc Int -> Player
    turn: Player // Denotes person who is going to move
    // mills: set set Int
}

// two representations convert between all single numbered

// Trace of Game
sig Trace {
    inital_state: one State
    next: pfunc State -> State
}

pred wellformed {
    // each square has slots 0 to 7
    all s: State | all i: Int | {
        s.inner_square[i] => i >= 0 and i <= 7
        s.middle_square[i] => i >= 0 and i <= 7
        s.outer_square[i] => i >= 0 and i <= 7
    }
}

fun countPiecesPlayer[s: State, p: Player]: Int {
    add[add[#{i: Int | s.inner_square[i] == p}, #{i: Int | s.middle_square[i] == p}], #{i: Int | s.outer_square[i] == p}]
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

pred move[pre: State, move???, p: Player???, post: State] {
    // Guard
    not gameOver[pre]


    // Action
    pre.turn != post.turn
    // TODO only a single piece of player moves
    // rest stays the same
}

// different types of moves? or allowed moves. maybe a flying more and moving move

pred loser[s: State, p: Player] {
     countPiecesPlayer[s, p] == 2
}

pred gameOver[s: State] {
    some p: Player | loser[s, p]
    // TODO or no legal moves
}

pred doNothing[pre: State, post: State] {
    // Guard
    gameOver[pre]

    // Action
    pre.inner_square == post.inner_square
    pre.middle_square == post.middle_square
    pre.outer_square == post.outer_square
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
            (some num: Int, p: Player | move[s, ???, ???, Trace.next[s]])
            or
            (doNothing[s, Trace.next[s]])
        }
        
    }
}

