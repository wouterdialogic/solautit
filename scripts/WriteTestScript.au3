#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#include <Date.au3>
#include <Misc.au3>
#include <GDIPlus.au3>

_GDIPlus_Startup()

OnAutoItExitRegister("ReleaseKeys")
Opt("MouseClickDelay", 250)
Opt("MouseClickDownDelay", 250)

HotKeySet("!c", "CopyClipboard"); ALT + c
HotKeySet("+!c", "QueryBuilder"); SHIFT + ALT + c
HotKeySet("+!i", "ScriptImport"); SHIFT + ALT + i
HotKeySet("+!m", "Marker"); SHIFT + ALT + m
HotKeySet("+!s", "Stop"); SHIFT + ALT + s
HotKeySet("+!p", "ScreenShot"); SHIFT + ALT + p
HotKeySet("+!g", "Parameter"); SHIFT + ALT + g
HotKeySet("+!o", "OcrGen"); SHIFT + ALT + o
HotKeySet("+!x", "TogglePauze"); SHIFT + ALT + x

Global $vDocumentsDir = @MyDocumentsDir & "\Batch\"
Global $sFilePath0 = $vDocumentsDir & "Settings\WriteTestScript.ini"
Global $ArtikelArray0 = FileReadToArray($sFilePath0)
Global $iCountLines0 = _FileCountLines($sFilePath0)
Global $hFileOpen0 = ""
If $iCountLines0 < 2 Then
	$hFileOpen0 = FileOpen($sFilePath0, $FO_OVERWRITE)
	FileWriteLine($hFileOpen0, "1" & @CRLF & "50" & @CRLF & "50" & @CRLF & "500" & "1" & @CRLF)
	FileFlush($hFileOpen0)
	FileClose($hFileOpen0)
    $ArtikelArray0 = FileReadToArray($sFilePath0)
    $iCountLines0 = _FileCountLines($sFilePath0)
EndIf
Global $fontFile = $vDocumentsDir & "Settings\OCRFontData.txt"
Global $fontArray = FileReadToArray($fontFile)
Global $iCountLinesFF = _FileCountLines($fontFile)
Global $fontFileOpen = ""
If $iCountLinesFF < 2 Then
	$fontFileOpen = FileOpen($fontFile, $FO_OVERWRITE)
	FileWriteLine($fontFileOpen, "" & @CRLF)
	FileFlush($fontFileOpen)
	FileClose($fontFileOpen)
EndIf
Global $cFx = $ArtikelArray0[1]
Global $cFy = $ArtikelArray0[2]
Global $ColorArray[25] = ["0xF5CB98", "0x91CFFF", "0xE7EAEE", "0xFFFFFF", "0xB33131", "0x6C99B3", "0xB8BDC3", "0x5692E1", "0xE6E9ED", "0xF1F2F4", "0xDB8270", "0xB5DB49", "0x75407C", "0x21608C", "0xF0F0F0", "0x8A8A8A", "0xE04343", "0xC75050", "0x7C8FB3", "0x2F84CF", "0xE81123", "0x4F93C9", "0xA9CDFA", "0x3693D9", "0xBF2020"]
Global $TekstArray[25] = ["Accountmanagers", "Artikelen", "Artikel detail", "Overig detail", "Annuleer", "Verrekijker", "Inactieve tab", "Detail knopje", "Actieve tab", "Tab achtergrond", "Window annuleer", "Info icoon groen", "Solidis logo test", "Solidis logo branch", "Witte kruisje", "Grijze driehoekje", "Annuleer w8 Actief", "Annuleer w8 Inactief", "Actief NAV-ITEM", "Pijltjes", "Annuleer w10", "Info icoon blauw", "Blauwe listview regel", "Mini dialoog", "Error scherm"]
;"0xF5CB98"[01]"Accountmanagers"
;"0x91CFFF"[01]"Artikelen"
;"0xE7EAEE"[02]"Artikel detail"
;"0xFFFFFF"[03]"Overig detail"
;"0xB33131"[04]"Annuleer"
;"0x6C99B3"[05]"Verrekijker"
;"0xB8BDC3"[06]"Inactieve tab"
;"0x5692E1"[07]"Detail knopje"
;"0xE6E9ED"[08]"Actieve tab"
;"0xF1F2F4"[09]"Tab achtergrond"
;"0xDB8270"[10]"Window annuleer"
;"0xB5DB49"[11]"Info icoon groen"
;"0x75407C"[12]"Solidis logo test"
;"0x21608C"[13]"Solidis logo branch"
;"0xF0F0F0"[14]"Witte kruisje"
;"0x8A8A8A"[15]"Grijze driehoekje"
;"0xE04343"[16]"Annuleer w8 Actief"
;"0xC75050"[17]"Annuleer w8 Inactief"
;"0x7C8FB3"[18]"Actief NAV-ITEM"
;"0x2F84CF"[19]"Pijltjes"
;"0xE81123"[20]"Annuleer w10"
;"0x4F93C9"[21]"Info icoon blauw"
;"0xA9CDFA"[22]"Blauwe listview regel"
;"0x3693D9"[23]"Mini dialoog"
;"0xBF2020"[24]"Error scherm"

