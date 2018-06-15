#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.2.12.1
	Author:         Rob Karels

	Script Function:
	Test script Solidis

#ce ----------------------------------------------------------------------------
#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <StringConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <Misc.au3>
#include <ScreenCapture.au3>
#include <ColorPicker.au3>
;include <Dbug.au3>

Opt("MouseClickDelay", 250) ;250 milliseconds
Opt("MouseClickDownDelay", 500) ;1,5 second

;HotKeySet("{ESC}", "Afsluiten")
HotKeySet("!g", "Start")
HotKeySet("!s", "Stop")
HotKeySet("!p", "Pauze")
HotKeySet("!m", "Menu")
HotKeySet("!o", "Overslaan")

Global $fPaused = False
Global $tAS, $tKS, $tLS, $FoutVlag, $cTel, $xPos, $yPos, $point, $ClickPosX, $ClickPosY, $StartX, $StartY, $EindX, $EindY, $TPos, $StPos = 0
Global $HmPosX, $HmPosY, $SmPosX, $SmPosY, $TabPosX, $TabPosY, $StPosX, $StPosY, $SbPosX, $SbPosY, $svPosY, $SizeX, $SizeY, $twSx, $twSy = 0
Global $iDelay = 250
Global $activeWhdColor = 13805969
Global $inactiveWhdColor = 14073779
Global $yPosTab = 420
Global $yPosSubTab = 455
Global $pVoortgang01
Global $cMouseClick, $vSleep, $hTimer = 0
Global $rNum
Global $AchterGrondKleur, $sSchuifMenu, $sSchuifVerschil, $sIconKleur, $sIconPosY = 0
Global $ActiveMenu
Global $ActiveScherm
Global $aHoofdMenu, $aSubMenu, $aTab, $aSubTab, $aVeld = 1
Global $sHoofdMenu, $sSubMenu, $sTab, $sSubTab, $sButton, $sTekst, $sActive, $sMaxTab = ""
Global $ItemClipboard, $vOverslaan = ""
Global $fTest = False
Global $FlowArray[15][20][25][25][25];10 menu's, 20 submenu's, 25 tabs, 10 subtabs en 25 velden
Global $arrxPos[15][20][25][25][25];Per veld de Xpos opslaan
Global $arryPos[15][20][25][25][25];Per veld de yPos opslaan
Global $arrColor[15][20][25][25][25];Per veld de kleur opslaan
Global $IcoonKleur[15][20][25][25][25]
Global $IcoonXPos[15][20][25][25][25]
Global $IcoonYPos[15][20][25][25][25]
Global $ColorArray[25] = ["0xF5CB98", "0x91CFFF", "0xE7EAEE", "0xFFFFFF", "0xB33131", "0x6C99B3", "0xB8BDC3", "0x5692E1", "0xE6E9ED", "0xF1F2F4", "0xDB8270", "0xB5DB49", "0x75407C", "0x21608C", "0xF0F0F0", "0x8A8A8A", "0xE04343", "0xC75050", "0x7C8FB3", "0x2F84CF", "0xE81123", "0x4F93C9", "0xA9CDFA", "0x3693D9", "0xBF2020"]
Global $TekstArray[25] = ["Accountmanagers", "Artikelen", "Artikel detail", "Overig detail", "Annuleer", "Verrekijker", "Inactieve tab", "Detail knopje", "Actieve tab", "Tab achtergrond", "Window annuleer", "Info icoon groen", "Solidis logo test", "Solidis logo branch", "Witte kruisje", "Grijze driehoekje", "Annuleer w8 Actief", "Annuleer w8 Inactief", "Actief NAV-ITEM", "Pijltjes", "Annuleer w10", "Info icoon blauw", "Blauwe listview regel", "Mini dialoog", "Error scherm"]
;0xF5CB98 [0]-Accountmanagers (checkpoint)
;0x91CFFF [1]-Artikelen (start menu loop)
;0xE7EAEE [2]-Artikel detail(grijs)
;0xFFFFFF [3]-Overig detail (wit)
;0xB33131 [4]-Annuleer
;0x6C99B3 [5]-Verrekijker
;0xB8BDC3 [6]-Inactieve tab
;0x5692E1 [7]-Detail knopje
;0xE6E9ED [8]-Actieve tab
;0xF1F2F4 [9]-Tab achtergrond
;0xDB8270 [10]-Window annuleer
;0xB5DB49 [11]-Info icoon (groen vraagteken)
;0x75407C [12]-Solidis logo test
;0x21608C [13]-Solidis logo branch
;0xF0F0F0 [14]-Witte kruisje
;0x8A8A8A [15]-Grijze driehoekje
;0xE04343 [16]-Annuleer Windows 8 (Actief)
;0xC75050 [17]-Annuleer Windows 8 (inActief)
;0x7C8FB3 [18]-Actief NAV-ITEM
;0x2F84CF [19]-Verder en terug pijltjes
;0xE81123 [20]-Annuleer Windows 10
;0x4F93C9 [21]-Info icoon (blauw vraagteken)
;0xA9CDFA [22]-Blauwe geselecteerde regel in listview
;0x3693D9 [23]-Blauw mini dialoog pijltje
;0xBF2020 [24]-Errorscherm

$MinItems = 0
$MaxItems = 100
Global $ItemDelim, $ItemType, $ItemInhoud
Global $aTekstTabel[20]
Global $wS
Global $aClick = 1
Global Const $sFilePath1 = @MyDocumentsDir & "\Batch\Log\LogFile.csv"
Global Const $sFilePath2 = @MyDocumentsDir & "\Batch\Log\MenuFile.csv"
Global $hFileOpen1 = FileOpen($sFilePath1, $FO_OVERWRITE)
Global $hFileOpen2 = FileOpen($sFilePath2, $FO_READ)

If @ComputerName = "ROB-PC" Then
	;$Form1 = GUICreate("TestScript", 700, 700, 3000, 200)
	$Form1 = GUICreate("TestScript", 700, 700, 1000, 100)
Else
	If @ComputerName = "DISTRIDATA" Then
		$Form1 = GUICreate("TestScript", 700, 700, -720, 10)
	Else
		If @ComputerName = "GEBRUIK-4LKDLIR" Then
			$Form1 = GUICreate("TestScript", 700, 700, 26, 0)
		Else
			$Form1 = GUICreate("TestScript", 700, 700, 10, 10)
		EndIf
	EndIf
EndIf

$Date1 = GUICtrlCreateDate(_NowDate(), 360, 24, 193, 25)
$Button1 = GUICtrlCreateButton("Start", 560, 24, 50, 25)
$Button2 = GUICtrlCreateButton("Stop", 620, 24, 50, 25)
$Button3 = GUICtrlCreateButton("v", 130, 20, 17, 17)
$Button4 = GUICtrlCreateButton("v", 300, 92, 17, 17)
$Button5 = GUICtrlCreateButton("v", 483, 92, 17, 17)

