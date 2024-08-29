// Synth to play the Sounds
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

// Create the Scale over 12 Instances
(~scale =Array.fill(12, { arg i;
	// declare Temorary Variable for Ratio
	var z;
	// Callculate the Ratio by Powring of Instance Number
	z = (7.0/4.0)**i;
	// Reoctaving Ratio in main Octave
	while({ z > 2 }, { z = z/2 });
	// Set calculated Ratio
	z
});)

// Sorting the Scale Ready for Use
(~sorter = {
	~scale = ~scale.sort()
};)

~sorter.value();

// Search Function to find closed Note
(~nearestTopic = {
	// As Argument the Note for which to find
	arg y;
	// Declare Memory for Under and Upper Found
	var x1, x2,
	// Declare Memory for Difference of Founds
	dx1, dx2, xf, z;
	// Set Founds to Default 0
	x1 = 0;
	x2 = 0;
	// Set Position to 0
	z = 0;
	// Iterrate about Scale until Scale is complete or Upper Found is over given Note
	while { ((x2 <= y) && ( z < (~scale.size()-1)))  } {
		// Read in Items for Looking
		x1 = ~scale[z];
		x2 = ~scale[z+1];
		// Calculate Diffrence to given Note
		dx1 = abs(x1-y);
		dx2 = abs(x2-y);
		// Increment Position in Scale
		z = z +1;
	};
	// Test is upper or Lower Found nearest to given Note
	// And Set nearest Note to Find Note
	if(dx1 <= dx2) {
		xf = x1;
	} {
		xf = x2;
	};
	xf
})

// Function to find Frequency in Scale
// Argument is true Frequency
(~cleanFrequency = { arg f;
	// Declare Variables for Is Note and Found Note
	var ff, fo;
	// Calculate Is Note
	ff = f / 440;
	// Search for Note in Scale
	fo = ~nearestTopic.value(ff);
	// Calculate found Frequency
	f = fo * 440;
})

~cleanFrequency.value( 660);

// Routine to play Melody
(~player = Routine.new({
	// Declare Variable to Handle Synth Instance
	var x,
	// Declare Variable for True and Play Frequency
	f, fd, ratio;
	// Set True Frequency to Begining by 440 Hz
	f = 440;
	// Set Ratio to Fifth
	ratio = 1.5;
	// Infinty Loop to play Melody
	while(true)
	{
		if([true, false].choose)
		{
			ratio = 3.0/2.0;
		} {
			ratio = 4.0/3.0;
		};
		// Choose Direction of Playing Interval
		// And increase or decreas by Ratio
		if([true, false].choose)
		{
			f = f * ratio;
		} {
			f = f / ratio;
		};
		// Make Boundaries to Octave from 440 to 880 Hz
		if(f >= 880)
		{
			f = f /2 }
		{
			if(f < 440) { f = f * 2 };
		};
		// Find Play Frequency
		fd = ~cleanFrequency.value(f);
		// Play the Synth with play Frequency
		x = Synth(\Synth, [freq: fd ]);
		// Wait for a Half Second
		0.5.wait;
		// Free PLaying Synth
		x.free;
	}
});)

~player.play;
~player.stop;