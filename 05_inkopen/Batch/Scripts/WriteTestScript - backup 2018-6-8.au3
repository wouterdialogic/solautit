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

OnAutoItExitRegister("ReleaseKeys")
Opt("MouseClickDelay", 250)
Opt("MouseClickDownDelay", 250)

HotKeySet("!c", "CopyClipboard"); ALT + c
HotKeySet("+!c", "QueryBuilder"); SHIFT + ALT + c
HotKeySet("+!i", "ScriptImport"); SHIFT + ALT + i
HotKeySet("+!m", "Marker"); SHIFT + ALT + m
HotKeySet("+!s", "Stop"); SHIFT + ALT + s
HotKeySet("+!p", "ScreenShot"); SHIFT + ALT + p

Global $sFilePath0 = @MyDocumentsDir & "\Batch\Settings\WriteTestScript.ini"
Global $ArtikelArray0 = FileReadToArray($sFilePath0)
Global $iCountLines0 = _FileCountLines($sFilePath0)
Global $cFx = $ArtikelArray0[1]
Global $cFy = $ArtikelArray0[2]
Global $ColorArray[25] = ["0xF5CB98", "0x91CFFF", "0xE7EAEE", "0xFFFFFF", "0xB33131", "0x6C99B3", "0xB8BDC3", "0x5692E1", "0xE6E9ED", "0xF1F2F4", "0xDB8270", "0xB5DB49", "0x75407C", "0x21608C", "0xF0F0F0", "0x8A8A8A", "0xE04343", "0xC75050", "0x7C8FB3", "0x2F84CF", "0xE81123", "0x4F93C9", "0xA9CDFA", "0x3693D9", "0xBF2020"]
Global $TekstArray[25] = ["Accountmanagers", "Artikelen", "Artikel detail", "Overig detail", "Annuleer", "Verrekijker", "Inactieve tab", "Detail knopje", "Actieve tab", "Tab achtergrond", "Window annuleer", "Info icoon groen", "Solidis logo test", "Solidis logo branch", "Witte kruisje", "Grijze driehoekje", "Annuleer w8 Actief", "Annuleer w8 Inactief", "Actief NAV-ITEM", "Pijltjes", "Annuleer w10", "Info icoon blauw", "Blauwe listview regel", "Mini dialoog", "Error scherm"]
;0x75407C [12]-Solidis logo test
;0x21608C [13]-Solidis logo branch

