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

Scale.directory

(
Pbind(
	\scale,Scale.aeolian,
	\degree, Prand([0,2,4,6], inf),
	\stretch, 1.875,
	\amp, Pbjorklund(9,16) * 0.2,
	\dur, Prand([1/16], inf),
).play;
)

(
Pbind(
	\scale,Scale.aeolian,
	\degree, Prand([0,2,4,6], inf),
	\stretch, 1.875,
	\amp, KeyState.kr(38, 0.1, 0.8),
	\dur, Prand([1/16], inf),
).play;
)