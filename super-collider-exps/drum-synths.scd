/*
The Fibonacci-sequence as controlsignal: melodies from Pisano Periods.
Because the sequence runs more or less exponentially, it seems best to assign the values to frequencies.
*/
s.boot;
SynthDef( \puls, {|freq=30, out|
		Out.ar(out,
			SinOsc.ar(freq, mul: 0.5*EnvGen.kr(Env.perc(0.01,0.75), doneAction: 2)),0)
}).add;
(
m=3000; //max index, 5 minutes = 300 when dur=0.1
a=Array.newClear(m);//two arrays to store numbers from the Pisano Periods
b=Array.newClear(m);
a.put(0,0);
a.put(1,1);
d=2; //even divisor
i=2; //index
while ({i<m}, {		//fill array a with numbers from the even Pisano Periods
	a.put(i, (a[i-2]+a[i-1])%d);
	if ((a[i]==1)&&(a[i-1]==0), {d=d+2});
	i=i+1;
});
d.postln;

b.put(0,0);
b.put(1,1);
d=3; //odd divisor
i=2; //index
while ({i<m}, {		//fill array b with numbers from the odd Pisano Periods
	b.put(i, (b[i-2]+b[i-1])%d);
	if ((b[i]==1)&&(b[i-1]==0), {d=d+2});
	i=i+1;
});
d.postln;
)
(
Pbind(
	\instrument, 	\puls,
	\out, 0,		//array a plays in left channel
	\dur, 	0.1,
	\freq, Pseq((1+a)*30)	//steps of 30Hz
	).play;

Pbind(
	\instrument, 	\puls,
	\out, 1,		//array b plays in right channel
	\dur, 	0.1,
	\freq, Pseq((1+b)*30)
	).play;


)