$Form1 = GUICreate("Test script recorder", 750, 540, $cFx, $cFy)
$Group0 = GUICtrlCreateGroup("", 8, 17, 325, 160)
$Label01 = GUICtrlCreateLabel("Klik op de startknop en selecteer met de rechtermuisknop", 32, 40, 300, 17)
$Label02 = GUICtrlCreateLabel("de objecten om aan het test bestand toe te voegen.", 32, 55, 300, 17)
$Label03 = GUICtrlCreateLabel("ALT + c is copy-paste input ", 32, 70, 300, 17)
$Label04 = GUICtrlCreateLabel("SHIFT + ALT + c is run query in script", 32, 85, 300, 17)
$Label05 = GUICtrlCreateLabel("SHIFT + ALT + i script import", 32, 100, 300, 17)
$Label06 = GUICtrlCreateLabel("SHIFT + ALT + m zet Marker", 32, 115, 300, 17)
$Label07 = GUICtrlCreateLabel("SHIFT + ALT + s Stop, onderbreek script", 32, 130, 300, 17)
$Label08 = GUICtrlCreateLabel("SHIFT + ALT + p maak een Screenshot", 32, 145, 300, 17)
$Label07 = GUICtrlCreateLabel("SHIFT + ALT + x Pauzeer script", 32, 160, 300, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Edit01 = GUICtrlCreateEdit("", 350, 23, 380, 445)

$Group1 = GUICtrlCreateGroup("Scherm", 8, 180, 325, 57)
$Radio11 = GUICtrlCreateRadio("Links", 24, 208, 60, 25)
$Radio12 = GUICtrlCreateRadio("Rechts", 86, 208, 60, 25)
GUICtrlSetState($ArtikelArray0[0], $GUI_CHECKED)
$Label10 = GUICtrlCreateLabel("StartPosX", 155, 194, 60, 17)
$Label11 = GUICtrlCreateLabel("0", 220, 194, 60, 17)
$Label12 = GUICtrlCreateLabel("SizeX", 155, 210, 60, 17)
$Label13 = GUICtrlCreateLabel("0", 220, 210, 60, 17)
$Checkbox14 = GUICtrlCreateCheckbox("Single", 260, 208, 60, 17)
GUICtrlSetState(-1, $ArtikelArray0[4])
GUICtrlCreateGroup("", -99, -99, 1, 1)

;standard setting for radiobutton LINKS = 1
GUICtrlSetState ( $Radio11, 1 )

$Edit20 = GUICtrlCreateEdit("", 8, 245, 325, 195)
$Input21 = GUICtrlCreateInput($ArtikelArray0[3], 8, 450, 325, 17)

$Button1 = GUICtrlCreateButton("Start", 60, 500, 32, 32, BitOR($BS_BITMAP, $BS_CENTER))
ButtonImage($Button1, "record_run.png")
GUICtrlSetTip( -1, "Start script")
$Button2 = GUICtrlCreateButton("Opslaan", 120, 500, 32, 32, BitOR($BS_BITMAP, $BS_CENTER))
ButtonImage($Button2, "floppy_disk_blue.png")
GUICtrlSetTip( -1, "Save script")
$Button3 = GUICtrlCreateButton("Pauze", 180, 500, 32, 32, BitOR($BS_BITMAP, $BS_CENTER))
ButtonImage($Button3, "record_pause.png")
GUICtrlSetTip( -1, "Pauze script")
$Button4 = GUICtrlCreateButton("Kalibreren", 485, 500, 32, 32, BitOR($BS_BITMAP, $BS_CENTER))
ButtonImage($Button4, "monitor_test_card.png")
GUICtrlSetTip( -1, "Calibrate mouse position, CAUTION!")
$Button5 = GUICtrlCreateButton("Standaard", 545, 500, 32, 32, BitOR($BS_BITMAP, $BS_CENTER))
ButtonImage($Button5, "nav_undo_blue.png")
GUICtrlSetTip( -1, "Save settings")
$Button6 = GUICtrlCreateButton("Enkele actie", 605, 500, 32, 32, BitOR($BS_BITMAP, $BS_CENTER))
ButtonImage($Button6, "single_action.png")
GUICtrlSetTip( -1, "Single action")
$Button7 = GUICtrlCreateButton("Handleiding", 425, 500, 32, 32, BitOR($BS_BITMAP, $BS_CENTER))
ButtonImage($Button7, "information.png")
GUICtrlSetTip( -1, "Help file")
$Line1 = GUICtrlCreateGraphic(20, 490, 740, 1)
GUICtrlSetBkColor(-1, 0xF0F0F0)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 15) ; start point
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xA6A6A6)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 700)

GUISetState(@SW_SHOW)
Send("{RIGHT}")

Global $hWnd2 = WinWait($Form1, "", 1)
Global $fPaused, $ClickPosX, $ClickPosY, $svPosX, $svPosY, $xPos, $yPos, $clipBoardGet, $svRecord, $svClipBoardGet, $StartX, $StartY, $SizeX, $SizeY, $EindX, $EindY = ""
Global $ItemType, $ItemInhoud, $sHoofdMenu, $sSubMenu, $sTab, $sSubTab, $sButton, $sTekst, $sActive, $sMaxTab, $vOmgeving = ""
Global $iDelay = 250
Global $pauze = False
Global $ExecuteVlag, $vSleep, $hTimer0, $hTimer1, $vTotalTime, $vSchrijfCount, $vTimeDiff, $iClipboardget, $vSingleAction, $iScreenCount, $FoutVlag, $cParm = 0
Global $aClipboardGet[25]
Global $hTimer = TimerInit()

;MouseClick("left", $cFx + 196, $cFy + 393, 1)
;MouseMove($cFx + 70, $cFy + 380, 5)

Func InitProg()
	$ExecuteVlag = 1
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ":" & "InitProg" & @CRLF)
	$hTimer0 = TimerInit()
	;Check of Solidis is opgestart met user Distri Nl. Bepaal daarna scherm grootte en positie
	Local $aList = WinList()
	For $i = 1 To $aList[0][0]
		If StringInStr($aList[$i][0], "Distri Nl") Then
			If BitAND(WinGetState($aList[$i][1]), 2) Then
				Global $hWnd = WinWait($aList[$i][0], "", 25)
			Else
				MsgBox($MB_SYSTEMMODAL, "Niet actief", $aList[$i][0] & @CRLF)
			EndIf
		EndIf
	Next
	If $hWnd = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Error!!", "Solidis is niet opgestart met user Distri Nl!!", 3)
		Exit
	EndIf

   WinActivate($hWnd)
	WachtActief($iDelay * 4)
	WinSetState($hWnd, "", @SW_MAXIMIZE)
	Local $aPos = WinGetPos($hWnd)
	$hPos = WinGetClientSize($hWnd)
	$SizeX = $hPos[0]
	$SizeY = $hPos[1]
	$StartX = $aPos[0]
	$StartY = $aPos[1]
	$EindX = $aPos[2]
	$EindY = $aPos[3]
	ZoekKleur($StartX, $StartY, $StartX + 25, $StartY + 25, $ColorArray[12], 0, 0, @ScriptLineNumber);Zoek Solidis logo test
	If $FoutVlag > 0 Then
		ZoekKleur($StartX, $StartY, $StartX + 25, $StartY + 25, $ColorArray[13], 0, 0, @ScriptLineNumber);Zoek Solidis logo branch
		If $FoutVlag > 0 Then
			ConsoleWrite(@ScriptLineNumber & "Solidis logo niet gevonden" & @CRLF)
		Else
			$vOmgeving = "BRANCH"
		EndIf
	Else
		$vOmgeving = "TEST"
	EndIf
	GUICtrlSetData($Label11, $StartX)
	GUICtrlSetData($Label13, $SizeX)
	If $StartX < $cFx Then; Als Solidis scherm links staat en het AutoIt scherm rechts
		GUICtrlSetState($Radio11, $GUI_CHECKED)
	Else
		GUICtrlSetState($Radio12, $GUI_CHECKED)
	EndIf
	If _IsChecked($Checkbox14) Then
		$vSingleAction = 1
	EndIf
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ":" & $SizeX & "," & $SizeY & "," & $StartX & "," & $StartY & "," & $EindX & "," & $EindY & "," & @CRLF)
	Local $textInput01 = GUICtrlRead($Input21, 1)
	If $vSingleAction = 0 Then
		$svRecord = "Klik met de rechtermuisknop op een HOOFDmenu" & @CRLF
		GUICtrlSetData($Edit01, $svRecord)
	EndIf
	ConsoleWrite("Bestandsnaam:" & $textInput01 & @CRLF)
	Global Const $sFilePath1 = $textInput01
	Global $hFileOpen1 = FileOpen($sFilePath1, $FO_OVERWRITE)
	Local $vFilePath = StringSplit($sFilePath1, $vDocumentsDir, $STR_ENTIRESPLIT)
	Global $vFileName = StringTrimRight($vFilePath[2], 4)
	Global Const $sFilePath3 = $vDocumentsDir & "Input\" & $vFileName & ".txt"
	Global $hFileOpen3 = FileOpen($sFilePath3, $FO_OVERWRITE)
