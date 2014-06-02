(
var n = NetAddr("127.0.0.1", 3333);
r = Routine({
	var st = Pseq([45,46,47,48,54,55,56,57],inf).asStream;
	loop({
		var v = st.next;
		n.sendMsg("/note",v,75);
		v.yield
	});
});

q = Routine({
	loop({
		var v = 60.rrand(80).round(6);
		n.sendMsg("/note",v,150);
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

(
TempoClock.default.tempo = 2;
Pbind(
	\instrument,\prophet5pwmstrings,
	\midinote,q.asStream,
	\dur,700/1000,
	\lfowidth,Pn(Pseries(0.0,0.025,7),inf),
	\lforate,Pn(Pseries(2,1,11),inf),
	\rq,Pn(Pseries(0.9,-0.1,5),inf)
).play
)

)