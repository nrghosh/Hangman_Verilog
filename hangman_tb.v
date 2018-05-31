`timescale 1ns/100ps

`include "hangman.v"

module hangman_tb();

   reg clk = 0;
   reg rst = 0; 
   reg[6:0] letter = " ";
   wire[1:0] game_output;
   wire[2:0] wrong_guesses;

   hangman the_game(clk, rst, letter, wrong_guesses, game_output);

   task test;
      input[6:0] the_guess;
      begin
         letter <= the_guess;
         #20
         $display("Guessed %s and game says %s. Wrong guesses: %d",the_guess,
            game_output==2'd0?"PLAY":
            game_output==2'd1?"LOSE":
            game_output==2'd2?"WIN":"??", wrong_guesses);
      end
   endtask

   always #10
      clk <= ~clk;

   initial begin

      $dumpfile("hangman.vcd");
      $dumpvars(0, the_game);

      $display("Starting new game");
      rst<=1; #20 rst<=0;
       test("q");
       test("w");
       test("q");
       test("z");
       test("v");


      $display("Starting new game");
      rst<=1; #20 rst<=0;
       test("p");
       test("a");
       test("s");
       test("s");
       test("q");
       test("l");
       test("z");
       test("t");
       test("a");
       test("z");
       test("z");


      $display("Starting new game");
      rst<=1; #20 rst<=0;
       test("l");
       test("a");
       test("s");
       test("q");
       test("p");
       test("z");
       test("t");
       test("u");
       test("z");


       $finish;

   end

endmodule
