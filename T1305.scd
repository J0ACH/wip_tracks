p = ProxySpace.push(s);
p.gui;

(
~drum.play(vol:0.9).quant_(1).mold(4).read(~track);
// ~drum.scope;
~drum[0] = {
	var f = \freq.kr([80,82,84,88]);
	var aEnv = EnvGen.kr(Env([0, 1, 0],[[0.01,0.05], [0.99, 0.29, 0.35, 0.87]], \welch), \aTrig.tr);
	var fEnv = EnvGen.kr(Env([f, 18000, f*1.2, f], [0.003, 0.008, 0.15], \exp), \fTrig.tr);
	var num = 8;
	var osc = Mix.fill(num, {|i| SinOsc.ar(fEnv,0.05*i,1/num) * GrayNoise.ar(0.3, SinOsc.kr([8, 16.01], 0, 0.7))});
	Pan2.ar( osc * aEnv, \pan.kr(0));
};
~drum[10] = \filter -> {|in| AllpassC.ar(in,0.02,0.005,0.05) };
~drum[12] = \filter -> {|in|
	var lpfEnv = EnvGen.kr(Env([400, \lpfFreq.kr(18000, 6), 1000, 400],[0.03, 0.12, 0.7], \exp), \aTrig.tr);
	LPF.ar(in, lpfEnv)
};
~pDrum = Pbind(\type, \set, \args, [\aTrig, \fTrig],
	\dur, Pn(1,8),
	\aTrig, 1,
	\fTrig, 1
);

~tone.play(vol:0.6).quant_(1).read(~track);
~tone[0] = { LinSelectX.ar(
	EnvGen.ar(Env.linen(0.25, 2.75,3,curve:\sin), \selTrig.tr), [
		SinOsc.ar(13000,0, SinOsc.kr(1/8, 0, 0.03, 0.18), 0.25),
		SinOsc.ar(SinOsc.kr(60, 0.01, 50, 250),0, 0.1, SinOsc.kr([2,4.1], 0, 0.15, 0.19), 0.2),
]) * \toneAmp.kr(0.6,10);
};
~tone[30] = \filter -> {|in| BPF.ar(in, 800, Saw.kr(1/2, 14, 15)) };

~track = Pdfsm([
	Pseq([
		Pseq([
			// Pn(\i1,3),
			Pn(\i2, 2),
			Pseq([\i2,\i3],2)
		]) ++ \end,

	]).trace(prefix: "drum "),
	( // intro
		\i1: [0, Pbind(\type, \set, \args, [\selTrig], \dur, Pn(8,1), \selTrig, 1)
		],
		\i2: [0,
			Ppar([
				Pbindf(~pDrum, \dur, Pn(0.5,16)),
				// Pbind(\type, \set, \args, [\aTrig, \fTrig], \aTrig, 1, \fTrig, Pseq([1,0], inf), \dur, Pn(0.5,16)),
				Pbind(\type, \set, \args, [\selTrig], \dur, Pn(8,1), \selTrig, 1)
			])
		],
		\i3: [0,
			Ppar([
				Pbindf(~pDrum, \dur, Pn(0.25,32), \fTrig, Pseq([1,0], inf)),
				// Pbind(\type, \set, \args, [\aTrig, \fTrig], \aTrig, 1, \fTrig, 1, \dur, Pseq([1,1],4)),
				Pbind(\type, \set, \args, [\selTrig], \dur, Pn(8,1), \selTrig, 1)
			])
		],
		\rest: [0, Pbind(\type, \set, \args, [\aTrig], \aTrig, 0, \dur, Pn(4,1))],
		\end: [2]
	),
	(
		\aaa: [1, Pbind(\type, \set, \args, [\aTrig], \aTrig, 1, \dur, Pn(2,2))],
		\bbb: [1, Pbind(\type, \set, \args, [\aTrig], \aTrig, 1, \dur, Pseq([1,1,2]))],
		\ccc: [1, Pbind(\type, \set, \args, [\aTrig], \aTrig, 1, \dur, Pseq([0.5,0.5,1,2]))],
		\end: [2, Pbind(\type, \set, \args, [\aTrig], \aTrig, 1, \dur, Pseq([0.25],8))]
	),
	(
		\default: [nil]
	)
],0,1).play;
)
(
~drum.free;
~tone.free;
/*
~volume = Pdfsm([
Pseq([\fadeIn, \rest, \fadeOut]).trace(prefix: "drumVol "),
(
\fadeIn: [0, (\vol: 0.3)],
\rest: [0, (\vol: 0.8)],
\fadeOut: [1, (\vol: 0.0)]
),
(	\default: [nil] )
],0,1);
*/
)


