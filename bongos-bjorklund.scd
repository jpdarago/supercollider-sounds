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
		\dur, Prand([1/16],inf),
		\buf, Pwrand(bongos, [16,8,4,2,1].reverse.normalizeSum, inf),
		\stretch, 1.875,
		\rate, Pbjorklund(9,16,inf),
		\amp, 1,
	);
).play
)

)