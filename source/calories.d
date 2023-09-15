module calories;

import std.stdio;
import std.file;
import std.array;

//ADVENT OF CODE 2022
//Day 1: Calorie Counting

string resources = "resources\\day1\\";

class BadInputException : Exception
{
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

struct TopElves
{
	uint[3] elf_numbers;
	uint[3] total_cals;
}

///inserts element into static array; shifts right removing last element
void insertShiftRight(T, uint N)(ref T[N] arr, uint idx, T val){
	T prev_elm;
	while(idx<=arr.length){
		prev_elm = arr[idx];
		arr[idx] = val;
		prev_elm = val;
		idx++;
	}
}

///inserts element into static array; shifts left removing first element
void insertShiftLeft(T, uint N)(ref T[N] arr, uint idx, T val){
	T prev_elm;
	if(idx>=N) return;
	while(idx != uint.max){
		prev_elm = arr[idx];
		arr[idx] = val;
		val = prev_elm;
		idx--;
	}
}

void ifBiggerThenPut(ref TopElves top, uint cals, uint elf_number){

	uint idx = top.total_cals.length;
	while(idx-- >0){

		if(top.total_cals[idx]<cals){
			insertShiftLeft(top.total_cals, idx, cals);
			insertShiftLeft(top.elf_numbers, idx, elf_number);
			break;
		}
	}
	
}

TopElves getRichestElf(string file_name){
	File cal_file = File(resources ~ file_name, "r");

	TopElves most_cal_elves;

	uint cal = 0;
	uint total_cal = 0;
	uint elf_num = 1;

	string line = cal_file.readln();
	while(line != null){
		
		if(line[0] == '\n'){
			ifBiggerThenPut(most_cal_elves, total_cal, elf_num);
			total_cal = 0;
			elf_num++;
			line = cal_file.readln();
			continue;
		}

		cal = 0;
		foreach (char key; line[0..$]) {
			if(key=='\n') break;
			if(key<'0' || key >'9') throw new BadInputException("File must be only numbers and new lines >>" ~ file_name);
			cal *=10;
			cal += key-'0';
		}

		total_cal+=cal;
		line = cal_file.readln();
	}
	ifBiggerThenPut(most_cal_elves, total_cal, elf_num);
	cal_file.close();
	return most_cal_elves;
}

void run()
{
    TopElves elves;
    try	elves = getRichestElf("CaloriesPerElf.txt");
    catch(Exception exp){
        writeln("Exception Thrown: ", exp.msg);
        return;
    } 
	uint grand_total = 0;

	foreach(uint idx, uint val; elves.total_cals){
		writeln("Elf Number: ", elves.elf_numbers[idx], "; \tTotal Cals: ", val);
		grand_total += val;
	}

	writeln("Grand Total: ", grand_total, " calories!");
	
}
