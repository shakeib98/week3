pragma circom 2.0.0;

// [assignment] implement a variation of mastermind from https://en.wikipedia.org/wiki/Mastermind_(board_game)#Variation as a circuit

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

template MastermindVariation(n) {
    //Walt Disney Mastermind
    //Colors max range till 5

    //public guess by the breaker
    signal input publicColors[n];

    signal input wp; //white peg for same position
    signal input rp; //red peg for different position

    //hash of public solution
    signal input privateSolHash;

    //private color guess
    signal input privateColors[n]; 

    //private solution hash so that constraint can be build
    signal output publicSolHash; 

    var wpCal = 0;
    var rpCal = 0;

    var colorSumPublic = 0;
    var colorSumPrivate = 0;

    
    //to check the color range
    component isLessThanColorsCount[6];
    var indexLessThan = 0;

    for(var i=0; i<3; i++){
        isLessThanColorsCount[indexLessThan] = LessThan(4);
        isLessThanColorsCount[indexLessThan].in[0] <== publicColors[i];
        isLessThanColorsCount[indexLessThan].in[1] <== 6;

        isLessThanColorsCount[indexLessThan].out === 1;

        isLessThanColorsCount[indexLessThan+1] = LessThan(4);
        isLessThanColorsCount[indexLessThan+1].in[0] <== privateColors[i];
        isLessThanColorsCount[indexLessThan+1].in[1] <== 6;

        isLessThanColorsCount[indexLessThan+1].out === 1;

        indexLessThan = indexLessThan + 2;
    }


    //to calculate whitepeg    
    
    component isEqualwp[3];

    for(var i=0; i<3; i++){
        isEqualwp[i] = IsEqual();
        isEqualwp[i].in[0] <== publicColors[i];
        isEqualwp[i].in[1] <== privateColors[i];

        wpCal+=isEqualwp[i].out;
    }

    component isEqualrp[6];
    
    var index = 0;

    for(var i=0; i<3; i++){
    //     index = 0;
        for(var j=0; j<3; j++){
            if(i!=j){
                isEqualrp[index] = IsEqual();
                isEqualrp[index].in[0] <== publicColors[i];
                isEqualrp[index].in[1] <== privateColors[j];
                
                rpCal+=isEqualrp[index].out;
                index = index + 1;
            }
        }
    }

    component wpEqual = IsEqual();
    wpEqual.in[0] <== wpCal;
    wpEqual.in[1] <== wp;
    wpEqual.out === 1;   
    

    component rpEqual = IsEqual();
    rpEqual.in[0] <== rpCal;
    rpEqual.in[1] <== rp;
    rpEqual.out === 1;
 
    component poseidon = Poseidon(3);
    poseidon.inputs[0] <== privateColors[0];
    poseidon.inputs[1] <== privateColors[1];
    poseidon.inputs[2] <== privateColors[2];

    publicSolHash <== poseidon.out;
    publicSolHash === privateSolHash;


}

component main {public [publicColors, wp, rp, privateSolHash]} = MastermindVariation(3);