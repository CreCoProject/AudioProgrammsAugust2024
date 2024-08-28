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

// Function to Choose the next FRequency
// Argument is old Frequency
(~nextTone = {arg oldFreq;
	// Variable for the Calculated new Frequency
	var f,
	// Variable for the Calculated Ratio of the
	//   Siamesian Fifth
	ratio;
	// Calculate the Ratio of the Siamesian Fifth
	ratio = 7.0/4.0;
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
	var freq;
	// Set Beginning Frequency to 449 Hz
	freq = 440;
	// Infinity Loop to play Melody
	while(true)
	{
		// Call the Synth to Play the choosen Frequency
		x = Synth(\Synth, [freq: freq ]);
		// Calculate the next Frequency
		freq = ~nextTone.value(freq);
		// Wait a half Second before to play the next Frequency
		0.5.wait;
		// Free the last actual Frequency Synth
		x.free;
	}
});)

// Methods to start and Stop the Player
~player.play;
~player.stop;