ProxySpace.push(s);

~tone.play(vol:0.4).quant_(1);
(
~tone[0] = {
	var selEnv = Select.kr(\tone_selOsc.kr(0),
		[
			EnvGen.kr( Env([0.001,1,0.2,1,0.001], [3,1,1,3], \exp) , \tone_selTrig.tr),
			EnvGen.kr( Env([0.001,1,0.9,1,0.001], [3,1,1,3], \step) , \tone_selTrig.tr),
			EnvGen.kr( Env([0.001,2,1.0,2,0.001], [3,1,1,3], \exp) , \tone_selTrig.tr),
		]
	);
	var selOsc = SelectX.ar(selEnv,
		[
			SinOsc.ar(\tone_freq.kr(60)) * BrownNoise.ar(0.3),
			SinOsc.ar(600) * GrayNoise.ar(0.3),
			SinOsc.ar(60),
		]
	);
	{selEnv}.plot(1);

	Pan2.ar(selOsc,\tone_pan.kr(0));
};
)
~tone.free;

~tone.set(\tone_selOsc,2);
~tone.set(\tone_selTrig,1);

(
Pbind(\type, \set, \args, [\tone_selTrig, \tone_selOsc],
	\dur, Pn(8,3),
	\tone_selTrig, 1,
	\tone_selOsc, Pseq([0,1,2], inf).trace
).play;
)
