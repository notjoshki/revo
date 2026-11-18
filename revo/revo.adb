-- Revo - Tiny ncurses wrapper for Ada.
-- Copyright (c) 2026 notjoshki

package body Revo is
   function Get_Key (Win : access constant Window := null) return Integer is
      function c_getch (win : access constant Window) return IC.int with Import => True, Convention => C;

      Key : IC.int := c_getch (Win);
   begin
      return Integer (Key);
   end Get_Key;

   procedure Get_Key_And_Discard (Win : access constant Window := null) is
      Key : constant Integer := Get_Key (Win);
   begin
      null;
   end Get_Key_And_Discard;

   procedure Refresh (Win : access constant Window := null) is
      procedure c_refresh (win : access constant Window) with Import => True, Convention => C;
   begin
      c_refresh (Win);
   end Refresh;

   procedure Move (Row : Natural; Column : Natural; Win : access constant Window := null) is
      procedure c_move (y : IC.int; x : IC.int; win : access constant Window) with Import => True, Convention => C;
   begin
      c_move (IC.int (Row), IC.int (Column), Win);
   end Move;

   procedure Move_Print (Row : Natural; Column : Natural; Message : String; Win : access constant Window := null) is
      procedure c_mvprintw (win : access constant Window; y : IC.int; x : IC.int; message : ICS.chars_ptr) with Import => True, Convention => C;
   begin
      c_mvprintw (Win, IC.int (Row), IC.int (Column), ICS.New_String (Message));
   end Move_Print;

   procedure Add_Character (Char : Character; Win : access constant Window := null) is
      procedure c_waddch (win : access constant Window; ch : IC.char) with Import => True, Convention => C;
   begin
      c_waddch (Win, IC.char (Char));
   end Add_Character;

   procedure Add_String (Str : String; Win : access constant Window := null) is
      procedure c_waddstr (win : access constant Window; str : ICS.chars_ptr) with Import => True, Convention => C;
   begin
      c_waddstr (Win, ICS.New_String (Str));
   end Add_String;

   function Has_Colors return Boolean is
      function c_has_colors return IC.C_bool with Import => True, Convention => C, External_Name => "has_colors";

      Has : constant IC.C_bool := c_has_colors;
   begin
      return Boolean (Has);
   end Has_Colors;

   procedure Keypad (Enabled : Boolean; Win : access constant Window := null) is
      procedure c_keypad (win : access constant Window; enabled : IC.C_bool) with Import => True, Convention => C;
   begin
      c_keypad (Win, IC.C_bool (Enabled));
   end Keypad;

   procedure Initialize_Color_Pair (Pair : Natural;  Foreground : Color; Background : Color) is
      procedure c_initialize_color_pair (pair : IC.short; f : Color; b : Color) with Import => True, Convention => C;
   begin
      c_initialize_color_pair (IC.short (Pair), Foreground, Background);
   end Initialize_Color_Pair;

   procedure Color_Pair_On (Pair : Natural; Win : access constant Window := null) is
      procedure c_color_pair_on (win : access constant Window; pair : IC.short) with Import => True, Convention => C;
   begin
      c_color_pair_on (Win, IC.short (Pair));
   end Color_Pair_On;

   procedure Color_Pair_Off (Pair : Natural; Win : access constant Window := null) is
      procedure c_color_pair_off (win : access constant Window; pair : IC.short) with Import => True, Convention => C;
   begin
      c_color_pair_off (Win, IC.short (Pair));
   end Color_Pair_Off;

   function Max_Height return Natural is
      function c_getmaxy return IC.int with Import => True, Convention => C;
   begin
      return Natural (c_getmaxy);
   end Max_Height;

   function Max_Width return Natural is
      function c_getmaxx return IC.int with Import => True, Convention => C;
   begin
      return Natural (c_getmaxx);
   end Max_Width;

   function New_Window (Height : Natural := Max_Height; Width : Natural := Max_Width; Row : Natural := 0; Column : Natural := 0) return Window is
      function c_new_window (maxy: IC.int; maxx: IC.int; starty : IC.int; startx : IC.int) return IC.int
         with Import => True, Convention => C;

      UID : Integer := Integer (c_new_window (IC.int (Height), IC.int (Width), IC.int (Row), IC.int (Column)));
   begin
      return (UID, Height, Width);
   end New_Window;

   procedure Delete_Window (Win : not null access constant Window) is
      procedure c_delete_window (win : access constant Window) with Import => True, Convention => C;
   begin
      c_delete_window (Win);
   end Delete_Window;

   procedure Move_Window (Win : not null access constant Window; Row : Natural; Column : Natural) is
      procedure c_move_window (win : access constant Window; y : IC.int; x : IC.int) with Import => True, Convention => C;
   begin
      c_move_window (Win, IC.int (Row), IC.int (Column));
   end Move_Window;

   procedure Background (Color_Pair : Natural; Win : access constant Window := null) is
      procedure c_background (win : access constant Window; pair : IC.short) with Import => True, Convention => C;
   begin
      c_background (Win, IC.short (Color_Pair));
   end Background;

   procedure Box (Win : access constant Window := null) is
      procedure c_box (win : access constant Window) with Import => True, Convention => C;
   begin
      c_box (Win);
   end Box;
end Revo;