/**
*  Hack for the Speaker vs ON Stage using Midsummer Night's Dream
*/
FS f;

/**
*  Original takes the integer data file from the transform
*/
me.arg(0) => string original;

//initialise matrix
string texta[2000];

f.readString(original, 1868) @=> texta;


//int chars[10];

for( 1 => int i; i < 1868; i++ ) {
   int chars[10];
   0 => int accum;
   get_extension(texta[i], chars, accum);
   0 => accum;   
}

/**
* Function to play the speaker. 
* Assign it to the Sine Oscillator
*/
fun void play_spk(string noteone) {
    SinOsc s1 => dac.left;
    <<< "speaker: ", noteone >>>;
    // start the first note
     Std.atoi(noteone)   => s1.freq;
    100::ms => now;
    0 => s1.freq;
}  

/**
* Function to play the character. 
* Assign it to the Sine Oscillator
*/
fun void play_char(string noteone) {
    SinOsc sr => dac.right;
    <<< "character: ", noteone >>>;
    (Std.atoi(noteone) + 70)  => sr.freq;
    100::ms => now;
    0 => sr.freq;
}

/**
*  Convert the strings into an array
*/
fun int[] get_extension (string filename, int chars[], int accum)
{
    // test needs to have the boundary at 0 and one with out
    if (filename.find(",") > 0) {
       filename.find(",") => int extPos;
       if (accum == 1) {
           play_spk(filename.substring(0,extPos));
           1 +=> accum;
           get_extension(filename.substring((extPos + 1)), chars, accum);
       } else {
       play_char(filename.substring(0,extPos));
       1 +=> accum;
       get_extension(filename.substring((extPos + 1)), chars, accum);
      } 
    } else {
       play_char(filename);
    }
}
