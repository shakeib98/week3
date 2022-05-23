// [bonus] implement an example game from part d

pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";

template SnakeAndLadder(n){
    signal input diceTurns[n];
    signal input publicHashSol;

    signal output solHash;

    var position = 0;
    signal p;

    component poseidon = Poseidon(n);

    for(var i=0; i<n; i++){
        poseidon.inputs[i] <== diceTurns[i];

      if(position == 0){
            if(diceTurns[i] > 5){
                position = position + 1;
            }
        }else{
            if(position + diceTurns[i] <=20){
                if(position + diceTurns[i] ==3){
                    position = 14;
                }else if(position + diceTurns[i] ==12){
                    position = 6;
                }else{
                    position = position + diceTurns[i];
                }
            }
        }
    }

    solHash <== poseidon.out;
    
    p <-- position;

    p === 20;
}

component main = SnakeAndLadder(8);