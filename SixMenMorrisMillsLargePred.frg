#lang forge

// Player
abstract sig Player {}
one sig P1, P2 extends Player {}

// Board
sig State {
    board: pfunc Int -> Int -> Player, // first int is the square we are on. 2 = outer, 1 = middle, 0 = inner
    turn: one Player // Denotes person who is going to move
}

// Trace of Game
one sig Trace {
    initial_state: one State,
    next: pfunc State -> State
}

pred wellformed {
    // each square has slots 0 to 4
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

pred millPostNotPre[pre: State, p: Player, post: State] {
    // if mill in post that is not in pre

    // middle square
    {{post.board[1][0] = p and post.board[1][1] = p and post.board[1][2] = p} and {pre.board[1][0] != p or pre.board[1][1] != p or pre.board[1][2] != p}} or
    {{post.board[1][2] = p and post.board[1][3] = p and post.board[1][4] = p} and {pre.board[1][2] != p or pre.board[1][3] != p or pre.board[1][4] != p}} or
    {{post.board[1][4] = p and post.board[1][5] = p and post.board[1][6] = p} and {pre.board[1][4] != p or pre.board[1][5] != p or pre.board[1][6] != p}} or
    {{post.board[1][6] = p and post.board[1][7] = p and post.board[1][0] = p} and {pre.board[1][6] != p or pre.board[1][7] != p or pre.board[1][0] != p}} or

    // inner square
    {{post.board[2][0] = p and post.board[2][1] = p and post.board[2][2] = p} and {pre.board[2][0] != p or pre.board[2][1] != p or pre.board[2][2] != p}} or
    {{post.board[2][2] = p and post.board[2][3] = p and post.board[2][4] = p} and {pre.board[2][2] != p or pre.board[2][3] != p or pre.board[2][4] != p}} or
    {{post.board[2][4] = p and post.board[2][5] = p and post.board[2][6] = p} and {pre.board[2][4] != p or pre.board[2][5] != p or pre.board[2][6] != p}} or
    {{post.board[2][6] = p and post.board[2][7] = p and post.board[2][0] = p} and {pre.board[2][6] != p or pre.board[2][7] != p or pre.board[2][0] != p}} or

    // across squares
    {{post.board[0][1] = p and post.board[1][1] = p and post.board[2][1] = p} and {pre.board[0][1] != p or pre.board[1][1] != p or pre.board[2][1] != p}} or
    {{post.board[0][3] = p and post.board[1][3] = p and post.board[2][3] = p} and {pre.board[0][3] != p or pre.board[1][3] != p or pre.board[2][3] != p}} or
    {{post.board[0][5] = p and post.board[1][5] = p and post.board[2][5] = p} and {pre.board[0][5] != p or pre.board[1][5] != p or pre.board[2][5] != p}} or
    {{post.board[0][7] = p and post.board[1][7] = p and post.board[2][7] = p} and {pre.board[0][7] != p or pre.board[1][7] != p or pre.board[2][7] != p}}
}

pred slide[pre: State, p: Player, post: State] {
    // Guard
    not gameOver[pre]
    p = P1 implies P1Turn[pre]
    p = P2 implies P2Turn[pre]

    // Action
    pre.turn != post.turn -- change turn to next player

    some square, i: Int | {
        // Constrain square and i
        pre.board[square][i] = p

        // remove as moving
        no post.board[square][i]

        some square1, i1: Int | {
            // ints are different so piece moves, only one should differ though, XOR!
            ((square != square1) or (i != i1)) and ((square = square1) or (i = i1))

            // square1 is in bounds
            square1 <= 1 and square1 >= 0

            // i1 is in bounds
            i1 <= 7 and i1 >= 0

            // constrain where you can slide the piece to: only one of i or square changes
            {
                // i is odd means that square can change; square1 will be 1 off from square and i won't change
                // i is odd comes after because of implies logic
                {{(square1 = add[square, 1] or square1 = subtract[square, 1]) and i = i1} implies remainder[i, 2] = 1}
                or 
                // if square doesn't move, then i can move: technically i can always move...
                // i must (i+1)%8 or (i-1)%8 and square won't change
                {(i1 = remainder[add[i, 1], 8] or i1 = remainder[subtract[i, 1], 8]) and square = square1}
            }

            // there is nothing at this place before this turn
            no pre.board[square1][i1]

            // there is something at this place after this turn, i.e. make the move
            post.board[square1][i1] = p

            millPostNotPre[pre, p, post] => {
                // remove a random piece from the opposite player
                some squareRem, iRem: Int | all square2, i2: Int | {
                    // Constrain squareRem and iRem
                    pre.board[squareRem][iRem] = P1 iff p = P2
                    pre.board[squareRem][iRem] = P2 iff p = P1

                    no post.board[squareRem][iRem]

                    // Frame Condition
                    (square2 != square and square2 != square1 and square2 != squareRem and i2 != i and i2 != i1 and i2 != iRem) => pre.board[square2][i2] = post.board[square2][i2]
                 }
            } else {
                // Frame Condition
                all square2, i2: Int | {
                    (square2 != square and square2 != square1 and i2 != i and i2 != i1) implies pre.board[square2][i2] = post.board[square2][i2]
                }
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

    some square, i: Int | {
        // Constrain square and i
        pre.board[square][i] = p

        // remove as moving
        no post.board[square][i]

        some square1, i1: Int | {
            // ints are different so piece moves
            (square != square1) or (i != i1)

            // square1 is in bounds
            square1 <= 1 and square1 >= 0

            // i1 is in bounds
            i1 <= 7 and i1 >= 0

            // there is nothing at this place before this turn
            no pre.board[square1][i1]

            // there is something at this place after this turn, i.e. make the move
            post.board[square1][i1] = p

            millPostNotPre[pre, p, post] => {
                // remove a random piece from the opposite player
                some squareRem, iRem: Int | all square2, i2: Int | {
                    // Constrain squareRem and iRem
                    pre.board[squareRem][iRem] = P1 iff p = P2
                    pre.board[squareRem][iRem] = P2 iff p = P1

                    no post.board[squareRem][iRem]

                    // Frame Condition
                    (square2 != square and square2 != square1 and square2 != squareRem and i2 != i and i2 != i1 and i2 != iRem) => pre.board[square2][i2] = post.board[square2][i2]
                 }
            } else {
                // Frame Condition
                all square2, i2: Int | {
                    (square2 != square and square2 != square1 and i2 != i and i2 != i1) implies pre.board[square2][i2] = post.board[square2][i2]
                }
            }
        }
    }

}

pred loser[s: State, p: Player] {
     countPiecesPlayer[s, p] = 2
}

pred gameOver[s: State] {
    some p: Player | loser[s, p]
    // TODO or no legal moves, isnt that basically move pred not work?
}

pred doNothing[pre: State, post: State] {
    // Guard
    gameOver[pre]

    // Action
    pre.board = post.board
    pre.turn = post.turn
}

pred tracesWithoutFlying {
    -- initial board is a starting board (rules of Nine Men Morris)
    starting[Trace.initial_state]
    -- initial board is initial in the sequence (trace)
    not (some sprev: State | Trace.next[sprev] = Trace.initial_state)
    --"next” enforces move predicate (valid transitions!)
    all s: State | {
        some Trace.next[s] implies {
            (some p: Player | slide[s, p, Trace.next[s]])
            or
            (doNothing[s, Trace.next[s]])
        }
        
    }
}

pred tracesWithFlying {
    -- initial board is a starting board (rules of Nine Men Morris)
    starting[Trace.initial_state]
    -- initial board is initial in the sequence (trace)
    not (some sprev: State | Trace.next[sprev] = Trace.initial_state)
    --"next” enforces move predicate (valid transitions!)
    all s: State | {
        some Trace.next[s] implies {
            // change to say player with 3 tokens always flies makes life easier, not needed actually as slide or fly up to them even though fly is just a better slide
            (some p: Player | slide[s, p, Trace.next[s]] or flyingMove[s, p, Trace.next[s]])
            or
            (doNothing[s, Trace.next[s]])
        }
        
    }
}

option verbose 5

inst opt2 {
    Trace = `Trace0
    State = `State0 + `State1
    P1 = `P10
    P2 = `P20
    Player = P1 + P2
    board in State -> (0 + 1 + 2)->(0 + 1 + 2 + 3 + 4 + 5 + 6 + 7)->(P1 + P2)
    initial_state = `Trace0->`State0
    next = `Trace0->`State0->`State1
}

run {
    wellformed
    tracesWithoutFlying
} for exactly 5 Int, exactly 2 State for opt2

// inst opt4 {
//     Trace = `Trace0
//     State = `State0 + `State1 + `State2 + `State3
//     P1 = `P10
//     P2 = `P20
//     Player = P1 + P2
//     board in State -> (0 + 1 + 2)->(0 + 1 + 2 + 3 + 4 + 5 + 6 + 7)->(P1 + P2)
//     initial_state = `Trace0->`State0
//     next = `Trace0->`State0->`State1 +
//            `Trace0->`State1->`State2 + 
//            `Trace0->`State2->`State3 
// }

// run {
//     wellformed
//     tracesWithoutFlying
// } for exactly 5 Int, exactly 4 State for opt4

// ensure that when the opppent player is removing a piece that the piece that they are removing is not in a mill // are we implementing this?
    //unless that is the only option left i.e no pieces outside the mill

