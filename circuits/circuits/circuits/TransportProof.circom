pragma circom 2.0.0;

include "node_modules/circomlib/circuits/comparators.circom";

template TransportProof() {
    // Private inputs
    signal input previousRouteScore;   // Higher = more congested
    signal input currentRouteScore;    // Lower = better
    signal input secretSalt;

    // Public outputs
    signal output improvementPercentage;
    signal output isValid;

    // Calculate improvement
    var improvement = previousRouteScore - currentRouteScore;
    var percentage = (improvement * 100) / previousRouteScore;

    improvementPercentage <== percentage;

    // Require >= 12% improvement
    component threshold = GreaterEqThan(32);
    threshold.in[0] <== improvement * 100;
    threshold.in[1] <== previousRouteScore * 12;

    isValid <== threshold.out;
}

component main = TransportProof();
