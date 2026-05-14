module input_buffer (
    input logic [2:0]   i_control,     //funct3 cua I-load
    input logic [31:0]  i_in_buf_addr, //dia chi
    input logic [31:0]  i_io_sw,

    output logic [31:0] o_in_buf_data
);

//dia chi switch trong bo nho
localparam SW_BASE_ADRR = 32'h10010000;
localparam SW_TOP_ADDR  = 32'h10010FFF;


//funct3
localparam LB  = 3'b000,
           LH  = 3'b001,
           LW  = 3'b010,
           LBU = 3'b100,
           LHU = 3'b101;
           
//offset trong vung switch
//offset = 1 thi doc byte,...
logic [1:0] byte_offset; 

//i_io_sw la gia tri thuc, nen gan du lieu tam cho i_io_sw
logic [31:0] sw_data;
assign sw_data = i_io_sw;

//extract tung byte
logic [7:0] temp[3:0];

assign temp[0] = sw_data[7:0];   //byte thap
assign temp[1] = sw_data[15:8];  //byte 2       
assign temp[2] = sw_data[23:16]; //byte 3
assign temp[3] = sw_data[31:24]; //byte cao


always_comb begin 
    if ((i_in_buf_addr >= SW_BASE_ADRR) && (i_in_buf_addr <= SW_TOP_ADDR)) begin //neu i_in_buf_addr nam trong vung 0x1001_0000 den 0x1001_0FFF thi chay 
       byte_offset = i_in_buf_addr[1:0];    //vi chi co 4byte trong bo nho nen lay 2 bit cuoi cua i_in_buf_addr

    case (i_control)
        LB: o_in_buf_data  = {{24{temp[byte_offset][7]}}, temp[byte_offset]}; //LB = load byte, lay 1 byte roi mo rong dau cho du 32 bit
        LH: o_in_buf_data  = (byte_offset == 2'b11) ? 32'b0 : {{16{temp[byte_offset+1][7]}}, temp[byte_offset+1], temp[byte_offset]}; //load 2 byte lien tiep, nhung o byte 3 la byte cuoi cung roi, k con byte ke tiep de load vao    
        LW: o_in_buf_data  = (byte_offset != 2'b00) ? 32'b0 : {temp[3], temp[2], temp[1], temp[0]};
        LBU: o_in_buf_data = {24'b0, temp[byte_offset]};
        LHU: o_in_buf_data = (byte_offset == 2'b11) ? 32'b0 : {16'b0, temp[byte_offset+1], temp[byte_offset]};
        default: o_in_buf_data = 32'b0;
    endcase
    end 
    else begin
        o_in_buf_data = 32'b0;
        end
        
    end

    endmodule




