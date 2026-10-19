`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  Unit test for SM_Output.
//  Checks reset holds the outputs low, nothing is counted at speed zero, and
//  every rising edge on the step pin gives exactly one o_step_counter pulse,
//  including the step started by a new command.
//////////////////////////////////////////////////////////////////////////////////

module tb_SM_Output;

    reg             clk = 0;
    reg             reset = 1;
    reg             data_DV = 0;
    reg             dir = 0;
    reg     [7:0]   speed = 0;
    wire            dir_pin;
    wire            step_pin;
    wire            step_counter;

    integer         errors = 0;
    integer         pin_edges = 0;
    integer         counter_pulses = 0;
    reg             step_pin_last = 0;

    always #41.667 clk = ~clk;  // 12 Mhz, as CMOD

    SM_Output dut(.i_sysclk(clk), .i_reset(reset), .i_data_DV(data_DV), .i_dir(dir), .i_speed(speed),
        .o_dir_pin(dir_pin), .o_step_pin(step_pin), .o_step_counter(step_counter));

    always @(posedge clk)
    begin
        step_pin_last <= step_pin;
        if (step_pin && !step_pin_last)
            pin_edges = pin_edges + 1;
        if (step_counter)
            counter_pulses = counter_pulses + 1;
    end

    task command(input [7:0] new_speed, input new_dir);
    begin
        @(negedge clk);
        speed = new_speed;
        dir = new_dir;
        data_DV = 1;
        @(negedge clk);
        data_DV = 0;
    end
    endtask

    task clear_counts;
    begin
        @(negedge clk);
        pin_edges = 0;
        counter_pulses = 0;
    end
    endtask

    task check(input [255:0] name, input integer expected_edges);
    begin
        if (pin_edges != expected_edges && expected_edges >= 0)
        begin
            $display("FAIL %0s: %0d step edges, expected %0d", name, pin_edges, expected_edges);
            errors = errors + 1;
        end
        if (counter_pulses != pin_edges)
        begin
            $display("FAIL %0s: %0d step edges but %0d count pulses", name, pin_edges, counter_pulses);
            errors = errors + 1;
        end
        else
            $display("ok   %0s: %0d step edges, %0d count pulses", name, pin_edges, counter_pulses);
    end
    endtask

    integer i;

    initial
    begin
        // Reset held for a while must keep everything quiet
        repeat (2000) @(posedge clk);
        check("held in reset", 0);
        if (step_pin !== 1'b0 || dir_pin !== 1'b0)
        begin
            $display("FAIL held in reset: step %b dir %b", step_pin, dir_pin);
            errors = errors + 1;
        end
        reset = 0;

        // Speed zero, no steps and no count pulses
        clear_counts;
        command(8'h00, 1'b0);
        repeat (5000) @(posedge clk);
        check("speed zero", 0);

        // Start from stopped, first step must be counted
        clear_counts;
        command(8'hFF, 1'b1);
        repeat (20) @(posedge clk);
        check("first step after start", 1);
        if (dir_pin !== 1'b1)
        begin
            $display("FAIL direction pin not set");
            errors = errors + 1;
        end

        // Keep running, every edge counted
        clear_counts;
        repeat (20000) @(posedge clk);
        check("running at speed FF", -1);
        if (pin_edges < 10)
        begin
            $display("FAIL running at speed FF: only %0d steps", pin_edges);
            errors = errors + 1;
        end

        // Change speed several times while running, at random phases
        clear_counts;
        for (i = 0; i < 20; i = i + 1)
        begin
            repeat (37 + i * 53) @(posedge clk);
            command(8'hF0 + i[3:0], i[0]);
        end
        repeat (3000) @(posedge clk);
        check("speed changes while running", -1);

        // Stop, no further counting
        command(8'h00, 1'b0);
        clear_counts;
        repeat (5000) @(posedge clk);
        check("stopped", 0);

        // Reset while running stops the pin
        command(8'hFF, 1'b0);
        repeat (1000) @(posedge clk);
        reset = 1;
        clear_counts;
        repeat (2000) @(posedge clk);
        check("reset while running", 0);

        if (errors == 0)
            $display("PASS tb_SM_Output");
        else
            $display("FAILED tb_SM_Output with %0d errors", errors);
        $finish;
    end

endmodule
