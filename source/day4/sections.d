module day4.sections;

import std.stdio;
import std.file;

private string resources_dir = "resources\\day4\\";

private struct Sector {
    uint start = 0;
    uint end = 0;
}

//Part 1
private uint loadAndCountContained(string file_name){
    File file = File(resources_dir ~ file_name, "r");

    uint full_contain = 0;

    uint* pointer;
    uint idx = 0;
    byte[] line = cast(byte[])file.readln();
    while(line!=null && line !="\n"){
        
        Sector first = Sector();
        Sector second = Sector();
        pointer = &first.start;

        for(idx = 0; line[idx]!=','; idx++){
            if(line[idx]=='-'){
                pointer = &first.end;
                continue;
            }
            (*pointer) = (*pointer) * 10;
            (*pointer) += (line[idx]-'0');
        }
        idx++;
        pointer = &second.start;
        for(; idx<line.length && line[idx]!='\n'; idx++){
            if(line[idx]=='-'){
                pointer = &second.end;
                continue;
            }
            (*pointer) = (*pointer) * 10;
            (*pointer) += (line[idx]-'0');
        }

        line = cast(byte[])file.readln();

        if( (first.start<=second.start && first.end>=second.end)
            || (first.start>=second.start && first.end<=second.end) ){
                
            /*
            writeln("\n\tContaining: ");
            writeln("Sectors start - A:", first.start, " B:", second.start);
            writeln("Sectors end - A:", first.end, " B:", second.end);
            */
            full_contain++;
        }
    }

    return full_contain;
}

//Part 2
private uint loadAndCountOverlaped(string file_name){
    File file = File(resources_dir ~ file_name, "r");

    uint full_contain = 0;

    uint* pointer;
    uint idx = 0;
    byte[] line = cast(byte[])file.readln();
    while(line!=null && line !="\n"){
        
        Sector first = Sector();
        Sector second = Sector();
        pointer = &first.start;

        for(idx = 0; line[idx]!=','; idx++){
            if(line[idx]=='-'){
                pointer = &first.end;
                continue;
            }
            (*pointer) = (*pointer) * 10;
            (*pointer) += (line[idx]-'0');
        }
        idx++;
        pointer = &second.start;
        for(; idx<line.length && line[idx]!='\n'; idx++){
            if(line[idx]=='-'){
                pointer = &second.end;
                continue;
            }
            (*pointer) = (*pointer) * 10;
            (*pointer) += (line[idx]-'0');
        }

        line = cast(byte[])file.readln();

        if( first.start<=second.end && second.start<=first.end){
                
            /*
            writeln("\n\tContaining: ");
            writeln("Sectors start - A:", first.start, " B:", second.start);
            writeln("Sectors end - A:", first.end, " B:", second.end);
            */
            full_contain++;
        }
    }

    return full_contain;
}

void run(){
    uint count = loadAndCountContained("sectors.txt");
    writeln("--Part 1--\n\tRanges that fully contain the other: ", count);

    count = loadAndCountOverlaped("sectors.txt");
    writeln("--Part 2--\n\tRanges that overlap each other: ", count);
}