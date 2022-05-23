// //[assignment] write your own unit test to show that your Mastermind variation circuit is working as expected

// import { Circuit, bigInt } from 'snarkjs'
// import * as compile from 'circom'
// import {pedersenHash} from '../pedersen'

const { expect } = require("chai");
const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);
const buildPoseidon = require("circomlibjs").buildPoseidon;

const assert = chai.assert;

describe("MastermindTest", function () {
    this.timeout(100000000);

    it("Bonus question", async () => {
        const poseidonJs = await buildPoseidon();
        const circuit = await wasm_tester("contracts/circuits/MastermindVariation.circom");

        const INPUT =
        {
            "publicColors": [5, 3, 2],
            "privateColors": [5, 3, 2],
            "wp": 3,
            "rp": 0,
            "privateSolHash": poseidonJs.F.toObject(poseidonJs([5, 3, 2]))
        }

        const witness = await circuit.calculateWitness(INPUT, true);

        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), poseidonJs.F.toObject(poseidonJs([5, 3, 2]))));

    });
});

