module day6.coms;

import std.stdio;
import std.array;

private immutable(char)[] resources = "resources\\day6\\";

private ubyte getLastRepIdx (immutable(ubyte) win_size) (ubyte[win_size] window){

    ubyte last_rep_idx = win_size;

    for(ubyte i = 0; i<win_size-1; i++){
        for(int j = i+1; j<win_size; j++){
            if(window[j]==window[i])
                last_rep_idx = i;
        }
    }
    return last_rep_idx; //WINDOW_SIZE if nothing repeats
}

private void insertAtEnd (immutable(ubyte) win_size) (ref ubyte[win_size] window, ubyte[] arr ){
    
    ubyte places = cast(ubyte)arr.length;
    ubyte i = 0;
    for(; i+places<win_size; i++){
        window[i] = window[i+places];
    }

    //ubyte j = cast(ubyte)(win_size - places);
    for(ubyte j = 0; j<places; j++, i++){
        window[i] = arr[j];
    }
}

private struct Marker {
    char symb;
    uint idx;
}

private Marker proccessStream (immutable(ubyte) win_size) ( string file_name){
    File file = File(resources ~ file_name, "r");

    ubyte[win_size] window;
    ubyte[] buffer;
    ubyte[] buff_sl;
    buffer.length = win_size;

    buff_sl = file.rawRead(buffer);
    window[] = buff_sl[0..$]; //Assuming input is sane

    uint counter = win_size;
    ubyte rep_idx = getLastRepIdx!win_size(window);
    while(rep_idx!=win_size && buff_sl.length!=0){

        buffer.length = rep_idx+1;
        buff_sl = file.rawRead(buffer);

        insertAtEnd!win_size(window, buff_sl);
        rep_idx = getLastRepIdx!win_size(window);

        counter += buff_sl.length;
    }

    Marker marker = Marker();
    file.readf!"%c"(marker.symb);
    marker.idx = counter;
    
    return marker;
}

private immutable(ubyte) START_WINDOW = 4;
private immutable(ubyte) MSG_WINDOW = 14;

public void run(){

    Marker marker = proccessStream!START_WINDOW("stream.txt");
    writeln("--Part 1--\n\t", marker.symb, " : ", marker.idx);

    marker = proccessStream!MSG_WINDOW("stream.txt");
    writeln("--Part 2--\n\t", marker.symb, " : ", marker.idx);

    /*
    ubyte[4] window = [41, 45, 43, 45];
    ubyte[] buff;
    buff.length = 2;
    buff[0] = 49;
    buff[1] = 49;

    insertAtEnd(window, buff);

    writeln("window = ", window);
    */
}
