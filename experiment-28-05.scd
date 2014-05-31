// Synth flashero con mouse

(
SynthDef.new(\flashero,{ |amp = 1.0|
	var ctl = RLPF.ar(Saw.ar(5,0.1), MouseX.kr(2, 200, 1), MouseY.kr(0.01, 1, 1));
    var sig = SinOsc.ar(ctl * 200 + 400) * amp;
	Out.ar([0,0], [sig, sig]);
}).add;
)

(
Synth.new(\flashero, [\amp, 0.1])
)

// Escalas
(
Pbind(
	\scale,Scale.minor,
	\degree, Prand([0,2,4,6], inf),
	\stretch, 1.875,
	\amp, Pbjorklund(9,16) * 0.2,
	\dur, Prand([1/16], inf),
).play;
)

// Reverbation
,(
{
var s, z, y;
    // 10 voices of a random sine percussion sound :
s = Mix.ar(Array.fill(10, { Resonz.ar(Dust.ar(0.2, 50), 200 + 3000.0.rand, 0.003)}) );
    // reverb predelay time :
z = DelayN.ar(s, 0.048);
    // 7 length modulated comb delays in parallel :
y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));
    // two parallel chains of 4 allpass delays (8 total) :
4.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });
    // add original sound to reverb and play it :
s+(0.2*y)
}.scope
)

// Arpegiator
(
SynthDef.new(\arpegiatorNote, { |sustain=1, freq|
    var out;
    out = RLPF.ar(
        LFSaw.ar( freq ),
        LFNoise1.kr(1, 36, 110).midicps,
        0.1
    ) * EnvGen.kr( Env.perc, levelScale: 0.3,
        timeScale: sustain, doneAction: 2 );
    4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
    Out.ar( 0, out );
}).add
)

(
var stream, pattern, dur = 1/8;
stream = Pseq(Scale.major, inf).midicps.asStream;
Routine({
	loop({
		Synth.new(\arpegiator, [\freq, stream.next]);
		dur.wait;
	});
}).play
)