$Form1 = GUICreate("Test script recorder", 750, 400, $cFx, $cFy)
$Group0 = GUICtrlCreateGroup("", 8, 17, 325, 100)
$Label01 = GUICtrlCreateLabel("Klik op de startknop en selecteer met de rechtermuisknop", 32, 40, 300, 17)
$Label02 = GUICtrlCreateLabel("de objecten om aan het test bestand toe te voegen.", 32, 55, 300, 17)
$Label03 = GUICtrlCreateLabel("ALT + c is copy-paste input ", 32, 70, 300, 17)
$Label03 = GUICtrlCreateLabel("CTRL + ALT + c is run query in script", 32, 85, 300, 17)
$Edit01 = GUICtrlCreateEdit("", 350, 23, 350, 325)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group1 = GUICtrlCreateGroup("Scherm", 8, 120, 325, 57)
$Radio11 = GUICtrlCreateRadio("Links", 24, 148, 60, 25)
$Radio12 = GUICtrlCreateRadio("Rechts", 96, 148, 60, 25)
GUICtrlSetState($ArtikelArray0[0], $GUI_CHECKED)
$Label10 = GUICtrlCreateLabel("StartPosX", 180, 134, 60, 17)
$Label11 = GUICtrlCreateLabel("0", 244, 134, 60, 17)
$Label12 = GUICtrlCreateLabel("SizeX", 180, 150, 60, 17)
$Label13 = GUICtrlCreateLabel("0", 244, 150, 60, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Edit20 = GUICtrlCreateEdit("", 8, 185, 325, 135)
$Input21 = GUICtrlCreateInput($ArtikelArray0[3], 8, 330, 325, 17)

$Button1 = GUICtrlCreateButton("Start", 35, 360, 75, 25)
$Button2 = GUICtrlCreateButton("Opslaan", 120, 360, 75, 25)
$Button3 = GUICtrlCreateButton("Pauze", 205, 360, 75, 25)
$Button4 = GUICtrlCreateButton("Kalibreren", 440, 360, 75, 25)
$Button5 = GUICtrlCreateButton("Standaard", 525, 360, 75, 25)
$Button6 = GUICtrlCreateButton("Enkele actie", 610, 360, 75, 25)

GUISetState(@SW_SHOW)
Send("{RIGHT}")

Global $fPaused, $ClickPosX, $ClickPosY, $svPosX, $svPosY, $xPos, $yPos, $clipBoardGet, $svRecord, $svClipBoardGet, $StartX, $StartY, $SizeX, $SizeY, $EindX, $EindY = ""
Global $ItemType, $ItemInhoud, $sHoofdMenu, $sSubMenu, $sTab, $sSubTab, $sButton, $sTekst, $sActive, $sMaxTab, $vOmgeving = ""
Global $iDelay = 250
Global $ExecuteVlag, $vSleep, $hTimer0, $hTimer1, $vTotalTime, $vSchrijfCount, $vTimeDiff, $iClipboardget, $vSingleAction, $iScreenCount, $FoutVlag = 0
Global $aClipboardGet[25]
Global $hTimer = TimerInit()

MouseClick("left", $cFx + 196, $cFy + 333, 1)
MouseMove($cFx + 70, $cFy + 380, 5)

Func InitProg()
	$ExecuteVlag = 1
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & "InitProg" & @CRLF)
	$hTimer0 = TimerInit()
	Global $hWnd = WinWait("zegro - U bent ingelogd als Distri Nl || Nederland - Zegro - Solidis", "", 5)
	If $hWnd = 0 Then
		Global $hWnd = WinWait("zegro - U bent ingelogd als Distri En || Nederland - Zegro - Solidis", "", 5)
		If $hWnd = 0 Then
			MsgBox($MB_SYSTEMMODAL, "Error!!", "Solidis scherm niet gevonden!!", 3)
			Exit
		EndIf
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
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & $SizeX & "," & $SizeY & "," & $StartX & "," & $StartY & "," & $EindX & "," & $EindY & "," & @CRLF)
	Local $textInput01 = GUICtrlRead($Input21, 1)
	If $vSingleAction = 0 Then
		$svRecord = "Klik met de rechtermuisknop op een HOOFDmenu" & @CRLF
		GUICtrlSetData($Edit01, $svRecord)
	EndIf
	ConsoleWrite("Bestandsnaam:" & $textInput01 & @CRLF)
	Global Const $sFilePath1 = $textInput01
	Global $hFileOpen1 = FileOpen($sFilePath1, $FO_OVERWRITE)
	Local $vFilePath = StringSplit($sFilePath1, @MyDocumentsDir & "\Batch\", $STR_ENTIRESPLIT)
	Global $vFileName = StringTrimRight($vFilePath[2], 4)
	Global Const $sFilePath3 = @MyDocumentsDir & "\Batch\Input\" & $vFileName & ".txt"
	Global $hFileOpen3 = FileOpen($sFilePath3, $FO_OVERWRITE)
EndFunc   ;==>InitProg

Func Start()
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & "Start" & @CRLF)
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
				MsgBox(0, "Hoofdmenu is nog onbekend", "Klik eerst op een hoofdmenu en daarna op een submenu om een flow te starten")
			EndIf
		Else
			If $sSubMenu = "" Then
				If $vSingleAction = 0 Then
					$svRecord = $svRecord & "Klik met de rechtermuisknop op een SUBmenu" & @CRLF
					GUICtrlSetData($Edit01, $svRecord)
					If StringLeft($clipBoardGet, 11) <> "~NAV-HEADER" Then
						MsgBox(0, "Submenu is nog onbekend", "Klik eerst op een submenu om een flow te starten")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Start

