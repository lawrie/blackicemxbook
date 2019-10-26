module ping (
  input clk,
  input req,
  input echo,
  output trig,
  output reg [3:0] cm_digits,
  output reg [3:0] cm_tens,
  output reg [3:0] cm_hundreds,
  output [3:0] led,
  output reg done);

reg [2:0] state = 0;
reg [31:0] counter;
reg [15:0] cm_counter;
reg trigger;

assign trig = trigger;

assign led[0] = req;
assign led[3:1] = state;

always @(posedge clk)
if (req && !done) begin
  if (counter == 250000) begin // If we get to 10 milliseconds, then error
     state <= 0;
     done <= 1;
     cm_hundreds <= 2;
     cm_tens <= 5;
     cm_digits <= 5;
     counter <= 0;
     trigger <= 0;
  end
  else case (state)
  0: begin // Got a request, set trigger low for 2 microseconds
       trigger <= 0;
       if (counter == 50) begin
         trigger <= 1;
         counter <= 0;
         state <= 1;
       end
       else counter <= counter + 1;
     end
  1: begin // Wait for end of trigger pulse, and set it low
       if (counter == 250) begin
         trigger <= 0;
         counter <= 0;
         state <= 2;
       end
       else counter <= counter + 1;
     end
  2: begin // Make sure echo is low
       if (echo == 0) begin
         counter <= 0;
         state <= 3;
       end
       else counter <= counter + 1;
     end
  3: begin // Wait for echo to go high
       if (echo == 1) begin
          counter <= 0;
          cm_counter <= 0;
          cm_digits <= 0;
          cm_tens <= 0;
          cm_hundreds <= 0;
          state <= 4;
       end 
       else counter <= counter + 1;
     end
  4: begin // Wait for echo to go low
       if (cm_counter == 1450) begin
         cm_counter <= 0;
         if (cm_digits == 9) begin
           cm_digits <= 0;
           if (cm_tens == 9) begin
             cm_tens <= 0;
             cm_hundreds <= cm_hundreds + 1;
           end
           else cm_tens <= cm_tens + 1;
         end
         else cm_digits <= cm_digits + 1;
       end
       else cm_counter <= cm_counter + 1;

       if (echo == 0) state <= 5;
       else counter <= counter + 1;
     end
  5: begin // Echo finished, return count in centimeters
       counter <= 0;
       done <= 1;
       state <= 0;
     end
  default: begin // Echo finished, return count in centimeters
       counter <= 0;
       done <= 1;
       state <= 0;
     end
  endcase
end
else begin
  state <= 0;
  done <= 0;
  counter <= 0;
  trigger <= 0;
end
endmodule