EndFunc   ;==>InitProg

Func TogglePauze()
	If $pauze == False Then
		$pauze = True
		ConsoleWrite("Script is gepauzeerd, gebruik CTRL + ALT + x om verder te gaan." & @CRLF)
	Else
		$pauze = False
		ConsoleWrite("Script neemt weer op." & @CRLF)
	EndIf
EndFunc

Func Start()
	If $pauze == True Then
		ConsoleWrite("pauze is enabled, not processing the mouseclick" & @CRLF)
		Return False
	EndIf

	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ":" & "Start" & @CRLF)
	$KlikVlag = 1
	;ClipPut("")
	;WachtActief($iDelay)
	;MouseClick("right", $ClickPosX, $ClickPosY, 1, 10)
	WachtActief($iDelay)
	$clipBoardGet = ClipGet()
	WachtActief($iDelay)
	If $clipBoardGet = "" Then
		$clipBoardGet = "~BUTTON: onbekend ~FORMNAME: onbekend"
		ToolTip("Geen object gevonden, alleen muispositie is opgeslagen!", $StartX + 1200, $StartY + 86)
		;$KlikVlag = 0
	EndIf
	SplitTekst($clipBoardGet, $ClickPosX, $ClickPosY, $KlikVlag)
	If $vSingleAction = 0 Then
		If $sHoofdMenu = "" Then
			If StringLeft($clipBoardGet, 11) <> "~NAV-HEADER" Then
				TrayTip("Hoofdmenu is nog onbekend", "Klik eerst op een hoofdmenu en daarna op een submenu om een flow te starten", 2)
			EndIf
		Else
			If $sSubMenu = "" Then
				If $vSingleAction = 0 Then
					$svRecord = $svRecord & "Klik met de rechtermuisknop op een SUBmenu" & @CRLF
					GUICtrlSetData($Edit01, $svRecord)
					If StringLeft($clipBoardGet, 11) <> "~NAV-HEADER" Then
						TrayTip("Submenu is nog onbekend", "Klik eerst op een submenu om een flow te starten", 2)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Start

Func Stop()
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & "Stop" & @CRLF)
	$hWnd2 = WinWait($Form1, "", 5)
	If $hWnd2 = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Error!!", "WriteTestScript scherm niet gevonden!!", 5)
	EndIf
	WinActivate($hWnd2)
	WachtActief($iDelay * 4)

	$stopScript = MsgBox($MB_YESNO, "Testscript opslaan", "Wilt u stoppen!", 10)
	If $stopScript = $IDTIMEOUT Then
		$stopScript = $IDYES
	EndIf
	If $stopScript = $IDYES Then
		$textInput01 = GUICtrlRead($Input21, 1)
		$vTimeDiff = Round(TimerDiff($hTimer0))
		$Record = "SLUIT;" & Round(($vTotalTime + 500) / 1000) + ($vSchrijfCount * $iDelay / 1000 * 12) & ";" & Round($vTimeDiff / 1000)
		FileWriteLine($hFileOpen1, $Record)
		FileClose($hFileOpen1)
		FileClose($hFileOpen3)
		_Exit()
	EndIf
	WinActivate($hWnd)
	WachtActief($iDelay * 4)
EndFunc   ;==>Stop

Func Pauze()
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ":" & "Pauze" & @CRLF)
	$fPaused = Not $fPaused
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & "Gepauzeerd, klik met muis om verder te gaan" & @CRLF)
	Local $i = 0
	Do
		If _IsPressed("01") Then
			ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & "Active" & @CRLF)
			$i = $i + 1
		EndIf
	Until $i > 0
EndFunc   ;==>Pauze

Func _Kalibreren()
	If $ExecuteVlag = 1 Then
		MsgBox($MB_OK, "Waarschuwing", "Kalibreren kan alleen voordat de startknop is aangeklikt!", 5)
	Else
		MsgBox($MB_OK, "Info", "Klik precies op het puntje van de i in het submenu artikelen!", 3)
		Local $i = 0
		Do
			If _IsPressed("01") Then
				$i = $i + 1
			EndIf
		Until $i > 0
		Local $vPos = MouseGetPos()
		$StartX = $vPos[0] - 75
		$StartY = $vPos[1] - 135
	EndIf
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & "- Kalibratie verwerkt op: " & $StartX & "," & $StartY & @CRLF)
EndFunc   ;==>_Kalibreren

Func CopyClipboard()
	If $pauze == True Then
		ConsoleWrite("pauze is on, will not copy the clipboard." & @CRLF)
		Return False
	EndIf

	ClipPut("")
	Local $i = 0
	Sleep($iDelay)
	Do
		Send("^a")
		Sleep($iDelay)
		Send("^c")
		Sleep($iDelay)
		$clipBoardGet = ClipGet()
		Sleep($iDelay)
		$i = $i + 1
	Until $clipBoardGet <> "" Or $i > 2
	$clipBoardGet = "~INPUT: " & $clipBoardGet
	If $clipBoardGet <> "" Then
		$iClipboardget = $iClipboardget + 1
		$aClipboardGet[$iClipboardget] = $clipBoardGet
		$svClipBoardGet = $svClipBoardGet & $clipBoardGet & @CRLF
		GUICtrlSetData($Edit20, $svClipBoardGet)
	EndIf
	ReleaseKeys()
	Local $vClipBoardGet = StringReplace($clipBoardGet, " ", "#")
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & "-" & $i & "- CopyClipboard:" & $clipBoardGet & @CRLF)
	ToolTip("Clipboard bevat: " & $clipBoardGet, $StartX + 1000, $StartY + 86)
	SplitTekst($vClipBoardGet, $ClickPosX, $ClickPosY, 0)
