#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

FileReadLine, windowwidth, settings.txt, 2
FileReadLine, numberperline, settings.txt, 4
FileReadLine, editnextgame, settings.txt, 6
pixelsperpicture := windowwidth/numberperline
gamenumberonline = 0
gamelocationheight = 0
onrow = 0
gamenumber1 = 0

if(editnextgame = 1)
{
    onclick = edit
}
else
{
    onclick = click
}

Loop Files, progames\*
{
    gamenumber1++
    gamelocationwidth := pixelsperpicture*gamenumberonline
    gamenumberonline++
    gamelocationheight := onrow*pixelsperpicture+(pixelsperpicture/10*onrow)
    FileReadLine, picoffile, progames\%A_LoopFileName%, 3
    FileReadLine, gamename, progames\%A_LoopFileName%, 1
    StringReplace, filetag, A_LoopFileName, .%A_LoopFileExt%, , All
    gui, add, picture, x%gamelocationwidth% y%gamelocationheight% w%pixelsperpicture% h%pixelsperpicture% V%filetag% g%onclick%, %picoffile%
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
            FileReadLine, startemulator, %A_LoopFilePath%, 4
            runrom = "%startemulator%" "%startgame%"
            if (startemulator = "")
            {
                Run, %startgame%
            }
            Else
            {
                Run, %runrom%
            }
            ExitApp
            Break
        }
        if(selectedgame = "zzzsettings")
        {
            Gui, settings:add, text, cffffff x50 w700, `n

            Gui, settings:add, text, cffffff x50 w700, width of the window (in pixels):
            Gui, settings:Add, Edit, r1 x50 w700 vwindowwidth, %windowwidth%

            Gui, settings:add, text, cffffff x50 w700, games per line:
            Gui, settings:Add, Edit, r1 x50 w700 vnumberperline, %numberperline%

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
    Gui, addgame:add, text, cffffff x50 y5 w700, name of the game:
    Gui, addgame:Add, Edit, r1 x50 w700 y25 vgamename,

    Gui, addgame:add, text, cffffff x50 y53 w700, location of the game (can be a file or shortcut):
    Gui, addgame:Add, Edit, r1 x50 w600 y75 vgamelocation,
    Gui, addgame:add, button, x650 w100 y75 gaddBrowsegame, Browse

    Gui, addgame:add, text, cffffff x50 y103 w700, location of the icon/picture (can be a exe to use the icon of the exe):  
    Gui, addgame:Add, Edit, r1 x50 w600 y125 viconlocation,
    Gui, addgame:add, button, x650 w100 y125 gaddBrowseicon, Browse

    Gui, addgame:add, text, cffffff x50 y153 w700, location of the emulator (if it is not a ROM then don't fil in this box):
    Gui, addgame:Add, Edit, r1 x50 w600 y175 vemulatorlocation,
    Gui, addgame:add, button, x650 w100 y175 gaddBrowseemulator, Browse

    Gui, addgame:add, text, cffffff x50 y203 w700, name of the file (leave empty for random name):
    Gui, addgame:Add, Edit, r1 x50 w700 y225 vfilenameinput,

    Gui, addgame:Add, button, x50 w700 y550 gaddgameConfirm, Confirm

    Gui, addgame:Color, 323233
    Gui, addgame:Show, w800 h600
    gui, settings:Destroy
Return

Editgame:
    gui settings:Submit
    gui settings:Destroy
    FileDelete, settings.txt
    FileAppend, 
    (
window width (in pixels):
%windowwidth%
games per line:
%numberperline%
edit next selected game
1
    ), settings.txt
    Reload
Return

Confirm:
    gui settings:Submit
    gui settings:Destroy
    FileDelete, settings.txt
    FileAppend, 
    (
window width (in pixels):
%windowwidth%
games per line:
%numberperline%
edit next selected game
0
    ), settings.txt
    Reload
Return

addBrowsegame:
    FileSelectFile, gamefilelocation , s 34, A_Desktop\game, Title, All Files (*.*)
    if(gamefilelocation = "")
    {
        
    }
    else
    {
        GuiControl,, gamelocation, %gamefilelocation%
    }
Return

addBrowseicon:
    FileSelectFile, gamefilelocation , s 34, A_Desktop\game, Title, Pictures (*.png; *.jpg; *.ico; *.gif; *.exe)
    if(gamefilelocation = "")
    {
        
    }
    else
    {
        GuiControl,, iconlocation, %gamefilelocation%
    }
Return

addBrowseemulator:
    FileSelectFile, gamefilelocation , s 34, A_Desktop\game, Title, All Files (*.*)
    if(gamefilelocation = "")
    {

    }
    else
    {
        GuiControl,, emulatorlocation, %gamefilelocation%
    }
Return

addgameConfirm:
    gui Submit
    filenameinput := removecharacters(filenameinput)
    if (filenameinput = "")
    {
        Random, filenameinput, 100000000, 999999999
    }
    Loop
    {
        IfNotExist, \progames\%filenameinput%.*
        {
            Break
        }
        Random, filenameinput, 100000000, 999999999
    }
    FileAppend,%gamename%`n%gamelocation%`n%iconlocation%`n%emulatorlocation%, progames\%filenameinput%.txt
    Reload
Return

edit:
MouseGetPos,,,, classNN
GuiControlGet, selectedgame, Name, %classNN%
Gui, destroy
FileDelete, settings.txt
FileAppend, 
    (
window width (in pixels):
%windowwidth%
games per line:
%numberperline%
edit next selected game
0
    ), settings.txt
    Loop Files, progames\*
    {
        StringReplace, games, A_LoopFileName, .%A_LoopFileExt%, , All
        if(selectedgame = games && selectedgame != "zzzsettings")
        {
            FileReadLine, editgamename, %A_LoopFilePath%, 1
            FileReadLine, editgamefile, %A_LoopFilePath%, 2
            FileReadLine, editgameicon, %A_LoopFilePath%, 3
            FileReadLine, editgameemulator, %A_LoopFilePath%, 4
            StringReplace, filenamefile, A_LoopFileName, .%A_LoopFileExt%, , All
            filepath = %A_LoopFilePath%
            Gui, editgame:add, text, cffffff x50 y5 w700, name of the game:
            Gui, editgame:Add, Edit, r1 x50 w700 y25 vgamename, %editgamename%

            Gui, editgame:add, text, cffffff x50 y53 w700, location of the game (can be a file or shortcut):
            Gui, editgame:Add, Edit, r1 x50 w600 y75 vgamelocation, %editgamefile%
            Gui, editgame:add, button, x650 w100 y75 geditBrowsegame, Browse

            Gui, editgame:add, text, cffffff x50 y103 w700, location of the icon/picture (can be a exe to use the icon of the exe):  
            Gui, editgame:Add, Edit, r1 x50 w600 y125 viconlocation, %editgameicon%
            Gui, editgame:add, button, x650 w100 y125 geditBrowseicon, Browse

            Gui, editgame:add, text, cffffff x50 y153 w700, location of the emulator (if it is not a ROM then don't fil in this box):
            Gui, editgame:Add, Edit, r1 x50 w600 y175 vemulatorlocation, %editgameemulator%
            Gui, editgame:add, button, x650 w100 y175 geditBrowseemulator, Browse

            Gui, editgame:add, text, cffffff x50 y203 w700, name of the file (leave empty for random name):
            Gui, editgame:Add, Edit, r1 x50 w700 y225 vfilenameinput, %filenamefile%

            Gui, editgame:Add, button, x50 w700 y500 geditdeletegamefromlist, Delete game from list
            Gui, editgame:Add, button, x50 w700 y550 geditgameConfirm, Confirm

            Gui, editgame:Color, 323233
            Gui, editgame:Show, w800 h600
            Break
        }
        if(selectedgame = "zzzsettings")
        {
            run settings.txt
            Break
        }
    }

Return

editBrowsegame:
    FileSelectFile, gamefilelocation , s 34, A_Desktop\game, Title, All Files (*.*)
    if(gamefilelocation = "")
    {
        
    }
    else
    {
        GuiControl,, gamelocation, %gamefilelocation%
    }
Return

editBrowseicon:
    FileSelectFile, gamefilelocation , s 34, A_Desktop\game, Title, Pictures (*.png; *.jpg; *.ico; *.gif; *.exe)
    if(gamefilelocation = "")
    {
        
    }
    else
    {
        GuiControl,, iconlocation, %gamefilelocation%
    }
Return

editBrowseemulator:
    FileSelectFile, gamefilelocation , s 34, A_Desktop\game, Title, All Files (*.*)
    if(gamefilelocation = "")
    {

    }
    else
    {
        GuiControl,, emulatorlocation, %gamefilelocation%
    }
Return

editdeletegamefromlist:
gui Submit
FileDelete, %filepath%
Reload
Return

editgameConfirm:
    gui Submit
    filenameinput := removecharacters(filenameinput)
    if (filenameinput = "")
    {
        Random, filenameinput, 100000000, 999999999
    }
    FileDelete, %filepath%
    Loop
    {
        IfNotExist, \progames\%filenameinput%.*
        {
            Break
        }
        Random, filenameinput, 100000000, 999999999
    }
    FileAppend,%gamename%`n%gamelocation%`n%iconlocation%`n%emulatorlocation%, progames\%filenameinput%.txt
    Reload
    Return


^!s::
    gui Destroy
    Gui, settings:add, text, cffffff x50 w700, `n

    Gui, settings:add, text, cffffff x50 w700, width of the window (in pixels):
    Gui, settings:Add, Edit, r1 x50 w700 vwindowwidth, %windowwidth%

    Gui, settings:add, text, cffffff x50 w700, games per line:
    Gui, settings:Add, Edit, r1 x50 w700 vnumberperline, %numberperline%

    Gui, settings:add, text, cffffff x50 w700, `n

    Gui, settings:Add, button, x50 w700 y500 gaddgame, Add a game
    Gui, settings:Add, button, x50 w700 y525 gEditgame, Edit a game
    Gui, settings:Add, button, x50 w700 y550 gConfirm, Confirm


    Gui, settings:Color, 323233
    Gui, settings:Show, w800 h600
Return

removecharacters(stringname)
{
    stringname := StrReplace(stringname, " ", "")
    stringname := StrReplace(stringname, "'", "")
    stringname := StrReplace(stringname, "/", "")
    stringname := StrReplace(stringname, "\", "")
    stringname := StrReplace(stringname, ":", "")
    stringname := StrReplace(stringname, ";", "")
    stringname := StrReplace(stringname, "*", "")
    stringname := StrReplace(stringname, "?", "")
    stringname := StrReplace(stringname, "!", "")
    stringname := StrReplace(stringname, "<", "")
    stringname := StrReplace(stringname, ">", "")
    stringname := StrReplace(stringname, "|", "")
    stringname := StrReplace(stringname, "@", "")
    stringname := StrReplace(stringname, "#", "")
    stringname := StrReplace(stringname, "$", "")
    stringname := StrReplace(stringname, "%", "")
    stringname := StrReplace(stringname, "^", "")
    stringname := StrReplace(stringname, "&", "")
    stringname := StrReplace(stringname, "(", "")
    stringname := StrReplace(stringname, ")", "")
    stringname := StrReplace(stringname, "-", "")
    stringname := StrReplace(stringname, "+", "")
    stringname := StrReplace(stringname, "_", "")
    stringname := StrReplace(stringname, "=", "")
    stringname := StrReplace(stringname, "[", "")
    stringname := StrReplace(stringname, "]", "")
    stringname := StrReplace(stringname, "{", "")
    stringname := StrReplace(stringname, "}", "")
    stringname := StrReplace(stringname, "(", "")
    stringname := StrReplace(stringname, ")", "")
    stringname := StrReplace(stringname, ".", "")
    stringname := StrReplace(stringname, ",", "")
    stringname := StrReplace(stringname, "~", "")
    stringname := StrReplace(stringname, "™", "")
    Return %stringname%
}