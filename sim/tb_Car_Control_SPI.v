`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  System test for Car_Control_SPI, driving the SPI bus the way the Pi
//  harness does (mode 0, 500 kHz, separate write and read transactions).
//  Built with BOARD_CMOD (12 Mhz). Watchdog shortened to 2 ms to keep it quick.
//////////////////////////////////////////////////////////////////////////////////

module tb_Car_Control_SPI;

    parameter SPI_HALF = 1000;              // ns, 500 kHz as the Pi harness
    parameter WATCHDOG = 24_000;            // 2 ms at 12 Mhz
    parameter ACK_OK = 8'h01;

    reg             clk = 0;
    reg             reset = 1;
    reg             spi_clk = 0;
    reg             spi_mosi = 0;
    reg             spi_cs = 1;
    wire            spi_miso;

    wire            lf_dir, lb_dir, rf_dir, rb_dir;
    wire            lf_step, lb_step, rf_step, rb_step;
    wire            enable, enable_led, spi_gnd, aux_gnd, msg_led, red, blue, green;

    integer         errors = 0;

    always #41.667 clk = ~clk;  // 12 Mhz

    Car_Control_SPI dut(.i_sysclk(clk), .i_reset(reset),
        .i_SPI_Clk(spi_clk), .i_SPI_MOSI(spi_mosi), .i_SPI_CS(spi_cs), .o_SPI_MISO(spi_miso),
        .o_Left_Front_Dir(lf_dir), .o_Left_Back_Dir(lb_dir), .o_Right_Front_Dir(rf_dir), .o_Right_Back_Dir(rb_dir),
        .o_Left_Front_Step(lf_step), .o_Left_Back_Step(lb_step), .o_Right_Front_Step(rf_step), .o_Right_Back_Step(rb_step),
        .o_Enable(enable), .o_Enable_LED(enable_led),
        .o_SPI_Gnd(spi_gnd), .o_Aux_Gnd(aux_gnd), .o_msg_LED(msg_led),
        .o_Red_led(red), .o_Blue_led(blue), .o_Green_led(green));
    defparam dut.WATCHDOG_TIMEOUT = WATCHDOG;

    // Count step pulses on each motor
    integer         lf_count = 0, lb_count = 0, rf_count = 0, rb_count = 0;
    always @(posedge lf_step) lf_count = lf_count + 1;
    always @(posedge lb_step) lb_count = lb_count + 1;
    always @(posedge rf_step) rf_count = rf_count + 1;
    always @(posedge rb_step) rb_count = rb_count + 1;

    task clear_counts;
    begin
        lf_count = 0; lb_count = 0; rf_count = 0; rb_count = 0;
    end
    endtask

    //------------------------------------------------------------------
    // SPI master, mode 0, MSB first
    //------------------------------------------------------------------
    task spi_byte(input [7:0] tx, output [7:0] rx);
        integer b;
    begin
        for (b = 7; b >= 0; b = b - 1)
        begin
            spi_mosi = tx[b];
            #SPI_HALF;
            rx[b] = spi_miso;
            spi_clk = 1;
            #SPI_HALF;
            spi_clk = 0;
        end
    end
    endtask

    reg     [7:0]   tx_buf [0:15];
    reg     [7:0]   rx_buf [0:15];

    task spi_transfer(input integer len);
        integer n;
        reg [7:0] rx;
    begin
        spi_cs = 0;
        #SPI_HALF;
        for (n = 0; n < len; n = n + 1)
        begin
            spi_byte(tx_buf[n], rx);
            rx_buf[n] = rx;
        end
        #SPI_HALF;
        spi_cs = 1;
        #(SPI_HALF * 10);
    end
    endtask

    // As message_send() in spi_test.c: start byte, 8 bytes, checksum, then read ack
    task send_message(input [63:0] msg);
        integer n;
        reg [7:0] sum;
    begin
        tx_buf[0] = 8'h10;
        sum = 0;
        for (n = 0; n < 8; n = n + 1)
        begin
            tx_buf[n + 1] = msg[n * 8 +: 8];
            sum = sum + msg[n * 8 +: 8];
        end
        tx_buf[9] = ~sum + 1;
        spi_transfer(10);
        tx_buf[0] = 8'h00;
        spi_transfer(1);
        if (rx_buf[0] !== ACK_OK)
        begin
            $display("FAIL message %h: ack %h", msg, rx_buf[0]);
            errors = errors + 1;
        end
    end
    endtask

    // As read_motor_message() in spi_test.c: request byte, then read 8 bytes plus checksum
    reg     [63:0]  status;
    task read_status(input [7:0] request);
        integer n;
        reg [7:0] sum;
    begin
        tx_buf[0] = request;
        spi_transfer(1);
        for (n = 0; n < 9; n = n + 1)
            tx_buf[n] = 8'h00;
        spi_transfer(9);
        sum = 0;
        for (n = 0; n < 8; n = n + 1)
        begin
            status[n * 8 +: 8] = rx_buf[n];
            sum = sum + rx_buf[n];
        end
        if (rx_buf[8] !== (~sum + 8'd1))
        begin
            $display("FAIL status %h: checksum %h, calculated %h", request, rx_buf[8], ~sum + 8'd1);
            errors = errors + 1;
        end
    end
    endtask

    // Skid motor message, as set_motor_limit() in spi_test.c
    function [63:0] skid_msg(input [7:0] left_speed, input [7:0] right_speed, input left_dir, input right_dir,
            input count, input count_right, input [23:0] steps);
        skid_msg = {8'h00, steps, right_speed, left_speed, {4'h0, count_right, count, right_dir, left_dir}, 8'h01};
    endfunction

    task wait_ms(input integer ms);
        integer n;
    begin
        for (n = 0; n < ms; n = n + 1)
            #1_000_000;
    end
    endtask

    task expect_steps(input [255:0] name, input integer got, input integer expected);
    begin
        if (got != expected)
        begin
            $display("FAIL %0s: %0d steps, expected %0d", name, got, expected);
            errors = errors + 1;
        end
        else
            $display("ok   %0s: %0d steps", name, got);
    end
    endtask

    task counted_move(input integer steps, input count_right);
    begin
        clear_counts;
        send_message(skid_msg(8'hFF, 8'hFF, 1'b0, 1'b1, 1'b1, count_right, steps));
        wait_ms(steps / 8 + 1);  // Speed FF on the CMOD is about 9 kHz
        expect_steps(count_right ? "counted move, right side" : "counted move, left side",
            count_right ? rf_count : lf_count, steps);
        read_status(8'h22);
        if (status[31:8] !== 24'd0 || status[3] !== 1'b0)
        begin
            $display("FAIL counted move %0d: status remaining %0d moving %b", steps, status[31:8], status[3]);
            errors = errors + 1;
        end
    end
    endtask

    initial
    begin
        repeat (20) @(posedge clk);
        reset = 0;
        repeat (20) @(posedge clk);

        // Version message
        read_status(8'h21);
        if (status[31:0] !== 32'h20_10_00_07)
        begin
            $display("FAIL version %h", status);
            errors = errors + 1;
        end
        else
            $display("ok   version %h", status[31:0]);

        // Independent mode, all directions set, all four direction pins must follow
        send_message({16'h0000, 8'h40, 8'h40, 8'h40, 8'h40, 8'h0F, 8'h05});
        repeat (10) @(posedge clk);
        if ({lf_dir, rf_dir, lb_dir, rb_dir} !== 4'b1111)
        begin
            $display("FAIL direction pins LF %b RF %b LB %b RB %b, expected all 1", lf_dir, rf_dir, lb_dir, rb_dir);
            errors = errors + 1;
        end
        else
            $display("ok   all four direction pins set");
        send_message({16'h0000, 8'h40, 8'h40, 8'h40, 8'h40, 8'h00, 8'h05});
        repeat (10) @(posedge clk);
        if ({lf_dir, rf_dir, lb_dir, rb_dir} !== 4'b0000)
        begin
            $display("FAIL direction pins LF %b RF %b LB %b RB %b, expected all 0", lf_dir, rf_dir, lb_dir, rb_dir);
            errors = errors + 1;
        end
        send_message(skid_msg(8'h00, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0, 24'd0));

        // Counted moves must give exactly the steps asked for
        counted_move(1, 1'b0);
        counted_move(5, 1'b0);
        counted_move(37, 1'b0);
        counted_move(16, 1'b1);

        // Counting a side that is stopped must not end the move early
        clear_counts;
        send_message(skid_msg(8'h00, 8'hFF, 1'b0, 1'b0, 1'b1, 1'b0, 24'd10));
        #500_000;
        read_status(8'h22);
        if (status[3] !== 1'b1 || rf_count < 5)
        begin
            $display("FAIL counting stopped side: moving %b, right side %0d steps", status[3], rf_count);
            errors = errors + 1;
        end
        else
            $display("ok   counting stopped side keeps running, right side %0d steps", rf_count);

        // Status requests act as a heartbeat, motors keep running
        send_message(skid_msg(8'h80, 8'h80, 1'b0, 1'b0, 1'b0, 1'b0, 24'd0));
        repeat (6)
        begin
            #1_000_000;
            read_status(8'h20);
        end
        clear_counts;
        #500_000;
        if (lf_count == 0)
        begin
            $display("FAIL heartbeat: motors stopped");
            errors = errors + 1;
        end
        else
            $display("ok   heartbeat keeps motors running");

        // No contact from the Pi, watchdog stops the motors
        wait_ms(3);
        clear_counts;
        wait_ms(1);
        expect_steps("after watchdog timeout", lf_count + rf_count + lb_count + rb_count, 0);
        read_status(8'h22);
        if (status[4] !== 1'b1 || status[3] !== 1'b0)
        begin
            $display("FAIL watchdog status bits %b", status[7:0]);
            errors = errors + 1;
        end
        else
            $display("ok   watchdog flagged in status");

        // Next motor message clears the flag and runs again
        send_message(skid_msg(8'h80, 8'h80, 1'b0, 1'b0, 1'b0, 1'b0, 24'd0));
        #500_000;
        read_status(8'h22);
        if (status[4] !== 1'b0 || lf_count == 0)
        begin
            $display("FAIL restart after watchdog: status %b, %0d steps", status[7:0], lf_count);
            errors = errors + 1;
        end
        else
            $display("ok   restart after watchdog");

        if (errors == 0)
            $display("PASS tb_Car_Control_SPI");
        else
            $display("FAILED tb_Car_Control_SPI with %0d errors", errors);
        $finish;
    end

endmodule
