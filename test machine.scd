p = ProxySpace.push(s);
p.arProxyNames;
p.krProxyNames;
p.gui;
(

~sin.play;
~sin.read(~phase);

~sin[0] = { Pan2.ar(SinOsc.ar(\myFreq.kr(80),mul:0.2), 0)};
~phase = Pdfsm([
	Pseq([
		~intro,
		~outro
	]),
	(
		\default:[1, Pbind(\type, \set, \args, [\myFreq], \dur, 0.5, \myFreq, Pseq([80, 200], 2))]
	),
	(
		\default:[2,Pbind(\type, \set, \args, [\myFreq], \dur, 0.125, \myFreq, Pseq([120, 160], 8))]
	),
	(
		\default:[nil]
	)
],0,1).trace;
~phase.play;
)


Pset(\myFreq, Pseq([80, 200], 2), Pbind(\dur, 0.5))