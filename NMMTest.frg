#lang forge

// Player
abstract sig Player {}
one sig P1, P2 extends Player {}
// sig Piece {
//     owner: Player
// }

// mills
sig Mills {
    slot1: pfunc Int -> Int,
    slot2: pfunc Int -> Int,
    slot3: pfunc Int -> Int,
    player: one Player
}

// Board
sig State {
    board: pfunc Int -> Int -> Player, // first int is the square we are on. 2 = outer, 1 = middle, 0 = inner
    turn: one Player, // Denotes person who is going to move
    mills: set Mills // a set of set of integer pairs, where pairs specify the slot. inner sets of size 3.
    validMills: set Mills // set of valid mills we can check against
}

// Trace of Game
one sig Trace {
    initial_state: one State,
    next: pfunc State -> State
}

pred wellformed {
    all m: Mills | some m.slot1 and some m.slot2 and some m.slot3
    // each square has slots 0 to 7
    all s: State | all square: Int | all i: Int {
        some s.board[square][i] => (i >= 0 and i <= 7 and square >= 0 and square <= 2)
    }
}

fun countPiecesPlayer[s: State, p: Player]: Int {
    add[add[#{i: Int | s.board[0][i] = p}, #{i: Int | s.board[1][i] = p}], #{i: Int | s.board[2][i] = p}]
}

pred starting[s: State] {
    // 1 player has 3 tokens on the board, the other player has 4 to 9 tokens on the board.
    (countPiecesPlayer[s, P1] = 3 and (countPiecesPlayer[s, P2] >= 4 and countPiecesPlayer[s, P2] <= 9))
    or
    (countPiecesPlayer[s, P2] = 3 and (countPiecesPlayer[s, P1] >= 4 and countPiecesPlayer[s, P1] <= 9))
}

pred P1Turn[s: State] {
    s.turn = P1
}

pred P2Turn[s: State] {
    s.turn = P2
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
        some square1, i1: Int | {
            // ints are different so piece moves
            square != square1 and i != i1
            // square1 is in bounds
            square1 <= 2 and square1 >= 0
            // there is nothing at this place before this turn
            no pre.board[square1][i1]
            // there is something at this place after this turn
            post.board[square1][i1] = p
            {
                // i changes or square changes only
                // i is odd means that square can change; square 1 will be 1 off from square and i won't change
                // i is odd comes after because of implies logic
                {{(square1 = add[square, 1] or square1 = subtract[square, 1]) and i = i1} implies remainder[i, 2] = 1}
                or 
                // if square doesn't move, then i can move
                // i must (i+1)%8 or (i-1)%8 and square won't change
                {(i1 = remainder[add[i, 1], 8] or i1 = remainder[subtract[i, 1], 8]) and square = square1}
            }
            // frame condition
            // all other squares should remain the same from pre to post
            all square2, i2: Int | {
                (square2 != square and square2 != square1 and i2 != i and i2 != i1)
                implies pre.board[square2][i2] = post.board[square2][i2]
            }
        }
    }
}

pred flyingMove[pre: State, p: Player, post: State] {
      // Guard
    not gameOver[pre]
    p = P1 implies P1Turn[pre]
    p = P2 implies P2Turn[pre]

    //make sure that the current player only has 3 pieces on the board
    countPiecesPlayer[pre, p] = 3

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
        some square1, i1: Int | {
            // ints are different so piece moves
            square != square1 and i != i1
            // square1 is in bounds
            square1 <= 2 and square1 >= 0
            // there is nothing at this place before this turn
            no pre.board[square1][i1]
            // there is something at this place after this turn
            post.board[square1][i1] = p
            // frame condition
            // all other squares should remain the same from pre to post
            all square2, i2: Int | {
                (square2 != square and square2 != square1 and i2 != i and i2 != i1)
                implies pre.board[square2][i2] = post.board[square2][i2]
            }
        }
    }

}

pred findMillSameSquare[s: State, p: Player] {
    all square: {0, 1, 2} | {
        {s.board[square][0] = p and s.board[square][1] = p and s.board[square][2] = p} or
        {s.board[square][2] = p and s.board[square][3] = p and s.board[square][4] = p} or
        {s.board[square][4] = p and s.board[square][5] = p and s.board[square][6] = p} or
        {s.board[square][6] = p and s.board[square][7] = p and s.board[square][0] = p}
    }
    // add to set of mills
}

