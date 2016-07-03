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
                              ["-t", "NYC: <skyCondition> <tempC>°C <rh>%"
                              , "-L", "15", "-H", "25", "--normal", "green"
                              , "--high", "red", "--low", "lightblue"] 36000
                    , Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Date "%a %b %_d %l:%M" "date" 10
                    , Run DiskU [("/", "/: <used>/<size>")]
                          ["-L", "20", "-H", "50", "-m", "1", "-p", "3"] 20
                    , Run StdinReader
                    , Run DynNetwork     [
                           "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
                          , "--Low"      , "1000"       -- units: kB/s
                          , "--High"     , "5000"       -- units: kB/s
                          , "--low"      , "green"
                          , "--normal"   , "orange"
                          , "--high"     , "red"
                          ] 10
                    , Run BatteryP ["BAT0"] [
                           "--template" , "Batt: <acstatus>"
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
       , template = "%StdinReader% }{ %battery% | %dynnetwork% | %disku% | %cpu% | %memory% * %swap%    <fc=#ee9a00>%date%</fc> | %KNYC%"
       }

-- Config {
-- 
--    -- appearance
--      font =         "xft:Source Code Pro:size=9:bold:antialias=true"
--    , bgColor =      "black"
--    , fgColor =      "#646464"
--    , position =     Top
--    , border =       BottomB
--    , borderColor =  "#646464"
-- 
--    -- layout
--    , sepChar =  "%"   -- delineator between plugin names and straight text
--    , alignSep = "}{"  -- separator between left-right alignment
--    , template = "%StdinReader% | %battery% | %multicpu% | %coretemp% | %memory% | %dynnetwork% }{ %RJTT% | %date% || %kbd% "
-- 
--    -- general behavior
--    , lowerOnStart =     True    -- send to bottom of window stack on start
--    , hideOnStart =      False   -- start with window unmapped (hidden)
--    , allDesktops =      True    -- show on all desktops
--    , overrideRedirect = False   -- set the Override Redirect flag (Xlib)
--    , pickBroadest =     False   -- choose widest display (multi-monitor)
--    , persistent =       True    -- enable/disable hiding (True = disabled)
-- 
--    -- plugins
--    --   Numbers can be automatically colored according to their value. xmobar
--    --   decides color based on a three-tier/two-cutoff system, controlled by
--    --   command options:
--    --     --Low sets the low cutoff
--    --     --High sets the high cutoff
--    --
--    --     --low sets the color below --Low cutoff
--    --     --normal sets the color between --Low and --High cutoffs
--    --     --High sets the color above --High cutoff
--    --
--    --   The --template option controls how the plugin is displayed. Text
--    --   color can be set by enclosing in <fc></fc> tags. For more details
--    --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
--    , commands = 
--         -- weather monitor
--         [ Run Weather "RJTT" [ "--template", "<skyCondition> | <fc=#4682B4><tempC></fc>°C | <fc=#4682B4><rh></fc>% | <fc=#4682B4><pressure></fc>hPa"
--                              ] 36000
-- 
--         -- network activity monitor (dynamic interface resolution)
--         , Run DynNetwork     [ "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
--                              , "--Low"      , "1000"       -- units: kB/s
--                              , "--High"     , "5000"       -- units: kB/s
--                              , "--low"      , "darkgreen"
--                              , "--normal"   , "darkorange"
--                              , "--high"     , "darkred"
--                              ] 10
-- 
--         -- cpu activity monitor
--         , Run MultiCpu       [ "--template" , "Cpu: <total0>%|<total1>%"
--                              , "--Low"      , "50"         -- units: %
--                              , "--High"     , "85"         -- units: %
--                              , "--low"      , "darkgreen"
--                              , "--normal"   , "darkorange"
--                              , "--high"     , "darkred"
--                              ] 10
-- 
--         -- cpu core temperature monitor
--         , Run CoreTemp       [ "--template" , "Temp: <core0>°C|<core1>°C"
--                              , "--Low"      , "70"        -- units: °C
--                              , "--High"     , "80"        -- units: °C
--                              , "--low"      , "darkgreen"
--                              , "--normal"   , "darkorange"
--                              , "--high"     , "darkred"
--                              ] 50
--                           
--         -- memory usage monitor
--         , Run Memory         [ "--template" ,"Mem: <usedratio>%"
--                              , "--Low"      , "20"        -- units: %
--                              , "--High"     , "90"        -- units: %
--                              , "--low"      , "darkgreen"
--                              , "--normal"   , "darkorange"
--                              , "--high"     , "darkred"
--                              ] 10
-- 
--         -- battery monitor
--         , Run Battery        [ "--template" , "Batt: <acstatus>"
--                              , "--Low"      , "10"        -- units: %
--                              , "--High"     , "80"        -- units: %
--                              , "--low"      , "darkred"
--                              , "--normal"   , "darkorange"
--                              , "--high"     , "darkgreen"
-- 
--                              , "--" -- battery specific options
--                                        -- discharging status
--                                        , "-o"	, "<left>% (<timeleft>)"
--                                        -- AC "on" status
--                                        , "-O"	, "<fc=#dAA520>Charging</fc>"
--                                        -- charged status
--                                        , "-i"	, "<fc=#006000>Charged</fc>"
--                              ] 50
-- 
--         -- time and date indicator 
--         --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
--         , Run Date           "<fc=#ABABAB>%F (%a) %T</fc>" "date" 10
-- 
--         -- keyboard layout indicator
--         , Run Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
--                              , ("us"         , "<fc=#8B0000>US</fc>")
--                              ]
--         ]
--     }
