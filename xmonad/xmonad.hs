import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.NoBorders
import System.IO

main = do
  xmproc <- spawnPipe "/usr/bin/env xmobar /home/orbekk/.xmonad/xmobar.hs"
  xmonad $ defaultConfig
      { manageHook = manageDocks <+> manageHook defaultConfig
      , layoutHook = smartBorders . avoidStruts $  layoutHook defaultConfig
      , logHook = dynamicLogWithPP xmobarPP
                      { ppOutput = hPutStrLn xmproc
                      , ppTitle = xmobarColor "green" "" . shorten 50
                      }
      , modMask = mod4Mask
      , terminal = "termite"
      , borderWidth = 2
      } `additionalKeys`
      [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
      , ((mod4Mask, xK_b), sendMessage ToggleStruts)
      ]
