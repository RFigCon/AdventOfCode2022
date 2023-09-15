module day2.calc;

import std.stdio;
import std.file;

import day2.symbols;

//ADVENT OF CODE 2022
//Day 1: Calorie Counting

string resources_dir = "resources\\day2\\";

//Part1
ulong calcMyScore(string file_name){
    File file = File(resources_dir ~ file_name, "r");

    char op_c;
    char my_c;
    uint my_score = 0;

    uint count = file.readf!"%c %c\n"(op_c, my_c);

    //Assuming file does NOT have mistakes. Every line must have two capital letters seperated by a space.
    //First letter may be A, B, or C. Second may be X, Y, or Z.
    //File ends in New Line char
    //Using enums to practice.
    while(count == 2) {
        
        my_c -= ('X'-'A');

        if(my_c == Symbol.ROCK){
            my_score += Score.ROCK;
            
            if(op_c == Symbol.ROCK){
                my_score += 3;
            }else if(op_c == Symbol.SCISSORS){
                my_score += 6;
            }

        }else if(my_c == Symbol.PAPER){
            my_score += Score.PAPER;

            if(op_c == Symbol.PAPER){
                my_score += 3;
            }else if(op_c == Symbol.ROCK){
                my_score += 6;
            }

        }else if(my_c == Symbol.SCISSORS){
            my_score += Score.SCISSORS;

            if(op_c == Symbol.SCISSORS){
                my_score += 3;
            }else if(op_c == Symbol.PAPER){
                my_score += 6;
            }

        }

        count = file.readf!"%c %c\n"(op_c, my_c);
    }
    file.close();
    return my_score;
}

//Part 2
ulong calcResult(string file_name){
    File file = File(resources_dir ~ file_name, "r");

    char op_c;
    char rs_c;
    ulong my_total_score = 0;

    uint count = file.readf!"%c %c\n"(op_c, rs_c);

    //Assuming file does NOT have mistakes. Every line must have two capital letters seperated by a space.
    //First letter may be A, B, or C. Second may be X, Y, or Z.
    //File ends in New Line char
    //Using enums to practice.
    while(count == 2) {
        
        if(rs_c == Result.WIN){

            my_total_score += 6;
            if(op_c == Symbol.PAPER){
                my_total_score += Score.SCISSORS;

            }else if(op_c == Symbol.ROCK){
                my_total_score += Score.PAPER;

            }else if(op_c == Symbol.SCISSORS){
                my_total_score += Score.ROCK;
            }

        }else if(rs_c == Result.DRAW){

            my_total_score += 3;
            if(op_c == Symbol.PAPER){
                my_total_score += Score.PAPER;

            }else if(op_c == Symbol.ROCK){
                my_total_score += Score.ROCK;

            }else if(op_c == Symbol.SCISSORS){
                my_total_score += Score.SCISSORS;
            }

        }else if(rs_c == Result.LOSS){

            if(op_c == Symbol.PAPER){
                my_total_score += Score.ROCK;

            }else if(op_c == Symbol.ROCK){
                my_total_score += Score.SCISSORS;
                
            }else if(op_c == Symbol.SCISSORS){
                my_total_score += Score.PAPER;
            }
        }
        
        count = file.readf!"%c %c\n"(op_c, rs_c);
    }

    return my_total_score;
}

void run(){
    writeln("---Part1---\nMyScore: ", calcMyScore("RkPpSc.txt"));
    writeln("\n---Part2---");
    writeln("MyScore: ", calcResult("RkPpSc.txt"));
}