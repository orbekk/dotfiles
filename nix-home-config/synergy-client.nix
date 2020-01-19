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
    synergyc = {
      Unit = {
        Description = "Synergy Client";
        After = ["network.target" "graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.synergy}/bin/synergyc -f localhost:24800";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
