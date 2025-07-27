# IMPORTANT

Here we have assumed that ALL seq gates can be faulted.
The computation assumes that all faults are tried to be injected.
This includes also the last gate of a circuit, this fault can never be corrected and for stuck-at-X and toggle fault the adversary cannot learn from this.
Since this faults are allways affective we can just compute the number of faults on the output gates by counting the nubmer of output bits and multiply this number by the probability of a single fault to occur.
