#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileReadLine, windowwidth, settings.txt, 2
FileReadLine, numberperline, settings.txt, 4
pixelsperpicture := windowwidth/numberperline
gamenumberonline = 0
gamelocationheight = 0
onrow = 0
gamenumber1 = 0

Loop Files, progames\*
{
    gamenumber1++
    gamelocationwidth := pixelsperpicture*gamenumberonline
    gamenumberonline++
    gamelocationheight := onrow*pixelsperpicture+(pixelsperpicture/15*onrow)
    FileReadLine, picoffile, progames\%A_LoopFileName%, 3
    FileReadLine, gamename, progames\%A_LoopFileName%, 1
    StringReplace, filetag, A_LoopFileName, .%A_LoopFileExt%, , All
    gui, add, picture, x%gamelocationwidth% y%gamelocationheight% w%pixelsperpicture% h-1 V%filetag% gclick, %picoffile%
    textlocationy := gamelocationheight+pixelsperpicture
    gui, add, text, +Center y%textlocationy% x%gamelocationwidth% w%pixelsperpicture% cffffff, %gamename%
    if(gamenumberonline = numberperline)
    {
        gamenumberonline = 0
        onrow++
    }
}
buttonheight := (onrow*pixelsperpicture)+pixelsperpicture
Gui, Color, 000000
Gui, Show, W%windowwidth%, NCGL
;Gui, show
;DPIScale 

Return

click:
MouseGetPos,,,, classNN
GuiControlGet, selectedgame, Name, %classNN%
Gui, destroy
Loop Files, progames\*
{
    StringReplace, games, A_LoopFileName, .%A_LoopFileExt%, , All
    if(selectedgame = games && selectedgame != "zzzsettings")
    {
        FileReadLine, startgame, %A_LoopFilePath%, 2
        Run, %startgame%
        ExitApp
        Break
    }
    if(selectedgame = "zzzsettings")
    {
        Gui, settings:add, text, cffffff x50 w700, `n

        Gui, settings:add, text, cffffff x50 w700, width of the window (in pixels):
        Gui, settings:Add, Edit, r1 vMyEdit x50 w700 vwindowwidth, %windowwidth%

        Gui, settings:add, text, cffffff x50 w700, games per line:
        Gui, settings:Add, Edit, r1 vMyEdit x50 w700 vnumberperline, %numberperline%

        Gui, settings:add, text, cffffff x50 w700, `n

        Gui, settings:Add, button, x50 w700 y500 gaddgame, Add a game
        Gui, settings:Add, button, x50 w700 y525 gEditgame, Edit a game
        Gui, settings:Add, button, x50 w700 y550 gConfirm, Confirm


        Gui, settings:Color, 323233
        Gui, settings:Show, w800 h600
        Break
    }
}

Return

GuiClose:
ExitApp
Return

addgame:

Return

Editgame:

Return

Confirm:
Gui, Submit
Return