{ config, pkgs, ... }:

let
  configFile = pkgs.writeText "synergy.conf" ''
    section: screens
      pincer:
      aji:
    end

    section: links
      pincer:
        right = aji
      aji:
        left = pincer
    end 
  '';
in
{
  systemd.user.services = {
    synergys = {
      Unit = {
        Description = "Synergy Server";
        After = ["network.target" "graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.synergy}/bin/synergys -f -c ${configFile}";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
