import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.ManageDocks
import XMonad.Util.Loggers
import XMonad.Util.Cursor
import XMonad.Util.ClickableWorkspaces
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.SpawnOnce
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Minimize
import XMonad.Actions.Minimize
import XMonad.Hooks.Minimize
import qualified XMonad.StackSet as W
import Text.Printf (printf)
import XMonad.Util.NamedWindows (getName)
import Numeric (showHex)

main:: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withUrgencyHook NoUrgencyHook
     . withEasySB (statusBarProp "xmobar" (clickablePP myXmobarPP)) defToggleStrutsKey
     $ myConfig

myConfig = def
	   { modMask = mod4Mask
	   , terminal = "kitty"
	   , borderWidth = 2
	   , normalBorderColor = "#252525"
	   , focusedBorderColor = "#505050"
	   , layoutHook = myLayout --avoidStruts $ spacingWithEdge 2 $ layoutHook def
	   , startupHook = myStartupHook
	   , manageHook = myManageHook
	   , handleEventHook = minimizeEventHook
	   }
	   `additionalKeysP`
           [ ("M-p", spawn "dmenu_run")
           , ("<Print>", spawn "flameshot gui")
	   , ("M-S-l", spawn "xscreensaver-command -lock")
	   , ("M-m", withFocused minimizeWindow)
           , ("M-S-m", withLastMinimized maximizeWindow)
	   , ( "<XF86AudioRaiseVolume>" , spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    	   , ( "<XF86AudioLowerVolume>" , spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
           , ( "<XF86AudioMute>"        , spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
           , ( "<XF86AudioMicMute>"     , spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
           ]

myStartupHook :: X ()
myStartupHook = do
	setDefaultCursor xC_left_ptr
	spawnOnce "feh --no-fehbg --bg-fill \"$HOME/Pictures/Wallpapers/samurai.jpg\""
	spawnOnce "/usr/libexec/polkit-mate-authentication-agent-1"
	spawnOnce "picom --backend glx"
	spawnOnce "xscreensaver --no-splash"
	spawn "xset r rate 300 75"
	spawn "setxkbmap latam"


myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , className =? "Qalculate-gtk" --> doCenterFloat
    , isDialog            --> doFloat
    ]

myLayout = minimize $ spacingWithEdge 2 $ tiled ||| Mirror tiled ||| Full
  where
    tiled    = Tall nmaster delta ratio
    nmaster  = 1 
    ratio    = 1/2  
    delta    = 3/100 


myLogger :: (String -> String) -> (String -> String) -> X (Maybe String)
myLogger formatFocused formatUnfocused =
  withWindowSet $ \ws -> do
    let wins = W.index ws
    case wins of
      [] -> pure (Just "") 
      _  -> do
        entries <- mapM (formatOne ws) wins
        pure . Just $ unwords entries
  where
    formatOne ws w = do
      name <- getName w
      let wid   = "0x" ++ showHex w ""
      minimized <- runQuery isMinimized w
      let actionCmd =
            if minimized
             then "xdotool windowactivate "      ++ wid
             else "xdotool windowminimize " ++ wid

      let base  = show name

      let formatted =
            if W.peek ws == Just w
               then formatFocused base
               else formatUnfocused base

      let action = "<action=" ++ actionCmd ++ ">"
      let close  = "</action>"

      pure $ action ++ formatted ++ close


myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = green " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [myLogger formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . green . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, green, red, white, yellow :: String -> String
    green  = xmobarColor "#a9b665" ""
    blue     = xmobarColor "#7daea3" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#9d9d9d" ""
















