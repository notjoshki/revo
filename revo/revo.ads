-- Revo - Tiny ncurses wrapper for Ada.
-- Copyright (c) 2026 notjoshki

with Interfaces.C;
with Interfaces.C.Strings;

package Revo is
   type Visibility is (Invisible, Visible) with Convention => C;
   type Attribute is (Standout, Dim, Blink, Underline, Bold, Italic, Reversed) with Convention => C;
   type Color is (Black, Red, Green, Yellow, Blue, Magenta, Cyan, White, Default);

   type Window is record
      UID : Natural;
      Height, Width : Integer;
   end record with Convention => C;

   procedure Initialize_Screen with Import => True, Convention => C, External_Name => "initscr";
   procedure End_Window with Import => True, Convention => C, External_Name => "endwin";
   procedure Cursor_Set (Setting : Visibility) with Import => True;
   procedure Echo with Import => True, Convention => C;
   procedure No_Echo with Import => True, Convention => C, External_Name => "noecho";
   procedure Raw with Import => True, Convention => C;
   procedure C_Break with Import => True, Convention => C, External_Name => "cbreak";
   function Get_Key (Win : access constant Window := null) return Integer;
   procedure Get_Key_And_Discard (Win : access constant Window := null);
   procedure Refresh (Win : access constant Window := null);
   procedure Move (Row : Natural; Column : Natural; Win : access Constant Window := null);
   procedure Move_Print (Row : Natural; Column : Natural; Message : String; Win : access constant Window := null);
   procedure Add_Character (Char : Character; Win : access constant Window := null);
   procedure Add_String (Str : String; Win : access constant Window := null);
   procedure Attribute_On (Attr : Attribute; Win : access constant Window := null) with Import => True, Convention => C;
   procedure Attribute_Off (Attr : Attribute; Win : access constant Window := null) with Import => True, Convention => C;
   function Has_Colors return Boolean;
   procedure Use_Default_Colors with Import => True, Convention => C;
   procedure Keypad (Enabled : Boolean; Win : access constant Window := null);
   procedure Start_Color with Import => True, Convention => C;
   procedure Initialize_Color_Pair (Pair : Natural;  Foreground : Color; Background : Color);
   procedure Color_Pair_On (Pair : Natural; Win : access constant Window := null);
   procedure Color_Pair_Off (Pair : Natural; Win : access constant Window := null);
   function Max_Height return Natural;
   function Max_Width return Natural;
   function New_Window (Height : Natural := Max_Height; Width : Natural := Max_Width; Row : Natural := 0; Column : Natural := 0) return Window;
   procedure Delete_Window (Win : not null access constant Window);
   procedure Move_Window (Win : not null access constant Window; Row : Natural; Column : Natural);
   procedure Background (Color_Pair : Natural; Win : access constant Window := null);
   procedure Box (Win : access constant Window := null);
   procedure Clear (Win : access constant Window := null) with Import => True, Convention => C, External_Name => "c_clear";

private
   package IC renames Interfaces.C;
   package ICS renames Interfaces.C.Strings;
end Revo;