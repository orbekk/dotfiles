Config { font = "xft:Source Code Pro:size=8:bold:antialias=true" -- "-*-Fixed-Bold-R-Normal-*-13-*-*-*-*-*-*-*"
       , lowerOnStart = True
       , overrideRedirect = True
       , persistent = False
       , bgColor = "black"
       , fgColor = "grey"
       , position = TopP 0 100 -- TopW L 95
       , commands = [
           --  Run Weather "EGPF" ["-t","<skyCondition> <tempC>°C","-L","64","-H","77","--normal","green","--high","red","--low","lightblue"] 36000
           Run Weather "KNYC"
                     ["-t", "<fc=lightblue>NYC</fc> <tempC>°C <skyCondition> <rh>%"
                     , "-L", "15", "-H", "25", "--normal", "green"
                     , "--high", "red", "--low", "lightblue"] 36000
 	 , Run MPD ["-t",
          "<artist> - <title> <track>/<plength> <statei> [<flags>]",
          "--", "-P", ">>", "-Z", "|", "-S", "><"] 30
         , Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
         , Run Volume "default" "Master" [
                "-t", "♪ <volume> <status>"] 10
         , Run Brightness ["-t", "☼<percent>%"] 10
         -- , Run Memory ["-t","Mem: <usedratio>%"] 600
         -- , Run Swap [] 10
         , Run Date "%a %b %_d <fc=darkorange>%H:%M:%S</fc>" "date" 10
         , Run DiskU [("/", "<fc=#eeeeee>/</fc> <used>/<size>")]
               ["-L", "20", "-H", "50", "-m", "1", "-p", "3"] 1000
         , Run StdinReader
         -- , Run DynNetwork     [
         --        "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
         --       , "--Low"      , "1000"       -- units: kB/s
         --       , "--High"     , "5000"       -- units: kB/s
         --       , "--low"      , "green"
         --       , "--normal"   , "orange"
         --       , "--high"     , "red"
         --       ] 100
         , Run BatteryP ["BAT0"] [
                "--template" , "⚡ <acstatus>"
               , "--Low"      , "10"        -- units: %
               , "--High"     , "80"        -- units: %
               , "--low"      , "darkred"
               , "--normal"   , "darkorange"
               , "--high"     , "darkgreen"
               , "--" -- battery specific options
                      -- discharging status
               , "-o"	, "<left>% (<timeleft>)"
               -- AC "on" status
               , "-O"	, "<fc=#ee9a00>Charging</fc>"
               -- charged status
               , "-i"	, "<fc=#00ff00>Charged</fc>"
               ] 50
         ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ %mpd%   %default:Master%   %bright%   %battery%   %disku% %date%   %KNYC%"
       }
