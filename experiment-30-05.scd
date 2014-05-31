{ FreeVerb.ar(LPF.ar(Blip.ar, 1000), 0.2, 0,3, 0.4) }.play

{Resonz.ar(LFNoise0.ar(400),1000,0.1)}.play

// Pan pans the stereo field to the speakers. Move the mouse
{Pan2.ar(PinkNoise.ar(0.1), MouseX.kr(-1,1))}.scope

// Bell
{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1))}.scope //bell spectra, all partials the same volume

{SinOsc.ar(440,0,Line.kr(0.1,0.0,1.0))}.scope