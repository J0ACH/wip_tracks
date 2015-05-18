p = ProxySpace.push(s);

(
~test = NodeProxy(s, \audio);
~test[0] = {
	var aEnv = EnvGen.kr(\ampEnv.kr(Env.newClear(4)),\ampTrig.tr);
	Pan2.kr(SinOsc.ar(\freq.kr(80),mul:aEnv),\pan.kr(0))
};

~test.getKeysValues;
)
(
var freqSeq = Pbind(\type, \set, \args, [\freq, \amp], \octave, 3, \degree, Pseq([3,7], inf));
var ampSeq = Pbind(\type, \set, \args, [\ampTrig, \ampEnv], \ampTrig, 1);
var panSeq = Pbind(\type, \set, \args, [\pan], \pan, Pseq([-0.8,0.8], inf));

~test.play;

Pdef(\track, Pdfsm([
	Pseq([
		\i1,
		\i2,
		\end
	]).trace(prefix: "phase -> "),
	(
		\i1: [0, Ppar([
			Pbindf(ampSeq, \dur, Pn(1,4), \ampEnv, [Env.perc(0.05,0.95).asArray]),
			Pbindf(freqSeq, \dur, Pn(1,4)),
			Pbindf(panSeq, \pan, Pn(0,4))
			])
		],
		\i2: [0,
			Ppar([
				Pbindf(ampSeq, \dur, Pn(0.5,8), \ampEnv, [Env.perc(0.45,0.05).asArray]),
				Pbindf(freqSeq, \dur, Pn(0.25,16)),
				Pbindf(panSeq, \dur, Pn(2,2))
			])
		],
		\end: [nil]
	)
],0,1)).trace.play;
)

~test.free;