Func Stop()
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & "Stop" & @CRLF)
	$stopScript = MsgBox($MB_YESNO, "Testscript opslaan", "Wilt u stoppen!", 5)
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
		Exit
	EndIf
EndFunc   ;==>Stop

Func Pauze()
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & "Pauze" & @CRLF)
	$fPaused = Not $fPaused
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & "Gepauzeerd, klik met muis om verder te gaan" & @CRLF)
	Local $i = 0
	Do
		If _IsPressed("01") Then
			ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & "Active" & @CRLF)
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
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & "- Kalibratie verwerkt op: " & $StartX & "," & $StartY & @CRLF)
EndFunc   ;==>_Kalibreren

Func CopyClipboard()
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
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & "-" & $i & "- CopyClipboard:" & $clipBoardGet & @CRLF)
	ToolTip("Clipboard bevat: " & $clipBoardGet, $StartX + 1000, $StartY + 86)
	SplitTekst($vClipBoardGet, $ClickPosX, $ClickPosY, 0)
EndFunc   ;==>CopyClipboard

Func QueryBuilder()
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
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & "-" & "CopyClipboard:" & $clipBoardGet & @CRLF)
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
	Local $iPID = ShellExecute(@MyDocumentsDir & "\Batch\Scripts\")
	$clipBoardGet = InputBox("Invoer gewenst", "Geef het bestand op wat je wilt importeren", @MyDocumentsDir & "\Batch\Scripts\")
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
EndFunc   ;==>BreakPoint

Func ScreenShot()
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
			_ScreenCapture_Capture(@MyDocumentsDir & "\Batch\ScreenShot_" & $vFileName & $iScreenCount & ".jpg", $iLeft, $iTop, $iRight, $iBottom)
			SoundPlay(@MyDocumentsDir & "\Batch\Settings\camera-shutter-click-07.wav")
			While _IsPressed("02")
				Sleep(10)
			WEnd
		EndIf
		Sleep(10)
	Until $i > 0
EndFunc   ;==>ScreenShot

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
EndFunc

Func ConvertToTime($nr_sec)
	$sec2time_hour = Int($nr_sec / 3600)
	$sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc   ;==>ConvertToTime

Func SplitTekst($Tekst, $PosX, $PosY, $KlikVlag)
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & "SplitTekst" & @CRLF)
	$hTimer1 = TimerInit() ; Begin the timer and store the handle in a variable.
	WachtActief($iDelay)
	Local $tTekst = StringReplace($Tekst, " ", "")
	Local $lsTekst = StringReplace($tTekst, "#", " ")
	$svRecord = $svRecord & $lsTekst & @CRLF
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & $Tekst & ", " & $lsTekst & @CRLF)
	GUICtrlSetData($Edit01, $svRecord)
	$sNAV = StringSplit($lsTekst, "~:")
	$iMax = UBound($sNAV) - 1
	$ItemType = $sNAV[2]
	For $i = 1 To $iMax
		ConsoleWrite($sNAV[$i] & " " & $i & ":|")
	Next
	ConsoleWrite(@CRLF)

	Local $sSchrijfVlag = 1
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
		Case "INPUT"
			$ItemInhoud = $sNAV[3]
			$sTekst = $sNAV[3]
		Case "KEY"
			$ItemInhoud = $sNAV[3]
			$sTekst = $sNAV[3]
			If $iMax = 4 Then
				$sTekst = $sNAV[3] & "+" & $sNAV[4]
			EndIf
			If $iMax > 4 Then
				$sTekst = $sNAV[3] & "+" & $sNAV[4] & "+" & $sNAV[5]
			EndIf
		Case "FILEIMPORT"
			$ItemInhoud = $sNAV[3]
		Case "MARKER"
			$ItemInhoud = ""
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

	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & $vSleep & @CRLF)
	If $vSleep > 2500 Then
		$vSleep = 2500
	EndIf

	$Record = StringReplace($ItemType & ";" & $sHoofdMenu & ";" & $sSubMenu & ";" & $sTab & ";" & $sSubTab & ";" & $sButton & ";" & $sTekst & ";" & $sActive & ";" & $sMaxTab & ";" & $sKleur & ";" & $PosX & ";" & $PosY & ";" & $vSleep & ";" & $vEditable, " ", "")

	If $sHoofdMenu = "" Then
		$sSchrijfVlag = 0
	EndIf

	If $sSubMenu = "" Then
		If $ItemType <> "NAV-HEADER" Then
			$sSchrijfVlag = 0
		EndIf
	EndIf

	If $ClickPosX = $svPosX And $ClickPosY = $svPosY Then
		If $ItemType <> "INPUT" And $ItemType <> "KEY" And $ItemType <> "FILEIMPORT" And $ItemType <> "MARKER" Then
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

	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & "-" & $sSchrijfVlag & "-File2:" & $sHoofdMenu & ", " & $sSubMenu & ", " & $sTab & ", " & $sSubTab & ", " & $sButton & ", " & $sTekst & ", " & $sActive & ", " & $sMaxTab & ", " & $sKleur & ", " & $PosX & ", " & $PosY & ", " & $vSleep & ", " & $vEditable & @CRLF)
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

	Global $hFileOpen0 = FileOpen($sFilePath0, $FO_OVERWRITE)
	Local $vSchermPos = ""
	If _IsChecked($Radio11) Then
		$vSchermPos = $Radio11
	EndIf
	If _IsChecked($Radio12) Then
		$vSchermPos = $Radio12
	EndIf
	$textInput01 = GUICtrlRead($Input21, 1)

	FileWriteLine($hFileOpen0, $vSchermPos & @CRLF & $cFx & @CRLF & $cFy & @CRLF & $textInput01 & @CRLF)
	FileFlush($hFileOpen0)
	FileClose($hFileOpen0)
