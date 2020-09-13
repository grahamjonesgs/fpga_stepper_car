#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>
#include "pigpiod_if2.h"

#define MESSAGE_TRIES 10

#define START_MSG_CODE 0x10
#define CRC_ERROR_CODE 0x02
#define TIMEOUT_CODE 0x03
#define ACK_OK 0x01

#define MSG_TYPE_MOTOR 0x01
#define MSG_TYPE_ENABLE 0x02
#define MSG_TYPE_LED 0x03
#define MSG_TYPE_STATUS 0x04;

#define LEFT_BACKWARDS 0x01
#define RIGHT_BACKWARDS 0x02
#define LEFT_FRONT_BACKWARDS 0x01
#define RIGHT_FRONT_BACKWARDS 0x02
#define LEFT_BACK_BACKWARDS 0x04
#define RIGHT_BACK_BACKWARDS 0x08
#define COUNT_STEPS 0x10
#define COUNT_RIGHT 0x20

#define POWER_PIN 24

#define M0_PIN 14
#define M1_PIN 15
#define M2_PIN 18

/*
8 byte car comtrol message
    Byte 0: Message type, 
        0x01 - Motor control skid
        0x02 - Enable control
        0x03 - LED control
        0x04 - Status Request
        0x05 - Motor control independent
        
 Motor Control skid
   Byte 1 - directions (bytes 8-15)
        bit 0 - left dir
        bit 1 - right dir
        bit 4 - mode, 0 for ever, 1 count
        bit 5 - 0 count left, 1 count right
   Byte 2 - Left speed (bytes 16-23)
   Btye 3 - Right speed (bytes 24-31)
   Byte 4/5/6 - Max number of step  (bytes 32-55)
   
 Motor Control ind
   Byte 1 - directions (bytes 8-15)
        bit 0 - left front dir
        bit 1 - right front dir
        bit 2 - left beck dir
        bit 3 - right back dir
        
   Byte 2 - Left front speed (bytes 16-23)
   Btye 3 - Right front speed (bytes 24-31)
   Byte 4 - Left back speed (byte 32-39)
   Byte 5 - Right back speed (byte 40-47)
   
 Enable Control
   Byte 1, bit 0 - enable
   
 LED control
   Byte 0 Red
   Byte 1 Blue
   Byte 2 Green
   
   Modes LSN
   X0 Off
   X1 On
   X2 Flash
   X3 Pulse
   Speed MSN // only for flash and pulse
   0x0X Pulse Slow
   0x1X Pulse Medium
   0x2X Pulse Fast

   
   
   
 */ 


int spi_handle;

int pi;
int power=1;
int M0=0;
int M1=0;
int M2=1;  // init to 1/16 steps
int enable=1; 
int direction=0;
int speed = 10;


int message_send(char* msg_buf)
{
        char full_msg[255];
        int counter;
        char ret_code;

        full_msg[0]=START_MSG_CODE; // Start msg char
        for (int i=0; i<8; i++) {
                full_msg[i+1]=msg_buf[i];
        }

        counter=0;
        for (int i=1; i<=8; i++)
        {
                counter=counter+full_msg[i];
        }

        full_msg[9]=counter%256; // set CRC value

        for (int i=0; i<MESSAGE_TRIES; i++)
        {
                spi_write(pi, spi_handle, full_msg, 10);
                spi_read(pi, spi_handle, &ret_code,1);
                switch (ret_code) {
                case ACK_OK:
                        printf("Message sent OK\n");
                        return(0);
                        break;
                case CRC_ERROR_CODE:
                        printf("Message CRC error\n");
                        break;
                case TIMEOUT_CODE:
                        printf("Message timeout error\n");
                        break;
                case 0:
                        printf("Message NULL return\n");
                        break;
                default:
                        printf("Message unknown code return\n");

                }
        }
        return(1);
}

int enable_motor(int flag) {
        char msg[255];

        msg[0]=MSG_TYPE_ENABLE;
        msg[1]=flag;
        return(message_send(msg));
}

int read_version_message(void) {
        char r_msg[255];
        char msg;

        msg=0x21; // Request message flag
        spi_write(pi, spi_handle, &msg, 1); // Request
        spi_read(pi,spi_handle,r_msg,8);

        printf("Version message %02X %02X %02X %02X %02X %02X %02X %02X\n",r_msg[7],r_msg[6],r_msg[5],r_msg[4],r_msg[3],r_msg[2],r_msg[1],r_msg[0]);
        printf("Version is %i.%i%i\n",r_msg[2]&0x08,r_msg[1],r_msg[0]);

}

int read_motor_message(void) {
        char r_msg[255];
        char msg;

        msg=0x22; // Request message flag
        spi_write(pi, spi_handle, &msg, 1); // Request
        spi_read(pi,spi_handle,r_msg,8);

        printf("Motor message %02X %02X %02X %02X %02X %02X %02X %02X\n",r_msg[7],r_msg[6],r_msg[5],r_msg[4],r_msg[3],r_msg[2],r_msg[1],r_msg[0]);

}

int read_null_message(void) {
        char r_msg[255];
        char msg;

        msg=0x20; // Request message flag
        spi_write(pi, spi_handle, &msg, 1); // Request
        spi_read(pi,spi_handle,r_msg,8);

        printf("Null message %02X %02X %02X %02X %02X %02X %02X %02X\n",r_msg[7],r_msg[6],r_msg[5],r_msg[4],r_msg[3],r_msg[2],r_msg[1],r_msg[0]);

}


