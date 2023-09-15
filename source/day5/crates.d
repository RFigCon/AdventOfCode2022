module day5.crates;

import std.stdio;
import std.file;

private string resources_dir = "resources\\day5\\";

private struct Stack{
    char[] crates;
    uint top = 0;
}

private Stack[] stacks;

private void insertAtStart(uint st_idx, char elem){
    Stack* st = &stacks[st_idx];

    st.top++;
    if(st.top>=st.crates.length){
        st.crates.length *= 2;
    }

    uint idx = st.top;
    while(idx>0){
        st.crates[idx] = st.crates[idx-1];
        idx--;
    }
    st.crates[0] = elem;

}

private File loadStacks(string file_name) {

    File file = File(resources_dir ~ file_name, "r");

    string line = file.readln();
    
    stacks.length = (line.length)/4;      //"[R] " takes up 4 places, and then comes the next crate
    foreach (size_t i, _; stacks) {
        stacks[i].crates.length = 10;
    }
    
    uint idx;
    uint st_idx;

    while(line[1] != '1' ) {

        st_idx = 0;
        idx = 1;    //Fist crate letter at index 1
        while(idx<line.length){
            
            if(line[idx] != ' '){
                insertAtStart(st_idx, line[idx]);
                //writeln(st_idx, " ", line[idx]);
            }
            st_idx++;
            idx += 4;   //Each crate takes up 4 places, and then comes then next crate
        }
        line = file.readln();

    }

    file.readln();  //Read empty line
    return file;
}

//ASCII/UTF-8 codes which correspond to 0011 ****, correspond to symbols '0' to '9', plus ':' to '?'
//Since the source file does not contain sysmbols from ':' to '?', we can use the 0011 prefix to know if the character is a number
immutable(uint) bin_code    = 0b0011_0000;
immutable(uint) bin_filter  = 0b1111_0000;
private void readOrders(File file){

    string line = file.readln();

    uint crates = 0, from = 0, to = 0, idx = 0;
    
    while(line != null && line != "\n" ) {

        crates = 0, from = 0, to = 0;
        idx = 5;    //Fist number at index 1
        
        while( (line[idx] & bin_filter) == bin_code ){
            
            crates *= 10;
            crates += line[idx]-'0';
            
            idx++;   //Each crate takes up 4 places, and then comes then next crate
        }

        idx += 6; //Second number will be 7 indexes away from the first
        
        while( (line[idx] & bin_filter) == bin_code ){
            
            from *= 10;
            from += line[idx]-'0';
            
            idx++;   //Each crate takes up 4 places, and then comes then next crate
        }

        idx += 4; //Third number will be 5 indexes away from the second
        
        while( idx<line.length && (line[idx] & bin_filter) == bin_code ){
            
            to *= 10;
            to += line[idx]-'0';
            
            idx++;   //Each crate takes up 4 places, and then comes then next crate
        }

        //writeln("Move crates ", crates, " from ", from, " to ", to);
        moveCrates(crates, from, to);

        line = file.readln();
    }

}

private void reverse(T)(T[] arr){

    if(arr.length < 2) return;

    uint f_pin = 0;
    uint l_pin = cast(uint)(arr.length - 1);

    uint half = cast(uint)arr.length>>1;

    T aux;

    while(f_pin<half){

        aux = arr[f_pin];
        arr[f_pin] = arr[l_pin];
        arr[l_pin] = aux;

        f_pin++;
        l_pin--;
    }

}

bool crane_9000 = true;

private void moveCrates(uint crates, uint from, uint to){

    //writeln(crates, ": ", from, "[", stacks[from-1].top, "] ~> ", to, "[", stacks[to-1].top, "]");

    from--;
    to--;

    uint end = stacks[from].top;
    uint start = end-crates;
    char[] temp = stacks[from].crates[start .. end].dup;
    stacks[from].top = start;

    if(crane_9000) reverse(temp);

    start = stacks[to].top;
    end = start + crates;
    while(end > stacks[to].crates.length){
        stacks[to].crates.length *= 2;
    }

    stacks[to].crates[start .. end] = temp;
    stacks[to].top = end;
}

private void printStacks(){
    foreach(size_t i, Stack stack; stacks){
        write(i, "[", stack.top, "] ~> ");
        foreach(size_t j, char ch; stack.crates){
            if(j>=stack.top) break;
            write(ch);
        }
        write('\n');
    }
}

private void printTops(){
    uint last_el;
    write('\t');
    foreach(Stack st; stacks){
        last_el = st.top-1;
        write(st.crates[last_el]);
    }
    write('\n');
}

private void resetStack(){
    foreach(size_t i, _; stacks){
        stacks[i].crates.length = 0;
        stacks[i].top = 0;
    }

}


void run(){
    
    writeln("--Part 1--");

    File f = loadStacks("crates.txt");
    readOrders(f);

    //printStacks();
    printTops();
    f.close();

    //-------------------------------

    writeln("--Part 2--");
    crane_9000 = false;
    resetStack();

    f = loadStacks("crates.txt");
    readOrders(f);

    //printStacks();
    printTops();
    f.close();

}