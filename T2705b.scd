(
ProxySynthDef(\drumA, { |oscT, freq = 80, pan = 0, idSel = 0|
	var aEnv = Select.kr(idSel,
		[
			EnvGen.kr(Env.perc(0.45,0.05), oscT, doneAction:2),
			EnvGen.kr(Env.asr(0.05,1,0.95), oscT, doneAction:2),
		]
	);
	Pan2.ar(SinOsc.ar(freq,mul:0.5)*aEnv,pan);
},[\tr,0,0.25,0,0]).add; // trig or lag time of args in sec
)

(
var drumG, recG;
ProxySpace.push(s);

drumG = Group.new;
recG = Group.new(drumG, \addAfter);

~limiter.play;
~limiter.group_(recG);
~limiter[0] = \filter -> {|in| Limiter.ar(in, 0.95) };

~drumA.play.quant_(1);
~drumA.group_(drumG);
~drumA[10] = \filter -> {|in| LPF.ar(in, \lpfFreq.kr(800,1)) };

Pdef(\drumSetup, Pbind(\instrument, \drumA, \group, drumG, \oscT, 1));
Pdef(\drum1, Pbindf(Pdef(\drumSetup), \idSel, 0, \dur, Pn(0.5,4)));
Pdef(\drum2, Pbindf(Pdef(\drumSetup), \idSel, 1, \dur, Pseq([0.25,0.25,0.5], 2)));
)


(
Pdef(\track, Pdfsm([
	Pseq([
		Pseq([\p1, \p2],1)
	]).trace(prefix: "phase -> "),
	(
		\p1:[0, Pdef(\drum1) ],
		\p2:[0, Pdef(\drum2) ]
	)
],0,1)).trace.play(quant:1);
)