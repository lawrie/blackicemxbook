/******************************************************************************
*                                                                             *
* Copyright 2016 myStorm Copyright and related                                *
* rights are licensed under the Solderpad Hardware License, Version 0.51      *
* (the “License”); you may not use this file except in compliance with        *
* the License. You may obtain a copy of the License at                        *
* http://solderpad.org/licenses/SHL-0.51. Unless required by applicable       *
* law or agreed to in writing, software, hardware and materials               *
* distributed under this License is distributed on an “AS IS” BASIS,          *
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or             *
* implied. See the License for the specific language governing                *
* permissions and limitations under the License.                              *
*                                                                             *
******************************************************************************/

/* 7 Segment identities *******************************************************
*       Digit 2  Digit 1  DIgit 0
*       ca:011   ca:101   ca:110
*       a  _     a  _      a  _
*       f | | b  f | | b  f | | b
*       g  -     g  -     g  -
*       e |_| c  e |_| c  e |_| c
*       d    .dp d    .dp d    .dp
 *****************************************************************************/
 
module seven_seg_display (
	input clk, 
	output reg [2:0] ca, 
	);

	initial begin
		ca = 3'b110;
	end

	reg [17:0] count;

	always @(posedge clk) begin
    	count <= count + 1;
		if(count[17]) begin
			count <= 0;
			ca <= {ca[1:0], ca[2]};
		end
	end
	
endmodule


