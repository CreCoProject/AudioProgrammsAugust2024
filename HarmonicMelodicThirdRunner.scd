// Synthdef for the Synth to play the Melody
// Argument freq is Frequency of the Sound to Play
(
SynthDef(\Synth, { |freq|
	// Temporary Variable for the Sig
    var sig;
	// SinusWava Source
	sig = SinOsc.ar(freq);
	// Output of the Signal
	Out.ar(0, [sig, sig]);
}).add;
)

// Dummy Variable to See is the Synth Running
x = Synth(\Synth, [freq: 110 ]);

// Function to Choose the next Melodic FRequency
// Argument is old Frequency
(~nextToneMelodic = {arg oldFreq;
	// Variable for the Calculated new Frequency
	var f,
	// Variable for the Calculated Ratio of the
	//   Melodic Intervall
	ratio;
	// Give the Ratio of the Melodic Interval
	ratio = 5.0/4.0;
	// Choose the Direction of the Interval
	if ( [false, true].choose,
		// One Siamesian Hight
		{  f = oldFreq*ratio; },
		// One Siamesian Down
		{  f = oldFreq*(1/ratio)  };);
	// Set Boundaries for the Frequencies
	// Not Higher then 5'000 Hz
	if ( ( f > 5000),
		// Set Higher to 5'000Hz
		{  f = 5000 },
		{  f = f  };);
	// Not Lesser then 330 Hz
	if ( ( f < 330),
		// Set Lesser to 330 Hz
		{  f = 330 },
		{  f = f  };);
	f.postln;
};)

// Function to Choose the parralel Harmonic FRequency
// Argument is old Frequency
(~nextToneHarmonic = {arg oldFreq;
	// Variable for the Calculated new Frequency
	var f,
	// Variable for the Calculated Ratio of the
	//   Harmonic Interval
	ratio;
	// Calculate the Ratio of the Siamesian Fifth
	ratio = 6.0/5.0;
	// Choose the Direction of the Interval
	if ( [false, true].choose,
		// One Siamesian Hight
		{  f = oldFreq*ratio; },
		// One Siamesian Down
		{  f = oldFreq*(1/ratio)  };);
	// Set Boundaries for the Frequencies
	// Not Higher then 5'000 Hz
	if ( ( f > 5000),
		// Set Higher to 5'000Hz
		{  f = 5000 },
		{  f = f  };);
	// Not Lesser then 330 Hz
	if ( ( f < 330),
		// Set Lesser to 330 Hz
		{  f = 330 },
		{  f = f  };);
	f.postln;
};)

// Dummy to Test the Frequency new Calculation
~nextTone.value(440);

// Player Routine
(~player = Routine.new({
	// Variable to store actual Frequency
	var freqMaster, freqHarmonic, x1, x2;
	// Set Beginning Frequency to 449 Hz
	freqMaster = 440;
	// Infinity Loop to play Melody
	while(true)
	{
		// Call the Synth to Play the choosen Frequency
		x1 = Synth(\Synth, [freq: freqMaster ]);
		// Calculate the Harmonic Parallel Frequency
		freqHarmonic = ~nextToneHarmonic.value(freqMaster);
		x2 = Synth(\Synth, [freq: freqHarmonic ]);

		// Callculte the next Master Frequency
		freqMaster = ~nextToneMelodic.value(freqMaster);
		// Wait a half Second before to play the next Frequency
		1.wait;
		// Free the last actual Frequency Synth
		x1.free;
		x2.free;
	}
});)

// Methods to start and Stop the Player
~player.play;
~player.stop;