EndFunc   ;==>CopyClipboard

Func QueryBuilder()
	If $pauze == True Then
		ConsoleWrite("Script is paused, not building a query" & @CRLF)
		Return False
	EndIf

	ConsoleWrite("QueryBuilder")
	ClipPut("")
	Local $i = 0
	Sleep($iDelay)
	Do
		Send("^a")
		Sleep($iDelay)
		Send("^c")
		Sleep($iDelay)
		$clipBoardGet = ClipGet()
		Sleep($iDelay)
	Until $clipBoardGet <> "" Or $i > 2
	$clipBoardGet = "~QUERYPARM: " & $clipBoardGet
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & "-" & "CopyClipboard:" & $clipBoardGet & @CRLF)
	ToolTip("Query parameter: " & $clipBoardGet, $StartX + 1000, $StartY + 86)
	If $clipBoardGet <> "" Then
		$iClipboardget = $iClipboardget + 1
		$aClipboardGet[$iClipboardget] = $clipBoardGet
		$svClipBoardGet = $svClipBoardGet & $clipBoardGet & @CRLF
		GUICtrlSetData($Edit20, $svClipBoardGet)
		FileWriteLine($hFileOpen3, $clipBoardGet & @CRLF)
	EndIf
	ReleaseKeys()
	SplitTekst($clipBoardGet, $ClickPosX, $ClickPosY, 0)
EndFunc   ;==>QueryBuilder

