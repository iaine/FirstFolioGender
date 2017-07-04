// shred to record the audio
// arguments: rec:<filename>

// get name
me.arg(0) => string filename;

if( filename.length() == 0 ) "chord" => filename;

// pull samples from the dac
dac => Gain g => WvOut w => blackhole;
// this is the output file name
filename => w.wavFilename;

// any gain you want for the output
.5 => g.gain;

// temporary workaround to automatically close file on remove-shred
null @=> w;

// infinite time loop...
// ctrl-c will stop it, or modify to desired duration
while( true ) {
   10::second => now;
}
