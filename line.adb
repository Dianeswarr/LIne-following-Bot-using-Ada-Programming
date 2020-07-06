with System;
with NXT.AVR;		  use NXT.AVR;
with Nxt.Display;         use Nxt.Display;
with NXT.Motor_Encoders;
with NXT.Battery; 
package body line is
protected type Mutex is           --- creating Mutex (protected type object)
   entry Seize;
   procedure Release;
private
    pragma Priority (System.Priority'First + 7);  -- giving mutex the highest priority
   owned : Boolean := True;
end Mutex;

protected body Mutex is
   entry Seize when owned is
   begin
      owned := False;
   end Seize;
   procedure Release is
   begin
      owned := True;
   end Release;
end Mutex;

 type Driving_Command is record       --- creating record

    speed_left:  Power_Percentage;
    speed_right:   Power_Percentage;
    Update_Priority:  Integer;    ---Update_Priority is not the actual priority its actually the integer.
end record;
 Drive_Command: Driving_Command;

   -----------------------
   --  Background task  --
   -----------------------

   -------------
   --  Tasks  --
   -------------
s: Mutex;




   task light_task is
pragma Priority (System.Priority'First + 2);
pragma Storage_Size (1365);
   end light_task;


   task body light_task is
    black:integer;
    white: integer;
    
     offset1:integer;
     
     Lightval: integer;
      
   begin
      
 put_noupdate("Black");
Screen_Update;
Await_Button_Press;
black:= LS.Light_Value; -- reading black value
put_noupdate(black);
newline;
put_noupdate(black);
newline;
put_noupdate("White");
Screen_Update;
Await_Button_Press;
white:= LS.Light_Value; -- reading white value
put_noupdate(white);
newline;
put_noupdate("press button");  -- if pressed the whole process starts
Await_Button_Press;
newline;

    offset1:= integer(black+white)/2;  -- calculating offset
   

      loop
       Next_Time:=Next_Time+Period_Light;       
       delay until Next_Time;

     Lightval:= LS.Light_Value;
       
     
  if Lightval>0 and Lightval<100 then  --  the value of black is between 17 to 30  and value of white is from 40 to 55 (approx)  so  i set the max range of light value from 1 to 99.
        s.Seize;  -- mutex is seized by light task
     Drive_Command.Update_Priority:=2; -- writes int the record 
     Drive_Command.speed_left:= 25 + (Power_Percentage(Lightval)-Power_Percentage(offset1));  --  25 is the speed of the motor if it goes straight, adding error value to the speed (error= Lightvalue - offset) 
     Drive_Command.speed_right:= 25 - (Power_Percentage(Lightval)-Power_Percentage(offset1)); --  25 is the speed of the motor if it goes straight, substracting error value to the speed (error= Lightvalue - offset) 
    
      
       s.Release; --mutex is released by light task after reading into record.
 --Start_Time2 := Start_Time2 + Milliseconds(100);
   end if;
   --end if;
      end loop;
   end light_task;

task Motorcontrol is
pragma Priority (System.Priority'First + 3);
pragma Storage_Size (1365);
   end Motorcontrol;
 

   task body Motorcontrol is
  
   begin

      loop
      
              Next_Time:=Next_Time+Period_Movement;
        delay until Next_Time;
             
       if  Drive_Command.Update_Priority = 2   then    --- reading  from the record 
                   
                    
                   Control_Motor (Right_Motor_Id, Drive_Command.speed_left,Forward);
                    Control_Motor (Left_Motor_Id, Drive_Command.speed_right, Forward);
                     
                
    elsif Drive_Command.Update_Priority = 4 then     --reading from the record 
                           
                      Control_Motor (Right_Motor_Id, Drive_Command.speed_left,Brake);
                   Control_Motor (Left_Motor_Id,Drive_Command.speed_right,Brake);
             
       end if;
     
end loop;
   end Motorcontrol;

task Distancetask is
pragma Priority (System.Priority'First + 5);     --giving distance sensor task the highest priority amoung all the tasks ( protected type(mutex) is not a task)
pragma Storage_Size (1365);
   end Distancetask;

task body Distancetask is
distance: Natural:=0;
begin
loop
 Next_Time:=Next_Time+Period_Distance;
delay until Next_Time;

Get_Distance(DS,distance);
if distance <=40 then             -- if distance is less than 40 or equal to 40 then stop 
                        s.Seize;
                     Drive_Command.Update_Priority:= 4;    writing into record and it is read in motor control task
               Drive_Command.speed_left:= 0; 
     Drive_Command.speed_right:= 0;
                       
              s.Release;

end if;
end loop;
end Distancetask;


procedure Background is
 
 begin
 


      loop
         null;
      end loop;
   end Background;


end line;