Func ScriptImport()
	If $ExecuteVlag <> 1 Then
		Return False
	EndIf
	Local $iPID = ShellExecute($vDocumentsDir & "Scripts\")
	$clipBoardGet = InputBox("Invoer gewenst", "Geef het bestand op wat je wilt importeren", $vDocumentsDir & "Scripts\")
	If FileExists($clipBoardGet) Then
		ProcessClose($iPID)
		$clipBoardGet = "~FILEIMPORT: " & $clipBoardGet
		SplitTekst($clipBoardGet, $ClickPosX, $ClickPosY, 0)
	Else
		MsgBox($MB_OK, "Waarschuwing", "Bestand niet gevonden in de Scripts map", 5)
	EndIf
EndFunc   ;==>ScriptImport

Func Marker()
	If $ExecuteVlag <> 1 Then
		Return False
	EndIf
	$clipBoardGet = "~MARKER: "
	SplitTekst($clipBoardGet, $ClickPosX, $ClickPosY, 0)
EndFunc   ;==>Marker

Func ScreenShot()
	If $pauze == True Then
		ConsoleWrite("Script is paused, not making a screenshot" & @CRLF)
		Return False
	EndIf

	ConsoleWrite(@ScriptLineNumber & " Screenshot" & @CRLF)
	$iScreenShot = MsgBox($MB_OK, "Invoer gewenst", "Klik eerst met de rechtermuis in de linkerbovenhoek en daarna in de rechteronderhoek om een screenshot te maken", 3)
	Local $i = 0
	Do
		If _IsPressed("02") Then; linksboven
			$i = $i + 1
			Local $vPos = MouseGetPos()
			$iLeft = $vPos[0]
			$iTop = $vPos[1]
			ToolTip("Linkerbovenhoek geselecteerd. Selecteer nu de rechteronderhoek")
			While _IsPressed("02")
				Sleep(10)
			WEnd
		EndIf
		Sleep(10)
	Until $i > 0
	Local $i = 0
	Do
		If _IsPressed("02") Then; Rechtsonder
			$i = $i + 1
			Local $vPos = MouseGetPos()
			$iRight = $vPos[0]
			$iBottom = $vPos[1]
			$iScreenCount = $iScreenCount + 1
			ToolTip("Rechteronderhoek geselecteerd, screenprint wordt gemaakt")
			_ScreenCapture_Capture($vDocumentsDir & "ScreenShot_" & $vFileName & $iScreenCount & ".jpg", $iLeft, $iTop, $iRight, $iBottom)
			SoundPlay($vDocumentsDir & "camera-shutter-click-07.wav")
			While _IsPressed("02")
				Sleep(10)
			WEnd
		EndIf
		Sleep(10)
	Until $i > 0
EndFunc   ;==>ScreenShot

Func Parameter()
	$cParm = $cParm + 1
	$clipBoardGet = "~PARAM: " & $cParm
	SplitTekst($clipBoardGet, $ClickPosX, $ClickPosY, 0)
EndFunc   ;==>Parameter

Func OcrGen()
	If $pauze == True Then
		ConsoleWrite("Script is paused, not processing mouse functions" & @CRLF)
		Return False
	EndIf

	$vOcrPos = MouseGetPos()
	Local $sKleur = PixelGetColor($vOcrPos[0], $vOcrPos[1])
	mouseOCR($vOcrPos[0], $vOcrPos[1], $sKleur)
EndFunc   ;==>OcrGen

Func Handleiding()
	ShellExecute($vDocumentsDir & "Handleiding testscripts.doc")
EndFunc   ;==>Handleiding

Func ZoekKleur($Xt, $Yt, $Xb, $Yb, $color, $Shade, $aClick, $nLine)
	For $i = 0 To 24 Step 1
		If $color = $ColorArray[$i] Then ;Als kleur uit tabel is gezochte kleur kijk in teksttabel
			ExitLoop
		EndIf
	Next

	$point = PixelSearch($Xt, $Yt + 5, $Xb, $Yb, $color, $Shade)

	If IsArray($point) Then
		$FoutVlag = 0
	Else
		ConsoleWrite($nLine & ": " & $TekstArray[$i] & " - " & $color & " niet gevonden!" & @CRLF)
		$FoutVlag = 1
	EndIf
EndFunc   ;==>ZoekKleur

Func ButtonImage($Button, $Image)
	Global $hImage = _GDIPlus_ImageLoadFromFile($vDocumentsDir & "Settings\Icons\" & $Image)
	Global $hHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($Button), $BM_SETIMAGE, $IMAGE_BITMAP, $hHBitmap))
EndFunc   ;==>ButtonImage

Func WachtActief($iWacht)
	Local $iCursor = MouseGetCursor()
	If $iCursor = 15 Then
		$iWacht = $iWacht * 8
	EndIf
	Do
		$iCursor = MouseGetCursor()
		Sleep($iWacht)
	Until $iCursor <> 15
EndFunc   ;==>WachtActief

Func ExecuteTime()
	Local $hExecuteTime = TimerDiff($hTimer)
	$hTimer = TimerInit()
	Return Round($hExecuteTime)
EndFunc   ;==>ExecuteTime

Func ConvertToTime($nr_sec)
	$sec2time_hour = Int($nr_sec / 3600)
	$sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc   ;==>ConvertToTime

Func SplitTekst($Tekst, $PosX, $PosY, $KlikVlag)
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ":" & "SplitTekst" & @CRLF)
	$hTimer1 = TimerInit() ; Begin the timer and store the handle in a variable.
	WachtActief($iDelay)
	Local $tTekst = StringReplace($Tekst, " ", "")
	Local $lsTekst = StringReplace($tTekst, "#", " ")
	$svRecord = $svRecord & $lsTekst & @CRLF
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ":" & $Tekst & ", " & $lsTekst & @CRLF)
	GUICtrlSetData($Edit01, $svRecord)
	$sNAV = StringSplit($lsTekst, "~:")
	$iMax = UBound($sNAV) - 1
	$ItemType = $sNAV[2]
	ConsoleWrite("1:| ")
	For $i = 1 To $iMax
		ConsoleWrite($sNAV[$i] & " " & $i + 1 & ":|")
	Next
	ConsoleWrite(@CRLF)

	Local $sSchrijfVlag = 1
	Local $vDubbelKlik = 1
	$vEditable = "FALSE"
	Switch $ItemType
		Case "NAV-HEADER"
			$ItemInhoud = $sNAV[3]
			$sHoofdMenu = $sNAV[3]
			$sSubMenu = ""
			$sTab = ""
			$sSubTab = ""
			$sButton = ""
			$sTekst = ""
			$sActive = ""
			$sMaxTab = ""
		Case "NAV-ITEM"
			$ItemInhoud = $sNAV[3]
			$sSubMenu = $sNAV[3]
			$sTab = ""
			$sSubTab = ""
			$sButton = ""
			$sTekst = ""
			$sActive = ""
			$sMaxTab = ""
		Case "TAB"
			$ItemInhoud = $sNAV[7]
			$sTab = $sNAV[7]
			$sSubTab = ""
			$sButton = ""
			$sTekst = $sNAV[5]
			$sActive = $sNAV[9]
			$sMaxTab = $sNAV[11]
		Case "SUB-TAB"
			$ItemInhoud = $sNAV[7]
			$sSubTab = $sNAV[7]
			$sButton = ""
			$sTekst = $sNAV[5]
			$sActive = $sNAV[9]
			$sMaxTab = $sNAV[11]
		Case "BUTTON"
			$ItemInhoud = $sNAV[3]
			$sButton = $sNAV[3]
			$sTekst = $sNAV[5]
		Case "LABEL"
			If $sNAV[7] = "" Then
				$ItemInhoud = $sNAV[3]
				$sButton = $sNAV[3]
				$sTekst = ""
				$vEditable = "COMBOBOX"
				;$KlikVlag = 0
			Else
				$ItemInhoud = $sNAV[7]
				$sTekst = $sNAV[5]
			EndIf
		Case "FIELD"
			$ItemInhoud = $sNAV[3]
			$sButton = $sNAV[3]
			$sTekst = $sNAV[5]
			If $sNAV[10] = "COMBOBOX" Then
				$vEditable = $sNAV[10]
				$KlikVlag = 0
			Else
				$vEditable = $sNAV[12]
			EndIf
			If $sNAV[11] = "CHECK" Then
				$sButton = $sNAV[9]
			EndIf
			$vDubbelKlik = 0
		Case "INPUT"
			$ItemInhoud = $sNAV[3]
			$sTekst = $sNAV[3]
			$vDubbelKlik = 0
		Case "KEY"
			$ItemInhoud = $sNAV[3]
			$sTekst = $sNAV[3]
			If $iMax = 4 Then
				$sTekst = $sNAV[3] & "+" & $sNAV[4]
			EndIf
			If $iMax > 4 Then
				$sTekst = $sNAV[3] & "+" & $sNAV[4] & "+" & $sNAV[5]
			EndIf
			$vDubbelKlik = 0
		Case "FILEIMPORT"
			$ItemInhoud = $sNAV[3]
			$vDubbelKlik = 0
		Case "MARKER"
			$ItemInhoud = ""
			$vDubbelKlik = 0
		Case "PARAM"
			$ItemInhoud = $sNAV[3]
			$vDubbelKlik = 0
		Case Else
			$sSchrijfVlag = 0
	EndSwitch

	If $KlikVlag = 1 Then
		MouseClick("left", $ClickPosX, $ClickPosY, 1, 1)
	EndIf
	Local $sKleur = PixelGetColor($ClickPosX, $ClickPosY)

	If $ClickPosX < -10 Then
		$ClickPosX = $ClickPosX + $SizeX
	EndIf
	If $ClickPosX > ($SizeX - 10) Then
		$ClickPosX = $ClickPosX - $SizeX
	EndIf
	$PosX = $ClickPosX
	WachtActief($iDelay)
	$vSleep = Round(TimerDiff($hTimer1) + $iDelay)
	$vTotalTime = $vTotalTime + $vSleep
	ToolTip($ItemType & "-" & $ItemInhoud & " op " & $ClickPosX & "," & $ClickPosY & ", sleep:" & $vSleep, $StartX + 1000, $StartY + 86)

	If $vSleep > 2500 Then
		$vSleep = 2500
	EndIf

	$Record = StringReplace($ItemType & ";" & $sHoofdMenu & ";" & $sSubMenu & ";" & $sTab & ";" & $sSubTab & ";" & $sButton & ";" & $sTekst & ";" & $sActive & ";" & $sMaxTab & ";" & $sKleur & ";" & $PosX & ";" & $PosY & ";" & $vSleep & ";" & $vEditable, " ", "")

	If $vSingleAction = 0 Then
		If $sHoofdMenu = "" Then
			$sSchrijfVlag = 0
		EndIf
	EndIf

	If $vSingleAction = 0 Then
		If $sSubMenu = "" Then
			If $ItemType <> "NAV-HEADER" Then
				$sSchrijfVlag = 0
			EndIf
		EndIf
	EndIf

	If $ClickPosX = $svPosX And $ClickPosY = $svPosY Then
		If $vDubbelKlik = 1 Then
			$sSchrijfVlag = 0
		EndIf
	EndIf
	$svPosX = $ClickPosX
	$svPosY = $ClickPosY

	If $sSchrijfVlag = 1 Then
		$vSchrijfCount = $vSchrijfCount + 1
		FileWriteLine($hFileOpen1, $Record)
		FileFlush($hFileOpen1)
	EndIf

	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & "-" & $sSchrijfVlag & "-File2:" & $sHoofdMenu & ", " & $sSubMenu & ", " & $sTab & ", " & $sSubTab & ", " & $sButton & ", " & $sTekst & ", " & $sActive & ", " & $sMaxTab & ", " & $sKleur & ", " & $PosX & ", " & $PosY & ", " & $vSleep & ", " & $vEditable & @CRLF)
