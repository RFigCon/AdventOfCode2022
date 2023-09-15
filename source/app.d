import std.stdio;
import std.file;
import std.array;
import std.datetime.stopwatch;

import calories;
import day2.calc;
import day3.rucksacks;
import day4.sections;
import day5.crates;
import day6.coms;

//ADVENT OF CODE 2022

void main() {

	StopWatch sw = StopWatch();

	if(sw.running()) sw.stop();
	sw.reset();
	sw.start();

	writeln("----------------------------\n\tDay 1\n----------------------------");
	calories.run();

	writeln("----------------------------\n\tDay 2\n----------------------------");
	day2.calc.run();

	writeln("----------------------------\n\tDay 3\n----------------------------");
	day3.rucksacks.run();

	writeln("----------------------------\n\tDay 4\n----------------------------");
	day4.sections.run();

	writeln("----------------------------\n\tDay 5\n----------------------------");
	day5.crates.run();

	writeln("----------------------------\n\tDay 6\n----------------------------");
	day6.coms.run();

	sw.stop();

	writeln(sw.peek().total!"usecs", " micro seconds have passed since the start of the program.");
}
