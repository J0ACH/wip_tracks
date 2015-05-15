p = ProxySpace.push(s);
p.arProxyNames;
p.krProxyNames;
p.gui;
(

~sin.play(vol:0.2);
~saw.play(vol:0.1);
~sin.read(~phase);
~saw.read(~phase);

~sin.getKeysValues;|
~sin[0] = {
	var env1 = EnvGen.kr(Env.perc, \aTrigSin.tr);
	var env2 = EnvGen.kr(Env.perc, \aTrigSin.tr);
	Pan2.ar(SinOsc.ar(\myFreq.kr(80),mul: env1), 0)};
~saw[0] = { Pan2.ar(LFSaw.ar(\myFreq.kr(80),mul: EnvGen.kr(Env.perc, \aTrigSaw.tr)), 0)};



// ~intro = Pseq([\i1], 8);
~phase.rebuild;
~phase = Pdfsm([
	Pseq([
		Pseq([\i1], 8),
		~outro
	]),
	(
		\i1:[1,Pbind(\type, \set, \args, [\aTrigSin, \aTrigSaw, \myFreq], \dur, 0.5,
			\aTrigSin, 1, \aTrigSaw, 0, \myFreq, Pseq([80, 200], 2))]
	),
	(
		\default:[2,Pbind(\type, \set, \args, [\aTrigSin, \aTrigSaw, \myFreq], \dur, 0.125,
			\aTrigSin, 0, \aTrigSaw, 1, \myFreq, Pseq([120, 160], 8))]
	),
	(
		\default:[nil]
	)
],0,1).trace;
// ~phase.play;
)


Pset(\myFreq, Pseq([80, 200], 2), Pbind(\dur, 0.5))