EndFunc   ;==>SplitTekst

Func ChangeDefaults()
	ConsoleWrite("** ChangeDefaults **" & @CRLF)
	If $ExecuteVlag = 1 Then
		MsgBox($MB_OK, "Waarschuwing", "Defaults opslaan kan alleen voordat de startknop is aangeklikt!", 5)
	Else
		Local $wPos = WinGetPos("[ACTIVE]")
		$cFx = $wPos[0]
		$cFy = $wPos[1]
	EndIf

	$hFileOpen0 = FileOpen($sFilePath0, $FO_OVERWRITE)
	Local $vSchermPos = ""
	If _IsChecked($Radio11) Then
		$vSchermPos = $Radio11
	EndIf
	If _IsChecked($Radio12) Then
		$vSchermPos = $Radio12
	EndIf
	If _IsChecked($Checkbox14) Then
		$vSingleAction = 1
	Else
		$vSingleAction = 4
	EndIf

	$textInput01 = GUICtrlRead($Input21, 1)

	FileWriteLine($hFileOpen0, $vSchermPos & @CRLF & $cFx & @CRLF & $cFy & @CRLF & $textInput01 & $vSingleAction & @CRLF)
	FileFlush($hFileOpen0)
	FileClose($hFileOpen0)
EndFunc   ;==>ChangeDefaults

Func EnkeleActie()
	If $ExecuteVlag = 1 Then
		MsgBox($MB_OK, "Waarschuwing", "Een enkele actie kan alleen voordat de startknop is aangeklikt!", 5)
	Else
		$vSingleAction = 1
		GUICtrlSetState($Checkbox14, $GUI_CHECKED)
		InitProg()
	EndIf
EndFunc   ;==>EnkeleActie

Func ReleaseKeys()
	If $pauze == True Then
		ConsoleWrite("Script is paused, not processing key strokes" & @CRLF)
		Return False
	EndIf

	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ": ReleaseKeys" & @CRLF)
	Local $i = 0
	Do
		If _IsPressed("10") Then
			$i = $i + 1
			While _IsPressed("10")
				ToolTip("SHIFT is ingedrukt")
				Sleep(10)
				Send("{SHIFTUP}")
			WEnd
		Else
			$i = $i + 1
		EndIf
		Sleep(10)
	Until $i > 0
	$i = 0
	Do
		If _IsPressed("11") Then
			$i = $i + 1
			While _IsPressed("11")
				ToolTip("CTRL is ingedrukt")
				Sleep(10)
				Send("{CTRLUP}")
			WEnd
		Else
			$i = $i + 1
		EndIf
		Sleep(10)
	Until $i > 0
	$i = 0
	Do
		If _IsPressed("12") Then
			$i = $i + 1
			Send("{ALTDOWN}")
			Sleep(100)
			Send("{ALTUP}")
			Sleep(100)
			While _IsPressed("12")
				ToolTip("ALT is ingedrukt")
				Sleep(10)
				Send("{ALTUP}")
			WEnd
		Else
			$i = $i + 1
		EndIf
		Sleep(10)
	Until $i > 0
EndFunc   ;==>ReleaseKeys

Func mouseOCR($xStart, $yStart, $kleur)
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ": mouseOCR" & @CRLF)
	$xEnd = $xStart + 150
	$yEnd = $yStart + 20
	$OCRString = _OCR($xStart, $yStart, $xEnd, $yEnd, $kleur, 100)
	ConsoleWrite(@ScriptLineNumber & ":" & $OCRString)
	Return $OCRString
EndFunc   ;==>mouseOCR

