# 1710 Final Project: Nine Men Morris

## Introduction:
    For our final project we have chosen to model a game called Nine Men Morris. The game has three phases. In the first phase, the players put down a single token on the board in alternating turns. In the second phase, players can only make moves by sliding pieces to adjacent slots ont he board. In the third phase of the game, one player is left with only 3 pieces and is allowed to employ a flying move. The goal of this project is to figure out whether or not the flying move is necessary for the player with 3 pieces left to win. Hence, we will only be modelling the game from the third phase onwards. Here is a link to a Wikipedia pages for more rules of the game, (https://en.wikipedia.org/wiki/Nine_men%27s_morris)

## Our Goals
    - Our target goal is to figure out whether or not the flying move was necessary for the player left with 3 pieces to win.
    - Our reach goal is to figure out if the game if fair if flying move is employed (i.e. run x times, 50/50 win split)

## Modeling Decisions
    - Each of the squares on the board is represented by an integer. The innermost square is represented by a 0, the middle square is represented by 1, and the outermost square is represented by 2.
    - Each of the squares have seven slots which is represented by having indices from 0 to 7. We start at 0 so when we move left or right i.e. +1 or -1 we can mod by 8 and make a circular array.
    - If a piece's index is an odd number, then it can jump across squares
    - A board is an int to int to player pfunc. The first integer is the square you are on, the second integer is the slot on the board.
    - We are not enforcing that if we are removing a piece from a mill there cannot be any other free non-mill-ed pieces.

## Understanding the Model and Visualizer
    An instance of our model shows a trace of the game. A trace is comprised of states and each state has a board, and whose turn it is. The visualizer will have the outline of the board and circles that are either black or white to represent different players pieces. As we move along the states in the trace using the next relation, the pieces of the board may change positions based on the moves the player makes. A piece may slide to a new position or be removed depending on if a mill was created. The different states in a trace of the game are show sequentially by the visualizer.

## Findings
    - We ran the model with a varying number of states and checked whether a player with 3 pieces could win without flying.
        - 2 States: UNSAT
        - 3 States: UNSAT
        - 4 States: UNSAT
        - 5 States: UNSAT
        - 6 States: SAT
    - We reached a conclusion that without flying the player with 3 pieces would need a minimum of 6 states in order to win

    - We then ran the model with varying number of states with the flying move enabled
        - 2 States: UNSAT
        - 3 States: UNSAT
        - 4 States: UNSAT
        - 5 States: UNSAT
        - 6 States: SAT
    - We reached the conclution that with flying, the player with 3 pieces would still need a minimum of 6 states in order to win.

    - Overall, we discovered that with or without flying, the player with 3 pieces needs at least 6 states to win, thus supporting the idea that flying is not absolutely essential for the player with less pieces to win.

    - Fairness stuff:


## Tradeoffs and Issues
    - Some of the tradeoffs that we made when choosing our representation of our model is that we got rid of the rule that when removing pieces they should not be a part of a mill unless only the pieces in the mill are left.
    - Another tradeoff that we made was that 
    - Some issues that we encountered was that it took a long time to run our model so we created an optimization instance to constrain all the fields in order to better our run time.
    - We also had issues with our frame condition

## Reflection

    - Some of the assumptions that we made about the scope of this model was that the 
    - The limits of our model is that it only models the third phase of the game, not the entire game from start to finish.
    - Our goals did not change from the proposal, our goal was to figure out whether or not flying was necessary for the player with 3 pieces to win.
What assumptions did you make about scope? What are the limits of your model?
Did your goals change at all from your proposal? Did you realize anything you planned was unrealistic, or that anything you thought was unrealistic was doable?



