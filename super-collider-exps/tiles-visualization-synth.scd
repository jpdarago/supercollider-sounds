(
var n = NetAddr("127.0.0.1", 3333);
r = Routine({
	loop({
		v = 40.rrand(90);
		n.sendMsg("/note",v,75);
		v.yield
	});
});

r.asStream.next;
)

(
SynthDef(\prophet5pwmstrings,{|out= 0 freq = 440 amp = 1.0 gate=1 lforate = 10 lfowidth= 0.5 cutoff= 12000 rq=0.5 pan = 0.0|

	var lfo, pulse, filter, env;

	lfo = LFTri.kr(lforate*[1,1.01],Rand(0,2.0)!2);

	pulse = Pulse.ar(freq*[1,1.01],lfo*lfowidth+0.5);

	filter = RLPF.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(0.01,0.0,1.0,0.5),gate,doneAction:2);

	Out.ar(out,Pan2.ar(Mix(filter)*env*amp*0.5,pan));

}).add
)


(
TempoClock.default.tempo = 2;
Pbind(
	\instrument,\prophet5pwmstrings,
	\midinote,r.asStream,
	\dur,350/1000,
	\lfowidth,Pn(Pseries(0.0,0.025,7),inf),
	\lforate,Pn(Pseries(2,1,11),inf),
	\rq,Pn(Pseries(0.9,-0.1,5),inf)
).play
)


)