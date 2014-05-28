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

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Prand([1/16], inf),
		\buf, Prand(bongos, inf),
		\stretch, 1.875,
		\rate, 1,
		\amp, Pseq([0.8]++(0.1!7),inf),
	);
).play
)

)

(
p = Pbind(
	\scale,Scale.major,
	\degree, Pseq([
		Prand([0,2,4,5],1),
		Pseq([8,7,6,5],1),
		Prand([0,2,4,3],1),
		Pseq([6,7,8,6],1),
	], inf),
	\amp, Pbjorklund(9,16) * (1/16),
	\stretch, 1.875,
	\dur, Prand([1/16], inf),
).play;
)