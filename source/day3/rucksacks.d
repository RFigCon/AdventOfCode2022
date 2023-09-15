module day3.rucksacks;

import std.stdio;
import std.file;
import std.array;
import std.algorithm;

private string resources_dir = "resources\\day3\\";

private bool binarySearch(T)(ref const T[] arr, T elem){
    if(arr.length==0) return false;

    ulong len = arr.length;
    ulong index = (len-1)>>1;
    //writeln("len: ",len, "\tindex: ", index);
    do{

        if(elem == arr[index]){
            return true;
        }

        len = len >> 1;

        if(elem<arr[index]){
            if(index==0) return false;
            if(len%2==0){
                index = index - (len>>1);
            }else{
                index = index - (len>>1) -1;
            }
        }else{
            if(len%2==0){
                index = index + (len>>1);
            }else{
                index = index + (len>>1) +1;
            }
        }
        
    }while(len!=0);
    //writeln(arr, "\nLEN: " , arr.length, "\nIDX: ",  index, "\nARR[IDX]: ", arr[index], "\nElem: ", elem, "\n");
    return false;
}

//Part 1
private struct Rucksack{
    ulong len = 0;
    byte[] compartment1;
    byte[] compartment2;
    char repeated_item;
}

private Rucksack[] rucksacks;

private void loadRucksacks(string file_name){
    File file = File(resources_dir ~ file_name, "r");

    rucksacks.length = 500;
    uint ruck_idx = 0;

    
    byte[] line = cast(byte[])file.readln();
    while(line!=null && line!="\n"){
        ulong half_point = line.length/2;

        byte[] first = line[0..half_point].dup();
        byte[] second = line[half_point..$].dup();

        if(second[$-1] == '\n'){
            second.length -= 1;
        }

        sort(first);
        sort(second);

        rucksacks[ruck_idx].compartment1 = first;
        rucksacks[ruck_idx].compartment2 = second;
        rucksacks[ruck_idx].len = half_point;

        

        // writeln("Compartment 1: ", rucksacks[ruck_idx].compartment1, "\n");
        // writeln("Compartment 2: ", rucksacks[ruck_idx].compartment2, "\n");

        if(rucksacks[ruck_idx].compartment1.length != rucksacks[ruck_idx].compartment2.length){
            throw new Exception("Rucksacks should be of an even size");
        }

        ruck_idx++;
        if(ruck_idx>=rucksacks.length){
            rucksacks.length *= 2;
        }

        line = cast(byte[])file.readln();
    }

}

private void findAndSetWrongItem(){
    
    Rucksack* sack;
    foreach (size_t sack_idx, _; rucksacks) {
        sack = &rucksacks[sack_idx];

        if(sack.len==0) break;  //Everything from here on is not initialized

        foreach(size_t idx, byte symb; sack.compartment1){
            
            if(symb<sack.compartment2[0] || symb>sack.compartment2[$-1]) continue;

            if(sack.compartment2.binarySearch!(byte)(symb)){
                // writeln("Symb:", cast(char)symb);
                rucksacks[sack_idx].repeated_item = cast(char)symb;
                // writeln("k = ", sack_idx, "\tRepeated Item:", sack.repeated_item);
                break;
            }

        }
    }

}

private uint sumPriority1(){
    uint priority = 0;
    uint total = 0;
    foreach (size_t idx, Rucksack sack; rucksacks) {

        if(sack.len == 0) break; //Everything from here on is not initialized
        
        if(sack.repeated_item>='a'){
            priority = (sack.repeated_item - 'a') + 1;
        }else{
            priority = (sack.repeated_item - 'A') + 1 + 26;
        }
        // writeln("idx = ", idx, "\tChar: ", sack.repeated_item, ";\tPriority: ", priority);
        total += priority;
    }
    return total;
}

//---End Part 1 exclusive code---

//Part 2
private byte[][] loadSacks(string file_name){
    File file = File(resources_dir ~ file_name, "r");

    byte[][] sacks;
    sacks.length = 200;
    uint sack_idx = 0;
    
    byte[] line = cast(byte[])file.readln();
    while(line!=null && line!="\n"){

        byte[] rucksack = line.dup();
        if(rucksack[$-1] == '\n'){
            rucksack.length -= 1;
        }

        sort(rucksack);

        sacks[sack_idx] = rucksack;
        sack_idx++;
        if(sack_idx>=sacks.length){
            sacks.length *= 2;
        }

        line = cast(byte[])file.readln();
    }
    return sacks;
}

private char[] findbadges(byte[][] sacks){
    char[] badges;
    badges.length = 70;
    byte[] matches;

    uint b_idx;
    uint m_idx;
    uint prev_idx;

    //Start at 1 and jump 2, why:
    //      We are going to compare the second sack with the first and keep the matches
    //      Then compare the third sack with the matches
    //      We never need to loop just the first of the three sacks
    for(int i = 1; i<sacks.length && sacks[i].length != 0; i+=2){

        m_idx = 0;
        prev_idx = i-1;
        matches.length = sacks[i].length;

        foreach(size_t j, byte ch; sacks[i]){
            if(sacks[prev_idx].binarySearch(ch)){
                matches[m_idx++] = ch;
                if(m_idx>=matches.length)
                    matches.length *= 2;
            }
        }
        matches.length = m_idx;
        i++;

        foreach(size_t j, byte ch; sacks[i]){
            if(matches.binarySearch(ch)){
                badges[b_idx++] = cast(char)ch;
                break;
            }
        }
        if(b_idx>=badges.length)
            badges.length *= 2;
    }
    badges.length = b_idx;
    return badges;
}

private uint sumPriority2(char[] arr){
    uint priority = 0;
    uint total = 0;
    foreach (size_t idx, char item; arr) {

        if(item>='a'){
            priority = (item - 'a') + 1;
        }else{
            priority = (item - 'A') + 1 + 26;
        }
        total += priority;
    }
    return total;
}
//---End Part 2 exclusive code---

void run(){
    
    try loadRucksacks("rucksacks.txt");
    catch(Exception ep){
        ep.writeln();
        return;
    }
    findAndSetWrongItem();
    writeln("--Part 1--\n\tTotal Priority: ", sumPriority1());

    byte[][] sacks = loadSacks("rucksacks.txt");
    char[] badges = findbadges(sacks);
    writeln("--Part 2--\n\tTotal Priority: ", sumPriority2(badges));
}