EndFunc   ;==>ChangeDefaults

Func EnkeleActie()
	If $ExecuteVlag = 1 Then
		MsgBox($MB_OK, "Waarschuwing", "Een enkele actie kan alleen voordat de startknop is aangeklikt!", 5)
	Else
		$vSingleAction = 1
		InitProg()
	EndIf
EndFunc   ;==>EnkeleActie

Func ReleaseKeys()
	ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ": ReleaseKeys" & @CRLF)
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

Func _IsChecked($iControlID)
	Return BitAND(GUICtrlRead($iControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
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
	EndSwitch
	If _IsPressed("01") And $ExecuteVlag = 1 Then
		Local $bPos = MouseGetPos()
		$ClickPosX = $bPos[0]
		$ClickPosY = $bPos[1]
		If $ClickPosX > $StartX And $ClickPosX < $StartX + $SizeX Then
			$stopScript = MsgBox($MB_OK, "Waarschuwing", "Alleen de RECHTERMUIS knop gebruiken!")
			Stop()
		EndIf
	EndIf
	If _IsPressed("02") And $ExecuteVlag = 1 Then
		ClipPut("")
		WachtActief($iDelay)
		Local $bPos = MouseGetPos()
		$ClickPosX = $bPos[0]
		$ClickPosY = $bPos[1]
		ConsoleWrite(@ScriptLineNumber  &  ";" & ExecuteTime() & ":" & $StartX & ", " & $StartY & ", " & $ClickPosX & ", " & $ClickPosY & @CRLF)
		If $ClickPosX > $StartX And $ClickPosX < $StartX + $SizeX Then
			Start()
		EndIf
	EndIf

	#include <KeyLogger.au3>
	Sleep(10)
WEnd
