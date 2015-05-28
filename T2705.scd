(
var synthG, recG;

ProxySpace.push(s);

synthG = Group.new;
recG = Group.new(synthG, \addAfter);

~drumA.group_(synthG);
~limiter.group_(recG);

ProxySynthDef(\drumA, { |oscT, freq = 80, pan = 0, idSel = 0|
	var aEnv = Select.kr(idSel,
		[
			EnvGen.kr(Env.perc(0.45,0.05), oscT, doneAction:2),
			EnvGen.kr(Env.asr(0.05,1,0.95), oscT, doneAction:2),
		]
	);
	Pan2.ar(SinOsc.ar(freq,mul:0.5)*aEnv,pan);
},[\tr,0,0.25,0,0]).add; // trig or lag time of args in sec

~limiter.play;
~limiter[0] = \filter -> {|in| Limiter.ar(in, 0.95) };

Pdef(\drum1, Pbind(\instrument, \drumA, \oscT, 1, \idSel, 0, \dur, Pn(0.5,4)));
Pdef(\drum2, Pbind(\instrument, \drumA, \oscT, 1, \idSel, 1, \dur, Pseq([0.25,0.25,0.5], 2)));

~drumA.play.quant_(1);
~drumA[0] = Pdfsm([
	Pseq([
		Pseq([\p1, \p2],1)
	]).trace(prefix: "phase -> "),
	(
		\p1:[0, Pbind(\instrument, \drumA, \oscT, 1, \idSel, 0, \dur, Pn(1,4))],
		\p2:[0, Pbind(\instrument, \drumA, \oscT, 1, \idSel, 1, \dur, Pseq([0.5,0.5,3], 1))]
	)
],0,inf);

~drumA[10] = \filter -> {|in| LPF.ar(in, \lpfFreq.kr(800,1)) };


// Pdef(\drumSetup, Pbind(\type, \set, \group, synthG, \args, [\oscT], \dur, Pn(0.5,4), \oscT, 1));
// Pdef(\drumSeq, Pbind(\instrument, \drumA, \group, synthG, \dur, Pn(0.5,4), \oscT, 1, \idSel, 1));
)

(

Pdef(\drum1, Pbind(\type, \set,  \args, [\oscT,\idSel], \oscT, 1, \idSel, 0, \dur, Pn(0.5,4)));
Pdef(\drum2, Pbind(\type, \set,  \args, [\oscT,\idSel], \oscT, 1, \idSel, 1, \dur, Pseq([0.25,0.25,0.5], 2)));

Pdef(\track, Pdfsm([
	Pseq([
		Pseq([\p1, \p2],1)
	]).trace(prefix: "phase -> "),
	(
		\p1:[0, Psym(\drum1)],
		\p2:[0, Psym(\drum2)]
	)
],0,1)).trace.play(quant:8);
)