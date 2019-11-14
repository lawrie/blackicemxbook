#include <stdio.h>
#include <stdlib.h>
#include "Vthruwire.h"
#include "verilated.h"

int main(int argc, char**argv) {
	// Call  commandArgs  first!
	Verilated::commandArgs(argc, argv);
	//  Instantiate  our  design
	Vthruwire *tb = new Vthruwire;

	for(int k=0; k<20; k++) {
		// We’ll set  the  switch  input
		// to the  LSB of our  counter
		tb->i_sw = k&1;
		tb->eval();
		
		// Now  let’s print  our  results
		printf("k = %2d, ", k);
		printf("sw = %d, ", tb->i_sw);
		printf("led = %d\n", tb->o_led);
	}
}
