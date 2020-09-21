//////////////////////////////////////////////////////////////////////////////////
//  SPI coms module uses SPI-slave module. Will accept incomming message
//  and if checksum is correct will flag to calling module through o_rec_data_DV
//  Timeout based on 100Mhz clock
//
//  Will response bytes and status messages.
//
// 
//////////////////////////////////////////////////////////////////////////////////



module SPI_Coms(
    input               i_sysclk, // 100 Mhz clock source on Basys 3 FPGA
    input               i_reset, // reset
    input               i_SPI_Clk,
    input               i_SPI_MOSI,
    input               i_SPI_CS,
    input       [63:0]  i_send_data_array,           
    output              o_SPI_MISO,
    output reg  [3:0]   o_send_message_type,
    output reg          o_rec_data_DV,
    output reg  [63:0]  o_rec_data_array,
    output reg          o_send_data_request

    );

    parameter IDLE  = 3'b001,RECMSG = 3'b010,MSGOK = 3'b100, MSGKO = 3'b101, ENDMSG = 3'b110, SENDMSG=3'b111;
    parameter CRC_ERROR = 3'b011, TIMEOUT = 3'b010;
    parameter RECEIVE_MAX_TIME = 99_999;  // 1 ms timeout between first and last byte of received message
    parameter SEND_MAX_TIME = 999_999; // 10 ms to complete receive of status after request
    parameter CRC_ERROR_CODE = 8'h02, TIMEOUT_CODE=8'h03, ACK_OK=8'h01; // ACK and Error return codes
    parameter START_MSG_CODE = 4'h1, SEND_MESSAGE_CODE = 4'h2; // Message start and status request codes. First nibble (most sig) type, second can be subtype.
    
    
    //-------------Internal Variables---------------------------
    reg     [2:0]       state;        // Seq part of the FSM
    reg     [2:0]       next_state;   // combo part of FSM
    reg     [2:0]       msg_rec_counter;   // counting received bytes    
    reg     [3:0]       msg_send_counter;   // counting sent bytes
    reg     [7:0]       crc_value;    // To hold the CRC value
	integer i;                        // For for loops    
    reg     [7:0]       r_data [7:0];  // Data received temp
    reg     [31:0]      timeout_counter;  // To check for message timeout
    reg     [2:0]       error_code;
    reg     [63:0]      r_i_send_data_array;
    
    //  Links to SPI slave
    wire                SPI_RX_DV;    // Data Valid pulse (1 clock cycle)
    wire    [7:0]       SPI_RX_Byte;  // Byte received on MOSI
    reg                 SPI_TX_DV;    // Data Valid pulse to register i_TX_Byte
    reg     [7:0]       SPI_TX_Byte;  // Byte to serialize to MISO. 
    wire                SPI_TX_sent;  // Pulse when TX sent

    // For output
    reg      [7:0]       rec_data [7:0];  // Data received for output
         
    SPI_Slave SPI_Slave1 (.i_Rst_L(~i_reset), .i_Clk(i_sysclk),.o_RX_DV(SPI_RX_DV),
        .o_RX_Byte(SPI_RX_Byte),.o_TX_sent(SPI_TX_sent),.i_TX_DV(SPI_TX_DV), .i_TX_Byte(SPI_TX_Byte),
        .i_SPI_Clk(i_SPI_Clk),.i_SPI_MOSI(i_SPI_MOSI),.i_SPI_CS_n(i_SPI_CS),.o_SPI_MISO(o_SPI_MISO));  
        
