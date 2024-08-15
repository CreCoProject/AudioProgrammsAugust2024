// Synth-Def for the Sound Source
// Arguments of the Synth:
// freq = Frequency of the Sound to play
// sourceMix = Color of the Sound between Sawrthooth and SquareWave
(
SynthDef(\Sound_Source, { |freq, sourceMix|
	// Signal Channels for the Sounds
	// sig Main Signal
	// sig1 sig2 Channels for the Components Sawthooth and SquareWave
    var sig, sig1, sig2;

	// Sources for the Sounds
	// Safthooth Source
	sig1 = Saw.ar(freq);
	// Squarewave Source
	sig2 = Pulse.ar(freq);

	// Mixing of the primary Sources
	sig = (sig1*sourceMix) + (sig2*(1-sourceMix));
	// Output of the resulting Signal
	Out.ar(0, [sig, sig]);
}).add;
)

// Dummy Method to test the Synth
x = Synth(\Sound_Source, [freq: 440, sourceMix: 1]);

// Creating Arrays for Frequency and Synth Instances
(
// Intialise empty Frequency Handling Array
~frequenciesPlayed = Array.new();
// Intialise empty Synth Instances Handling Array
~synthsRunning = Array.new();
)

// Method to creting a new Sound Synth Instance
// Argument is Frequency of the Sound
( ~newSound = { arg freq;
	// Creating the Sound Synth Instance
	x = Synth(\Sound_Source, [freq: 440, sourceMix: 0.5]);
	// Store Frequency of the new Sound in the Frequency Array
	~frequenciesPlayed = ~frequenciesPlayed.add(freq);
	// Store Handler of the new Sound Synth Instance to the Synth Instance Array
	~synthsRunning = ~synthsRunning.add(x)};
)

// Method to erase a random choosen Synth Instance
(
~deleteSound = {
	// Temporary Variables for
	// n Number of playing Synth Instances
	// m Number of Synth Instances which will be erase
	var n, m; n = 0;
	// Estimate Number of playing Synths
	n = ~synthsRunning.size();
	// Choose a Random Synth Instance by Number
	m = n.rand();
	// Free the corresponding Synth Instance
	~synthsRunning[m].free;
	// Erase Synth Sound Instance from Handling Arrays
	// Erase Synth Sound Instance from Array of playing Synth Sound Instances
	~synthsRunning.removeAt(m);
	// Erase Synth Sound Instance from Array of Frequencies who will be playe
	~frequenciesPlayed.removeAt(m); ~frequenciesPlayed[m]};
)

// Dummy Methods to test Creating and Deleting of Sound Synth Instances
// Test Creating of Sound Synth Instance
~newSound.value(220);
// Test Deleting of Sound Synth Instance
~deleteSound.value();

// Showing Content of Handling Arrays
// Show Played Frequencies
~frequenciesPlayed;
// Show Played Synth Instances
~synthsRunning;

// Creating Empty Overtone Series Array
~overtoneSeries = Array.new();

// Function to create a new Overtone Serie
// Argument is Base Frequency of this Serie
(
~createOvertoneSeries = { arg base;
	// Variable to store incremented Frequency over the Serie
	var res;
	// Create new Empty Array for the Overtone Serie
	~overtoneSeries = Array.new();
	// Intialise Temporary Result with Base Frequency
	res = base;
	// Go with Serie to the Boundary of Maximal Frequency for the Sound System
	while { res < 22000 }
	{
		// Increment Temporary Result with Base Frequency
		res = res + base;
		// Store Temporary Result in the Overtone Series Array
		~overtoneSeries = ~overtoneSeries.add(res);
};};
)

// Dummy Tests for the Creating of OverToneSerie
// Create a new Overtone Serie from a given Base Frequency
~createOvertoneSeries.value(110);
// Show actual OverToneSerie
~overtoneSeries;

// Creating new Overtone Sound Instance
(
~createNewOvertoneSound = {
	// Temporary Variables
	// n Size of Played Frequencies
	// m Choose Played Frequency Position
	// x Size of Overtone Series
	// y Choose Overtone Frequency Position
	// f Choosen new Frequency for new Sound Synth Instance
	var n, m, x, y, f; n = 0;
	// Estimate Number of Playing Frequencies
	n = ~frequenciesPlayed.size();
	// Choose the Position of the Played Frequency to derivate from
	m = n.rand();
	// Create from this Frequency the Overtone Serie
	~createOvertoneSeries.value(~frequenciesPlayed[m]);
	// Estimate the Size of the actual OverTone Series
	x = ~overtoneSeries.size();
	// Choose the Position in the actual OverTone Serie
	y = x.rand();
	// Call the Frequency for the new Sound Synth Instance from the OverTone Serie
	f = ~overtoneSeries[y];
	// Call Function to create new Sound Synth Instance with actual Frequency
	~newSound.value( f)};
)

// Dummy Test for Creaing a New Overtone Series Sound Synt Instance
~createNewOvertoneSound.value();

(
// Function to create a new Diverence Sound
~createNewDiverenceSound = {
	// Temporary Variables
	// n Sizes of the Played Frequency Array
	// m Position of the Frequency in this Array for first and Second Frequency
	// f1 f2 The booth Frequencies choosen from the Array of playing Frequencies
	var n, m, f1, f2, f; n = 0;
	// Estimate Size of Playing Frequencies Array
	n = ~frequenciesPlayed.size();
	// Choose a Frequency from playing Frequencies
	m = n.rand();
	// Call first Frequency from this Position
	f1 = ~frequenciesPlayed[m];
	// Choose another Freuency from playing Frequencies
	m = n.rand();
	// Call Second Frequency from this Position
	f2 = ~frequenciesPlayed[m];
	// Check boot Frequencies are not the Same for avoiding 0 Result
	if(f1!=f2)
	{
		// Callculate Diverence Frequency
		f = abs( f1 - f2);
		// Call Method to create new Sound Synth Instance with calculated Frequency
		~newSound.value( f)};
};
)

// Dummy Test for creating New Diverence Sound Instance
~createNewDiverenceSound.value();

// Function to Choose to Create a new Sound Instance or to delete a Sound Instance
( ~changeSoundsSub = {
	// Randomly Create or Delete a Sound Instance
	if([false, true].choose)
	// Randomly call a Function to Create a Sound Instance
	{ if([false, true].choose)
		// Creating a Sound Instance by Diverence Method
		{ ~createNewDiverenceSound.value();}
		// Creating a Sound Instance by OverTone Method
		{  ~createNewOvertoneSound.value();}
	}
	// Delete a Sound Instance
	{ ~deleteSound.value();
};
};
)

// Function to Change the Sounds
( ~changeSounds = {
	// Temporay Variable for Frequency of free Creating Sound Instance
	var f;
	// Try Construct to Handling unsolved Exceptions
	try{
	// Cheeck there enough Sounds Instances for Processing
	if(~synthsRunning.size > 1)
	// Change the Playing Sounds by derivative Methods
	{ ~changeSoundsSub.value; }
	// Create free Sound Instances to hold System Consistent
	{f = 22000.rand; ~newSound.value(f);};
	}
};)

// Dummy Test Method for Change Sounds
~changeSounds.value;

// Wrapper Routine to Process the whoole Synth System
(
r = Routine {
	while { true }
	{
		// Change Sounds
		~changeSounds.value;
		// Wait a half Second to Process future
		0.5.sleep;
	};
}
)

// Start and Stop the whoole Synt System
r.run;
r.stop;