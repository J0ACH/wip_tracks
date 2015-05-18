p = ProxySpace.push(s);

(
// node setUp
~test = NodeProxy(s, \audio);
~test[0] = {
	var vol = EnvGen.kr(\volEnv.kr(Env.newClear(8)),\volTrig.tr);
	var aEnv = EnvGen.kr(\ampEnv.kr(Env.newClear(8)),\ampTrig.tr);
	Pan2.kr(SinOsc.ar(\freq.kr(80),mul:aEnv),\pan.kr(0)) * vol;
};
~test.getKeysValues;
)

(
// sequence setUp
var freqSeq = Pbind(\type, \set, \args, [\freq, \amp], \amp, 0.4, \octave, 3, \degree, Pseq([3,7], inf));
var ampSeq = Pbind(\type, \set, \args, [\ampTrig, \ampEnv], \ampTrig, 1);
var volSeq = Pbind(\type, \set, \args, [\volTrig, \volEnv]);
var panSeq = Pbind(\type, \set, \args, [\pan]);

~test.play;

// track setUp
Pdfsm([
	Pseq([
		\fadeIn,
		Pseq([\i1,\i2], 1),
		\fadeOut,
		\end
	]).trace(prefix: "phase -> "),
	(
		\fadeIn: [1,
			Ppar([
				Pbindf(volSeq, \dur, Pn(8,1), \volTrig, 1, \volEnv, [Env([0,0.4], [8], \lin).asArray]),
				Pbindf(ampSeq, \dur, Pn(1,8), \ampEnv, [Env([0,0.8,0.2,1,0], [0.25,0.05,0.7,0.05], \welch).asArray]),
			])
		]
	),
	(
		\i1: [1,
			Ppar([
				Pbindf(ampSeq, \dur, Pn(1,4), \ampEnv, [Env([0,0.8,0.2,1,0], [0.25,0.05,0.7,0.05], \welch).asArray]),
				Pbindf(freqSeq, \dur, Pn(1,4)),
				Pbindf(panSeq, \dur, Pn(4,1), \pan, 0)
			])
		],
		\i2: [1,
			Ppar([
				Pbindf(ampSeq, \dur, Pn(0.5,8), \ampEnv, [Env.perc(0.25,0.05).asArray]),
				Pbindf(freqSeq, \dur, Pn(0.25,16)),
				Pbindf(panSeq, \dur, Pn(2,2), \pan, Pseq([-0.8,0.8], inf))
			])
		],
		\fadeOut: [1,
			Ppar([
				Pbindf(panSeq, \dur, Pn(16,1), \pan, 0),
				Pbindf(volSeq, \dur, Pn(16,1), \volTrig, 1, \volEnv, [Env([0.4,0.0], [16], \lin).asArray]),
				Pbindf(ampSeq, \dur, Pn(1,16), \ampEnv, [Env([0,0.8,0.2,1,0], [0.7,0.05,0.25,0.05], \welch).asArray]),
			])
		],
		\end: [nil]
	)
],0,1).play;
)

~test.free;
