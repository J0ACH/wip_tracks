AutoIDE2.run;
p = ProxySpace.push(s);

(
~node[0] = {
	var aEnv = EnvGen.ar( Env( [0,1,0], [0.45,0.05]), \aTrig.tr);
	var osc = SinOsc.ar(\freq.kr(lag:0.5)) * BrownNoise.ar(0.25,0.75) * LFPulse.ar(32,0,0.3,0.7,0.3);
	Pan2.ar( osc * aEnv, \pan.kr(0,0.25) );
};
~node[2] = \set -> Pbind(\args, [\aTrig], \aTrig, 1, \dur, 0.5);
~node[10] = \set -> Pbind(\args, [\pan], \pan, Pseq([0.9,-0.9], inf), \dur, 0.25);
~node[11] = \set -> Pbind(\args, [\freq], \freq, Pseq([160,132,170,142], inf), \dur, 16);

~node[30] = \filter -> {|in| LPF.ar(in, \freq_lpf.kr(lag: 8)) };
~node[31] = \filter -> {|in| GVerb.ar(in, 160,4.5) };
);

~node.set(\freq_lpf, 1820);
~node.play(vol:4.8, fadeTime:16).quant = 2;
~node.stop(20);

~node.set(\pan, 0);

~node.scope;

(
~drum[0] = {
	var f = [60,82,84,98];
	var aEnv = EnvGen.kr(Env([0, 1, 0.45, 0],[[0.01,0.05],[0.29,0.27], [0.5, 0.29, 0.35, 0.57]], \welch), \aTrig.tr);
	var fEnv = EnvGen.kr(Env([f, 18000, f*1.4, f], [0.003, 0.011, 0.15], \exp), \fTrig.tr);
	var num = 8;
	var osc = Mix.fill(num, {|i| SinOsc.ar(fEnv,0.05*i,1/num) * BrownNoise.ar(0.3, SinOsc.kr([8, 16.01], 0, 0.7))});
	Pan2.ar(osc * aEnv,\pan.kr(0,2));
};
~drum[1] = \set -> Pbind(\args, [\pan], \dur, 0.25, \pan, Pseq([0.3, -0.3, 0.9, -0.9], inf));
~drum[2] = \set -> Pbind(\args, [\aTrig], \aTrig, 1, \dur, 0.5);
~drum[3] = \set -> Pbind(\args, [\fTrig], \fTrig, 1, \dur, 1);
~drum[10] = \filter -> {|in| AllpassC.ar(in,0.06,0.001,4.75) };
~drum[11] = \filter -> {|in|
	var lpfEnv = EnvGen.kr(Env([250, \lpfFreq.kr(80, 16), 800, 50],[0.03, 0.37, 0.7], \exp), \aTrig.tr);
	LPF.ar(in, lpfEnv)
};
~drum[12] = \filter -> {|in| FreeVerb.ar(in,0.12,0.47,0.95) };

);
~drum.set(\lpfFreq, 12200);
~drum.play(vol:4.8, fadeTime:4).quant_(4);
~drum.stop(2);
~drum.scope;

s.scope;

(
~node2[0] = {
	var aEnv = EnvGen.ar( Env( [0,1,0], [0.05,0.20]), \aTrig.tr);
	var osc = LFSaw.ar(\freq.kr(6000,0.125)) * SinOsc.ar(32,0,0.3,0.7);
	Pan2.ar( osc * aEnv, \pan.kr(0,0.25) );
};
~node2[10] = \set -> Pbind(\args, [\aTrig], \aTrig, 1, \dur, Pseq([Pn(0.25,4), Rest(3.5)], inf));

~node2[30] = \filter -> {|in| LPF.ar(in, \freq_lpf.kr(lag: 8)) };
~node2[31] = \filter -> {|in| GVerb.ar(in, 18,8.25) };
);

~node2.set(\freq_lpf, 2020);
~node2.play(vol:1.8, fadeTime:4).quant_(2);
~node2.stop(8);
~node2.set(\freq, 8000);
~node2.set(\pan, 0);
~node2.scope;
