p = ProxySpace.push(s);
(
~drum[0] = {
	var f = [60,82,84,98];
	var aEnv = EnvGen.kr(Env([0, 1, 0.45, 0],[[0.01,0.05],[0.29,0.27], [1.5, 0.29, 0.35, 1.57]], \welch), \aTrig.tr);
	var fEnv = EnvGen.kr(Env([f, 18000, f*1.4, f], [0.003, 0.011, 0.15], \exp), \fTrig.tr);
	var num = 8;
	var osc = Mix.fill(num, {|i| SinOsc.ar(fEnv,0.05*i,1/num) * BrownNoise.ar(0.3, SinOsc.kr([8, 16.01], 0, 0.7))});
	Splay.ar( osc * aEnv, center:\pan.kr(0));
};
~drum.play;
)
(
var drumSeq = Pbind(\type, \set, \args, [\aTrig, \fTrig], \aTrig, 1, \fTrig, 1);
var scr;

p = Pdfsm([
	Pseq([\i1, \i2], 2),
	(
		\i1: [0, Pbindf(drumSeq, \dur, Pn(1, 4))],
		\i2: [0, Pbindf(drumSeq, \dur, Pn(0.5, 2))]
	)
],0,1);

z = p.asScore(12);
z.score;
z.endTime;

z.saveToFile("C:/patTest.osc"); // txt
z.write("C:/patTest_write.osc") // binar
)

Score.playFromFile("C:/patTest.osc");
Score.playFromFile("C:/patTest_write.osc");

Score.recordNRT(z,oscFilePath:"C:/patTest_write.osc", outputFilePath: "C:/patTest.aiff",duration:12);
// z.recordNRT(z.score, oscFilePath: "C:/patTest.osc",outputFilePath: "C:/patTest.aiff");