Func _OCR($left, $top, $right, $bottom, $bkgndColour, $bkgndShadeVariation)
	ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ": _OCR" & @CRLF)
	Const $spaceMult = 0.5
	$startTime = TimerInit()
	ConsoleWrite(@ScriptLineNumber & ":" & $fontFile & @CRLF)
	If Not FileExists($fontFile) Then
		FileWriteLine($fontFile, "@**************************************@")
		FileWriteLine($fontFile, "@****** AutoIt OCR Font Data **********@")
		FileWriteLine($fontFile, "@**************************************@")
	EndIf
	;    ConsoleWrite ("Starting OCR..." & @CRLF)
	;find the left row with coloured pixels
	For $x = $left To $right
		For $y = $top To $bottom
			;scan each vertical line in the scan area looking for pixels different to the background colour
			PixelSearch($x, $y, $x, $y, $bkgndColour, $bkgndShadeVariation)
			If @error = 1 Then ; colour is found
				$left = $x
				ExitLoop 2
			EndIf
		Next
	Next
	ConsoleWrite(@ScriptLineNumber & ": Left=" & $left & @CRLF)
	;find the right row with coloured pixels
	For $x = $right To $left - 1 Step -1
		For $y = $top To $bottom
			;scan each vertical line in the scan area looking for pixels different to the background colour
			PixelSearch($x, $y, $x, $y, $bkgndColour, $bkgndShadeVariation)
			If @error = 1 Then
				$right = $x
				ExitLoop 2
			EndIf
		Next
	Next
	ConsoleWrite(@ScriptLineNumber & ": Rechts=" & $right & @CRLF)
	If $x < $left Then
		; There were no non-background pixels found in the selection, so return
		; Beep()
		ConsoleWriteError("No foreground pixels found. Exiting...")
		Return 0 ; the encompased area is empty
	EndIf

	;find the top row with coloured pixels
	For $y = $top To $bottom
		For $x = $left To $right
			;scan each vertical line in the scan area looking for pixels different to the background colour
			PixelSearch($x, $y, $x, $y, $bkgndColour, $bkgndShadeVariation)
			If @error = 1 Then
				$top = $y
				ExitLoop 2
			EndIf
		Next
	Next
	ConsoleWrite(@ScriptLineNumber & ": Top=" & $top & @CRLF)
	;find the bottom row with coloured pixels
	For $y = $bottom To $top Step -1
		For $x = $left To $right
			;scan each line in the scan area looking for pixels different to the background colour
			PixelSearch($x, $y, $x, $y, $bkgndColour, $bkgndShadeVariation)
			If @error = 1 Then
				$bottom = $y
				ExitLoop 2
			EndIf
		Next
	Next

	;check whether the bottom row is an underline
	If $top = $bottom Then
	;only one row, so assume it's not an underline
		$hasUnderline = False
	Else
		$hasUnderline = True
		For $x = $left To $right
			PixelSearch($x, $y, $x, $y, $bkgndColour, $bkgndShadeVariation)
			If Not @error = 1 Then
				$hasUnderline = False
				ExitLoop
			EndIf
		Next
	EndIf
	ConsoleWrite(@ScriptLineNumber & ":" & $bottom & "," & $top & "," & $bkgndColour & "," & $left & "," & $right & "," & $bkgndShadeVariation & @CRLF)
	;create an array which contains the sum of the pixels in each column for the scan area
	Local $array[$right - $left + 1]
	;arr = 'counter'
	;    $arr = 0    ; registers the current column (same as )
	For $x = $left To $right
		$val = 0 ;reset the value to zero for next vertical line
		$p = 1
		For $y = $top To $bottom
			If $hasUnderline And $y = $bottom Then ExitLoop
			;scan each vertical line in the scan area looking for pixels different to the background colour
			PixelSearch($x, $y, $x, $y, $bkgndColour, $bkgndShadeVariation)
			If @error = 1 Then $val = $val + $p ;create a value of the vertical line based on the pixels present
			$p = $p * 2
		Next
		$array[$x - $left] = $val ;load the value into the array
		;        $arr = $arr+1 ;increase the counter
	Next

	;now delete any blank rows above the letter (effectively shrink the bounding box down to the top of the character)
	; do this by dividing all the values in the character array by the lowest numbered pixel of any column for that character
	$minVal = 999999999
	$charStartPos = 0
	$charEndPos = 0
	$newBlank = True ; The blank variables are used for figuring out the size of spaces in the block
	$blankBlockCount = 0
	$blankColCnt = 0
	For $a = 1 To UBound($array) - 1
		; First go through the array and find the lowest numbered pixel in the current character. Assume each character ends with a blank column
		If $array[$a] > 0 Then ; if the current value is greater than 0 then we haven't got to the end of the character
			; find the lowest bit set to 1 for the current column, and if it's lower than previous set minVal to that bit
			For $i = 0 To 20
				$bitAnd = BitAND($array[$a], 2 ^ $i)
				If $bitAnd > 0 Then
					If $minVal > $bitAnd Then $minVal = $bitAnd
					ExitLoop
				EndIf
			Next
			$newBlank = True
		Else
			; create a running total of blanks - average size will be used for guessing the size of spaces in the text
			If $newBlank Then $blankBlockCount = $blankBlockCount + 1
			$blankColCnt = $blankColCnt + 1
			$newBlank = False
		EndIf
		; If the current column is blank, or is the last column in the array, we must be at the end of the character, so
		;  bitshift each column in the character by the appropriate amount to eliminate blank rows above it.
		If $array[$a] = 0 Or $a = UBound($array) - 1 Then
			$charEndPos = $a - 1
			If $a = UBound($array) - 1 Then $charEndPos = $a ; if we're at the end, then need to include the last column
			For $i = $charStartPos To $charEndPos
				$array[$i] = Int($array[$i] / $minVal)
			Next
			$minVal = 999999999
			$charStartPos = $charEndPos + 2
			$charEndPos = 0
		EndIf
	Next
	$string = _ArrayToString($array) ; NB the default delimiter separating each number in the array is "|"

	; deal with space between characters - assume than more than the average number of columns together are spaces, and give such an artificial value
	$avBlankWidth = ($blankColCnt / $blankBlockCount) * $spaceMult
	ConsoleWrite(@CRLF & $avBlankWidth & @CRLF)
	$spaceSize = ""
	For $a = 0 To $avBlankWidth
		$spaceSize = $spaceSize & "|0"
	Next
	ConsoleWrite(@CRLF & $spaceSize & @CRLF)
	$string = StringReplace($string, $spaceSize, "|0|space|0")
	ConsoleWrite(@CRLF & $string & @CRLF)

	; ensure there is only one blank column dividing letters, and no blanks at the ends:-
	$curLen = 0
	While $curLen <> StringLen($string)
		$curLen = StringLen($string)
		$string = StringReplace($string, "|0|0|", "|0|")
		If StringLeft($string, 2) = "0|" Then $string = StringMid($string, 3)
		If StringRight($string, 2) = "|0" Then $string = StringLeft($string, StringLen($string) - 2)
		$string = StringReplace($string, "||", "|")
	WEnd

	;split string at blank verticals to create an array which contains one character in each member
	$string = StringSplit($string, "|0|", 1)
	$database = FileRead($fontFile) ;read database
	$data = ""


	; now step through each letter to identify it - (one letter is contained in each member of the $string array)
	For $a = 1 To UBound($string) - 1
		$pos = StringInStr($database, "@ " & $string[$a] & " @")

		If $pos Then
			;value already exists in database so read in its corresponding character/s.
			$pos2 = StringInStr($database, "@", 0, -1, $pos - 1) ; first get the position of the preceeding '@'
			If $pos2 < 1 Then $pos2 = 1 ; nee
			$data = $data & StringMid($database, $pos2, ($pos - $pos2)) ; then read in the letter it represents
		Else

			$unrecogBlock = $string[$a]

			;check whether it's made up of a group of previously recognised characters
			$minVal = 999999999
			$charStartPos = 0
			$pos = 0
			$charBlock = StringSplit($string[$a], "|", 2) ; flag 2 = don't use the first element to record the size of the array
			$arrUbound = UBound($charBlock) - 1
			$dataTemp = ""

			; only check
			;            if $arrUbound > 2 Then
			; iterate through all the columns in the block to try and find recognised characters.
			; if one is found then add that to the recognised characters and try and recognise more
			; Block characters must be minimum of 3 columns (0,1,2) (else "," matches lots of things)
			For $charEndPos = 0 To $arrUbound
				$shiftedString = ""

				;                $shiftedArr = bitShiftArr($arrToShift,$amountToShift,$startMemb, $endMemb)
				; find the lowest bit set to 1 for the current column (=array member), and if it's lower than previous set minVal to that bit
				$bitMinVal = bitMin($charBlock[$charEndPos])
				If $minVal > $bitMinVal Then $minVal = $bitMinVal

				; iterate through each column in the current block and bitShift it to eliminate whitespace above the block
				For $i = $charStartPos To $charEndPos
					$shiftedString = $shiftedString & "|" & $charBlock[$i] / (2 ^ $minVal)
				Next

				$shiftedString = StringMid($shiftedString, 2) ; get rid of the leading "|"

				; only check character blocks if they're 3 or more columns (to reduce errors from incorrect matches)
				If $charEndPos > $charStartPos + 1 Then
					$pos = StringInStr($database, "@ " & $shiftedString & " @")
					If $pos Then
						;value already exists in database so read in its corresponding character/s.
						$pos2 = StringInStr($database, "@", 0, -1, $pos - 1) ; first get the position of the preceeding '@'
						If $pos2 < 1 Then $pos2 = 1 ; nee
						$dataTemp = $dataTemp & StringMid($database, $pos2, ($pos - $pos2)) ; then read in the letter it represents

						$minVal = 999999999
						$charStartPos = $charEndPos + 1 ; $charEndPos will be incremented by one at the end of the loop
						If $charStartPos <= $arrUbound Then
							If $charEndPos >= $arrUbound Then $charEndPos = $arrUbound - 1
						Else
							$data = $data & $dataTemp
						EndIf

					EndIf
				EndIf
			Next
			;            EndIf

			; It couldn't completely split the block either, so if not in batch mode ask the user for input
			If $charStartPos <= $arrUbound Then
				;no character recognised in database, so create an image and ask for an input
				If $charStartPos > 0 Then
					; fix during daylight...
					$map = StringSplit(_ArrayToString($charBlock, "|", $charStartPos), "|")
				Else
					$map = StringSplit($string[$a], "|")
				EndIf

				Local $leftine[$bottom - $top + 2]
				For $i = 0 To ($bottom - $top + 1)
					$leftine[$i] = ""
					For $ml = 1 To $map[0]
						If StringIsInt($map[$ml] / 2) = 1 Then
							$leftine[$i] = $leftine[$i] & "~"
						Else
							$leftine[$i] = $leftine[$i] & "#"
						EndIf
						$map[$ml] = Int($map[$ml] / 2)
					Next
				Next
				$image = ""
				For $i = 0 To ($bottom - $top + 1)
					$image = $image & $leftine[$i] & @CRLF
				Next
				If StringInStr($image, "#") Then
					;Beep()
					$data = dataClean($data)
					$dataTemp = dataClean($dataTemp)
					$dataTemp2 = $data
					If StringLen($dataTemp) > 0 Then $dataTemp2 = $data & "_" & $dataTemp & "_"
					$dataTemp2 = dataClean($dataTemp2)
					$letter = InputBox("Unknown Character", "Identify this pattern following" & @CR & "(or just OK to skip identifying it):-" & @CR & $dataTemp2 & @CR & @CR & $image & @CR & @CR & "If you disagree with the guess" & @CR & "(between _s) then type" & @CR & "'@' followed by the correct" & @CR & "character/s", "", "", 200, 500, @DesktopWidth - 200, @DesktopHeight - 500)
					If $letter <> "" Then
						If StringLeft($letter, 1) = "@" And StringLen($letter) > 1 Then
							;The guess was incorrect
							$dataTemp = ""
							$letter = StringMid($letter, 2)
							$pattern = $string[$a]
						Else
							;The guess split letters correctly, so just write the remainder to the database
							$pattern = _ArrayToString($charBlock, "|", $charStartPos)
						EndIf
						; write to the database file, and update the version held in memory, as well as the data string
						FileWriteLine($fontFile, $letter & "@ " & $pattern & " @")
						$database = $database & $letter & "@ " & $pattern & " @" & @CRLF
						$data = $data & $dataTemp & $letter
					ElseIf @error = 1 Then ;The Cancel button was pushed.
						FileWriteLine($fontFile, "err@! " & $unrecogBlock & " !@")
						SetError(-2)
						Return
					Else
						FileWriteLine($fontFile, "err@! " & $unrecogBlock & " !@")
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	$data = dataClean($data)
	ConsoleWrite("Recognised " & StringLen($data) & " characters in " & TimerDiff($startTime) & "msec" & @CRLF)
	ConsoleWrite("Average  " & TimerDiff($startTime) / StringLen($data) & "msec per " & ($right - $left) / StringLen($data) & " x " & $bottom - $top & " pixel character" & @CRLF)
	ToolTip("OcrGen: " & StringLen($data) & " characters in " & TimerDiff($startTime) & "msec", $StartX + 1000, $StartY + 86)
	Return $data
