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
			EnvGen.kr(Env.perc(0.05,0.45), oscT),
			EnvGen.kr(Env.perc(0.92,0.05), oscT),
		]
	);
	Pan2.ar(SinOsc.ar(freq,mul:0.5)*aEnv,pan);
},[\tr,0,0.25,0,0]).add; // trig or lag time of args in sec
)

(
~limiter.play;
~limiter[0] = \filter -> {|in| Limiter.ar(in, 0.95) };

~drumA.play.quant_(1);
~drumA[0] = \drumA;
~drumA[10] = \filter -> {|in| LPF.ar(in, 800) };
)

Pdef(\drumA, Pbind(\dur, 0.5, \oscT, 1)).play;

(
Pded(\drumA, Pbind(\type, \set, \args, [\oscT], \oscT, 1));
Pdef(\track, Pdfsm([
	Pseq([
		Pseq([\p1,\p2])
	]).trace(prefix: "phase -> "),
	(
	\p1:[0, Pbind(\type
	)
],0,1)).play(quant:8);
)