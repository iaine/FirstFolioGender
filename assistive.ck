/**
*  Sonification of the count data for 
*  presentation audio insert
*/

SinOsc s => dac => WvOut w => blackhole;

3000 => int overTime;

"count" => w.wavFilename;

60 => s.freq;
overTime * (16/100)::ms => now;

120 => s.freq;
overTime * (54/100)::ms => now;

210 => s.freq;
overTime * (30/100)::ms => now;

//close the file
null @=> w;
