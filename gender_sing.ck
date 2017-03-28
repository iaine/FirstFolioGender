/**
*  Hack for the Speaker vs ON Stage using Midsummer Night's Dream
*/
FS f;
Exception e;

SinOsc s1 => dac.left;
SinOsc s2 => Pan2 p => dac.right;

/**
*  Original takes the integer data file from the transform
*/
me.arg(0) => string original;
if (!original) {
   e.createMessage("No file is given");
}

// initialise matrix
string texta[1869];

f.readInts(original, 1868) @=> texta;

// initialise the accumulator
0 => int accum;

// Assumption that there is a max of 10 character elements
int chars[10];

// iterate over the array 
for( 1 => int i; i < 1868; i++ ) {
   convert_to_array(texta[i], chars, accum);
   /** Play the speaker on the left channel */
   play_spk(s1, chars[1]);
   /**
   *  Play the second channel for the characters.
   */
   for (2 => int k; k<(chars.size() -2); k++) {
      // making the data audible
      play_char(s2, (70+chars[k]), p);
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
fun void play_char(SinOsc sr, int noteone) {
    Std.mtof( noteone ) => sr.freq;
    100::ms => now;
    0 => sr.freq;
}

/**
*  Convert the strings into an array
*/
fun int[] convert_to_array (string filename, int a[], int accum)
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
