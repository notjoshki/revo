with Ada.Text_IO;
with Revo;

procedure Example is
   Background_Pair : constant Natural := 1;
   Shadow_Pair : constant Natural := 2;
   Display_Pair : constant Natural := 3;
   Display_Title_Pair : constant Natural := 4;

   Height_Margin : constant Natural := 2;
   Width_Margin : constant Natural := 4;
   Shadow_Height_Thickness : constant Natural := 1;
   Shadow_Width_Thickness : constant Natural := 1;
   Display_Border_Thickness : constant Natural := 1;

   Minimum_Height : constant Natural := 10;
   Minimum_Width : constant Natural := 50;

   Use_Dark_Theme : Boolean := True;
begin
   Revo.Initialize_Screen;

   declare
      Height : constant Natural := Revo.Max_Height;
      Width : constant Natural := Revo.Max_Width;
      Thrown : Boolean := False;
   begin
      if Revo.Max_Height < Minimum_Height then
         Ada.Text_IO.Put_Line ("Console height too small; minimum height is" & Minimum_Height'Img & " but this is" & Height'Img);
         Thrown := True;
      end if;

      if Revo.Max_Width < Minimum_Width then
         Ada.Text_IO.Put_Line ("Console width too small; minimum width is" & Minimum_Width'Img & " but this is" & Width'Img);
         Thrown := True;
      end if;

      if Thrown then
         Revo.End_Window;
         return;
      end if;
   end;

   Revo.No_Echo;
   Revo.C_Break;
   Revo.Cursor_Set (Revo.Invisible);
   Revo.Start_Color;
   Revo.Use_Default_Colors;

   if Use_Dark_Theme then
      Revo.Initialize_Color_Pair (Background_Pair, Revo.White, Revo.Black);
      Revo.Initialize_Color_Pair (Shadow_Pair, Revo.White, Revo.Magenta);
      Revo.Initialize_Color_Pair (Display_Pair, Revo.Magenta, Revo.Black);
      Revo.Initialize_Color_Pair (Display_Title_Pair, Revo.Blue, Revo.Black);
   else
      Revo.Initialize_Color_Pair (Background_Pair, Revo.White, Revo.Blue);
      Revo.Initialize_Color_Pair (Shadow_Pair, Revo.White, Revo.Black);
      Revo.Initialize_Color_Pair (Display_Pair, Revo.Black, Revo.White);
      Revo.Initialize_Color_Pair (Display_Title_Pair, Revo.Red, Revo.White);
   end if;

   declare
      Background : aliased Revo.Window := Revo.New_Window;
      Shadow : aliased Revo.Window := Revo.New_Window (Background.Height - (Height_Margin * 2), Background.Width - (Width_Margin * 2),
         Height_Margin + Shadow_Height_Thickness, Width_Margin + Shadow_Width_Thickness);

      Display : aliased Revo.Window := Revo.New_Window (Background.Height - (Height_Margin * 2), Background.Width - (Width_Margin * 2), Height_Margin, Width_Margin);

      procedure Display_Print (Row : Natural; Column : Natural; Message : String) is
      begin
         Revo.Move_Print (Row + Display_Border_Thickness, Column + Display_Border_Thickness, Message, Display'Access);
      end Display_Print;
   begin
      Revo.Color_Pair_On (Background_Pair, Background'Access);
      Revo.Color_Pair_On (Shadow_Pair, Shadow'Access);
      Revo.Color_Pair_On (Display_Pair, Display'Access);

      Revo.Background (Background_Pair, Background'Access);
      Revo.Background (Shadow_Pair, Shadow'Access);
      Revo.Background (Display_Pair, Display'Access);

      Revo.Box (Display'Access);
      Revo.Move_Print (0, Display.Width / 2 - 6, "|         |", Display'Access);

      Revo.Color_Pair_On (Display_Title_Pair, Display'Access);
      Revo.Move_Print (0, Display.Width / 2 - 4, "Example", Display'Access);
      Revo.Color_Pair_Off (Display_Title_Pair, Display'Access);

      Revo.Move_Print (0, 0, "Some text up here", Background'Access);
      Display_Print (0, 0, "Some text in here");

      Revo.Refresh (Background'Access);
      Revo.Refresh (Shadow'Access);
      Revo.Refresh (Display'Access);
      Revo.Get_Key_And_Discard (Background'Access);
   end;

   Revo.End_Window;
end Example;
