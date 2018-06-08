module camara (input capture, //.........
               input clk, 
               input Href, 
               input Vsyn, 
               input Pclk,
               input [7:0]data,
               input rst,         //---------
               input en_div,    //..........
               input rd,
               output reset,    
               output Xclk, 
               output PWDN,     
               output [9:0]data_out);
 
reg wr;
reg [9:0]data_in;
reg [20:0]counter;
wire empty;
wire full;
wire [9:0]data_out;


assign PWDN = ~capture;
assign Pclk = Xclk; /// para gtk wave
assign reset = rst;  

div_frec div( .Xclk(Xclk), .en_div(en_div), .clk(clk)); 

FIFO fif(.data_in(data_in), .Pclk(Pclk), .empty(empty), .full(full), .rd(rd), .wr(wr), .data_out(data_out), .rst(rst));

always @(posedge Pclk) begin
    if (rst)begin
         wr<=0;
        counter<=0;       
    end
    if (~PWDN )begin
         data_in <= {data[7:0],Href,Vsyn}; 
        if (Vsyn==0 && Href==1)
            wr<=1;
        else
            wr<=0;
    end
end      
endmodule