int set_motor (char left_speed, char right_speed, int left_dir, int right_dir) {
        char msg[255];

        if (left_dir>1) left_dir=1;
        if (right_dir>1) right_dir=1;

        msg[0]=MSG_TYPE_MOTOR;
        msg[1]=left_dir*LEFT_BACKWARDS|right_dir*RIGHT_BACKWARDS;
        msg[2]=left_speed;
        msg[3]=right_speed;
        return(message_send(msg));

}


int send_led (char red, char blue, char green) {
        char msg[255];

        msg[0]=MSG_TYPE_LED;
        msg[1]=red;
        msg[2]=blue;
        msg[3]=green;
        msg[4]=0;
        msg[5]=0;
        msg[6]=0;
        msg[7]=0;
        return(message_send(msg));

}

int set_motor_limit (char left_speed, char right_speed, int left_dir, int right_dir, int steps, int count_right) {
        char msg[255];

        if (left_dir>1) left_dir=1;
        if (right_dir>1) right_dir=1;
        if (count_right>1) count_right=1;

        msg[0]=MSG_TYPE_MOTOR;
        msg[1]=left_dir*LEFT_BACKWARDS|right_dir*RIGHT_BACKWARDS|COUNT_STEPS|count_right*COUNT_RIGHT;
        msg[2]=left_speed;
        msg[3]=right_speed;
        msg[4]=steps%256;
        msg[5]=(steps/256)%256;
        msg[6]=steps/(256*256);
        return(message_send(msg));

}

int main (int argc, char **argv)
{

        char buf[255];
        char c='0';
        
        gpio_write(pi,POWER_PIN,power);
        set_mode(pi,POWER_PIN,  PI_OUTPUT);
        gpio_write(pi,POWER_PIN,power);
        
        set_mode(pi,M0_PIN,  PI_OUTPUT);
        set_mode(pi,M1_PIN,  PI_OUTPUT);
        set_mode(pi,M2_PIN,  PI_OUTPUT);
        gpio_write(pi,POWER_PIN,power); 
        gpio_write(pi,M0_PIN,M0);
        gpio_write(pi,M1_PIN,M1);
        gpio_write(pi,M2_PIN,M2);
        

        pi=pigpio_start(NULL,NULL);
        if (pi<0) {
                printf("gpio init failed\n");
                return 1;
        }
        else {
                printf("gpio init ok\n");

        }
        
        spi_handle=spi_open(pi, 0, 1e7, 0);
        read_version_message();


        enable_motor(enable);
        
        
         do {
                system ("/bin/stty raw");
                c = getchar();
                system ("/bin/stty cooked");
                switch (c) {
                case 'f':
                        speed++;
                        if(speed>255) speed=255;
                        printf("Speed now %i steps M%i%i%i\n",speed, M0,M1,M2);
                        break;
                case 's':
                        speed--;
                        if(speed<0) speed=0;
                        printf("Speed now %i steps M%i%i%i\n",speed, M0,M1,M2);
                        break;
                case 'p':
                        power=!power;
                        if (power)
                        {
                        	printf("Power off\n");
                        }
                        else
                        {
                        	printf("Power on\n");
                        }
                        gpio_write(pi,POWER_PIN,power);
                        break;
                case 'e':
                        enable=!enable;
                        if (enable) 
                        {
                        	printf("Motors disabled\n");  
                        }
                        else 
                        {
                        	printf("Motors enabled\n");  
                        }  
                        enable_motor(enable);
                        break;
                case 'd':
                        direction=!direction;
                        printf("Direction now %i\n",direction);
                        break;
                case 'x':
                        printf("Start now\n");
                        break;
                case '0':
                        M0=!M0;
                        printf("M0 now %i\n",M0);  
                        printf("Speed now %i steps M%i%i%i\n",speed, M0,M1,M2);   
                        gpio_write(pi,M0_PIN,M0);
                        break;
                case '1':
                        M1=!M1;
                        printf("M1 now %i\n",M1); 
                        printf("Speed now %i steps M%i%i%i\n",speed, M0,M1,M2);   
                        gpio_write(pi,M1_PIN,M1);
                        break;
                case '2':
                        M2=!M2;
                        printf("M2 now %i\n",M2);   
                        printf("Speed now %i steps M%i%i%i\n",speed, M0,M1,M2); 
                        gpio_write(pi,M2_PIN,M2);
                        break;
                case 'v':
                        read_version_message();
                        break;
                case 'l':
                		printf("LED flash");
                        send_led(0x02,0x12,0x22);;
                        break;
                case 'u':
                		printf("LED pulse");
                        send_led(0x03,0x13,0x23);;
                        break;
                case 'o':
                		printf("LED on");
                        send_led(0x01,0x01,0x01);;
                        break;
				
                }
                set_motor (speed,speed,direction,direction);
                
        } while (c!='q');
        system ("/bin/stty cooked");
        set_motor (0,0,0,0);
        gpio_write(pi,POWER_PIN,1);  // power off
        enable_motor(1);  // diable motors


        //set_motor (0x0,0x0,0,1);
        //set_motor_limit (10,10,1,1, 10*200, 0);
        //set_motor (10,10,1,1);
        
        //sleep(5);
        //set_motor (0x0,0x0,0,1);
        
        //enable_motor(1);


 

        //send_led(0x03,0x13,0x23);
        

        spi_close(pi,spi_handle);








}
