with Ada.Real_Time;       use Ada.Real_Time;
with NXT;                 use NXT;
with NXT.Touch_Sensors;   use NXT.Touch_Sensors;
with NXT.Motor_Controls;  use NXT.Motor_Controls;
with NXT.Light_Sensors;   use NXT.Light_Sensors;
with NXT.Light_Sensors.Ctors;   use NXT.Light_Sensors.Ctors;
With NXT.Ultrasonic_Sensors;    use  NXT.Ultrasonic_Sensors;
With NXT.Ultrasonic_Sensors.Ctors;   use NXT.Ultrasonic_Sensors.Ctors;
with NXT.Display;       use NXT.Display;
With test_utils;          use test_utils;
package line is

   procedure Background;

   private

   ------------------------------------
   --  Definition periods and times  --
   ------------------------------------
   Period_Movement : constant Time_Span := Milliseconds (50);
   Period_Distance : constant Time_Span := Milliseconds (80);
   
   Period_Light :  constant Time_Span := Milliseconds (30); 
   Display_Time : constant Time_Span := Milliseconds (500);
   Start_Time1: constant Time := Clock;
   Next_Time : Time := Start_Time1;
  --  Start_Time2: constant Time_Span := Clock ;
  

   --------------------------------
   --  Definition of used ports  --
   --------------------------------
   Touch_1 : Touch_Sensor (Sensor_1);
    LS : Light_Sensor := make(Sensor_3, True);
    DS: Ultrasonic_Sensor:= make(Sensor_2);
   --Joystick_Motor_Id : constant Motor_Id := Motor_C;
   Right_Motor_Id : constant Motor_Id := Motor_A;
   Left_Motor_Id : constant Motor_Id := Motor_B;

   ----------------------------------
   --  Definition of motors speed  --
   ----------------------------------
 
   Speed_Stop : constant Power_Percentage := 0;

end line;
