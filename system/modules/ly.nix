{ ... }:

{
  services.displayManager.ly = {
    enable = true;
    x11Support = false;

    settings = {
      animation = "dur_file";
      dur_file_path = "/home/astosolo/nixos-dotfiles/assets/ly/bamboo.dur";
      full_color = true;
      fg = "0x00FFFFFF";
      border_fg = "0x0000FFFF";
      error_fg = "0x01FF0000";

      clock = "%H:%M  %d.%m.%Y";
      bigclock = "en";

      default_input = "password";
      hide_borders = false;
      numlock = true;

      shell = false;
      xinitrc = "null";

      hide_key_hints = false;       # F1 shutdown / F2 reboot
      brightness_up_key = "null";   # F6 
      brightness_down_key = "null"; # F5
      show_password_key = "null";   # F7
      hide_keyboard_locks = true;   # Num/Caps Lock
    };
  };

  # tty palette: replaces the 16 console colors, needed only for eye candy bamboo-tty.dur.
  #console.colors = [
  #  "000000" "93000a" "005143" "334b45" "194d54" "2e8b79" "096b5a" "bfc9c4"
  #  "252b29" "ffb4ab" "85d6c1" "cde8df" "aacbe3" "b1ccc3" "a1f2dc" "dee4e0"
  #];

}
