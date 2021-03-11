{-# LANGUAGE FlexibleContexts, PatternGuards #-}

import System.Posix.Unistd (nodeName, getSystemID)
import System.Posix.Env (setEnv)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Kde
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.InsertPosition
import XMonad.Util.Run (spawnPipe)
import XMonad.Layout
import XMonad.Layout.OnHost
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutScreens
import XMonad.Layout.LayoutModifier
import XMonad.Layout.TwoPane
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import System.Exit
import XMonad.Hooks.EwmhDesktops
import Control.Applicative ((<$>), pure)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import Data.List.Split
import Control.Monad

cViolet = "#68217A"
cDark = "#252526"
cBlue = "#237AD3"
  
myDzenPP = def { ppCurrent  = dzenColor "white" cBlue . pad
               , ppVisible  = dzenColor "white" cViolet . pad
               , ppHidden   = dzenColor "white" cDark . pad
               , ppHiddenNoWindows = const ""
               , ppUrgent   = dzenColor "red" "yellow" . pad
               , ppWsSep    = ""
               , ppSep      = ""
               , ppLayout   = dzenColor cBlue cDark .
                               (\ x -> pad $ case x of
                                       "TilePrime Horizontal" -> "TTT"
                                       "TilePrime Vertical"   -> "[]="
                                       "Hinted Full"          -> "[ ]"
                                       _                      -> x
                               )
               , ppTitle    = (("^p(10)^bg(" ++ cDark ++ ") ") ++) . dzenEscape
               } 

dzenCommand = "dzen2 -dock -x 0 -y 0 -h 24 -expand right -fn \"WenQuanYi Micro Hei-16\" -ta l -bg '" ++ cDark ++ "' -fg '#f4f4f4'"

bar :: LayoutClass l Window => XConfig l -> IO (XConfig (ModifiedLayout AvoidStruts l))
bar = statusBar dzenCommand myDzenPP toggleStrutsKey
  where toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b)

main = do
  host <- (head . splitOn "." . nodeName) <$> getSystemID
  setEnv "HOST" host True
  config <- bar (myConfig host)
  xmonad config

layoutScreensHost = "unused" -- orange

myConfig host =
  (docks . ewmh) $ kdeConfig
    { layoutHook = smartBorders $ myLayout
    , keys = myKeys
    , modMask = mod4Mask
    , terminal = "urxvt"
    , borderWidth = 2
    , focusedBorderColor = cBlue
    , normalBorderColor = cDark
    , workspaces = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十" ]
    , manageHook = manageHook kdeConfig <+> insertPosition Below Newer <+> (isDialog --> doF W.shiftMaster <+> doF W.swapDown)
    }
  where myLayout = onHost layoutScreensHost (verticalTiled ||| horizontalTiled ||| Full) $
                   layoutHook desktopConfig
        verticalTiled = Mirror (Tall 1 (5/100) (2/3))
        horizontalTiled = Tall 0 (5/100) (2/3)

muteCommand = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
increaseVolumeCommand = "sh -c \"pactl set-sink-mute 0 false ; pactl set-sink-volume @DEFAULT_SINK@ +5%\""
decreaseVolumeCommand = "sh -c \"pactl set-sink-mute 0 false ; pactl set-sink-volume @DEFAULT_SINK@ -5%\""

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_d     ), spawn "rofi -show run")
    , ((modm,               xK_s     ), spawn "rofipass --type")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    -- , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Next monitor
    , ((modm              , xK_Tab ), nextScreen)
    , ((modm .|. shiftMask, xK_Tab ), swapNextScreen)

    -- Increment the number of windows in the master area
    -- , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_semicolon ), sendMessage (IncMasterN 1))
    , ((modm              , xK_q ), sendMessage (IncMasterN (-1)))

    , ((modm              , xK_w ), spawn muteCommand)
    , ((modm              , xK_v ), spawn decreaseVolumeCommand)
    , ((modm              , xK_z ), spawn increaseVolumeCommand)

    -- , ((modm              , xK_s ), (layoutScreens 2 (TwoPane 0.5 0.5)))
    -- , ((modm .|. shiftMask, xK_s ), rescreen)

    -- This is redundant because it's added by the statusBar function.
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    -- , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    -- , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Lock screen
    , ((modm .|. shiftMask, xK_z), spawn "mate-screensaver-command --lock")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    -- [((m .|. modm, k), windows $ f i)
    --     | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    --     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [
                      xK_apostrophe
                    , xK_comma
                    , xK_period
                    , xK_p
                    , xK_y
                    , xK_a
                    , xK_o
                    , xK_e
                    , xK_u
                    , xK_i]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    -- ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_semicolon, xK_q, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
