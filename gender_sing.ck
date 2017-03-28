/**
*  Hack for the Speaker vs ON Stage using Midsummer Night's Dream
*/
FS f;

SinOsc s1 => dac.left;
SinOsc s2 => Pan2 p => dac.right;

/**
*  Original takes the integer data file from the transform
*/
me.arg(0) => string original;

//initialise matrix
string texta[2000];

f.readInts(original, 1868) @=> texta;

//to do, get the 
0 => int accum;
int chars[10];
for( 1 => int i; i < 1868; i++ ) {
   get_extension(texta[i], chars, accum);
   /** Play the speaker on the left channel */
   play_spk(s1, chars[1]);
   /**
   *  Play the second channel for the characters.
   */
   for (2 => int k; k<(chars.size() -2); k++) {
      spork ~ play_char(s2, (70+chars[k]), p);
   }
}

/**
* Function to play the speaker. 
* Assign it to the Sine Oscillator
*/
fun void play_spk(SinOsc s, int noteone) {
    // start the first note
    Std.mtof( noteone )  => s.freq;
    100::ms => now;
    0 => s.freq;
}  

/**
* Function to play the character. 
* Assign it to the Sine Oscillator
*/
fun void play_char(SinOsc sr, int noteone, pan2 p) {
    Math.random2f( -1, 1 ) => p.pan;
    Std.mtof( noteone ) => sr.freq;
    100::ms => now;
    0 => sr.freq;
}

/**
*  Convert the strings into an array
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
