(
SynthDef(\signal, {
	var aEnv = EnvGen.ar(Env([0,1,0],[0.2,0.05]), doneAction:2);
	var osc = SinOsc.ar(\freq.kr(200)) * WhiteNoise.ar(0.05, 0.05);
	var sig = Pan2.ar(osc, \pan.kr(0,0.25)) * aEnv;
	Out.ar(0, sig);
}).add;
)

Synth(\signal);
