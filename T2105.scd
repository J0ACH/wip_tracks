p = ProxySpace.push(s);
p.gui;

(
~drum.rebuild;
~drum[0] = {
	var f = [60,82,84,98];
	var aEnv = EnvGen.kr(Env([0, 1, 0.45, 0],[[0.01,0.05],[0.29,0.27], [1.5, 0.29, 0.35, 1.57]], \welch), \masterTrig.tr);
	var fEnv = EnvGen.kr(Env([f, 18000, f*1.4, f], [0.003, 0.011, 0.15], \exp), \fTrig.tr);
	var num = 8;
	var osc = Mix.fill(num, {|i| SinOsc.ar(fEnv,0.05*i,1/num) * BrownNoise.ar(0.3, SinOsc.kr([8, 16.01], 0, 0.7))});
	Splay.ar( osc * aEnv, center:\pan.kr(0));
};
~drum[11] = \filter -> {|in|
	var lpfEnv = EnvGen.kr(Env([250, \lpfFreq.kr(2000, 6), 800, 50],[0.03, 0.37, 1.2], \exp), \masterTrig.tr);
	LPF.ar(in, lpfEnv)
};
/*
~drum[1] = \set -> Pbind(\args, [\pan], \dur, 1, \pan, Pseq([0.3, -0.3, 0.9, -0.9], inf));
~drum[10] = \filter -> {|in| AllpassC.ar(in,0.06,0.001,4.75) };
~drum[12] = \filter -> {|in| FreeVerb.ar(in,0.12,0.47,0.95) };
*/
~drumTail.rebuild;
~drumTail = {
	var aEnv = EnvGen.kr(\tailEnv.kr(Env.newClear(8)), \masterTrig.tr);
	Pan2.ar(LFSaw.ar(\tailFreq.kr(420),0,0.3,0.7)  * aEnv, 0);
};
)

(
var masterSeq = Pbind(\type, \set, \args, [\masterTrig], \masterTrig, 1);
var drumSeq = Pbind(\type, \set, \args, [\fTrig], \fTrig, 1);
var tailSeq = Pbind(\type, \set, \args, [\tailEnv, \tailFreq]);

var tailEnv1 = Env([0.001,1,0], [0.2,3.8], [\exp, \sin]);
var tailEnv2 = Env([0.001,1,0.3,0.8,0], [0.2,1.8,0.2,1.8], [\exp, \sin]);

~drum.play(vol:0.9).quant_(1).mold(4);
~drumTail.play(vol:0.2).quant_(1);

Pdfsm([
	Pseq([
		// Pseq([\stage1, \stage2],1),
		\stage1,
		\stage2,
		// Pseq([\i1,\i2,\i3], 2),
		// Pseq([\i3,\i4], 4),
		// \i3,
		// Pseq([\i5,\i3,\i5,\i3,\i4]),
		// Pn(\i3, 2),
		// \fadeOut_tone,
		\end
	]).trace(prefix: "phase -> "),
	(
		// \stage1: [0, Pbindf(toneSeq_amp, \dur, Pn(8, 1), \tone_ampEnv, [Env([0,1], [8], \sin).asArray] )],
		\stage1: [0,
			Ppar([
				Pbindf(masterSeq, \dur, Pn(4,1)),
				// Pbindf(drumSeq, \dur, Pseq([0.125,Pn(0.0625,3)])),
				Pbindf(tailSeq, \dur, Pn(4,1), \tailEnv, [tailEnv1.asArray])
			])
		],
		\stage2: [0,
			Ppar([
				Pbindf(masterSeq, \dur, Pn(4,1)),
				// Pbindf(drumSeq, \dur, Pseq([0.125,Pn(0.0625,3)])),
				Pbindf(tailSeq, \dur, Pn(4,1), \tailEnv, [tailEnv1.asArray])
			])
		],
		\end: [nil]
	)
],0,1).trace.play;
)