/*  ila_0  myila(.clk(i_sysclk),.probe0(crc_value),.probe1(r_i_send_data_array),.probe2(crc),.probe3(SPI_TX_sent),
  .probe4(o_send_message_type), .probe5(SPI_TX_Byte),.probe6(state),.probe7(SPI_RX_Byte));
    */
    initial
        begin
            state=IDLE;
            next_state=IDLE;
            o_rec_data_DV=1'h0;
            o_send_message_type=4'h0;
        end 
    
    //  Reset FSM   
    always @(posedge i_sysclk)
    begin
     if (i_reset==1)                
        begin
            state = IDLE; 
        end //if reset
        else
        begin
            state=next_state;
        end // if not reset
    end //always
       
    // FSM block 
    always @(posedge i_sysclk) 
        begin     
            case(state)
            IDLE:
            begin
                o_rec_data_DV=1'b0;
                SPI_TX_DV<=1'b0;
                if(SPI_RX_DV==1'b1)
                begin 
                    case (SPI_RX_Byte[7:4])
                    START_MSG_CODE:
                    begin
                        next_state<=RECMSG;
                        msg_rec_counter<=3'h0; 
                        timeout_counter<=32'h0;
                        SPI_TX_Byte<=8'd0;          
                    end // If start byte
                    SEND_MESSAGE_CODE:
                    begin 
                        // Here we can use the second nibble of SPI_RX_DV to set message type
                        next_state<=SENDMSG;
                        msg_send_counter=4'h0;
                        o_send_data_request<=1'b1; // Tell caller to update send message
                        o_send_message_type<=SPI_RX_Byte[3:0];
                        r_i_send_data_array=i_send_data_array;
                        SPI_TX_Byte<=r_i_send_data_array[7:0];
                        SPI_TX_DV<=1'b1;  // Send first byte, leave high until ended
                        timeout_counter<=32'h0;
                    end // if SEND_MESSAGE_CODE
                    default:  next_state<=IDLE;
                    endcase
                 end // if(SPI_RX_DV)
            end // case IDLE
            SENDMSG:
            begin
                timeout_counter=timeout_counter+1;
                if (timeout_counter>SEND_MAX_TIME)
                begin
                    r_i_send_data_array=64'h0;
                    SPI_TX_Byte<=8'h0;
                    SPI_TX_DV<=1'b1;
                    o_send_message_type=4'h0;
                    o_send_data_request<=0'b1;
                    next_state<=IDLE;   // If not all message sent then go back to idle state.
                end
                
                if (msg_send_counter==0) // pick up new message before transmition starts
                begin
                    r_i_send_data_array=i_send_data_array; // pick up any update from calling module based on message type
                    SPI_TX_Byte<=r_i_send_data_array[7:0];
                    crc_value<=r_i_send_data_array[7:0];
                    SPI_TX_DV<=1'b1;
                end
                else
                begin
                    o_send_data_request<=0'b1; // Can no longer update the send message as we have sarted
                end
                if (SPI_TX_sent)  // Pulse from SPI Slave that byte was sent 
                begin
                  msg_send_counter=msg_send_counter+1; // Blocking update
                  SPI_TX_DV<=1'b1;
                  case (msg_send_counter)
                  1: 
                  begin
                    SPI_TX_Byte<=r_i_send_data_array [15:8];
                    crc_value<=crc_value+r_i_send_data_array [15:8];
                  end
                  2: 
                  begin
                    SPI_TX_Byte<=r_i_send_data_array [23:16];
                    crc_value<=crc_value+r_i_send_data_array [23:16];
                  end
                  3: 
                  begin
                    SPI_TX_Byte<=r_i_send_data_array [31:24];
                    crc_value<=crc_value+r_i_send_data_array [31:24];
                  end
                  4: 
                  begin
                    SPI_TX_Byte<=r_i_send_data_array [39:32];
                    crc_value<=crc_value+r_i_send_data_array [39:32];
                  end
                  5: 
                  begin
                    SPI_TX_Byte<=r_i_send_data_array [47:40];
                    crc_value<=crc_value+r_i_send_data_array [47:40];
                  end
                  6: 
                  begin
                    SPI_TX_Byte<=r_i_send_data_array [55:48];
                    crc_value<=crc_value+r_i_send_data_array [55:48];
                  end
                  7: 
                  begin
                    SPI_TX_Byte<=r_i_send_data_array [63:56];
                    crc_value<=crc_value+r_i_send_data_array [63:56];
                  end
                  8: SPI_TX_Byte<=~crc_value+1;  // twos complement
                  default:  // for the 9th byte and error cases
                  begin
                    SPI_TX_Byte<=8'h0;  
                    o_send_message_type=4'h0;
                    next_state<=IDLE;
                    msg_send_counter=4'h0;
                  end
                  endcase
                end
            end // case SENDMSG
            RECMSG:
            begin
                timeout_counter=timeout_counter+1;
                if (timeout_counter>RECEIVE_MAX_TIME)
                begin
                    next_state<=MSGKO;
                    error_code <= TIMEOUT;
                end      
                if(SPI_RX_DV)
                begin
                    r_data[msg_rec_counter]<=SPI_RX_Byte;
                    msg_rec_counter<=msg_rec_counter+1;
                    if (msg_rec_counter==7)
                    begin
                        next_state<=ENDMSG;
                    end // if end of message
                end // if SPI_RX_DV
            end // case RECMSG
            ENDMSG:       
            begin
                timeout_counter=timeout_counter+1;
                if (timeout_counter>RECEIVE_MAX_TIME)
                begin
                    next_state<=MSGKO;
                    error_code <= TIMEOUT;
                end  
                if(SPI_RX_DV)
                begin 
                    crc_value=8'h0;
                    for (i=0;i<8;i=1+i)
	                    crc_value=crc_value+r_data[i];
	                crc_value=~crc_value+1;
		            if (crc_value==SPI_RX_Byte)
                    begin
                    next_state<=MSGOK;
                    end // if CRC OK
                    else
                    begin
                        // Send MSG OK pin value;
                        next_state<=MSGKO;
                        error_code <= CRC_ERROR;
                    end // if CRC KO
                end // if SPI_RX_DV
            end // case ENDMSG 
            MSGOK:
            begin
                SPI_TX_DV<=1'b1;
                SPI_TX_Byte<=ACK_OK;  // Ack responce
                o_rec_data_DV<=1;
                
                o_rec_data_array[63:56]<=r_data[7];
                o_rec_data_array[55:48]<=r_data[6];
                o_rec_data_array[47:40]<=r_data[5];
                o_rec_data_array[39:32]<=r_data[4];
                o_rec_data_array[31:24]<=r_data[3];
                o_rec_data_array[23:16]<=r_data[2];
                o_rec_data_array[15:8]<=r_data[1];
                o_rec_data_array[7:0]<=r_data[0];
                
                next_state<=IDLE;              
            end // case MSGOK
            MSGKO:
            begin
                SPI_TX_DV<=1'b1;
                if (error_code==CRC_ERROR)
                    SPI_TX_Byte<=CRC_ERROR_CODE;   // Nack response
                if (error_code==TIMEOUT)
                    SPI_TX_Byte<=TIMEOUT_CODE;   // Nack response
                next_state<=IDLE;
            end // case MSGKO
            default : next_state <= IDLE;
            endcase
      end // always block

     
              
 endmodule