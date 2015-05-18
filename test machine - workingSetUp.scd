p = ProxySpace.push(s);

~test = NodeProxy(s, \audio);
~test[0] = { Pan2.kr(SinOsc.ar(\freq.kr(80),mul:\amp.kr(0.2, 2)),\pan.kr(0)) };

~test.getKeysValues;

(
var freqSeq = Pbind(\type, \set, \args, [\freq, \amp], \octave, 3, \degree, Pseq([3,7], inf));
var panSeq = Pbind(\type, \set, \args, [\pan], \pan, Pseq([-0.8,0.8], inf));

~test.play;

Pdef(\track, Pdfsm([
	Pseq([
		\i1,
		\i2,
		\end
	]).trace(prefix: "phase -> "),
	(
		\i1: [0, Pbindf(freqSeq, \dur, Pn(1,4)) ],
		\i2: [0,
			Ppar([
				Pbindf(freqSeq, \dur, Pn(0.25,16)),
				Pbindf(panSeq, \dur, Pn(2,2))
			])
		],
		\end: [nil]
	)
],0,1)).trace.play;
)

~test.free;
