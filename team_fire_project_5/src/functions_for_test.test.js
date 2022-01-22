const { expect } = require('@jest/globals');
const is_set = require  ('./functions_for_tests')
const test_from_string_signature = require  ('./functions_for_tests')
/**
 * Testing specifically for is_set function
 *      to check if three cards to be a set
 */

// All different Numbers - All are Red - All are Diamonds - All are Solid
test('[1,S,D,R] & [2,S,D,R] & [3,S,D,R] is a set', () => {
    expect(is_set([{numbers: 1, texture: "solid", shape: "diamond", color: "red"},
{numbers: 2, texture: "solid", shape: "diamond", color: "red"}, 
{numbers: 3, texture: "solid", shape: "diamond", color: "red"}
])).toBeTruthy();
});

// // All different Numbers - All different Colors - All different Symbols - All different Shadings
test('[1,O,V,G] & [3,T,D,R] & [2,S,P,Q] is a set', () => {
    expect(is_set([{numbers: 1, texture: "open", shape: "oval", color: "green"},
    {numbers: 3, texture: "striped", shape: "diamond", color: "red"},
    {numbers: 2, texture: "solid", shape: "squigle", color: "purple"}

    ])).toBeTruthy();
});

//All have 1 - All are Red - All different Symbols - All different Shadings
test('[1,S,D,R] & [3,T,P,D] & [2,T,G,Q] is a set', () => {
    expect(is_set([{numbers: 1, texture: "solid", shape: "diamond", color: "red"},
    {numbers: 1, texture: "striped", shape: "oval", color: "red"},
    {numbers: 1, texture: "open", shape: "squigle", color: "red"}])).toBeTruthy();
});

/**
 * Testing three cards not to be a set
 */
//Not a set, two are red and one is not
 test('[1,S,D,G] & [2,O,S,R] & [3,T,V,R] is not a set', () => {
   expect(is_set([{numbers: 1, texture: "solid", shape: "diamond", color: "green"},
    {numbers: 2, texture: "open", shape: "squigle", color: "red"},
    {numbers: 3, texture: "striped", shape: "oval", color: "red"}])).toBeFalsy();
});
//Not a set, two are striped and one is open
test('[1,S,O,R] & [2,T,S,P] & [3,T,D,P] is not a set', () => {
    expect(is_set([{numbers: 1, texture: "striped", shape: "oval", color: "red"},
     {numbers: 2, texture: "striped", shape: "squigle", color: "purple"},
     {numbers: 3, texture: "open", shape: "diamond", color: "green"}])).toBeFalsy();
 });
//Nnot a set, two have numbers 3, and one is not; two have stripped and one is not
 test('[2,T,O,R] & [3,T,S,G] & [3,O,D,P] is not a set', () => {
    expect(is_set([{numbers: 2, texture: "striped", shape: "oval", color: "red"},
     {numbers: 3, texture: "striped", shape: "squigle", color: "purple"},
     {numbers: 3, texture: "open", shape: "diamond", color: "green"}])).toBeFalsy();
 });


