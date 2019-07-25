{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  systemd.user.startServices = true;

  systemd.user.services = {
    weechat = {
      Unit = {
        Description = "Weechat";
        After = [ "networking.target" ];
      };

      Service = {
        Environment = ["TERM=${pkgs.rxvt_unicode.terminfo}" "TMUX_TMPDIR=/run/user/1000"];
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "" + pkgs.writeScript "weechat-start" ''
          #!${pkgs.stdenv.shell}
          ${pkgs.tmux}/bin/tmux -2 new-session -d -s irc "${pkgs.weechat}/bin/weechat"
        '';
        ExecStop = "" + pkgs.writeScript "weechat-stop" ''
          #!${pkgs.stdenv.shell}
          pkill -SIGTERM -xf "${pkgs.weechat}/bin/weechat"
          for i in {1..10}; do
            echo "Waiting for weechat to stop... $i"
            pgrep -xlf "${pkgs.weechat}/bin/weechat" || break
            sleep 1
          done
          tmux kill-session -t irc || true
        '';
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
