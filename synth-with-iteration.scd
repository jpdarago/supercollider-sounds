(
SynthDef.new(\iter, {
	arg freq = 40;
	var env, temp, sum;
	sum = 0;
	env = EnvGen.kr(
		Env.perc(0.01, 5, 1, -2),
		doneAction:2
	);
	10.do{
		temp = VarSaw.ar(
			freq * {Rand(0.99, 1.02)}!2,
			{Rand(0.0,1.0)}!2,
			{ExpRand(0.005, 0.05)}!2
		);
		sum = sum + temp;
	};
	sum = sum*0.05*env;
	Out.ar(0, sum);
}).add;
)

x = Synth.new(\iter, [\freq, 400]);
x.free;

(
SynthDef.new(\iter2, {
	arg freq=200;
	var temp,sum;
	sum = 0;
	10.do{
		arg count;
		temp = SinOsc.ar(freq
			* (count+1)
			* LFNoise1.kr({Rand(0.05, 0.2)}!2).range(0.98, 1.02)
		);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth.new(\iter2);
x.set(\freq, 50);
x.free;