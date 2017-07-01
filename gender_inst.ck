/**
*  Speaker vs On Stage using Midsummer Night's Dream. 
*  Use instruments. 
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
   100::ms => now;   
}

/**
* Function to play the speaker. 
* Assign it to the Sine Oscillator
*/
fun void play_spk(string noteone) {
    /*SinOsc s1 => dac.left;
    <<< "speaker: ", noteone >>>;
    // start the first note
     Std.atoi(noteone)   => s1.freq;
    100::ms => now;
    0 => s1.freq;*/
    Std.atoi(noteone) => int n;
    // assign instrument to gender.
    if (n > 210) {
       fluteSpk(n);
    } else if (n > 127) {
       stringsSpk(n);
    } else if(n > 60) {
       electronicSpk(n);
    }
} 

fun void stringsSpk(int note) {
   Clarinet s => JCRev r3 => dac.left;
   0.5 => r3.gain;

  0.2 => s.reed;
  0.2 => s.noiseGain;
  0.2 => s.pressure;

  note => s.freq;
  0.5 => s.gain;
  0.5 => s.noteOn;
  100::ms => now;
}

fun void fluteSpk(int note) {
   Flute fl => JCRev r => dac.left;
   0.5 => r.gain;

  note => fl.freq;
  0.5 => fl.gain;
  0.5 => fl.noteOn;
  100::ms => now;
}

fun void electronicSpk (int note) {
    SinOsc sr => dac.left;
    (note + 70)  => sr.freq;
    100::ms => now;
    0 => sr.freq;
}

/**
* Function to play the character. 
*/
fun void play_char(string noteone) {
    Std.atoi(noteone) => int n;
    // assign instrument to gender. 
    if (n > 210) {
       fluteChar(n);
    } else if (n > 127) {
       stringsChar(n);
    } else if(n > 60) {
       electronic(n);
    }
}

fun void stringsChar(int note) {
   Clarinet s => JCRev r3 => dac.right;
   0.5 => r3.gain;

  0.2 => s.reed;
  0.2 => s.noiseGain;
  0.2 => s.pressure;

  note => s.freq;
  0.5 => s.gain;
  0.5 => s.noteOn;
  100::ms => now; 
}

fun void fluteChar(int note) {
   Flute fl => JCRev r => dac.right;
   0.5 => r.gain;

  note => fl.freq;
  0.5 => fl.gain;
  0.5 => fl.noteOn;
  100::ms => now;
}

fun void electronic (int note) {
    SinOsc sr => dac.right;
    (note + 70)  => sr.freq;
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
           spork~play_spk(filename.substring(0,extPos));
           1 +=> accum;
           get_extension(filename.substring((extPos + 1)), chars, accum);
       } else {
       spork~play_char(filename.substring(0,extPos));
       100::ms => now;
       1 +=> accum;
       get_extension(filename.substring((extPos + 1)), chars, accum);
      } 
    } else {
       play_char(filename);
       100::ms => now;
    }
}
