

# 1710 Final Project

    Introduction:
        For our final project we have chose to model a game called Nine Men Morris. Specifically we decided to start modelling from the third phase of the game. The game orignally has three phases. In the first and second phase, the players put down a single token on the board in alternating turns. In the third phase of the game, one player is left with only 3 pieces and is allowed to employ a flying move. The goal of this project is to figure out whether or not the flying move is necessary for the player with 3 pieces left to win. Also, here is a link to a Wikipedia pages for more rules for the game, (https://en.wikipedia.org/wiki/Nine_men%27s_morris)

# Our Goals
    - Our target goal was to figure out whether or not the flying move was necessary for the player left with 3 pieces to win.
    - Our reach goal was to figure our if our model was fair with the flying move(i.e. run x times, 50/50 win split)

# Modeling Decisions
    Some of the modelling decision that we made are:
        - Each of the squares on the board are represented by an integer. The innermost square is represented by a 0, the next smallest square is represented by 1, and the outermost square is represented by 2.
        - Each of the squares have seven slots which is represented by having indexes from 0 to 7. We start at 0 so when we move left or right i.e. +1 or -1 we can mod by 8 and make a circular array.
        - If a piece's index is an odd index in a square, then it can jump across squares
        - A board is an int to int to player. The first integer is the square you are on, the second integer is the slot on the board.
        - We are not enforcing that if we are removing a piece from a mill there cannot be any other free non-mill-ed pieces.

# Understanding the Model and Visualizer
    - An instance of our model would have the board and the pieces of each player on different places on the board. The visualizer will have the outline of the board and circles that are either black or white to represent different players. An instance will represent the current state of the game, the pieces of the board may change positions based on the moves the player makes. A piece may slide to a new position or be removed depending on if a mill was created. This will all be displayed by different states of the game which the visualizer will show.

How should we understand an instance of your model and what your custom visualization shows?


# Findings
    - We ran the model with a varying number of states and checked whether a player with 3 pieces could win without flying.
        - 2 States: UNSAT
        - 3 States: UNSAT
        - 4 States: UNSAT
        - 5 States: UNSAT
    - We reached a conclusion that without flying the player with 3 pieces would need a minimum of 6 states in order to win

    - We then ran the model with varying number of states with the flying move enabled
        - 2 States: UNSAT
        - 3 States: UNSAT
        - 4 States: UNSAT
        - 5 States: UNSAT
    - We reached the conclution that with flying, the player with 3 pieces would still need a minimum of 6 states in order to win.
    - Overall, we discovered that with or without flying, the player with 3 pieces needs at least 6 states to win, thus supporting the idea that flying is not absolutely essntial for the player with less pieces to win.
    - Fairness stuff:


# Tradeoffs and Issues
    - Some of the tradeoffs that we made when choosing our representation of our model is that we got rid of the rule that when removing pieces, they should not be a part of a mill unless only the pieces in the mill are left.
    - Another tradeoff that we made was that 
    - Some issues that we encountered was that it took a long time to run our model so we created an optimization instance to constrain all the fields in order to better our run time.

What tradeoffs did you make in choosing your representation? What else did you try that didn’t work as well?

# Reflection

    - Some of the assumptions that we made about the scope of this model was that the 
    - The limits of our model is that it only models the third phase of the game, not the entire game from start to finish.
    - Our goals did not change from the proposal, our goal was to figure out whether or not flying was necessary for the player with 3 pieces to win.
What assumptions did you make about scope? What are the limits of your model?
Did your goals change at all from your proposal? Did you realize anything you planned was unrealistic, or that anything you thought was unrealistic was doable?



