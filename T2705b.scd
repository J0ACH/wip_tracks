ProxySpace.push(s);

(
~drumA.play.quant_(1);
~drumA[0] = {
	var aEnv = Select.kr(\idSel.kr(0),
		[
			EnvGen.kr(Env.perc(0.5,0.5), \oscT.tr),
			EnvGen.kr(Env([0,1,1,0],[0.7,0.25,0.05],[\sin, \lin, \step]), \oscT.tr, timeScale: \sustain.kr(1)),
			EnvGen.kr(Env([0,1,1,0],[0.7,0.25,0.25],[\sin, \lin, \sin]), \oscT.tr, timeScale: \sustain.kr(1))
		]
	);
	Pan2.ar(LFSaw.ar(\freq.kr(80),mul:0.5)*aEnv,\pan.kr(0,0.25));
};
~drumA[10] = \filter -> {|in| LPF.ar(in, \lpfFreq.kr(2000,8)) };

~limiter.play;
~limiter[0] = \filter -> {|in| Limiter.ar(in, 0.95) };

Pdef(\drumSetup, Pbind(\type, \set, \args, [\oscT, \idSel, \freq, \sustain], \oscT, 1));
Pdef(\drum1, Pbindf(Pdef(\drumSetup), \idSel, 0, \octave, 2, \degree, 3, \dur, Pn(1,4)));
Pdef(\drum2, Pbindf(Pdef(\drumSetup), \idSel, Pseq([1,1,2]), \octave, 3, \degree, 3, \dur, Pseq([0.25,0.25,3.5], 2)));

)

~drumA.set(\lpfFreq, 80);

(
Pdef(\track, Pdfsm([
	Pseq([
		Pseq([\p1, \p2],1)
	]).trace(prefix: "phase -> "),
	(
		\p1:[0, Pdef(\drum1) ],
		\p2:[0, Pdef(\drum2) ]
	)
],0,inf)).trace.play(quant:1);
)