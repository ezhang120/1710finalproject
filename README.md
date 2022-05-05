# 1710finalproject

We have modeled a game called Nine Men Morris.
The game has three phases.
    In the first phase, the players put down a single token on the board in alternating turns.
We decided to focus on the third phase of the game and therefore have modeled it from that point onwards.

# Modeling Decisions
    - Each square is an array
    - A square has indexes from 0 to 7. We start at 0 so when we move left or right i.e. +1 or -1 we can mod by 8 and make a circular array.
    - If you are at an odd index in a square, you can jump across squares
    - A board is an int to int to player. The first integer is the square you are on, the second integer is the slot on the board.
    - We are not enforcing that if we are removing a piece from a mill there cannot be any other free non-mill-ed pieces.

# Findings
    - We ran the model with a varying number of states and checked whether a player with 3 pieces could win without flying.
        - 2: UNSAT
        - 3: UNSAT
        - 4: UNSAT
        - 5: UNSAT

# Our Goals:
    - is flying necessary to run?
    - is it fair with flying (i.e. run x times, 50/50 win split)
