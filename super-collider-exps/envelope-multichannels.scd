(
{
	var sig, freq, env;
	env = XLine.kr(1, 0.01, 1, doneAction: 2);
	freq = XLine.kr(880, 110, 1, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500)) * env;
}.play;
)

(
x = {
	var sig, env;
	env = EnvGen.kr(Env.new(
			[0,1, 0.2, 0],
			[0.5, 1, 2],
			[3, -3, 0]
		), doneAction: 2);
	sig = Pulse.ar(ExpRand(50, 300)) * env;
}.play;
)

{ PinkNoise.ar(0.5)!2 }.play