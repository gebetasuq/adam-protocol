pragma circom 2.0.0;

include "node_modules/circomlib/circuits/comparators.circom";

template TransportProof() {
    // Private inputs
    signal input previousCommuteMinutes;  // baseline
    signal input currentCommuteMinutes;   // today's commute
    signal input secretSalt;

    // Public outputs
    signal output reductionPercentage;
    signal output isValid;

    // Compute reduction
    var savedMinutes = previousCommuteMinutes - currentCommuteMinutes;
    var percentage = (savedMinutes * 100) / previousCommuteMinutes;

    // Constrain output
    reductionPercentage <== percentage;

    // Check >= 20% reduction for demo
    component ge = GreaterEqThan(32);
    ge.in[0] <== savedMinutes * 100;
    ge.in[1] <== previousCommuteMinutes * 20;

    isValid <== ge.out;
}

component main = TransportProof();
