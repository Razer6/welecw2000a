The toplevel entity is TopDownSampler. 
simulation tools: ghdl, Octave
synthesis tool:   Quartus

x values are comming out only shortly after other sampling options are set!
(Decimator >= 10) => (Decimator < 10)
These aren't realy bugs, everey filter needs it's setup time, but they can make serious troubles for further processing!
Use the is_x function like here, it returns always false in synthesis (-;, to solve this problems!

TODO: Dealing with the wrong signal gain comming out of this filters.
 
The Octave directory contains Octave scripts to create the filter coefficients and some test samples. The wave file DownSampled.wav created in the simDownSampler simulation cannot be played, because of it's to high sampling rate, but you can display and analyse them with Octave's wavread + plot function.

