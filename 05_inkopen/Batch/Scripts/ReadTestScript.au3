#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <Memory.au3>
#include <ColorPicker.au3>

Opt("MouseClickDelay", 250) ;250 milliseconds
Opt("MouseClickDownDelay", 500) ;0,5 second

HotKeySet("!s", "Stop")
HotKeySet("!p", "Pauze")
HotKeySet("+!m", "SetMarker"); SHIFT + ALT + m
HotKeySet("+!j", "ReadJavaConsole"); SHIFT + ALT + j

Global $sFilePath0 = @MyDocumentsDir & "\Batch\Settings\ReadTestScript.ini"
Global $ArtikelArray0 = FileReadToArray($sFilePath0)
Global $iCountLines0 = _FileCountLines($sFilePath0)
Global $cFx = $ArtikelArray0[1]
Global $cFy = $ArtikelArray0[2]
Global $sFilePath2 = @MyDocumentsDir & "\Batch\Log\"

$Form1 = GUICreate("Test script reader", 1000, 700, $cFx, $cFy, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_TOPMOST))
$Group0 = GUICtrlCreateGroup("", 8, 35, 375, 65)
$Label1 = GUICtrlCreateLabel("Drag and drop de te lezen scriptbestanden in het lege vak ==>", 32, 50, 300, 17)
$Label2 = GUICtrlCreateLabel("Klik op de startknop om script uit te voeren", 32, 75, 300, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Label40 = GUICtrlCreateLabel("Speed", 32, 165, 50, 17)
$Input41 = GUICtrlCreateInput($ArtikelArray0[4], 96, 165, 50, 17)

$Label3 = GUICtrlCreateLabel("Sleep hier je testscripts in juiste volgorde", 500, 23, 300, 17)
$Edit01 = GUICtrlCreateEdit("", 500, 41, 480, 183); Bestanden drag and drop vak
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Edit02 = GUICtrlCreateEdit("", 500, 235, 480, 450); Log vak
$Edit03 = GUICtrlCreateEdit("", 395, 41, 100, 183); Input en key vak

$Group1 = GUICtrlCreateGroup("Scherm", 8, 103, 161, 55)
$Radio11 = GUICtrlCreateRadio("Links", 24, 127, 60, 25)
$Radio12 = GUICtrlCreateRadio("Rechts", 96, 127, 60, 25)
GUICtrlSetState($ArtikelArray0[0], $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group2 = GUICtrlCreateGroup("Time frame", 174, 103, 210, 80)
$Label20 = GUICtrlCreateLabel("Verwachte tijdsduur:", 190, 127, 100, 17)
$Input20 = GUICtrlCreateInput("", 295, 122, 65, 17)
$Label21 = GUICtrlCreateLabel("Werkelijke tijdsduur:", 190, 155, 100, 17)
$Input21 = GUICtrlCreateInput("", 295, 155, 65, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Label30 = GUICtrlCreateLabel("SQL Limit", 32, 198, 50, 17)
$Input31 = GUICtrlCreateInput($ArtikelArray0[3], 96, 198, 50, 17)
$Checkbox32 = GUICtrlCreateCheckbox("Valideren", 190, 198, 97, 17)
GUICtrlSetState(-1, $ArtikelArray0[5])
$Checkbox33 = GUICtrlCreateCheckbox("Uitvoer", 290, 198, 97, 17)
GUICtrlSetState(-1, $ArtikelArray0[6])

$Button1 = GUICtrlCreateButton("Start", 35, 660, 75, 25)
$Button2 = GUICtrlCreateButton("Stop", 120, 660, 75, 25)
$Button3 = GUICtrlCreateButton("Pauze", 205, 660, 75, 25)
$Button4 = GUICtrlCreateButton("Test", 290, 660, 75, 25)
$Button5 = GUICtrlCreateButton("Standaard", 375, 660, 75, 25)

GUISetState(@SW_SHOW)
Send("{RIGHT}")

Global $sFilePath1, $hFileOpen1, $iCountLines1, $Label10, $Label11, $ColorLabel11, $ColorLabel12, $ColorLabel13, $ColorLabel14, $ColorLabel15 = ""
Global $fPaused, $ClickPosX, $ClickPosY, $svPosX, $svPosY, $xPos, $yPos, $PosX, $PosY, $StartX, $StartY, $clipBoardGet = ""
Global $ItemType, $ItemInhoud, $sHoofdMenu, $sSubMenu, $sTab, $sSubTab, $sButton, $sTekst, $sActive, $sMaxTab, $svRecord, $svKeyLog, $vOmgeving = ""
Global $iDelay = 250
Global $gaDropFiles[1], $str, $Voortgang = ""
Global $vSleep, $iMax, $vXc, $vYc, $ErrorVlag, $ExecuteVlag, $hTimer1, $vTotalTime, $vLimit, $FoutVlag = 0
Global Const $cGrijs = "0xC0C0C0"
Global Const $cGroen = "0x00FF00"
Global Const $cBlauw = "0x00CCFF"
Global Const $cGeel = "0xFFCC00"
Global Const $cOranje = "0xFF6600"
Global Const $cRood = "0xFF0000"
Global $ColorArray[25] = ["0xF5CB98", "0x91CFFF", "0xE7EAEE", "0xFFFFFF", "0xB33131", "0x6C99B3", "0xB8BDC3", "0x5692E1", "0xE6E9ED", "0xF1F2F4", "0xDB8270", "0xB5DB49", "0x75407C", "0x21608C", "0xF0F0F0", "0x8A8A8A", "0xE04343", "0xC75050", "0x7C8FB3", "0x2F84CF", "0xE81123", "0x4F93C9", "0xA9CDFA", "0x3693D9", "0xBF2020"]
Global $TekstArray[25] = ["Accountmanagers", "Artikelen", "Artikel detail", "Overig detail", "Annuleer", "Verrekijker", "Inactieve tab", "Detail knopje", "Actieve tab", "Tab achtergrond", "Window annuleer", "Info icoon groen", "Solidis logo test", "Solidis logo branch", "Witte kruisje", "Grijze driehoekje", "Annuleer w8 Actief", "Annuleer w8 Inactief", "Actief NAV-ITEM", "Pijltjes", "Annuleer w10", "Info icoon blauw", "Blauwe listview regel", "Mini dialoog", "Error scherm"]
;0x75407C [12]-Solidis logo test
;0x21608C [13]-Solidis logo branch

ShellExecute(@MyDocumentsDir & "\Batch")
GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")

Func InitProg()
	ConsoleWrite(@ScriptLineNumber & ":" & "InitProg" & @CRLF)
	Local $textControle = GUICtrlRead($Edit01, 1)
	If StringLeft($textControle, 2) <> @HomeDrive Then
		MsgBox($MB_OK, "Warning", "Geen of verkeerde bestanden toegevoegd!!", 3)
		Return False
	EndIf
	$ExecuteVlag = 1
	$vYc = 230
	$Group2 = GUICtrlCreateGroup("Voortgang", 8, $vYc, 425, 420)
	$vYc = $vYc + 20
	$Voortgang = GUICtrlCreateProgress(18, $vYc, 400, 25)
	$Label11 = GUICtrlCreateLabel("", 205, $vYc + 4, 30, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$vYc = $vYc + 20
	;Scherm grootte en positie bepalen van active scherm
	Global $hWnd = WinWait("zegro - U bent ingelogd als Distri Nl || Nederland - Zegro - Solidis", "", 5)
	If $hWnd = 0 Then
		Global $hWnd = WinWait("zegro - U bent ingelogd als Distri En || Nederland - Zegro - Solidis", "", 5)
		If $hWnd = 0 Then
			MsgBox($MB_SYSTEMMODAL, "Error!!", "Solidis scherm niet gevonden!!", 3)
			Exit
		EndIf
	EndIf
	WinActivate($hWnd)
	WachtActief(1000)
	WinSetState($hWnd, "", @SW_MAXIMIZE)
	Local $aPos = WinGetPos($hWnd)
	Local $hPos = WinGetClientSize($hWnd)
	$SizeX = $hPos[0]
	$SizeY = $hPos[1]
	$StartX = $aPos[0]
	$StartY = $aPos[1]
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
	;_Kalibreren()
	Global $vSpeed = GUICtrlRead($Input41, 1)
	If $StartX < $cFx Then
		GUICtrlSetState($Radio11, $GUI_CHECKED)
	Else
		GUICtrlSetState($Radio12, $GUI_CHECKED)
	EndIf
EndFunc   ;==>InitProg

Func Start()
	ConsoleWrite(@ScriptLineNumber & ":" & "Start" & @CRLF)
	Local $textInput01 = GUICtrlRead($Edit01, 1)
	$vSqlFileCount = StringCount($textInput01, ".sql")
	Local $sFiles = StringSplit($textInput01, @CRLF, $STR_ENTIRESPLIT)
	ConsoleWrite(@ScriptLineNumber & ": " & UBound($sFiles) - 2 & " bestanden, waarvan " & $vSqlFileCount & " SQL en " & UBound($sFiles) - 2 - $vSqlFileCount & " overige bestanden" & @CRLF)
	For $f = 1 To UBound($sFiles) - 1
		$sFilePath1 = $sFiles[$f]
		If $sFilePath1 <> @CRLF Then
			Local $aFileList = _FileListToArray($sFilePath1, "*.csv")
			If @error = 1 Then
				ConsoleWrite(@ScriptLineNumber & ":" & $sFilePath1 & " Path is geen map" & @CRLF)
				If StringInStr($sFilePath1, ".csv") Then
					$hTimer1 = TimerInit()
					VerwerkenBestand($f)
					Local $vTimeDiff = TimerDiff($hTimer1)
					GUICtrlSetData($Input21, ConvertToTime(Round(($vTimeDiff + 500) / 1000)))
					ConsoleWrite(@ScriptLineNumber & ":" & $hTimer1 & ", " & $Input21 & ", " & $vTimeDiff & @CRLF)
					WachtActief(500)
				EndIf
				If StringInStr($sFilePath1, ".sql") Then
					$vLimit = GUICtrlRead($Input31, 1)
					ReadQuery($f, "OpenReadClose", $vLimit)
					WachtActief(500)
				EndIf
			Else
				If @error = 4 Then
					ConsoleWrite(@ScriptLineNumber & ":" & $sFilePath1 & " Map bevat geen bestanden of bestand is geen csv" & @CRLF)
				Else
					ConsoleWrite(@ScriptLineNumber & ":" & "Path is een map, afzonderlijke bestanden worden verwerkt" & @CRLF)
					For $x = 1 To UBound($aFileList) - 1
						$sFilePath1 = $sFilePath1 & "\" & $aFileList[$x]
						$hTimer1 = TimerInit()
						VerwerkenBestand($f + $x)
						GUICtrlSetData($Input21, ConvertToTime(Round(TimerDiff($hTimer1 / 1000))))
						WachtActief(500)
					Next
				EndIf
			EndIf
		EndIf
	Next
	Local $tKlaar = MsgBox($MB_YESNO, "Klaar!!", "Script is klaar!!, wilt u het script beeindigen?", $hWnd)
	If $tKlaar = $IDYES Then
		Stop()
	EndIf
EndFunc   ;==>Start

Func Stop()
	ConsoleWrite(@ScriptLineNumber & ":" & "Stop" & @CRLF)
	FileClose($hFileOpen1)
	Exit
EndFunc   ;==>Stop

Func Pauze()
	ConsoleWrite(@ScriptLineNumber & ":" & "Pauze" & @CRLF)
	ToolTip("Script gepauzeerd, klik met de linkermuisknop om script te hervatten!")
	$fPaused = Not $fPaused
	ConsoleWrite(@ScriptLineNumber & "Gepauzeerd, klik met muis om verder te gaan" & @CRLF)
	Local $i = 0
	Do
		If _IsPressed("01") Then
			$i = $i + 1
			While _IsPressed("01")
				ToolTip("Linkermuisknop is ingedrukt")
				Sleep(10)
			WEnd
		EndIf
		Sleep(10)
	Until $i > 0
	ToolTip("Pauze opgeheven, script gaat verder!")
	ConsoleWrite(@ScriptLineNumber & "- Pauze opgeheven! " & @CRLF)
EndFunc

Func _Kalibreren()
	Local $PuntjeOpIx = 75
	Local $PuntjeOpIy = 135
	MouseClick("right", $StartX + $PuntjeOpIx, $StartY + $PuntjeOpIy, 1)
	If ClipGet() <> "~NAV-ITEM: Artikelen" Then
		MsgBox($MB_OK, "Waarschuwing", "Solidis scherm staat niet goed. Klik precies op het puntje van de i in het submenu artikelen!", 3)
		Local $i = 0
		Do
			If _IsPressed("01") Then
				Local $vPos = MouseGetPos()
				MouseClick("right", $vPos[0], $vPos[1], 1)
				Sleep($iDelay)
				If ClipGet() = "~NAV-ITEM: Artikelen" Then
					MsgBox($MB_OK, "Info", "Oke, Solidis scherm staat nu goed", 3)
					$i = $i + 1
				Else
					MsgBox($MB_OK, "Waarschuwing", "Je hebt niet goed geklikt. Klik precies op het puntje van de i in het submenu artikelen!", 3)
				EndIf
			EndIf
		Until $i > 0
		$StartX = $vPos[0] - $PuntjeOpIx
		$StartY = $vPos[1] - $PuntjeOpIy
	EndIf
	ConsoleWrite(@ScriptLineNumber & "- Kalibratie verwerkt op: " & $StartX & "," & $StartY & @CRLF)
EndFunc   ;==>_Kalibreren

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
	Sleep($iWacht)
	Local $iCursor = MouseGetCursor()
	If $iCursor = 15 Then
		$iWacht = $iWacht * 2
	EndIf
	Do
		$iCursor = MouseGetCursor()
		Sleep($iWacht)
	Until $iCursor <> 15
EndFunc   ;==>WachtActief

Func VerwerkenBestand($f)
	$hFileOpen1 = FileOpen($sFilePath1, $FO_READ)
	$iCountLines1 = _FileCountLines($sFilePath1)
	$iProgressPos = 100 / $iCountLines1
	ConsoleWrite(@ScriptLineNumber & ":" & "VerwerkenBestand " & $f & ":" & $sFilePath1 & " met " & $iCountLines1 & " records" & @CRLF)
	$vXc = 320
	$vYc = $vYc + 20
	$Label10 = GUICtrlCreateLabel($sFilePath1, 18, $vYc, 300, 17)
	$ColorLabel11 = GUICtrlCreateLabel("", $vXc, $vYc, 17, 17)
	GUICtrlSetBkColor($ColorLabel11, $cGrijs)
	$vXc = $vXc + 20
	$ColorLabel12 = GUICtrlCreateLabel("", $vXc, $vYc, 17, 17)
	GUICtrlSetBkColor($ColorLabel12, $cGrijs)
	$vXc = $vXc + 20
	$ColorLabel13 = GUICtrlCreateLabel("", $vXc, $vYc, 17, 17)
	GUICtrlSetBkColor($ColorLabel13, $cGrijs)
	$vXc = $vXc + 20
	$ColorLabel14 = GUICtrlCreateLabel("", $vXc, $vYc, 17, 17)
	GUICtrlSetBkColor($ColorLabel14, $cGrijs)
	$vXc = $vXc + 20
	$ColorLabel15 = GUICtrlCreateLabel("", $vXc, $vYc, 17, 17)
	GUICtrlSetBkColor($ColorLabel15, $cGrijs)
	For $i = 1 To $iCountLines1
		$vProgressTot = Round($i * $iProgressPos, 1)
		If $vProgressTot > 90 Then
			$vProgressTot = 100
			If $ErrorVlag > 0 Then
				ReadJavaConsole()
				GUICtrlCreatePic(@HomePath & "\Pictures\Cancel.jpg", $vXc + 40, $vYc, 17, 17)
			Else
				GUICtrlSetBkColor($ColorLabel11, $cGroen)
				GUICtrlCreatePic(@HomePath & "\Pictures\Check.jpg", $vXc + 40, $vYc, 17, 17)
			EndIf
		EndIf
		GUICtrlSetData($Voortgang, $vProgressTot)
		GUICtrlSetData($Label11, $vProgressTot & "%")
		If $vProgressTot > 40 Then
			GUICtrlSetBkColor($Label11, $cGrijs)
		EndIf
		$sRecord = FileReadLine($hFileOpen1, $i)
		$sFields = StringSplit($sRecord, ";")
		$iMax = UBound($sFields) - 1
		;For $x = 1 To $iMax
		;	ConsoleWrite($x & ":" & $sFields[$x] & "| ")
		;Next
		$svRecord = $svRecord & $sRecord & @CRLF
		GUICtrlSetData($Edit02, $svRecord)
		LezenRecord($sFields, $i)
		VerwerkenRecord($ItemType, $ItemInhoud)
	Next
EndFunc   ;==>VerwerkenBestand

Func LezenRecord($sNAV, $i)
	ConsoleWrite(@ScriptLineNumber & ":" & "LezenRecord " & $i & " met " & $iMax & " velden" & @CRLF)
	$vOverslaanVlag = 0
	$ItemType = $sNAV[1]
	Switch $ItemType
		Case "NAV-HEADER"
			$ItemInhoud = $sNAV[2]
			$sHoofdMenu = $sNAV[2]
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
			$ItemInhoud = $sNAV[4]
			$sTab = $sNAV[4]
			$sSubTab = ""
			$sButton = ""
			$sTekst = $sNAV[7]
			$sActive = $sNAV[8]
			$sMaxTab = $sNAV[9]
		Case "SUB-TAB"
			$ItemInhoud = $sNAV[5]
			$sSubTab = $sNAV[5]
			$sButton = ""
			$sTekst = $sNAV[7]
			$sActive = $sNAV[8]
			$sMaxTab = $sNAV[9]
		Case "BUTTON"
			$ItemInhoud = $sNAV[6]
			$sButton = $sNAV[6]
			$sTekst = $sNAV[7]
		Case "LABEL"
			$ItemInhoud = $sNAV[6]
			$sButton = $sNAV[6]
			$sTekst = $sNAV[7]
		Case "FIELD"
			$ItemInhoud = $sNAV[6]
			$sButton = $sNAV[6]
			$sTekst = $sNAV[7]
		Case "INPUT"
			$ItemInhoud = $sNAV[7]
			$sButton = $sNAV[6]
			$sTekst = $sNAV[7]
		Case "KEY"
			$ItemInhoud = $sNAV[7]
			$sButton = $sNAV[6]
			$sTekst = $sNAV[7]
		Case "MARKER"
			$ItemInhoud = $sNAV[2]
			$vOverslaanVlag = 1
		Case "FILEIMPORT"
			$ItemInhoud = $sNAV[2]
			$vOverslaanVlag = 1
		Case "SLUIT"
			$ItemInhoud = $sNAV[2]
			$vOverslaanVlag = 1
		Case Else
			GUICtrlSetBkColor($ColorLabel15, $COLOR_RED)
			ReadJavaConsole()
			$ErrorVlag = 9
	EndSwitch
	If $vOverslaanVlag = 0 Then
		$sKleur = $sNAV[10]
		If StringIsInt($sNAV[11]) = 1 Then
			$PosX = $sNAV[11]
			$ClickPosX = $StartX + $PosX + 8
			$PosX = $ClickPosX
		EndIf
		If StringIsInt($sNAV[12]) = 1 Then
			$PosY = $sNAV[12]
			$ClickPosY = $StartY + $PosY
		EndIf
		$vSleep = $sNAV[13] - $vSpeed
		$vEditable = $sNAV[14]
		ToolTip($ItemType & "-" & $ItemInhoud & " op " & $PosX & "," & $PosY & ", sleep:" & $vSleep & "," & $vEditable, $StartX + 1000, $StartY + 86)
		ConsoleWrite(@ScriptLineNumber & ":" & $ItemType & "," & $sHoofdMenu & "," & $sSubMenu & "," & $sTab & "," & $sSubTab & "," & $sButton & "," & $sTekst & "," & $sActive & "," & $sMaxTab & "," & $sKleur & "," & $PosX & "," & $PosY & "," & $vSleep & "," & $vEditable & @CRLF)
	EndIf
EndFunc   ;==>LezenRecord

Func VerwerkenRecord($ItemType, $ItemInhoud)
	ConsoleWrite(@ScriptLineNumber & ":" & "VerwerkenRecord, veld:" & $ItemType & " met waarde:" & $ItemInhoud & @CRLF)
	Switch $ItemType
		Case "INPUT"
			If StringLeft($ItemInhoud, 1) = "!" Or StringLeft($ItemInhoud, 1) = "^" Or StringLeft($ItemInhoud, 1) = "+" Then
				Send($ItemInhoud, $SEND_RAW)
			Else
				Send($ItemInhoud)
			EndIf
			$svKeyLog = $svKeyLog & "INPUT:" & $ItemInhoud & @CRLF
			GUICtrlSetData($Edit03, $svKeyLog)
		Case "KEY"
			Switch $ItemInhoud
				Case "ENTER"
					Send("{ENTER}")
				Case "UP"
					Send("{UP}")
				Case "DOWN"
					Send("{DOWN}")
				Case "TAB"
					Send("{TAB}")
			EndSwitch
			$svKeyLog = $svKeyLog & "KEY:" & $ItemInhoud & @CRLF
			GUICtrlSetData($Edit03, $svKeyLog)
		Case "MARKER"
			SetMarker()
		Case "FILEIMPORT"
			ShellExecute($ItemInhoud)
			WachtActief($iDelay)
		Case "SLUIT"
			GUICtrlSetData($Input20, ConvertToTime($ItemInhoud))
		Case Else
			CheckValues()
			MouseClick("Left", $PosX, $PosY, 1, 10)
	EndSwitch
	WachtActief($vSleep)
EndFunc   ;==>VerwerkenRecord

Func ConvertToTime($nr_sec)
	$sec2time_hour = Int($nr_sec / 3600)
	$sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc   ;==>ConvertToTime

Func CheckValues()
	ConsoleWrite(@ScriptLineNumber & ":" & "CheckValues" & @CRLF)
	MouseClick("Right", $PosX, $PosY, 1, 10)
	WachtActief($iDelay)
	Local $lsTekst = StringReplace(ClipGet(), " ", "")
	Local $lNAV = StringSplit($lsTekst, "~:")
	Local $lMax = UBound($lNAV) - 1
	Local $x = 0
	Local $y = 0
	For $i = 1 To $lMax
		If StringInStr($ItemType, $lNAV[$i]) Then
			$x = $x + 1
		EndIf
		If StringInStr($ItemInhoud, $lNAV[$i]) Then
			$y = $y + 1
		EndIf
	Next
	ConsoleWrite(@ScriptLineNumber & "- " & $ItemType & " als type gevonden:" & $x & "- " & $ItemInhoud & " als Inhoud gevonden:" & $y & @CRLF)
EndFunc   ;==>CheckValues

Func Test()
	ConsoleWrite(@ScriptLineNumber & ":" & "Test" & @CRLF)
	ClipPut("")
	Local $i = 0
	Sleep($iDelay)
	Do
		$tMPOS = MouseGetPos()
		MouseClick($tMPOS[0], $tMPOS[1], 2)
		Sleep($iDelay)
		Send("^c")
		Sleep($iDelay)
		$clipBoardGet = ClipGet()
	Until $clipBoardGet <> ""
	Local $sNAV = StringSplit($clipBoardGet, ";")
	$iMax = UBound($sNAV) - 1
	If StringIsInt($sNAV[11]) = 1 Then
		$PosX = $sNAV[11]
		If StringIsInt($sNAV[12]) = 1 Then
			$PosY = $sNAV[12]
			MouseMove($PosX, $PosY, 5)
		EndIf
	EndIf
	ConsoleWrite(@ScriptLineNumber & ":" & $PosX & ", " & $PosY & @CRLF)
EndFunc

Func ChangeDefaults()
	ConsoleWrite("** ChangeDefaults **" & @CRLF)
	If $ExecuteVlag = 1 Then
		MsgBox($MB_OK, "Waarschuwing", "Defaults opslaan kan alleen voordat de startknop is aangeklikt!", 5)
		Return False
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

	$vLimit = GUICtrlRead($Input31, 1)
	$vSpeed = GUICtrlRead($Input41, 1)
	If _IsChecked($Checkbox32) Then
		$vValidate = 1
	Else
		$vValidate = 4
	EndIf
	If _IsChecked($Checkbox33) Then
		$vOutput = 1
	Else
		$vOutput = 4
	EndIf

	FileWriteLine($hFileOpen0, $vSchermPos & @CRLF & $cFx & @CRLF & $cFy & @CRLF & $vLimit & @CRLF & $vSpeed & @CRLF & $vValidate & @CRLF & $vOutput & @CRLF)
	FileFlush($hFileOpen0)
	FileClose($hFileOpen0)
EndFunc   ;==>ChangeDefaults

Func ReadQuery($f, $vFunction, $vLimit)
	ConsoleWrite(@ScriptLineNumber & ":" & "ReadQuery " & $f & ":" & $sFilePath1 & @CRLF)
	$hFileOpen1 = FileOpen($sFilePath1, $FO_READ)
	Local $sFile1 = FileRead($hFileOpen1)
	Local $vFilePath = StringSplit($sFilePath1, @MyDocumentsDir & "\Batch\", $STR_ENTIRESPLIT)
	Global $vFileName = StringTrimRight($vFilePath[2], 4)
	Local $sFilePath3 = @MyDocumentsDir & "\Batch\Input\" & $vFileName & ".txt"
	Local $hFileOpen3 = FileOpen($sFilePath3, $FO_READ)
	Local $svQueryInput3 = ""
	If $hFileOpen3 <> -1 Then
		$aQueryInput3 = FileReadToArray($sFilePath3)
		$iCountLines3 = _FileCountLines($sFilePath3)
		For $i = 0 To UBound($aQueryInput3) - 1
			If StringTrimLeft($aQueryInput3[$i], 12) = "~QUERYPARM: " Then
				$svQueryInput3 = StringTrimLeft($aQueryInput3[$i], 12)
				$aQueryInput3[$i] = $svQueryInput3
			EndIf
		Next
	EndIf

	$oConn = ObjCreate("ADODB.Connection")
	$oRS = ObjCreate("ADODB.Recordset")
	$strConn = "DSN=PostgreSQL35W;DATABASE=distridata_test;SERVER=test.distridata.nl;Port=5432;Uid=postgres;Pwd=Distr!Data007"

	If StringInStr($vFunction, "Open") <> 0 Then
		$oConn.Open($strConn)
		If @error Then
			ConsoleWrite(@ScriptLineNumber & ":" & " Fatal error Opening Connection, code 9" & @CRLF)
			Return 9
		Else
			ConsoleWrite(@ScriptLineNumber & ":" & " Connection succesful" & @CRLF)
		EndIf
	EndIf
	Local $sql = $sFile1
	$strReturn = ""
	If $hFileOpen3 <> -1 Then
		For $i = 0 To UBound($aQueryInput3) - 1
			$sql = StringReplace($sFile1, "?", $aQueryInput3[$i], 1)
			Local $iReplacements = @extended
			$sFile1 = $sql
			ConsoleWrite(@ScriptLineNumber & "- Waarde: " & $aQueryInput3[$i] & "  aantal: " & $iReplacements & @CRLF)
		Next
		ConsoleWrite(@ScriptLineNumber & ": Van bestand " & $sFilePath1 & " zijn er " & $iCountLines3  & " parameters replaced. Bestand heeft status " & $hFileOpen3  & @CRLF)
	EndIf

	If $vLimit > 0 Then
		$sql = $sFile1 & @CRLF & " LIMIT " & $vLimit
	EndIf

	If StringInStr($vFunction, "Read") <> 0 Then
		$oRS.open($sql, $oConn, 1, 3)
		If @error Then
			ConsoleWrite(@ScriptLineNumber & ":" & " Error Executing SQL, code 2" & @CRLF)
			Return 2
		Else
			$oRS.MoveFirst
			ConsoleWrite(@ScriptLineNumber & ":" & " Executing SQL succesful" & @CRLF)
			Local $vHeader = ""
			Local $iField = $oRS.Fields.Count
			For $i = 0 To $iField - 1
				$vHeader = $vHeader & $oRS.Fields($i).Name & "|"
			Next

			$strReturn = $oRS.GetRows()
			If $vLimit > $oRS.RecordCount Then
				$vLimit = $oRS.RecordCount
			EndIf
			_FileWriteFromArray($sFilePath2 & $vFileName & ".csv", $strReturn, 0, $vLimit - 1, ";")
			If _IsChecked($Checkbox33) Then
				_ArrayDisplay($strReturn, "Uitvoer query: " & $vFileName, Default, 32, Default, $vHeader, Default, 0xDDFFDD)
			EndIf
		EndIf
	EndIf

	If StringInStr($vFunction, "Close") <> 0 Then
		$oConn.Close
		If @error Then
			ConsoleWrite(@ScriptLineNumber & ":" & " Error Closing Connection, code 3" & @CRLF)
			Return 3
		Else
			ConsoleWrite(@ScriptLineNumber & ":" & " Closing connection succesful" & @CRLF)
		EndIf
	EndIf
	Return 0
EndFunc   ;==>ReadQuery

Func StringCount($string, $substring)
	If StringInStr($string, $substring) = 0 Then
		Return False
	EndIf
	$vStringLen = StringLen($string)
	$vSubStringLen = StringLen($substring)
	$vStringNew = $string
	$x = 0
	For $i = 1 To $vStringLen
		ConsoleWrite(@ScriptLineNumber & ":" & $i & ", " & $x & "-" & $vStringNew & @CRLF)
		$vSubStringPos = StringInStr($vStringNew, $substring)
		If $vSubStringPos > 0 Then
			$x = $x + 1
			$i = $i + $vSubStringPos + $vSubStringLen
		EndIf
		$vStringNew = StringRight($string, $vStringLen - $i)
	Next
	Return $x
EndFunc

Func ReadJavaConsole()
	If $ExecuteVlag = 0 Then
		MsgBox($MB_OK, "Waarschuwing", "Javaconsole wegschrijven kan alleen nadat de startknop is aangeklikt!", 5)
		Return False
	EndIf

	$hWnd2 = WinWait("Java Console - Solidis " & $vOmgeving, "", 5)
	If $hWnd2 = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Error!!", "Java console niet gevonden!!", 3)
		Return False
	EndIf
	WinActivate($hWnd2)
	WachtActief($iDelay * 4)
	Local $aPos = WinGetPos($hWnd2)
	WachtActief($iDelay)
	$twSx = Round(($aPos[2] / 2) + $aPos[0])
	$twSy = $aPos[1] + $aPos[3] - 25
	MouseClick("left", $twSx, $twSy)
	$vJavaConsole = ClipGet()
	$hFileOpen2 = FileOpen($sFilePath2 & "JavaConsole_" & $vFileName & ".txt", $FO_OVERWRITE)
	FileWrite($hFileOpen2, $vJavaConsole & @CRLF)
	FileClose($hFileOpen2)
	ConsoleWrite(@ScriptLineNumber & ":" & $aPos[0] & ", " & $aPos[1] & ", " & $aPos[2] & ", " & $aPos[3] & @CRLF)
	WinActivate($hWnd)
	WachtActief($iDelay * 2)
EndFunc

Func SetMarker()
	If $ExecuteVlag = 1 Then
		MsgBox($MB_OK, "Info", "Klik op het invoerveld, voer de waarde in en druk op enter om de actie uit te voeren")
	EndIf
	Local $i = 0
	Do
		If _IsPressed("0D") Then
			$i = $i + 1
			While _IsPressed("0D")
				ToolTip("Enter is ingedrukt")
				Sleep(10)
			WEnd
		EndIf
		Sleep(10)
	Until $i > 0
	ConsoleWrite(@ScriptLineNumber & "- Eigen invoer op marker verwerkt op: " & $StartX & "," & $StartY & @CRLF)
EndFunc

Func _IsChecked($iControlID)
	Return BitAND(GUICtrlRead($iControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $GUI_EVENT_DROPPED
			$str = ""
			For $i = 0 To UBound($gaDropFiles) - 1
				$str &= $gaDropFiles[$i]
			Next
			GUICtrlSetData($Edit01, $str & @CRLF, 1)
		Case $Button1
			InitProg()
			If $ExecuteVlag = 1 Then
				Start()
			EndIf
		Case $Button2
			Stop()
		Case $Button3
			Pauze()
		Case $Button4
			Test()
		Case $Button5
			ChangeDefaults()
	EndSwitch
	Sleep(10)
WEnd

Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
	ConsoleWrite("drag en drop" & @CRLF)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
EndFunc   ;==>WM_DROPFILES_FUNC
