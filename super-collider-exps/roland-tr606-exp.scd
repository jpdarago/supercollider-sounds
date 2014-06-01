(
~kitnames = Dictionary[
	"snare" -> "606SNAR.WAV",
	"hihat" -> "606MHAT.WAV",
	"kick"  -> "606BASS.WAV"
];
~kit = Dictionary.new;
)

(
var path = "/home/jpdarago/projects/supercollider-sounds/sound-files/tr606/";
~kitnames.keysValuesDo({ |key, val|
	~kit.put(key, Buffer.read(s, path ++ val))
});
)

(
SynthDef(\sampleplay,{|out= 0 bufnum = 0 amp = 0.1 gate=1 pan = 0.0|

	var playbuf, env;

	playbuf = PlayBuf.ar(1,bufnum);

	env = EnvGen.ar(Env.adsr(0.0,0.0,1.0,0.1),gate,doneAction:2);

	Out.ar(out,Pan2.ar(playbuf*env*amp,pan));

}).add;

SynthDef(\samplecompress,{|out =0 gain=2 reduction=8 ratio=3 gate= 1 attackTime=0.016 relaxTime=0.05|

	var source = In.ar(out,2);
	var compression;
	var env = Linen.kr(gate, 0.0, 1, 0.1, 2);

	compression= Compander.ar(2*source,source,(-8).dbamp,1.0,ratio.reciprocal,attackTime,relaxTime);

	XOut.ar(out,env, compression);

}).add;

SynthDef(\sampleeq1,{|out =0 gate= 1|

	var source = In.ar(out,2);
	var env = Linen.kr(gate, 0.0, 1, 0.1, 2);
	var eq;

	eq= BLowShelf.ar(source,100,1.0,3);
	eq= BPeakEQ.ar(eq,600,1.0,-3);

	XOut.ar(out,env,eq);

}).add;

SynthDef(\sampleeq2,{|out =0 gate= 1|

	var source = In.ar(out,2);
	var env = Linen.kr(gate, 0.0, 1, 0.1, 2);
	var eq;

	eq= BHiPass(150,0.3);

	XOut.ar(out,env,eq);

}).add;


SynthDef(\samplereverb,{|out =0 gate= 1|

	var source = In.ar(out,2);
	var env = Linen.kr(gate, 0.0, 0.3, 0.1, 2);
	var reverb;

	reverb= FreeVerb.ar(source,1.0,0.6,0.6);

	XOut.ar(out,env,reverb);

}).add;
)

(
var hihat, snare, drum;

hihat = Pbind(
	\instrument, \bufplay,
	\dur, Prand([1/8], inf),
	\buf, Prand([~kit["hihat"]], inf),
	\stretch, 1.875,
	\rate, 1,
	\amp, Pseq([0.8]++(0.1!7),inf),
);

snare = Pbind(
	\instrument, \bufplay,
	\dur, Prand([1], inf),
	\buf, Prand([~kit["snare"]], inf),
	\stretch, 1.875,
	\rate, 1,
	\amp, 1,
);

drum = Pbind(
	\instrument, \bufplay,
	\dur, Prand([1/2], inf),
	\buf, Prand([~kit["kick"]], inf),
	\stretch, 1.875,
	\rate, 1,
	\amp, 1.2,
);

//Pfxb organises private busses for each sound
Ptpar([
	0.0,
	Pfxb(Pfx(drum,\samplecompress),\sampleeq1),
	1.0,
	Pfxb(Pfx(snare,\samplecompress,\gain,1,\reduction,10,\ratio,2,\attackTime,0.60),\samplereverb),
	0.0,
	Pfxb(hihat,\sampleeq2)
]).play
)
)