EndFunc   ;==>_OCR

Func dataClean($toClean)
	; Do a search and replace every iteration so $toClean is up to date (and can be used in the inputbox)
	$toClean = StringReplace($toClean, "@", "")
	$toClean = StringReplace($toClean, @CRLF, "")
	$toClean = StringReplace($toClean, @CR, "")
	$toClean = StringReplace($toClean, @LF, "")
	Return $toClean
EndFunc   ;==>dataClean

Func bitMin($numToCheck)
	; returns the location of the lowest bit set
	For $i = 0 To 20
		If BitAND($numToCheck, BitShift(1, -$i)) > 0 Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>bitMin

Func _IsChecked($iControlID)
	Return BitAND(GUICtrlRead($iControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

While 1
	If $pauze == True Then ;dont process any request
	Else

		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				_Exit()
			Case $Button1
				InitProg()
			Case $Button2
				Stop()
			Case $Button3
				Pauze()
			Case $Button4
				_Kalibreren()
			Case $Button5
				ChangeDefaults()
			Case $Button6
				EnkeleActie()
			Case $Button7
				Handleiding()
		EndSwitch
		If _IsPressed("01") And $ExecuteVlag = 1 Then
			Local $bPos = MouseGetPos()
			$ClickPosX = $bPos[0]
			$ClickPosY = $bPos[1]
			If $ClickPosX > $StartX And $ClickPosX < $StartX + $SizeX Then
				If $pauze == True Then
					ConsoleWrite("pauze is enabled, Go nuts with your left mouse" & @CRLF)
				Else
					TrayTip("Waarschuwing", "Alleen de RECHTERMUIS knop gebruiken!", 2)
				EndIf
			EndIf
		EndIf
		If _IsPressed("02") And $ExecuteVlag = 1 Then
			ClipPut("")
			WachtActief($iDelay)
			Local $bPos = MouseGetPos()
			$ClickPosX = $bPos[0]
			$ClickPosY = $bPos[1]
			ConsoleWrite(@ScriptLineNumber & ";" & ExecuteTime() & ":" & $StartX & ", " & $StartY & ", " & $ClickPosX & ", " & $ClickPosY & @CRLF)
			If $ClickPosX > $StartX And $ClickPosX < $StartX + $SizeX Then
				Start()
			EndIf
		EndIf

		#include <KeyLogger.au3>
		Sleep(100)
	EndIf
WEnd

Func _Exit()
	_WinAPI_DeleteObject($hHBitmap)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
	GUIDelete()
	Exit
EndFunc   ;==>_Exit
