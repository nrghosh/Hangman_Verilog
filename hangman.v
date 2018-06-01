// Nikhil Ghosh
// COMP 331
// Homework 5.5: Hangman!

module hangman(clk, rst, letter, WrongGuesses, GameStatus);

    // the clock input
    input clk;

    // assert to start new game
    input rst;

    // In Verilog you can also use quoted
    // characters to represent ASCII values, e.g.
    //    (letter == "s") ? something : something_else
    // is identical to
    //    (letter == 73) ? something : something_else
    input [6:0] letter;

    // An unsigned number between 0 and 4, inclusive.
    // How many wrong guesses has the user made. Guessing
    // a letter that has already been guessed, or which
    // does not occur in the word, counts as a wrong guess.
    output [2:0] WrongGuesses;

    // Outputs the current game status. Its values are:
    //    2'd0: ready for next letter
    //    2'd1: game over, you lost
    //    2'd2: game over, you won
    // Initially, the status should be PLAY, i.e. you can
    // guess a letter. If the player makes four bad guesses,
    // the status will become LOSE. If the player guesses
    // all the letters in the word without making four
    // bad guesses, the status will become WIN.
    // Once the game has been won or lost, future inputs
    // should not be able to change the game status,
    // until reset is asserted and a new game is started.
    output [1:0] GameStatus;
    parameter PLAY=2'd0;
    parameter LOSE=2'd1;
    parameter WIN=2'd2;

    // -----------------------------
    // Your code goes below this line

    // Expressing correctly guessed letters
    reg[5:0] Guess;
    wire[5:0] NextGuess;

    // Base state and winning state (what "guess" will be in each of these, rather)
    parameter s0 = 6'b000000;
    parameter Won = 6'b111111;

    // Expressing current and next "wrong state"
    reg[2:0] WrongStatus;
    wire[2:0] NextWrongStatus;

    // Parameters for wrong states
    parameter wrong0 = 3'b000;
    parameter wrong1 = 3'b001;
    parameter wrong2 = 3'b010;
    parameter wrong3 = 3'b011;
    parameter wrong4 = 3'b100;

    // Parameters for correct letters
    parameter S = 6'b100000;
    parameter P = 6'b010000;
    parameter A = 6'b001000;
    parameter T = 6'b000100;
    parameter U = 6'b000010;
    parameter L = 6'b000001;

    // Every cycle, do reset if necessary, otherwise update and progress 'normally'
    always@(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                Guess <= s0;
                WrongStatus <= wrong0;
                end

            else
                begin
                Guess <= NextGuess;
                // So that we don't update the # of wrong guesses if the game is already won or lost
                if(Guess != Won & WrongStatus != wrong4)
                    WrongStatus <= NextWrongStatus;
                end
        end

    // if correct and not previously guessed letter, add to state, else do nothing  
    assign NextGuess[0] = (letter == "s" & ~Guess[0] ? 1'b1 : Guess[0]);
    assign NextGuess[1] = (letter == "p" & ~Guess[1] ? 1'b1 : Guess[1]);
    assign NextGuess[2] = (letter == "a" & ~Guess[2] ? 1'b1 : Guess[2]);
    assign NextGuess[3] = (letter == "t" & ~Guess[3] ? 1'b1 : Guess[3]);
    assign NextGuess[4] = (letter == "u" & ~Guess[4] ? 1'b1 : Guess[4]);
    assign NextGuess[5] = (letter == "l" & ~Guess[5] ? 1'b1 : Guess[5]);

    // if ok state, do nothing, otherwise go to the 'next' wrong state
    assign NextWrongStatus =
        ((letter == "s" & ~Guess[0]) | (letter == "p" & ~Guess[1]) | (letter == "a" & ~Guess[2]) | (letter == "t" & ~Guess[3]) | (letter == "u" & ~Guess[4]) | (letter == "l" & ~Guess[5]) ? WrongStatus : 
            (WrongStatus == wrong0 ? wrong1 : 
                (WrongStatus == wrong1 ? wrong2 :
                    (WrongStatus == wrong2 ? wrong3 : 
                        wrong4))));

    // Start off at the beginning point
    assign WrongGuesses = WrongStatus;

    // Make the rules 
    assign GameStatus = (WrongStatus == wrong4 ? LOSE : (Guess == Won ? WIN : PLAY));


endmodule