pred findMillSameSquare[s: State, p: Player] {
    all square: {0, 1, 2} | all {
        {s.board[square][0] = p and s.board[square][1] = p and s.board[square][2] = p} or
        {s.board[square][2] = p and s.board[square][3] = p and s.board[square][4] = p} or
        {s.board[square][4] = p and s.board[square][5] = p and s.board[square][6] = p} or
        {s.board[square][6] = p and s.board[square][7] = p and s.board[square][0] = p}
    } 
    // add to set of mills
}

// pred findMillDiffSquare[s: State, p: Player] {
//     {s.board[0][1] = p and s.board[1][1] = p and s.board[2][1] = p} or
//     {s.board[0][3] = p and s.board[1][3] = p and s.board[2][3] = p} or
//     {s.board[0][5] = p and s.board[1][5] = p and s.board[2][5] = p} or
//     {s.board[0][7] = p and s.board[1][7] = p and s.board[2][7] = p}
//     // add to set of mills
// }
// in starting
// existing mills on the board
all m: Mills | some square: {0, 1, 2} | m in s.mills iff {s.board[square][m.slot1[square]] = m.player} and {s.board[square][m.slot2[square]] = m.player} and {s.board[square][m.slot3[square]] = m.player} 

pred validMillDiffSquare[m: Mills] {
    {m.slot1 = 0 -> 1 and m.slot2 = 1 -> 1 and m.slot1 = 2 -> 1} or
    {m.slot1 = 0 -> 3 and m.slot2 = 1 -> 3 and m.slot1 = 2 -> 3} or
    {m.slot1 = 0 -> 5 and m.slot2 = 1 -> 5 and m.slot1 = 2 -> 5} or
    {m.slot1 = 0 -> 7 and m.slot2 = 1 -> 7 and m.slot1 = 2 -> 7}
    all square: {0, 1, 2} | all {
        {m.slot1 = square -> 0 and m.slot2 = square -> 1 and m.slot1 = square -> 2} or
        {m.slot1 = square -> 2 and m.slot2 = square -> 3 and m.slot1 = square -> 4} or
        {m.slot1 = square -> 4 and m.slot2 = square -> 5 and m.slot1 = square -> 6} or
        {m.slot1 = square -> 6 and m.slot2 = square -> 7 and m.slot1 = square -> 0}
    } 
    // add to set of mills
}

pred findMills[s: State, p: Player] {
    findMillSameSquare[s, p] or findMillDiffSquare[s, p] 
}

// get move and check if piece there or not
// checked if open or not

// // different types of moves? or allowed moves. maybe a flying more and moving move

pred loser[s: State, p: Player] {
     countPiecesPlayer[s, p] = 2
}
// TODO
pred gameOver[s: State] {
    some p: Player | loser[s, p]
    // TODO or no legal moves
}

pred doNothing[pre: State, post: State] {
    // Guard
    gameOver[pre]

    // Action
    pre.board = post.board
    pre.turn = post.turn
}

pred traces {
    -- initial board is a starting board (rules of Nine Men Morris)
    starting[Trace.initial_state]
    -- initial board is initial in the sequence (trace)
    not (some sprev: State | Trace.next[sprev] = Trace.initial_state)
    --"next” enforces move predicate (valid transitions!)
    all s: State | {
        some Trace.next[s] implies {
            (some p: Player | move[s, p, Trace.next[s]] or flyingMove[s, p, Trace.next[s]])
            or
            (doNothing[s, Trace.next[s]])
        }
        
    }
}

run {
    traces
} for exactly 5 Int, exactly 4 State


// TODO LIST (cause I like lists)
// write move 
// write game over
// write function to find mills
// predicate to remove an oppenents piece when they create a mill
    //when you create a mill, them you are given the option to remove an opponents piece
// ensure that when the opppent player is removing a piece that the piece that they are removing is not in a mill
    //unless that is the only option left i.e no pieces outside the mill