$Group0 = GUICtrlCreateGroup("Info", 8, 424, 495, 88)
$Label01 = GUICtrlCreateLabel("Item info", 32, 456, 95, 17)
$Edit01 = GUICtrlCreateEdit("", 100, 456, 376, 20)
$Label02 = GUICtrlCreateLabel("Veld info", 32, 480, 95, 17)
$Edit02 = GUICtrlCreateEdit("", 100, 480, 376, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group1 = GUICtrlCreateGroup("Artikelen", 8, 8, 145, 400)
$Checkbox1 = GUICtrlCreateCheckbox("Specificaties", 32, 40, 97, 17)
$Checkbox2 = GUICtrlCreateCheckbox("Voorraad", 32, 64, 97, 17)
$Checkbox3 = GUICtrlCreateCheckbox("Prijzen", 32, 88, 97, 17)
$Checkbox4 = GUICtrlCreateCheckbox("historie", 32, 112, 97, 17)
$Checkbox5 = GUICtrlCreateCheckbox("In omloop", 32, 136, 97, 17)
$Checkbox6 = GUICtrlCreateCheckbox("Inkoop", 32, 160, 97, 17)
$Checkbox7 = GUICtrlCreateCheckbox("Verkoop", 32, 184, 97, 17)
$Checkbox8 = GUICtrlCreateCheckbox("Online", 32, 208, 97, 17)
$Checkbox9 = GUICtrlCreateCheckbox("Leverancier", 32, 232, 97, 17)
$Checkbox10 = GUICtrlCreateCheckbox("Informatie", 32, 256, 97, 17)
$Checkbox11 = GUICtrlCreateCheckbox("EAN", 32, 280, 97, 17)
$Checkbox12 = GUICtrlCreateCheckbox("Alternatief", 32, 304, 97, 17)
$Checkbox13 = GUICtrlCreateCheckbox("Notities", 32, 328, 97, 17)
$Checkbox14 = GUICtrlCreateCheckbox("Prijswijzigingen", 32, 352, 97, 17)
$Checkbox15 = GUICtrlCreateCheckbox("Sub artikelen", 32, 376, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group2 = GUICtrlCreateGroup("Klanten", 176, 80, 145, 330)
$Checkbox21 = GUICtrlCreateCheckbox("Specificaties", 200, 112, 97, 17)
$Checkbox22 = GUICtrlCreateCheckbox("Communicatie", 200, 136, 97, 17)
$Checkbox23 = GUICtrlCreateCheckbox("Bestelformulier", 200, 160, 97, 17)
$Checkbox24 = GUICtrlCreateCheckbox("Verkopen", 200, 184, 97, 17)
$Checkbox25 = GUICtrlCreateCheckbox("Speciale prijzen", 200, 208, 97, 17)
$Checkbox26 = GUICtrlCreateCheckbox("Notities", 200, 208, 97, 17)
$Checkbox27 = GUICtrlCreateCheckbox("Routes", 200, 232, 97, 17)
$Checkbox28 = GUICtrlCreateCheckbox("BelKlant", 200, 256, 97, 17)
$Checkbox29 = GUICtrlCreateCheckbox("Organisatie", 200, 280, 97, 17)
$Checkbox2A = GUICtrlCreateCheckbox("Factuur Splitsing", 200, 304, 97, 17)
$Checkbox2B = GUICtrlCreateCheckbox("Documenten", 200, 328, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group3 = GUICtrlCreateGroup("Leveranciers", 360, 80, 145, 330)
$Checkbox31 = GUICtrlCreateCheckbox("Specificaties", 384, 112, 120, 17)
$Checkbox32 = GUICtrlCreateCheckbox("Communicatie", 384, 136, 120, 17)
$Checkbox33 = GUICtrlCreateCheckbox("Bestelformulier", 384, 160, 120, 17)
$Checkbox34 = GUICtrlCreateCheckbox("Artikelen", 384, 184, 120, 17)
$Checkbox35 = GUICtrlCreateCheckbox("Speciale prijzen", 384, 208, 120, 17)
$Checkbox36 = GUICtrlCreateCheckbox("Kortingen", 384, 208, 120, 17)
$Checkbox37 = GUICtrlCreateCheckbox("Notities", 384, 232, 120, 17)
$Checkbox38 = GUICtrlCreateCheckbox("Organisatie", 384, 256, 120, 17)
$Checkbox39 = GUICtrlCreateCheckbox("Bestelgegevens", 384, 280, 120, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group4 = GUICtrlCreateGroup("Machine", 176, 8, 161, 57)
$Radio41 = GUICtrlCreateRadio("Test", 184, 24, 60, 25)
GUICtrlSetState(-1, $GUI_CHECKED)
$Radio42 = GUICtrlCreateRadio("Branch", 256, 24, 60, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group5 = GUICtrlCreateGroup("Instellingen", 520, 80, 145, 161)
$Checkbox51 = GUICtrlCreateCheckbox("Nieuw artikel", 544, 112, 120, 17)
$Checkbox52 = GUICtrlCreateCheckbox("Nieuwe klant", 544, 136, 120, 17)
$Checkbox53 = GUICtrlCreateCheckbox("Nieuwe leverancier", 544, 160, 120, 17)
$Checkbox54 = GUICtrlCreateCheckbox("Nieuwe zoek", 544, 184, 120, 17)
$Checkbox55 = GUICtrlCreateCheckbox("Opstarten Solidis", 544, 208, 120, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group6 = GUICtrlCreateGroup("Zoekopdrachten", 520, 248, 145, 113)
$Input61 = GUICtrlCreateInput("Artikel", 544, 272, 90, 17)
$Input611 = GUICtrlCreateInput("", 640, 272, 20, 17)
$Input62 = GUICtrlCreateInput("Klant", 544, 296, 90, 17)
$Input621 = GUICtrlCreateInput("", 640, 296, 20, 17)
$Input63 = GUICtrlCreateInput("Leverancier", 544, 320, 90, 17)
$Input631 = GUICtrlCreateInput("", 640, 320, 20, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group7 = GUICtrlCreateGroup("Specifiek story-point", 520, 368, 145, 67)
$Input71 = GUICtrlCreateInput("ZN-", 544, 392, 100, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group8 = GUICtrlCreateGroup("Standaard functies", 520, 440, 145, 161)
$Checkbox81 = GUICtrlCreateCheckbox("Inkoop bestelling", 544, 472, 120, 17)
$Checkbox82 = GUICtrlCreateCheckbox("Ontvangst", 544, 496, 120, 17)
$Checkbox83 = GUICtrlCreateCheckbox("Verkoop bestelling", 544, 520, 120, 17)
$Checkbox84 = GUICtrlCreateCheckbox("Levering", 544, 544, 120, 17)
$Checkbox85 = GUICtrlCreateCheckbox("Offerte", 544, 568, 120, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group9 = GUICtrlCreateGroup("Flow", 8, 524, 155, 154)
$Checkbox91 = GUICtrlCreateCheckbox("Menu opbouwen", 32, 548, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Checkbox92 = GUICtrlCreateCheckbox("Menu openen", 32, 572, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Checkbox93 = GUICtrlCreateCheckbox("Tabs klikken", 32, 596, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Checkbox94 = GUICtrlCreateCheckbox("Buttons klikken", 32, 620, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Checkbox95 = GUICtrlCreateCheckbox("Minidialoog openen", 32, 644, 120, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

$Group10 = GUICtrlCreateGroup("Parameters", 180, 524, 320, 154)
$Label91 = GUICtrlCreateLabel("Sleep", 200, 548, 100, 17)
$Input91 = GUICtrlCreateInput($iDelay, 300, 548, 50, 17)
$Label92 = GUICtrlCreateLabel("Teller", 200, 572, 100, 17)
$Edit92 = GUICtrlCreateEdit("", 300, 572, 50, 17)
$Label96 = GUICtrlCreateLabel("Regels overslaan", 200, 596, 100, 17)
$Input96 = GUICtrlCreateInput("0", 300, 596, 50, 17)
$Label97 = GUICtrlCreateLabel("Object overslaan", 200, 620, 100, 17)
$Input97 = GUICtrlCreateInput("", 300, 620, 150, 17)

$Checkbox95 = GUICtrlCreateCheckbox("Log", 200, 644, 50, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$ColorLabel01 = GUICtrlCreateLabel("", 300, 644, 17, 17)
GUICtrlSetBkColor($ColorLabel01, $COLOR_GRAY)
GUICtrlCreateGroup("", -99, -99, 1, 1)

ControlFocus($Form1, $cTel, $Edit01)
GUISetState(@SW_SHOW)
;Send("{SHIFTDOWN}{HOME}{SHIFTUP}")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			Start()
		Case $Button2
			Stop()
		Case $Button3
			AlleArtikelScripts()
		Case $Button4
			AlleKlantenScripts()
		Case $Button5
			AlleLeverancierScripts()
	EndSwitch
	Sleep(100)
WEnd

Func Afsluiten()
	ConsoleWrite(@ScriptLineNumber & " Afsluiten" & @CRLF)
	FileWriteLine($hFileOpen1, "Script beeindigd op: " & _Now())
	FileFlush($hFileOpen1)
	FileClose($hFileOpen1)
	FileClose($hFileOpen2)
	Exit 1
EndFunc   ;==>Afsluiten

Func Start()
	ConsoleWrite(@ScriptLineNumber & " Start" & @CRLF)
	If _IsChecked($Checkbox91) Then
		FileClose($hFileOpen2)
		$hFileOpen2 = FileOpen($sFilePath2, $FO_OVERWRITE)
	EndIf
	If _IsChecked($Checkbox95) Then
		$fTest = True
	EndIf

	If $hFileOpen1 = -1 Then
		MsgBox($MB_SYSTEMMODAL, "", "Controleer de logfile in de documenten map!!")
		Exit
	EndIf
	FileWriteLine($hFileOpen1, "Script gestart op: " & _Now())
	FileFlush($hFileOpen1)
	If $hFileOpen2 = -1 Then
		MsgBox($MB_SYSTEMMODAL, "", "Controleer de Menufile in de documenten map!!")
		Exit
	EndIf
	GUICtrlSetData($Edit01, "** Start **")
	Global $textInput61 = GUICtrlRead($Input61, 1)
	Global $textInput611 = GUICtrlRead($Input611, 1)
	Global $textInput62 = GUICtrlRead($Input62, 1)
	Global $textInput621 = GUICtrlRead($Input621, 1)
	Global $textInput63 = GUICtrlRead($Input63, 1)
	Global $textInput631 = GUICtrlRead($Input631, 1)
	Global $textInput71 = GUICtrlRead($Input71, 1)
	Global $textInput91 = GUICtrlRead($Input91, 1)
	Global $textInput96 = GUICtrlRead($Input96, 1)
	Global $textInput97 = GUICtrlRead($Input97, 1)
	Global $timeout = 5

	ClipPut(""); clipboard leeg maken
	$hTimer = TimerInit()

	If _IsChecked($Checkbox55) Then
		Opstarten()
		Sleep(5000)
		$timeout = 25
	EndIf

	;Scherm grootte en positie bepalen van active scherm
	Global $hWnd = WinWait("zegro - U bent ingelogd als Distri Nl || Nederland - Zegro - Solidis", "", $timeout)
	;Global $hWnd = WinWait("horeca totaal - U bent ingelogd als Distri Nl || Belgi? - Brugge BVBA - Solidis 1.0", "", $timeout)
	If $hWnd = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Error!!", "Solidis scherm niet gevonden!!", 3)
		Exit
	EndIf
	WinActivate($hWnd)
	Local $aPos = WinGetPos("[ACTIVE]")
	$hPos = WinGetClientSize($hWnd)
	$SizeX = $hPos[0]
	$SizeY = $hPos[1]
	$StartX = $aPos[0] + 10
	$StartY = $aPos[1]
	$EindX = $aPos[2]
	$EindY = $aPos[3]
	ConsoleWrite(@ScriptLineNumber & ":" & $SizeX & "," & $SizeY & "," & $StartX & "," & $StartY & "," & $EindX & "," & $EindY & "," & @CRLF)
	;$hWnd = WinWait("HyperCam 3 MainDialog", "", 5)
	;WinActivate($hWnd)
	;HyperCam()
	;Global $hWnd = WinWait("zegro - U bent ingelogd als Distri Nl || Nederland - Zegro - Solidis 1.0", "", $timeout)
	;WinActivate($hWnd)
	ZoekKleur($StartX, $StartY, $StartX + 25, $StartY + 25, $ColorArray[12], 0, 0, @ScriptLineNumber);Zoek Solidis logo test
	If $FoutVlag > 0 Then
		ZoekKleur($StartX, $StartY, $StartX + 25, $StartY + 25, $ColorArray[13], 0, 0, @ScriptLineNumber);Zoek Solidis logo branch
		If $FoutVlag > 0 Then
			ConsoleWrite(@ScriptLineNumber & "Solidis logo niet gevonden" & @CRLF)
		Else
			GUICtrlSetState($Radio42, $GUI_CHECKED)
		EndIf
	Else
		GUICtrlSetState($Radio41, $GUI_CHECKED)
	EndIf
	If StringIsDigit($textInput91) Then
		$iDelay = $textInput91
	EndIf

	;Instellingen
	If _IsChecked($Checkbox54) Then
		ArtikelStart()
	EndIf

	;Artikelen
	If _IsChecked($Checkbox1) Then
		ArtikelSpecificaties()
	EndIf

	If _IsChecked($Checkbox2) Then
		ArtikelVoorraad()
	EndIf

	If _IsChecked($Checkbox3) Then
		ArtikelPrijzen()
	EndIf

	If _IsChecked($Checkbox4) Then
		ArtikelHistorie()
	EndIf

	If _IsChecked($Checkbox5) Then
		ArtikelInOmloop()
	EndIf

	If _IsChecked($Checkbox6) Then
		ArtikelInkoop()
	EndIf

	If _IsChecked($Checkbox7) Then
		ArtikelVerkoop()
	EndIf

	If _IsChecked($Checkbox8) Then
		ArtikelOnline()
	EndIf

	If _IsChecked($Checkbox9) Then
		ArtikelLeverancier()
	EndIf

	If _IsChecked($Checkbox10) Then
		ArtikelInformatie()
	EndIf

	If _IsChecked($Checkbox11) Then
		ArtikelEan()
	EndIf

	If _IsChecked($Checkbox12) Then
		ArtikelAlternatief()
	EndIf

	If _IsChecked($Checkbox13) Then
		ArtikelNotities()
	EndIf

	If _IsChecked($Checkbox14) Then
		ArtikelPrijswijzigingen()
	EndIf

	If _IsChecked($Checkbox15) Then
		ArtikelSubArtikelen()
	EndIf

	;Klanten
	If _IsChecked($Checkbox21) Then
		KlantenSpecificaties()
	EndIf

	If _IsChecked($Checkbox22) Then
		KlantenCommunicatie()
	EndIf

	If _IsChecked($Checkbox23) Then
		KlantenBestelformulier()
	EndIf

	If _IsChecked($Checkbox24) Then
		KlantenVerkopen()
	EndIf

	If _IsChecked($Checkbox25) Then
		KlantenSpecialePrijzen()
	EndIf

	If _IsChecked($Checkbox26) Then
		KlantenNotities()
	EndIf

	If _IsChecked($Checkbox27) Then
		KlantenRoutes()
	EndIf

	If _IsChecked($Checkbox28) Then
		KlantenBelKlant()
	EndIf

	If _IsChecked($Checkbox29) Then
		KlantenOrganisatie()
	EndIf

	If _IsChecked($Checkbox2A) Then
		KlantenFactuurSplitsing()
	EndIf

	If _IsChecked($Checkbox2B) Then
		KlantenDocumenten()
	EndIf

	;Leveranciers
	If _IsChecked($Checkbox31) Then
		LeveranciersSpecificaties()
	EndIf

	If _IsChecked($Checkbox32) Then
		LeverancierCommunicatie()
	EndIf

	If _IsChecked($Checkbox33) Then
		LeverancierBestelformulier()
	EndIf

	If _IsChecked($Checkbox34) Then
		LeverancierArtikelen()
	EndIf

	If _IsChecked($Checkbox35) Then
		LeverancierSpecialePrijzen()
	EndIf

	If _IsChecked($Checkbox36) Then
		LeverancierKortingen()
	EndIf

	If _IsChecked($Checkbox37) Then
		LeverancierNotities()
	EndIf

	If _IsChecked($Checkbox38) Then
		LeverancierOrganisatie()
	EndIf

	If _IsChecked($Checkbox39) Then
		LeverancierBestelgegevens()
	EndIf

	;Standaard functies
	If _IsChecked($Checkbox81) Then
		InkoopBestelling()
	EndIf
	If _IsChecked($Checkbox82) Then
		Ontvangst()
	EndIf
	If _IsChecked($Checkbox83) Then
		VerkoopBestelling()
	EndIf
	If _IsChecked($Checkbox84) Then
		Levering()
	EndIf
	If _IsChecked($Checkbox85) Then
		Offerte()
	EndIf

	; Parameters
	If _IsChecked($Checkbox91) Then
		MenuOpbouwen()
	EndIf

	Klaar()

EndFunc   ;==>Start

Func Stop()
	ConsoleWrite(@ScriptLineNumber & " Stop" & @CRLF)
	$stopScript = MsgBox($MB_YESNO, "Testscript stoppen", "Weet u zeker dat u wilt stoppen")
	If $stopScript = $IDYES Then
		FileWriteLine($hFileOpen1, "Script voortijdig beeindigd op: " & _Now())
		FileFlush($hFileOpen1)
		FileClose($hFileOpen1)
		FileClose($hFileOpen2)
		Exit
	EndIf
EndFunc   ;==>Stop

Func Pauze()
	$fPaused = Not $fPaused
	ConsoleWrite(@ScriptLineNumber & " Gepauzeerd, klik met muis om verder te gaan" & @CRLF)
	FileWriteLine($hFileOpen1, "Script gepauzeerd op: " & _Now())
	FileFlush($hFileOpen1)
	Local $i = 0
	Do
		If _IsPressed("01") Then
			ConsoleWrite(@ScriptLineNumber & "Active" & @CRLF)
			$i = $i + 1
		EndIf
	Until $i > 0
	FileWriteLine($hFileOpen1, "Script geherstart op: " & _Now())
	FileFlush($hFileOpen1)
EndFunc   ;==>Pauze

Func Menu()
	$fPaused = Not $fPaused
	ConsoleWrite(@ScriptLineNumber & " Script verder laten lopen vanaf ander menu, klik met rechtermuis op nieuwe menu om verder te gaan" & @CRLF)
	FileWriteLine($hFileOpen1, "Menu aangepast op: " & _Now())
	FileFlush($hFileOpen1)
	Local $i = 0
	Do
		If _IsPressed("02") Then ;Rechtmuis klik
			ConsoleWrite(@ScriptLineNumber & "Active" & @CRLF)
			AnderMenu()
			$i = $i + 1
		EndIf
	Until $i > 0
	FileWriteLine($hFileOpen1, "Script geherstart op: " & _Now())
	FileFlush($hFileOpen1)
EndFunc   ;==>Menu

Func AnderMenu()
	$clipBoardGet = ClipGet()
	If StringLeft($clipBoardGet, 4) = "~NAV" Then
		FileWriteLine($hFileOpen1, $clipBoardGet)
		FileFlush($hFileOpen1)
		$point = MouseGetPos()
		$MPos = $point[1]
	EndIf
EndFunc   ;==>AnderMenu

Func Overslaan()
	MsgBox(0, "Overslaan", "Klik met de rechtermuisknop op het object wat je wilt overslaan!", 3)
	ClipPut("")
	WachtActief($iDelay)
	Local $i = 0
	Do
		If _IsPressed("02") Then ;Rechtmuis klik
			WachtActief($iDelay)
			$vOverslaan = ClipGet()
		EndIf
	Until StringLeft($vOverslaan, 1) = "~"
	ConsoleWrite(@ScriptLineNumber & $vOverslaan & " wordt overgeslagen" & @CRLF)
EndFunc

Func Klaar()
	ConsoleWrite(@ScriptLineNumber & " Klaar !!!" & @CRLF)
	FileWriteLine($hFileOpen1, "-----** Script is klaar op " & _Now() & ", er zijn " & $cMouseClick & " items aangeklikt **-----")
	FileClose($hFileOpen1)
	FileClose($hFileOpen2)
	MsgBox(0, "Testscript is gereed", "Het testscript is succesvol afgerond!!", 2)
	Exit
EndFunc   ;==>Klaar

Func AlleArtikelScripts()
	ConsoleWrite(@ScriptLineNumber & " AlleArtikelScripts" & @CRLF)
	For $i = $Checkbox1 To $Checkbox15
		If _IsChecked($i) Then
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($i, $GUI_CHECKED)
		EndIf
	Next
EndFunc   ;==>AlleArtikelScripts

Func AlleKlantenScripts()
	ConsoleWrite("AlleKlantenScripts" & @CRLF)
	For $i = $Checkbox21 To $Checkbox2B
		If _IsChecked($i) Then
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($i, $GUI_CHECKED)
		EndIf
	Next
EndFunc   ;==>AlleKlantenScripts

Func AlleLeverancierScripts()
	ConsoleWrite("AlleLeverancierScripts" & @CRLF)
	For $i = $Checkbox31 To $Checkbox39
		If _IsChecked($i) Then
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($i, $GUI_CHECKED)
		EndIf
	Next
EndFunc   ;==>AlleLeverancierScripts

Func _IsChecked($iControlID)
	Return BitAND(GUICtrlRead($iControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

;Artikelen
Func ArtikelSpecificaties()
	ConsoleWrite("ArtikelSpecificaties" & @CRLF)
EndFunc   ;==>ArtikelSpecificaties

Func ArtikelVoorraad()
	ConsoleWrite("ArtikelVoorraad" & @CRLF)
EndFunc   ;==>ArtikelVoorraad

Func ArtikelPrijzen()
	ConsoleWrite("ArtikelPrijzen" & @CRLF)
EndFunc   ;==>ArtikelPrijzen

Func ArtikelHistorie()
	ConsoleWrite("ArtikelHistorie" & @CRLF)
EndFunc   ;==>ArtikelHistorie

Func ArtikelInOmloop()
	ConsoleWrite("ArtikelInOmloop" & @CRLF)
EndFunc   ;==>ArtikelInOmloop

Func ArtikelInkoop()
	ConsoleWrite("ArtikelInkoop" & @CRLF)
EndFunc   ;==>ArtikelInkoop

Func ArtikelVerkoop()
	ConsoleWrite("ArtikelVerkoop" & @CRLF)
EndFunc   ;==>ArtikelVerkoop

Func ArtikelOnline()
	ConsoleWrite("ArtikelOnline" & @CRLF)
EndFunc   ;==>ArtikelOnline

Func ArtikelLeverancier()
	ConsoleWrite("ArtikelLeverancier" & @CRLF)
EndFunc   ;==>ArtikelLeverancier

Func ArtikelInformatie()
	ConsoleWrite("ArtikelInformatie" & @CRLF)
EndFunc   ;==>ArtikelInformatie

Func ArtikelEan()
	ConsoleWrite("ArtikelEan" & @CRLF)
EndFunc   ;==>ArtikelEan

Func ArtikelAlternatief()
	ConsoleWrite("ArtikelAlternatief" & @CRLF)
EndFunc   ;==>ArtikelAlternatief

Func ArtikelNotities()
	ConsoleWrite("ArtikelNotities" & @CRLF)
EndFunc   ;==>ArtikelNotities

Func ArtikelPrijswijzigingen()
	ConsoleWrite("ArtikelPrijswijzigingen" & @CRLF)
EndFunc   ;==>ArtikelPrijswijzigingen

Func ArtikelSubArtikelen()
	ConsoleWrite("ArtikelSubArtikelen" & @CRLF)
EndFunc   ;==>ArtikelSubArtikelen

;Klanten
Func KlantenSpecificaties()
	ConsoleWrite("KlantenSpecificaties" & @CRLF)
EndFunc   ;==>KlantenSpecificaties

Func KlantenCommunicatie()
	ConsoleWrite("KlantenCommunicatie" & @CRLF)
EndFunc   ;==>KlantenCommunicatie

Func KlantenBestelformulier()
	ConsoleWrite("KlantenBestelFormulier" & @CRLF)
EndFunc   ;==>KlantenBestelformulier

Func KlantenVerkopen()
	ConsoleWrite("KlantenVerkopen" & @CRLF)
EndFunc   ;==>KlantenVerkopen

Func KlantenSpecialePrijzen()
	ConsoleWrite("KlantenSpecialePrijzen" & @CRLF)
EndFunc   ;==>KlantenSpecialePrijzen

Func KlantenNotities()
	ConsoleWrite("KlantenNotities" & @CRLF)
EndFunc   ;==>KlantenNotities

Func KlantenRoutes()
	ConsoleWrite("KlantenRoutes" & @CRLF)
EndFunc   ;==>KlantenRoutes

Func KlantenBelKlant()
	ConsoleWrite("KlantenBelKlant" & @CRLF)
EndFunc   ;==>KlantenBelKlant

Func KlantenOrganisatie()
	ConsoleWrite("KlantenOrganisaties" & @CRLF)
EndFunc   ;==>KlantenOrganisatie

Func KlantenFactuurSplitsing()
	ConsoleWrite("KlantenFactuurSplitsing" & @CRLF)
EndFunc   ;==>KlantenFactuurSplitsing

Func KlantenDocumenten()
	ConsoleWrite("KlantenDocumenten" & @CRLF)
EndFunc   ;==>KlantenDocumenten

;Leveranciers
Func LeveranciersSpecificaties()
	ConsoleWrite("LeveranciersSpecificaties" & @CRLF)
EndFunc   ;==>LeveranciersSpecificaties

Func LeverancierCommunicatie()
	ConsoleWrite("LeverancierCommunicatie" & @CRLF)
EndFunc   ;==>LeverancierCommunicatie

Func LeverancierBestelformulier()
	ConsoleWrite("LeverancierBestelformulier" & @CRLF)
EndFunc   ;==>LeverancierBestelformulier

Func LeverancierArtikelen()
	ConsoleWrite("LeverancierArtikelen" & @CRLF)
EndFunc   ;==>LeverancierArtikelen

Func LeverancierSpecialePrijzen()
	ConsoleWrite("LeverancierSpecialePrijzen" & @CRLF)
EndFunc   ;==>LeverancierSpecialePrijzen

Func LeverancierKortingen()
	ConsoleWrite("LeverancierKortingen" & @CRLF)
EndFunc   ;==>LeverancierKortingen

Func LeverancierNotities()
	ConsoleWrite("LeverancierNotities" & @CRLF)
EndFunc   ;==>LeverancierNotities

Func LeverancierOrganisatie()
	ConsoleWrite("LeverancierOrganisatie" & @CRLF)
EndFunc   ;==>LeverancierOrganisatie

Func LeverancierBestelgegevens()
	ConsoleWrite("LeverancierBestelgegevens" & @CRLF)
EndFunc   ;==>LeverancierBestelgegevens

;Instellingen
Func Opstarten()
	ConsoleWrite("Opstarten" & @CRLF)
	LoginSolidis("distrinl", "Test_010", "Zegro", @DesktopDir & "\Solidis Test.exe")
EndFunc   ;==>Opstarten

Func LoginSolidis($inlognaam, $wachtwoord, $organisatie, $Path)
	ConsoleWrite("Inloggen" & @CRLF)
	Run($Path)
	Sleep(15000)
	Local $hWnd = WinWait("Login scherm - Solidis 1.0", "", 25)
	WinActivate($hWnd)
	Sleep($iDelay)
	Send("{SHIFTDOWN}{TAB}{SHIFTUP}")
	Sleep($iDelay)
	Send("{CTRLDOWN}a{CTRLUP}{DEL}")
	Sleep($iDelay)
	Send($inlognaam)
	Sleep($iDelay)
	Send("{TAB}")
	Sleep($iDelay)
	Send($wachtwoord)
	Sleep($iDelay)
	Send("{TAB}")
	Sleep($iDelay)
	Send("{CTRLDOWN}a{CTRLUP}{DEL}")
	Sleep($iDelay)
	Send($organisatie)
	Sleep($iDelay)
	Send("{ENTER}")
EndFunc   ;==>LoginSolidis

;Stories
;Func ZN-4907

Func ArtikelStart()
	ConsoleWrite("ArtikelStart" & @CRLF)
EndFunc   ;==>ArtikelStart

;Standaard functies
Func InkoopBestelling()
	ConsoleWrite("InkoopBestelling" & @CRLF)
EndFunc   ;==>InkoopBestelling

Func Ontvangst()
	ConsoleWrite("Ontvangst" & @CRLF)
EndFunc   ;==>Ontvangst

Func VerkoopBestelling()
	ConsoleWrite("VerkoopBestelling" & @CRLF)
EndFunc   ;==>VerkoopBestelling

Func Levering()
	ConsoleWrite("Levering" & @CRLF)
EndFunc   ;==>Levering

Func Offerte()
	ConsoleWrite("Offerte" & @CRLF)
EndFunc

Func MenuOpbouwen()
	ConsoleWrite(@ScriptLineNumber & " MenuOpbouwen" & @CRLF)
	;loopje totaan het artikelmenu icoon
	For $i = 0 To 1 Step 1
		ZoekKleur($StartX + 5, $StartY + 100, $StartX + 200, $EindY - 50, $ColorArray[$i], 0, 2, @ScriptLineNumber) ;Menu formaat
		If $FoutVlag > 0 Then
			ZoekKleur($StartX + 5, $StartY + 100, $StartX + 200, $EindY - 50, $ColorArray[0], 0, 2, @ScriptLineNumber) ;Start vanaf accountmanagers ipv artikelen
		EndIf
		If $FoutVlag > 0 Then
			MouseClick("Left", $StartX + 180, $StartY + 130, 1, 5)
		EndIf
		WachtActief($iDelay)
	Next

	;vanaf artikelmenu icoon iedere keer 20 pixels naar beneden
	$ClickPosY = $point[1] - 5

	;********Stuk in menu overslaan*******
	If StringIsDigit($textInput96) Then
		$ClickPosY = $ClickPosY + ($textInput96 * 20)
	EndIf

	$vOverslaan = $textInput96

	Global $MPos = $ClickPosY
	$aHoofdMenu = 1
	$aSubMenu = 1
	$aTab = 1
	$aSubTab = 1
	$aVeld = 1
	RightClick($ClickPosX, $ClickPosY - 20, 1, 5)
	SplitTekst(ClipGet(), $ClickPosX, $ClickPosY - 20); 1e Hoofdmenu
	WachtActief($iDelay)
	For $i = $MinItems To $MaxItems - 1 Step 1
		$ClickPosX = $StartX + 45
		$ClickPosY = $MPos
		$MPos = $ClickPosY + 20
		If $ClickPosY < $EindY - 60 Then
			ClipPut("")
			Local $i = 0
			Do
				MouseClick("right", $ClickPosX, $ClickPosY, 1, 5)
				$clipBoardGet = ClipGet()
				WachtActief($iDelay)
				$i = $i + 1
			Until StringLeft($clipBoardGet, 1) = "~" Or $i > 2
			SplitTekst($clipBoardGet, $ClickPosX, $ClickPosY)
			WachtActief($iDelay)
			ToolTip($ItemType & "-" & $ItemInhoud & " op " & $ClickPosX & "," & $ClickPosY, $StartX + 1000, $StartY + 86)
			ConsoleWrite(@ScriptLineNumber & ">" & $aHoofdMenu & "-" & $aSubMenu & "-" & $aTab & "-" & $aSubTab & "-" & $aVeld & "*" & ClipGet() & "*" & $ClickPosX & "," & $ClickPosY & @CRLF)
			If $ItemType <> "NAV-HEADER" Then ;Geen hoofdmenu's
				ConsoleWrite(@ScriptLineNumber & "=>" & $aHoofdMenu & "-" & $aSubMenu & "-" & $aTab & "-" & $aSubTab & "-" & $aVeld & "*" & ClipGet() & "*" & $ClickPosX & "," & $ClickPosY & @CRLF)
				If _IsChecked($Checkbox92) And $clipBoardGet <> $vOverslaan Then ;Submenu openen
					WachtActief($iDelay)
					MouseClick("left", $ClickPosX, $ClickPosY, 2, 5)
					FoutControle()
					Send("{CTRLDOWN}j{CTRLUP}")
					WachtActief($iDelay)
					If $ItemInhoud = "Artikelen" Then
						ZoekQs($textInput61, $textInput611)
					EndIf
					If $ItemInhoud = "Klanten" Then
						ZoekQs($textInput62, $textInput621)
					EndIf
					If $ItemInhoud = "Leverancier" Then
						ZoekQs($textInput63, $textInput631)
					EndIf
					If _IsChecked($Checkbox94) Then ;Ook op de buttons van de taakbalk klikken
						Button($StartX + 520, $StartY + 65)
					EndIf
					WachtActief($iDelay)
					If _IsChecked($Checkbox93) Then ;Ook de tabs van submenu aanklikken
						MenuTab()
					EndIf
				EndIf
				$aSubMenu = $aSubMenu + 1
			Else
				$aHoofdMenu = $aHoofdMenu + 1
				$aSubMenu = 1
				$aVeld = 1; Velden nummeren per submenu
				;$hWnd = WinWait("HyperCam 3 MainDialog", "", 5)
				;WinActivate($hWnd)
				;Sleep($iDelay)
				;Send("{F3}") ;Sluit HyperCam
				;HyperCam()
			EndIf
		Else
			If $sSchuifMenu = 0 Then
				SchuifMenu()
			Else
				ExitLoop
			EndIf
		EndIf
	Next
EndFunc   ;==>MenuOpbouwen

Func MenuTab()
	#cs ----------------------------------------------------------------------------

		Func MenuTab
		1. Per submenu item detailknop zoeken in listview
		2. Indien detailknop gevonden, bepalen of detail een frame of dialoog is
		3.

	#ce ----------------------------------------------------------------------------

	ConsoleWrite(@ScriptLineNumber & " MenuTab" & @CRLF)
	ZoekKleur($StartX + 180, $StartY + 100, $StartX + 250, $EindY - 250, $ColorArray[7], 0, 1, @ScriptLineNumber); 1. Click detail knopje in listview
	WachtActief($iDelay)
	WachtActief($iDelay)
	If $FoutVlag = 0 Then ;Alleen inactieve tab zoeken op detail scherm wanneer detailknop is aangeklikt in listview
		WachtActief($iDelay)
		ConsoleWrite(@ScriptLineNumber & $sHoofdMenu & " Detailknop in listview gevonden" & @CRLF)
		BepaalScherm()
		If $ActiveScherm = "ERROR" Then
			SluitDialoog()
			ControleDialoogGesloten()
			$twSx = Round(($wS[2] / 2) + $wS[0])
			$twSy = $wS[1] + $wS[3] - 25
			MouseClick("left", $twSx, $twSy); klik op oke knop om error dialoog te sluiten
			ConsoleWrite(@ScriptLineNumber & ":" & $ActiveScherm & ": Error dialoog oke knop " & $wS[0] & "-" & $wS[1] & "-" & $wS[0] + $wS[2] & "-" & $wS[1] + $wS[3] & "," & $twSx & "," & $twSy & @CRLF)
			$FoutVlag = 9
		EndIf
		If $ActiveScherm = "Foutmelding" Then
			SluitDialoog()
			ControleDialoogGesloten()
			ConsoleWrite(@ScriptLineNumber & ":" & $ActiveScherm & ": " & $wS[0] & "-" & $wS[1] & "-" & $wS[0] + $wS[2] & "-" & $wS[1] + $wS[3] & "," & $twSx & "," & $twSy & @CRLF)
			$FoutVlag = 9
		EndIf
		If $ActiveScherm = "PrintManager" Then
			SluitDialoog()
			ControleDialoogGesloten()
			$twSx = Round(($wS[0] + $wS[2]) - 50)
			$twSy = $wS[1] + $wS[3] - 25
			MouseClick("left", $twSx, $twSy); klik op de annuleer knop om de Print Manager te sluiten
			ConsoleWrite(@ScriptLineNumber & ":" & $ActiveScherm & ": annuleer knop " & $wS[0] & "-" & $wS[1] & "-" & $wS[0] + $wS[2] & "-" & $wS[1] + $wS[3] & "," & $twSx & "," & $twSy & @CRLF)
		EndIf
		If $ActiveScherm = "ExportManager" Then
			SluitDialoog()
			ControleDialoogGesloten()
			ConsoleWrite(@ScriptLineNumber & ":" & $ActiveScherm & ": " & $wS[0] & "-" & $wS[1] & "-" & $wS[0] + $wS[2] & "-" & $wS[1] + $wS[3] & "," & $twSx & "," & $twSy & @CRLF)
		EndIf
		If $ActiveScherm = "Dialoog" Then; 2. Vanaf listview geen detailscherm maar gelijk een dialoog (b.v. "Artikelen voorraad")
			ConsoleWrite(@ScriptLineNumber & " Detail knop geeft een dialoog" & @CRLF)
			ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[6], 5, 1, @ScriptLineNumber);Zoek inactieve tab in dialoog
			ClickNextPrev()
			SluitDialoog()
			ControleDialoogGesloten()
			$FoutVlag = 9
		Else
			ConsoleWrite(@ScriptLineNumber & " Detail knop geeft een detailscherm" & @CRLF)
			If _IsChecked($Checkbox94) Then ;Ook op de buttons klikken
				Button($StartX + 520, $StartY + 65)
			EndIf
			If _IsChecked($Checkbox95) Then
				ZoekMiniDialoog($StartX + 210, $StartY + 100, $StartX + 1150, $StartY + 400, 23, 2)
			EndIf
			ZoekKleur($StartX + 210, $StartY + 350, $EindX - 50, $StartY + 600, $ColorArray[6], 0, 0, @ScriptLineNumber);Zoek inactieve tab op detailscherm
			If $FoutVlag > 0 Then; Tab zoeken via loopje (tabs staan niet op de goede hoogte)
				ZoekTab()
			Else
				MouseClick("left", $StartX + 220, $ClickPosY, 1, 5)
			EndIf
		EndIf
		If $sHoofdMenu = "Voorkeuren" Then
			ZoekKleur($StartX + 210, $StartY + 100, $EindX - 50 + 500, $StartY + 150, $ColorArray[6], 0, 0, @ScriptLineNumber);Zoek inactieve tab bovenkant detailscherm
		EndIf
		$TPos = $ClickPosY
		;ZoekVeld()
	EndIf
	If $FoutVlag = 0 Then
		ConsoleWrite(@ScriptLineNumber & " Inactieve tab gevonden" & @CRLF)
		Local $lActiveTab = ""
		Local $lsActiveTab = ""
		$aTab = 1
		For $i = $StartX + 240 To $StartX + $EindX Step 40; loop over alle tabs
			$ClickPosY = $TPos
			$AchterGrondKleur = PixelGetColor($i, $ClickPosY, $hWnd)
			EindeTab($AchterGrondKleur)
			If $fTest = True Then
				ConsoleWrite(@ScriptLineNumber & "#" & $aTab & "-" & $FoutVlag & "-" & @CRLF)
			EndIf
			If $FoutVlag = 0 Then
				MouseClick("right", $i, $ClickPosY, 1, 5)
				FoutControle()
				WachtActief($iDelay)
				$lActiveTab = ClipGet()
				WachtActief($iDelay)
				If $sHoofdMenu = "Voorkeuren" And StringLeft($lActiveTab, 8) = "~SUB-TAB" Then;In de voorkeuren zijn de tabs altijd subtabs
					$lActiveTab = "~" & StringTrimLeft($lActiveTab, 5)
					ConsoleWrite(@ScriptLineNumber & ":" & $lActiveTab & "," & @CRLF)
				EndIf
				If StringLeft($lActiveTab, 4) = "~TAB" Then
					If $lActiveTab <> $lsActiveTab And $lActiveTab <> $vOverslaan Then
						SplitTekst($lActiveTab, $i, $ClickPosY)
						If $fTest = True Then
							ToolTip($ItemType & "-" & $ItemInhoud & " op " & $i & "," & $ClickPosY, $StartX + 1000, $StartY + 86)
							ConsoleWrite(@ScriptLineNumber & "==>" & $aHoofdMenu & "-" & $aSubMenu & "-" & $aTab & "-" & $aSubTab & "-" & $aVeld & "*" & ClipGet() & "*" & $i & "," & $ClickPosY & @CRLF)
						EndIf
						;MouseClick("left", $i, $ClickPosY, 1, 5)
						ZoekKleur($StartX + 225, $TPos + 25, $StartX + 400, $TPos + 60, $ColorArray[6], 0, 1, @ScriptLineNumber);Zoek inactieve subtab
						If $FoutVlag = 0 Then
							SubTab()
						Else
							If _IsChecked($Checkbox94) Then ;Ook op de buttons klikken
								Button($StartX + 250, $TPos + 45)
							EndIf
						EndIf
						ZoekKleur($StartX + 200, $TPos + 25, $StartX + 250, $TPos + 150, $ColorArray[7], 0, 1, @ScriptLineNumber);Click detail knopje op detailscherm
						If $FoutVlag = 0 Then
							BepaalScherm()
							WachtActief($iDelay)
							ClickNextPrev()
							SluitDialoog()
							ControleDialoogGesloten()
						EndIf
						$aTab = $aTab + 1
						If $aTab > 20 Then
							ExitLoop
						EndIf
						WachtActief($iDelay)
						$lsActiveTab = $lActiveTab
					EndIf
				EndIf
			Else
				ExitLoop
			EndIf
			WachtActief($iDelay)
		Next
	EndIf
EndFunc   ;==>MenuTab

Func SubTab()
	ConsoleWrite(@ScriptLineNumber & " SubTab" & @CRLF)
	$aSubTab = 1
	$aVeld = 1
	$StPos = $ClickPosY
	Local $lActiveSubTab = ""
	Local $lsActiveSubTab = ""
	For $i = $StartX + 250 To $StartX + $EindX Step 40; loop over alle subtabs
		$ClickPosY = $StPos
		$AchterGrondKleur = PixelGetColor($i, $ClickPosY, $hWnd)
		EindeTab($AchterGrondKleur)
		If $fTest = True Then
			ConsoleWrite(@ScriptLineNumber & "##" & $aSubTab & @CRLF)
		EndIf
		If $FoutVlag = 0 Then
			MouseClick("right", $i, $ClickPosY, 1, 5)
			WachtActief($iDelay)
			$lActiveSubTab = ClipGet()
			WachtActief($iDelay)
			If StringLeft($lActiveSubTab, 8) = "~SUB-TAB" Then
				If $lActiveSubTab <> $lsActiveSubTab And $lActiveSubTab <> $vOverslaan  Then
					SplitTekst($lActiveSubTab, $i, $ClickPosY)
					If $fTest = True Then
						ToolTip($ItemType & "-" & $ItemInhoud & " op " & $i & "," & $ClickPosY, $StartX + 1000, $StartY + 86)
						ConsoleWrite(@ScriptLineNumber & "===>" & $aHoofdMenu & "-" & $aSubMenu & "-" & $aTab & "-" & $aSubTab & "-" & $aVeld & "*" & ClipGet() & "*" & $i & "," & $ClickPosY & @CRLF)
					EndIf
					ZoekKleur($StartX + 225, $StPos + 25, $StartX + 400, $StPos + 60, $ColorArray[6], 0, 1, @ScriptLineNumber);Zoek inactieve subtab
					If $FoutVlag = 0 Then
						If _IsChecked($Checkbox94) Then ;Ook op de buttons klikken
							Button($StartX + 250, $StPos + 85)
						EndIf
						ZoekKleur($StartX + 190, $StPos + 65, $StartX + 290, $StPos + 190, $ColorArray[7], 0, 1, @ScriptLineNumber);Click detail knopje
					Else
						If _IsChecked($Checkbox94) Then ;Ook op de buttons klikken
							Button($StartX + 250, $StPos + 45)
						EndIf
						ZoekKleur($StartX + 190, $StPos + 25, $StartX + 290, $StPos + 150, $ColorArray[7], 0, 1, @ScriptLineNumber);Click detail knopje
					EndIf
					If $FoutVlag = 0 Then
						BepaalScherm()
						WachtActief($iDelay)
						ClickNextPrev()
						SluitDialoog()
						ControleDialoogGesloten()
					EndIf
					$aSubTab = $aSubTab + 1
					If $aSubTab > 10 Then
						ExitLoop
					EndIf
					WachtActief($iDelay)
					$lsActiveSubTab = $lActiveSubTab
				EndIf
			EndIf
		Else
			ExitLoop
		EndIf
	Next
	$FoutVlag = 0
EndFunc   ;==>SubTab

Func EindeTab($EindeKleur)
	$FoutVlag = 0
	If $EindeKleur = $ColorArray[2] Then ;Artikel detail
		$FoutVlag = 1
	EndIf
	If $EindeKleur = $ColorArray[3] Then ;Overig detail
		$FoutVlag = 2
	EndIf
	If $EindeKleur = $ColorArray[9] Then ;SubTab achtergrond
		$FoutVlag = 3
	EndIf
	If $EindeKleur = $ColorArray[22] Then ;Listview blauwe geselecteerde regel
		$FoutVlag = 4
	EndIf
	If $FoutVlag > 0 Then
		ConsoleWrite(@ScriptLineNumber & ": EindeTab " & $FoutVlag & @CRLF)
	EndIf
EndFunc   ;==>EindeTab

Func BepaalScherm()
	ConsoleWrite(@ScriptLineNumber & " BepaalScherm" & @CRLF)
	$ActiveScherm = ""
	If WinActive("[CLASS:SunAwtFrame]") Then
		$hWnd = WinWait("[CLASS:SunAwtFrame]", "", 2)
		$ActiveScherm = "HoofdScherm"
	Else
		If WinActive("[CLASS:SunAwtDialog]") Then
			If WinActive("[Title:Foutmelding]") Then
				$hWnd = WinWait("[Title:Foutmelding]", "", 2)
				$ActiveScherm = "Foutmelding"
			Else
				If WinActive("[Title:Error]") Then
					$hWnd = WinWait("[Title:Error]", "", 2)
					$ActiveScherm = "ERROR"
				Else
					If WinActive("[Title:Print Manager]") Then
						$hWnd = WinWait("[Title:Print Manager]", "", 2)
						$ActiveScherm = "PrintManager"
					Else
						If WinActive("[Title:Export manager]") Then
							$hWnd = WinWait("[Title:Export manager]", "", 2)
							$ActiveScherm = "ExportManager"
						Else
							$hWnd = WinWait("[CLASS:SunAwtFrame]", "", 2)
							$ActiveScherm = "Dialoog"
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	$wS = WinGetPos("[ACTIVE]")
	WinActivate($hWnd)
	ConsoleWrite(@ScriptLineNumber & ":" & $ActiveScherm & ":" & $wS[0] & "-" & $wS[1] & "-" & $wS[0] + $wS[2] & "-" & $wS[1] + $wS[3] & @CRLF)
EndFunc   ;==>BepaalScherm

Func ZoekKleur($Xt, $Yt, $Xb, $Yb, $color, $Shade, $aClick, $nLine)
	GUICtrlSetBkColor($ColorLabel01, $color)
	Tekenkader($Xt, $Yt, $Xb, $Yb, 5)
	MouseMove($Xt + 10, $Yt + 10, 50)
	WachtActief($iDelay)
	For $i = 0 To 24 Step 1
		If $color = $ColorArray[$i] Then ;Als kleur uit tabel is gezochte kleur kijk in teksttabel
			ExitLoop
		EndIf
	Next
	ConsoleWrite(@ScriptLineNumber & " i=" & $i & "-" & $ItemType & "-" & $ItemInhoud & ":" & $TekstArray[$i] & @CRLF)
	GUICtrlSetData($Edit01, $ItemType & "-" & $ItemInhoud & ":" & $TekstArray[$i])
	$point = PixelSearch($Xt, $Yt + 5, $Xb, $Yb, $color, $Shade)
	$FoutVlag = 0
	If IsArray($point) Then
		If $i = 7 Then ;Alleen bij zoeken naar detail knop ook rechts klikken
			MouseClick("right", $point[0] + 60, $point[1], $aClick, 5)
			WachtActief($iDelay)
			ToolTip($TekstArray[$i] & " op " & $point[0] & "," & $point[1], $StartX + 1000, $StartY + 86)
			EersteKolom()
		EndIf
		MouseClick("left", $point[0], $point[1], $aClick, 25)
		FoutControle()
		$ClickPosX = $point[0]
		$ClickPosY = $point[1] + 5
	Else
		ConsoleWrite($nLine & ": " & $TekstArray[$i] & " - " & $color & " niet gevonden!" & @CRLF)
		$FoutVlag = 1
	EndIf
EndFunc   ;==>ZoekKleur

Func Tekenkader($Xt, $Yt, $Xb, $Yb, $speed)
	MouseMove($Xt, $Yt, $speed)
	MouseMove($Xb, $Yt, $speed)
	MouseMove($Xb, $Yb, $speed)
	MouseMove($Xt, $Yb, $speed)
	MouseMove($Xt, $Yt, $speed)
EndFunc   ;==>Tekenkader

Func SluitDialoog()
	ConsoleWrite(@ScriptLineNumber & " Sluitdialoog" & @CRLF)
	If @OSVersion = "WIN_10" Then
		ConsoleWrite(@ScriptLineNumber & " ==w0===>" & @CRLF)
		ZoekKleur($wS[0] + $wS[2] - 25, $wS[1] + 5, $wS[0] + $wS[2] - 5, $wS[1] + 25, $ColorArray[20], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
	Else
		ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[4], 1, 1, @ScriptLineNumber) ;Zoek dialoog annuleer knop
	EndIf

	;Wanneer annuleer knopje een nieuwe dialoog opent met het groene of blauwe info icoon, of het rode error icoon dan deze dialoog ook sluiten
	If $FoutVlag = 0 Then
		WachtActief($iDelay)
		BepaalScherm()
		ConsoleWrite(@ScriptLineNumber & " ==wE===>" & $ActiveScherm & @CRLF)
		If $ActiveScherm = "ERROR" Or $ActiveScherm = "Foutmelding" Then
			ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[24], 5, 1, @ScriptLineNumber) ;Error scherm rood
			$twSx = Round(($wS[2] / 2) + $wS[0])
			$twSy = $wS[1] + $wS[3] - 25
			ConsoleWrite(@ScriptLineNumber & " Sluit error scherm " & $wS[0] & "," & $wS[1] & "," & $wS[2] & "," & $wS[3] & "," & $twSx & "," & $twSy & @CRLF)
			MouseClick("left", $twSx, $twSy); klik op oke knop in Error scherm om dialoog te sluiten
			WachtActief($iDelay)
			BepaalScherm()
			If @OSVersion = "WIN_10" Then
				ZoekKleur($wS[0] + $wS[2] - 25, $wS[1] + 5, $wS[0] + $wS[2] - 5, $wS[1] + 25, $ColorArray[20], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
			Else
				ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[4], 1, 1, @ScriptLineNumber) ;Zoek dialoog annuleer knop
			EndIf
			WachtActief($iDelay)
			BepaalScherm()
		EndIf
		If $ActiveScherm = "Dialoog" Then
			ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[11], 5, 1, @ScriptLineNumber) ;Info scherm groen
			If $FoutVlag > 0 Then
				ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[21], 5, 1, @ScriptLineNumber) ;Info scherm blauw
			EndIf
			If $FoutVlag = 0 Then
				If @OSVersion = "WIN_7" Then
					ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[10], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
				Else
					If @OSVersion = "WIN_10" Then
						$twSx = Round(($wS[2] / 2) - 25 + $wS[0])
						$twSy = $wS[1] + $wS[3] - 25
						ConsoleWrite(@ScriptLineNumber & " ==w1===>" & $wS[0] & "," & $wS[1] & "," & $wS[2] & "," & $wS[3] & "," & $twSx & "," & $twSy & @CRLF)
						MouseClick("left", $twSx, $twSy); klik op ja knop in blauw of groen info scherm om dialoog te sluiten
						;ZoekKleur($wS[0] + $wS[2] - 25, $wS[1] + 5, $wS[0] + $wS[2] - 5, $wS[1] + 25, $ColorArray[20], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
					Else
						;Windows 8 heeft andere annuleer knoppen
						ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[16], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Actief)
						If $FoutVlag > 0 Then
							ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[17], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Inactief)
						EndIf
					EndIf
				EndIf
			EndIf
			$FoutVlag = 0
		EndIf
	EndIf

	;Probeer dialoog te sluiten met het windows sluit venster kruisje
	If $FoutVlag > 0 Then
		If @OSVersion = "WIN_7" Then
			ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[10], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
		Else
			If @OSVersion = "WIN_10" Then
				ConsoleWrite(@ScriptLineNumber & " ===w2==>" & @CRLF)
				ZoekKleur($wS[0] + $wS[2] - 25, $wS[1] + 5, $wS[0] + $wS[2] - 5, $wS[1] + 25, $ColorArray[20], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
			Else
				;Windows 8 heeft andere annuleer knoppen
				ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[16], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Actief)
				If $FoutVlag > 0 Then
					ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[17], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Inactief)
				EndIf
			EndIf
		EndIf
	EndIf

	;Indien de actieve dialoog het groene of blauwe info icoon bevat dan deze dialoog sluiten en ook de volgende dialoog met de vraag "weet u zeker..."
	If $FoutVlag > 0 Then
		ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[11], 5, 1, @ScriptLineNumber) ;Info scherm groen
		If $FoutVlag > 0 Then
			ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[21], 5, 1, @ScriptLineNumber) ;Info scherm blauw
			If $FoutVlag = 0 Then
				If @OSVersion = "WIN_7" Then
					ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[10], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
				Else
					If @OSVersion = "WIN_10" Then
						ConsoleWrite(@ScriptLineNumber & " ==w3===>" & @CRLF)
						ZoekKleur($wS[0] + $wS[2] - 25, $wS[1] + 5, $wS[0] + $wS[2] - 5, $wS[1] + 25, $ColorArray[20], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
					Else
						;Windows 8 heeft andere annuleer knoppen
						ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[16], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Actief)
						If $FoutVlag > 0 Then
							ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[17], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Inactief)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	If $FoutVlag > 0 Then
		If _IsChecked($Radio41) Then; Indien test dan zoeken naar test logo anders naar branch logo
			ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[12], 0, 2, @ScriptLineNumber) ;Zoek Solidis logo test
		Else
			ZoekKleur($wS[0], $wS[1], $wS[0] + $wS[2], $wS[1] + $wS[3], $ColorArray[13], 0, 2, @ScriptLineNumber) ;Zoek Solidis logo branch
		EndIf
	EndIf
EndFunc   ;==>SluitDialoog

Func ClickNextPrev()
	ConsoleWrite("ClickNextPrev" & @CRLF)
	ZoekKleur($wS[0] + $wS[2] - 150, $wS[1] + 20, $wS[0] + $wS[2], $wS[1] + 100, $ColorArray[19], 5, 1, @ScriptLineNumber);
	If $FoutVlag = 0 Then
		MouseClick("Right", $ClickPosX, $ClickPosY, 1)
		WachtActief($iDelay)
		$clipBoardGet = ClipGet()
		WachtActief($iDelay)
		ConsoleWrite("ClickNextPrev:" & $clipBoardGet & @CRLF)
		If StringLeft($clipBoardGet, 18) = "~BUTTON: btn_first" Then
			MouseClick("Left", $ClickPosX + 40, $ClickPosY, 3, 25)
			WachtActief($iDelay)
			MouseClick("Left", $ClickPosX + 20, $ClickPosY, 3, 25)
		EndIf
	EndIf
	$FoutVlag = 0
EndFunc   ;==>ClickNextPrev

Func ZoekMiniDialoog($Xt, $Yt, $Xb, $Yb, $tK, $tD)
	Local $Mdeel = Round(($Xb - $Xt) / $tD)
	For $x = 1 To $tD
		ZoekKleur($Xt + (($x - 1) * $Mdeel), $Yt, $Xt + ($Mdeel * $x), $Yb, $ColorArray[$tK], 3, 1, @ScriptLineNumber);Zoek in detailscherm naar blauwe pijltje voor een mini dialoog
		If $FoutVlag = 0 Then
			$point = MouseGetPos()
			Local $MPosX = $point[0]
			Local $MPosY = $point[1]
			WachtActief($iDelay)
			BepaalScherm()
			SluitDialoog()
			ControleDialoogGesloten()
			For $i = $MPosY + 20 To $Yb Step 20
				ZoekKleur($MPosX - 20, $i, $MPosX + 20, $Yb, $ColorArray[$tK], 5, 1, @ScriptLineNumber);Zoek in detailscherm naar blauwe pijltje voor een mini dialoog
				If $FoutVlag = 0 Then
					WachtActief($iDelay)
					BepaalScherm()
					SluitDialoog()
					ControleDialoogGesloten()
				Else
					ExitLoop
				EndIf
			Next
		EndIf
	Next
	$FoutVlag = 0
EndFunc   ;==>ZoekMiniDialoog

Func ZoekTab()
	$color = PixelGetColor($StartX + 235, $StartY + 250)
	If $color = $ColorArray[2] Or $color = $ColorArray[3] Then
		$sColor = $color
	EndIf

	For $i = $StartY + 340 To $StartY + 500 Step 20
		$color = PixelGetColor($StartX + 235, $i)
		If $color = $ColorArray[3] Or $color = $ColorArray[3] Then
			$sColor = $color
		EndIf
		If $color <> $ColorArray[3] Then; Loop totdat de gevonden pixel niet wit is
			$ClickPosY = $i
			$FoutVlag = 0
			ExitLoop
		EndIf
	Next
	For $i = 0 To 24 Step 1
		If $color = $ColorArray[$i] Then ;Als kleur uit tabel is gezochte kleur kijk in teksttabel
			ExitLoop
		EndIf
	Next
	If $i > 0 And $i < 25 Then
		ConsoleWrite(@ScriptLineNumber & ": Gevonden kleur= " & $color & " Tekst -" & $TekstArray[$i] & "- in tabel." & @CRLF)
	Else
		ConsoleWrite(@ScriptLineNumber & ": Geen tabs gevonden!!" & @CRLF)
		$FoutVlag = 1
	EndIf
EndFunc   ;==>ZoekTab

Func ZoekVeld()
	$ItemClipboard = ""
	$sVeld = ""
	$color = PixelGetColor($StartX + 200, $StartY + 200)
	If $color = $ColorArray[2] Or $color = $ColorArray[3] Then
		$sColor = $color
	EndIf

	For $i = $StartY + 130 To $StartY + 500 Step 10
		$color = PixelGetColor($StartX + 200, $i)
		MouseClick("right", $StartX + 250, $i, 1, 5)
		FoutControle()
		$ItemClipboard = ClipGet()
		If $sVeld <> $ItemClipboard Then
			If $fTest = True Then
				ConsoleWrite(@ScriptLineNumber & " Label: " & $ItemClipboard & @CRLF)
			EndIf
			If StringMid($ItemClipboard, 2, 5) = "LABEL" Then
				SplitTekst($ItemClipboard, $ClickPosX, $ClickPosY)
				$aVeld = $aVeld + 1
			EndIf
			$sVeld = $ItemClipboard
		EndIf
	Next
EndFunc   ;==>ZoekVeld

Func SplitTekst($Tekst, $PosX, $PosY)
	WachtActief($iDelay)
	Local $lsTekst = ""
	$lsTekst = StringReplace($Tekst, " ", "")
	If StringLeft($lsTekst, 1) <> "~" Then
		ConsoleWrite(@ScriptLineNumber & " Clipboard bevat ongeldige waarde:" & $Tekst & @CRLF)
		$lsTekst = "Fout type:" & StringLeft($Tekst, 5) & "..."
	Else
		$cMouseClick = $cMouseClick + 1
		GUICtrlSetData($Edit92, $cMouseClick)
	EndIf
	If $fTest = True Then
		FileWriteLine($hFileOpen1, "Clipboard tekst:" & $lsTekst)
	EndIf
	$sNAV = StringSplit($lsTekst, "~:")
	$iMax = UBound($sNAV) - 1
	$ItemType = $sNAV[2]

	If $fTest = True Then
		For $i = 0 To $iMax
			ConsoleWrite($sNAV[$i] & "|")
		Next
		ConsoleWrite(@CRLF)
	EndIf
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
			$ItemInhoud = $sNAV[7]
			If $ItemInhoud = "" Then
				$ItemInhoud = $sNAV[3]
			EndIf
			$sTekst = $sNAV[5]
		Case "FIELD"
			$ItemInhoud = $sNAV[3]
			$sButton = $sNAV[3]
			$sTekst = $sNAV[5]
			$vEditable = $sNAV[12]
		Case Else
			$sSchrijfVlag = 0
	EndSwitch

	$vSleep = Round(TimerDiff($hTimer)) + 250

	Local $sKleur = PixelGetColor($PosX, $PosY)
	If $PosX < -10 Then
		$PosX = $PosX + $SizeX
	EndIf
	If $PosX > ($SizeX - 10) Then
		$PosX = $PosX - $SizeX
	EndIf

	If $ItemType = "NAV-ITEM" Then
		$sIconKleur = $sKleur
		$sIconPosY = $PosY
	EndIf
	If $ItemType = "NAV-HEADER" Or $ItemType = "NAV-ITEM" Then
		$Record = StringReplace($ItemType & ";" & $sHoofdMenu & ";" & $sSubMenu & ";" & $sTab & ";" & $sSubTab & ";" & $sButton & ";" & $sTekst & ";" & $sActive & ";" & $sMaxTab & ";" & $sKleur & ";" & $PosX & ";" & $sSchuifVerschil + $PosY & ";" & $vSleep, " ", "")
	Else
		$Record = StringReplace($ItemType & ";" & $sHoofdMenu & ";" & $sSubMenu & ";" & $sTab & ";" & $sSubTab & ";" & $sButton & ";" & $sTekst & ";" & $sActive & ";" & $sMaxTab & ";" & $sKleur & ";" & $PosX & ";" & $PosY & ";" & $vSleep & ";" & $vEditable, " ", "")
	EndIf
	If $ItemType = "NAV-HEADER" Then
		If $PosY = $svPosY Then
			$sSchrijfVlag = 0
		Else
			$svPosY = $PosY
		EndIf
	EndIf

	$hTimer = TimerInit()

	If _IsChecked($Checkbox91) And $sSchrijfVlag = 1 Then
		FileWriteLine($hFileOpen2, $Record)
	EndIf
	ConsoleWrite("File2:" & $sHoofdMenu & ", " & $sSubMenu & ", " & $sTab & ", " & $sSubTab & ", " & $sButton & ", " & $sTekst & ", " & $sActive & ", " & $sMaxTab & ", " & $sKleur & ", " & $PosX & ", " & $PosY & @CRLF)

	GUICtrlSetData($Edit01, $ItemType & ":" & $ItemInhoud)
	GUICtrlSetData($Edit02, $PosX & ", " & $PosY & " - " & $sKleur & " : " & $ItemType & " - " & $ItemInhoud)
EndFunc   ;==>SplitTekst

Func FoutControle()
	$clipBoardGet = ClipGet()
	If StringLeft($clipBoardGet, 7) = "~ERROR:" Then
		ScreenShot()
		FileWriteLine($hFileOpen1, $clipBoardGet)
		FileFlush($hFileOpen1)
		Beep(2000, 500)
		Beep(500, 500)
		Beep(2000, 500)
		Beep(500, 500)
	EndIf
EndFunc   ;==>FoutControle

Func EersteKolom()
	$clipBoardGet = ClipGet()
	ConsoleWrite(@ScriptLineNumber & " Veld:" & $clipBoardGet & @CRLF)
	If StringLeft($clipBoardGet, 7) = "~FIELD:" Then
		FileWriteLine($hFileOpen1, $clipBoardGet)
		FileFlush($hFileOpen1)
	EndIf
EndFunc   ;==>EersteKolom

Func ZoekQs($sZoekTekst, $sZoekTeken)
	;MouseClick("left", 1427, 65, 1);klik in zoekvak
	Send("{CTRLDOWN}f{CTRLUP}")
	WachtActief($iDelay)
	ConsoleWrite(@ScriptLineNumber & "*" & $sZoekTekst & "_" & $sZoekTeken & "*" & @CRLF)
	If StringIsDigit($sZoekTekst) Then
		If $sZoekTeken = "^" Then
			Send("^" & $sZoekTekst)
		Else
			If $sZoekTeken = "$" Then
				Send($sZoekTekst & "$")
			Else
				If $sZoekTeken = "" Then
					Send($sZoekTekst)
				EndIf
			EndIf
		EndIf
	Else
		$rNum = Random(011, 5000, 1)
		Send($rNum)
	EndIf
	WachtActief($iDelay)
	Send("{ENTER}")
	WachtActief($iDelay)
EndFunc   ;==>ZoekQs

Func Button($XbPos, $YbPos)
	Local $lActiveButton = ""
	Local $lsActiveButton = ""
	For $i = $XbPos To $XbPos + 400 Step 100; loop over alle buttons
		ClipPut("")
		WachtActief($iDelay)
		MouseClick("right", $i, $YbPos, 1, 5)
		WachtActief($iDelay)
		$lActiveButton = ClipGet()
		WachtActief($iDelay)
		If $lActiveButton <> "" And $lActiveButton <> "~BUTTON: btn_newc ~FORMNAME: dd_prod_dd_prod_stock_location_tbl" And $lActiveButton <> "~BUTTON: BTN_open ~FORMNAME: dd_prod_dd_prod_product_lst_frm"  And $lActiveButton <> $vOverslaan Then
			If StringLeft($lActiveButton, 8) = "~BUTTON:" Then
				If $lActiveButton <> $lsActiveButton Then
					FileWriteLine($hFileOpen1, $lActiveButton)
					FileFlush($hFileOpen1)
					SplitTekst($lActiveButton, $i, $YbPos)
					If $fTest = True Then
						ToolTip($ItemType & "-" & $ItemInhoud & " op " & $i & "," & $YbPos, $StartX + 1000, $StartY + 86)
						ConsoleWrite(@ScriptLineNumber & "#>" & $aHoofdMenu & "-" & $aSubMenu & "-" & $aTab & "-" & $aSubTab & "-" & $aVeld & "*" & $lActiveButton & "*" & $i & "," & $YbPos & @CRLF)
					EndIf
					MouseClick("left", $i, $YbPos, 1, 5)
					WachtActief($iDelay)
					BepaalScherm()
					If $ActiveScherm = "Hoofdscherm" Then ;Dialoog openen duurt te lang
						WachtActief($iDelay)
						WachtActief($iDelay)
						BepaalScherm()
					EndIf
					If $ActiveScherm = "Dialoog" Then ;Test of je een dialoog krijgt als je op de knop klikt
						ConsoleWrite(@ScriptLineNumber & " Knop " & StringLeft($lActiveButton, 16) & "... aanklikken geeft een dialoog" & @CRLF)
						WachtActief($iDelay)
						If _IsChecked($Checkbox95) Then
							ZoekMiniDialoog($wS[0] + 25, $wS[1] + 100, $wS[0] + $wS[2] - 50, $wS[1] + $wS[3] - 25, 23, 3)
						EndIf
						ClickNextPrev()
						SluitDialoog()
						ControleDialoogGesloten()
					EndIf
					If $ActiveScherm = "PrintManager" Then ;Test of je de Print Manager krijgt als je op de knop klikt
						ConsoleWrite(@ScriptLineNumber & " Knop " & StringLeft($lActiveButton, 16) & "... aanklikken geeft de Print Manager" & @CRLF)
						WachtActief($iDelay)
						$twSx = Round(($wS[0] + $wS[2]) - 50)
						$twSy = $wS[1] + $wS[3] - 25
						MouseClick("left", $twSx, $twSy); klik op de annuleer knop om de Print Manager te sluiten
					EndIf
					If $ActiveScherm = "ExportManager" Then ;Test of je de Export Manager krijgt als je op de knop klikt
						ConsoleWrite(@ScriptLineNumber & " Knop " & StringLeft($lActiveButton, 16) & "... aanklikken geeft de Export Manager" & @CRLF)
						WachtActief($iDelay)
						SluitDialoog()
						ControleDialoogGesloten()
					EndIf
					If $ActiveScherm = "Foutmelding" Then
						ConsoleWrite(@ScriptLineNumber & " Knop " & StringLeft($lActiveButton, 16) & "... aanklikken geeft een Foutmelding!" & @CRLF)
						WachtActief($iDelay)
						SluitDialoog()
						ControleDialoogGesloten()
						WachtActief($iDelay)
						BepaalScherm()
						WachtActief($iDelay)
					EndIf
					If $ActiveScherm = "ERROR" Then
						ConsoleWrite(@ScriptLineNumber & " Knop " & StringLeft($lActiveButton, 16) & "... aanklikken geeft een ERROR!!!" & @CRLF)
						Do
							WachtActief($iDelay)
							SluitDialoog()
							ControleDialoogGesloten()
							WachtActief($iDelay)
							BepaalScherm()
							;$twSx = Round(($wS[2] / 2) + $wS[0])
							;$twSy = $wS[1] + $wS[3] - 25
							;MouseClick("left", $twSx, $twSy); klik op oke knop om error dialoog te sluiten
						Until $ActiveScherm <> "ERROR"
					EndIf
					WachtActief($iDelay)
					$lsActiveButton = $lActiveButton
				EndIf
			EndIf
		Else
			ConsoleWrite(@ScriptLineNumber & " Geen knop gevonden " & "*" & $lActiveButton & "*" & @CRLF)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>Button

Func WachtActief($iWacht)
	Local $iCursor = MouseGetCursor()
	Sleep($iWacht)
	If $iCursor = 15 Then
		$iWacht = $iWacht * 2
	EndIf
	Do
		$iCursor = MouseGetCursor()
		Sleep($iWacht)
	Until $iCursor <> 15
	;2e keer uitvoeren om knipperende zandloper op te vangen
	Sleep($iWacht)
	If $iCursor = 15 Then
		$iWacht = $iWacht * 2
	EndIf
	Do
		$iCursor = MouseGetCursor()
		Sleep($iWacht)
	Until $iCursor <> 15
EndFunc   ;==>WachtActief

Func ControleDialoogGesloten()
	ConsoleWrite(@ScriptLineNumber & " ControleDialoogGesloten" & @CRLF)
	If $FoutVlag > 0 Then
		ConsoleWrite(@ScriptLineNumber & " Sluiten dialoog lukt niet!!" & @CRLF)
		WachtActief($iDelay)
		Local $sWs = $wS
		BepaalScherm()
		If $sWs = $wS Then ;Als schermgrootte nog steeds hetzelfde is, dialoog geforceerd sluiten
			WachtActief($iDelay)
			Send("!F4") ;Geforceerd sluiten
			BepaalScherm()
			If $sWs = $wS Then
				ConsoleWrite("Scherm nog steeds niet gesloten, test gestopt!!" & @CRLF)
				Exit
			EndIf
		EndIf
	Else
		Send("{ENTER}")
		WachtActief($iDelay)
		BepaalScherm()
		If $ActiveScherm = "Dialoog" Then
			If @OSVersion = "WIN_7" Then
				ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[10], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
			Else
				If @OSVersion = "WIN_10" Then
					ConsoleWrite(@ScriptLineNumber & " =====>" & @CRLF)
					ZoekKleur($wS[0] + $wS[2] - 25, $wS[1] + 5, $wS[0] + $wS[2] - 5, $wS[1] + 25, $ColorArray[20], 5, 1, @ScriptLineNumber) ;Zoek window annuleer knop (fusie zoek)
				Else
					;Windows 8 heeft andere annuleer knoppen
					ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[16], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Actief)
					If $FoutVlag > 0 Then
						ZoekKleur($wS[0] + $wS[2] - 90, $wS[1] - 50, $wS[0] + $wS[2] + 10, $wS[1] + 50, $ColorArray[17], 5, 1, @ScriptLineNumber) ;Annuleer Windows 8 (Inactief)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>ControleDialoogGesloten

Func RightClick($cPosX, $cPosY, $cX, $cT)
	ClipPut("")
	WachtActief($iDelay)
	MouseClick("right", $ClickPosX, $ClickPosY - 20, 1, 5)
	WachtActief($iDelay)
EndFunc   ;==>RightClick

Func SchuifMenu()
	MouseClick("Left", $StartX + 180, $ClickPosY - 40, 1, 5)
	ZoekKleur($StartX + 5, $StartY + 100, $StartX + 200, $EindY - 50, $ColorArray[18], 0, 2, @ScriptLineNumber) ;Menu formaat
	If $FoutVlag = 0 Then
		$sSchuifMenu = $sSchuifMenu + 1
		$sSchuifVerschil = $sIconPosY - $ClickPosY
		$ColorArray[20] = $sIconKleur
		ZoekKleur($StartX + 10, $ClickPosY - 10, $StartX + 150, $ClickPosY + 10, $ColorArray[20], 0, 2, @ScriptLineNumber) ;Laatste NAV-ITMEM terug zoeken
		$MPos = $ClickPosY + 15
		If $fTest = True Then
			GUICtrlSetState($Checkbox92, $GUI_CHECKED)
		EndIf
	EndIf
EndFunc   ;==>SchuifMenu

Func ScreenShot()
	ConsoleWrite(@ScriptLineNumber & " Screenshot" & @CRLF)
	_ScreenCapture_Capture(@MyDocumentsDir & "\Batch\Error_ScreenShot" & _NowTime() & ".jpg")
EndFunc   ;==>ScreenShot

Func HyperCam()
	ConsoleWrite(@ScriptLineNumber & " HyperCam" & @CRLF)
	Sleep($iDelay)
	Send("{F2}") ;Start HyperCam
EndFunc   ;==>HyperCam
