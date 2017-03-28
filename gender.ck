/**
*  Hack for the Speaker vs ON Stage using Midsummer Night's Dream
*/

SinOsc s1 => dac.left;
SinOsc s2 => Pan2 p => dac.right;

me.arg(0) => string original;

//initialise matrix
string texta[2000];

readInts(original) @=> texta;

//to do, get the 
0 => int accum;
int chars[10];
for( 1 => int i; i < 1868; i++ ) {
   get_extension(texta[i], chars, accum);
   <<< texta[i] >>>;
   play_spk(s1, chars[1]);
   for (2 => int k; k<(chars.size() -2); k++) {
      spork ~ play_char(s2, (70+chars[k]), p);
   }
}

// play the note
fun void play_spk(SinOsc s, int noteone) {
    // start the first note
    Std.mtof( noteone )  => s.freq;

    100::ms => now;
    0 => s.freq;
}  
// play the note
fun void play_char(SinOsc sr, int noteone, pan2 p) {
    // start the first note
    Math.random2f( -1, 1 ) => p.pan;
    Std.mtof( noteone ) => sr.freq;

    100::ms => now;
    0 => sr.freq;
}


/**
*   Convert this into an Iterator pattern already!
*/
fun int[] get_extension (string filename, int a[], int accum)
{
    filename.find(",") => int extPos;
    // test needs to have the boundary at 0 and one with out
    if (extPos > -1) {
       Std.atoi(filename.substring(0,extPos)) => a[accum];
       get_extension(filename.substring((extPos + 1)), a, (accum + 1));
    } else {
       return a;
    }
}

fun string get_pattern (string filename, string search) {
    filename.find("[") => int extPos;
    if (extPos > 0 ) {
        filename.replace(extPos, "");
        //get_pattern(filename, search);
    } else {
       return filename;
    }
}

fun string[] readInts(string path) {

    // open the file
    FileIO file;
    if (!file.open(path, FileIO.READ)) {
        <<< "file read failed" >>>;
        <<< path >>>;
        string ret[0]; // error opening the specified file
        return ret;
    }

    // read the size of the array
    1868 => int size;
    // now read in the contents
    string ret[size];
    // loop until end
    for( 0 => int i; i < (size-1); i++ )
    {
       file => ret[i];
    }
    file.close();
    return ret;
}
