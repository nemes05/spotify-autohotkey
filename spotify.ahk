#SingleInstance force
DetectHiddenWindows(true)

;Waits for spotify to open
WinWait("ahk_exe Spotify.exe")

;Initializes previous track variable
global prevTrack := 'Spotify'

;Calling the toast method every 2 seconds
SetTimer(Toast, 2000) 

;Method for showing the toast
Toast()
{
    ;If spotify is closed, the script is closed
    if (ProcessExist("Spotify.exe") == 0)
    {
        ExitApp
    }
    
    ;Iterate through spotify ids and checks if any song is playing
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

    ;Checks if windows is active and if spotify is not in focus
    if (winname != '' && winfocused == 0)
    {
        global prevTrack
        artist := SubStr(winname, 1, InStr(winname, '-') - 2)
        track := SubStr(winname, InStr(winname, '-') + 2)

        ;Displays the toast if a new song is playing
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