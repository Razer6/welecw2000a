The toplevel entity is TopDownSampler. 
simulation tools: ghdl, Octave
synthesis tool:   Quartus

TODO: Dealing with the wrong signal gain comming out of this filters.
 
The Octave directory contains Octave scripts to create the filter coefficients and some test samples. The wave file DownSampled.wav created in the simDownSampler simulation cannot be played, because of it's to high sampling rate, but you can display and analyse them with Octave's wavread + plot function.

