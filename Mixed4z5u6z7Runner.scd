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
	if ( [false, true].choose,                // Boolean expression (chooses one at random)
    { ratio = 4.0/5.0 },    // true function
    { ratio = 6.0/7.0 }    // false function
);
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
	var freq1, freq2, freq3, x1, x2, x3;
	// Set Beginning Frequency to 449 Hz
	freq1 = 440;
	freq2 = 440;
	freq3 = 440;
	// Infinity Loop to play Melody
	while(true)
	{
		// Call the Synth to Play the choosen Frequency
		x1 = Synth(\Synth, [freq: freq1 ]);
		// Calculate the next Frequency
		x2 = Synth(\Synth, [freq: freq2 ]);
		x3 = Synth(\Synth, [freq: freq3 ]);

		freq1 = ~nextTone.value(freq1);
		freq2 = ~nextTone.value(freq2);
		freq3 = ~nextTone.value(freq3);
		// Wait a half Second before to play the next Frequency
		0.5.wait;
		// Free the last actual Frequency Synth
		x1.free;
		x2.free;
		x3.free;
	}
});)

// Methods to start and Stop the Player
~player.play;
~player.stop;