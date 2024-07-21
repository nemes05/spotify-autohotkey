#SingleInstance force

DetectHiddenWindows(true)

WinWait("ahk_exe Spotify.exe")

global prevTrack := 'Spotify'

SetTimer(Toast, 2000) 

Toast()
{
    if (ProcessExist("Spotify.exe") == 0)
    {
        ExitApp
    }
    
    ids := WinGetList("ahk_exe Spotify.exe")
    winname := ''
    for id in ids
    {
        temp_winname := WinGetTitle(id)
        if (temp_winname != 'Spotify' && temp_winname !== 'Spotify Premium' && temp_winname != '')
        {
            if (InStr(temp_winname, '-') != 0)
            {
                winname := WinGetTitle(id)
                winfocused := WinActive("ahk_exe Spotify.exe")
            }
        }
    }

    
    if (winname != '' && winfocused == 0)
    {
        global prevTrack
        artist := SubStr(winname, 1, InStr(winname, '-') - 2)
        track := SubStr(winname, InStr(winname, '-') + 2)

        if (InStr(winname, prevTrack) == 0)
        {
            TrayTip
            TrayTip artist, track, 16
            prevTrack := track
        }
    }
}

SendMode 'Input'

;Page Up: Previous Track
PgUp::Media_Prev

;Page Down: Next Track
PgDn::Media_Next

;Ctrl & Shift & Space: Play/Pause Track
^+Space::Media_Play_Pause