p = ProxySpace.push(s);

~drum.play(vol:0.9).quant_(1);
~drum.mold(4);
(
~drum[0] = {
	var f = \freq.kr([80,82,84,88]);
	var aEnv = EnvGen.kr(Env([0, 1, 0],[[0.01,0.05], [1.99, 1.49, 1, 0.5]], \welch), \aTrig.tr);
	var fEnv = EnvGen.kr(Env([f, 18000, f*1.2, f], [0.003, 0.008, 0.15], \exp), \fTrig.tr);
	// var vEnv = EnvGen.kr(Env(,[ ]),\vTrig.tr)
	Pan2.ar( Mix.fill(4, {|i| SinOsc.ar(fEnv,0.05*i,1/4) * BrownNoise.ar(0.2, SinOsc.kr([16, 16.01], 0, 0.8))}) * aEnv, \pan.kr(0));
};
~drum[10] = \filter -> {|in| AllpassC.ar(in,0.02,0.005,0.05) };
~drum[12] = \filter -> {|in| LPF.ar(in, \lpfFreq.kr(1800, 6)) };

~drum[50] = \set ->
Pdfsm([
	Pseq([
		Pseq([\i1,\i2],4) ++ \end,
		\aaa,
		\end,
		\fin
	]).trace(prefix: "drum "),
	( // intro
		\i1: [0, Pbind(\args, [\aTrig, \fTrig], \aTrig, 1, \fTrig, 1, \dur, Pn(1,4))],
		\i2: [0,
			Ppar([
				Pbind(\args, [\aTrig], \aTrig, 1, \dur, Pn(1,4)),
				Pbind(\args, [\fTrig], \fTrig, 1, \dur, Pn(0.25,16))
			])
		],
		\rest: [0, Pbind(\args, [\aTrig], \aTrig, 0, \dur, Pn(4,1))],
		\end: [2]
	),
	(
		\aaa: [1, Pbind(\args, [\aTrig], \aTrig, 1, \dur, Pn(2,2))],
		\bbb: [1, Pbind(\args, [\aTrig], \aTrig, 1, \dur, Pseq([1,1,2]))],
		\ccc: [1, Pbind(\args, [\aTrig], \aTrig, 1, \dur, Pseq([0.5,0.5,1,2]))],
		\end: [2, Pbind(\args, [\aTrig], \aTrig, 1, \dur, Pseq([0.25],8))]
	),
	(
		\default: [nil]
	)
],0,1)
);
~drum[51] = \set ->
Pdfsm([
Pseq([\fadeIn, \rest, \fadeOut]).trace(prefix: "drumVol "),
	(
		\fadeIn: [0, (\vol: 0.3)],
		\rest: [0, (\vol: 0.8)],
		\fadeOut: [1, (\vol: 0.0)]
	)
	(	\default: [nil] )
~drum[33] = \set -> Pbind(\args, [\lpfFreq], \dur, 8, \lpfFreq, Pseq([800,1800], inf));
)
~drum.end(16);