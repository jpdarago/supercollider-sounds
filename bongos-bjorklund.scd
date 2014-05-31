(
var bongos;

bongos = PathName.new("/home/jpdarago/projects/supercollider-sounds/sound-files/bongos").entries.collect({
	arg path;
	Buffer.read(s,path.fullPath);
});

(
SynthDef.new(\bufplay, {
	arg buf = 0, rate = 1, amp = 1;
	var sig;
	sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf) * rate, doneAction: 2);
	sig = sig * amp;
	Out.ar(0, sig);
	Out.ar(1, sig);
}).add;
);

Synth.new(\bufplay, [\buf, bongos[2].bufnum]);

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Prand([1/16],inf),
		\buf, Prand(bongos, inf),
		\stretch, 1.875,
		\rate, 1,
		\amp, Pbjorklund(11,16,inf) * 1.2,
	);
).play(quant:1.875)
)

)

(
Pbind(
	\scale,Scale.minor,
	\degree, Prand([0,2,4,6], inf),
	\stretch, 1.875,
	\amp, Pbjorklund(9,16) * 0.2,
	\dur, 1/16,
).play;
)