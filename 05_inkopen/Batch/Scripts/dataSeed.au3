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
Global $Y = 40

$Form1 = GUICreate("dataSeed", 416, 200, 375, 375)
$Group00 = GUICtrlCreateGroup("", 8, 17, 400, 130)
GUICtrlCreateLabel("Druk op de startknop", 32, $Y + 20, 300, 17)
GUICtrlCreateLabel("Ga naar dbvis en selecteer de tabel ", 32, $Y + 20, 300, 17)
GUICtrlCreateLabel("die je aan de dataseed wilt toevoegen", 32, $Y + 40, 300, 17)
$bStart = GUICtrlCreateButton("Start", 150, 150, 75, 25)

GUISetState(@SW_SHOW)

Global $vButton = 1
Global $vX, $vY = 0
Global $vButton = "left"
Global $vTabel = ""
Global $vKlik = 2
Global $pauze = 750
Global $cBleep = 1
$date = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC &  "_"
Global $vFilepath = "C:\Users\Test\Documents\solidis\_dataSeed\" & $date

Func Start()
	ConsoleWrite(@ScriptLineNumber & ":Start" & @CRLF)

;Eerst met de muis de knop links klikken
	ToolTip("Selecteer de tabel in dbvis", 200, 100, "Klik!",1)
	Local $i = 0
	Do
		If _IsPressed("01") Then
			$i = $i + 1
			Sleep(500)
		EndIf
	Until $i > 0
	Local $vPos = MouseGetPos()
	$vX = $vPos[0]
	$vY = $vPos[1]
	Verwerk($vX, $vY)
	Exit
EndFunc

Func Verwerk($x, $y)
	ConsoleWrite(@ScriptLineNumber & ":Verwerk: " & $x & "," & $y & @CRLF)
	BleepStart()
	Sleep($pauze)
	Click("left", $x,$y)
	Sleep($pauze)
	Send("{CTRLDOWN}c{CTRLUP}")
	Sleep($pauze)
	$vClipget = ClipGet()
	Sleep($pauze)
	Click("right", $x,$y)
	Proceed($vClipget)
	Sleep($pauze)
	BleepStop()
EndFunc

Func Proceed($clipboard)
	Send("{DOWN 10}")
	Sleep($pauze)
	Send("{ENTER}")
	Sleep($pauze*2)
	Send("{TAB}")
	Sleep($pauze)
	Send("{TAB}")
	Sleep($pauze)
	Send("{TAB}")
	Sleep($pauze)
	Send("{TAB}")
	Sleep($pauze)
	Send("{CTRLDOWN}a{CTRLUP}{DEL}")
	Sleep($pauze)
	Send($vFilepath & $clipboard & ".sql")
	ConsoleWrite(@ScriptLineNumber & $date & @CRLF)
	Sleep($pauze)
	Send("{ENTER}")
	Sleep($pauze)
	Send("{ESC}")
	Sleep($pauze)
	ShellExecute($vFilepath & $clipboard & ".sql")
	Sleep($pauze)
	Sleep($pauze)
	Send("{CTRLDOWN}{HOME}{CTRLUP}")
	Sleep($pauze)
	Send("SET search_path = stb_data, pg_catalog;")
	Send("{ENTER}")
	Send("TRUNCATE " & $clipboard & " RESTART IDENTITY;")
	Sleep($pauze)
	Send("{ENTER}")
	Sleep($pauze)
	Send("{ENTER}")
	Sleep($pauze)
	Send("{CTRLDOWN}{END}{CTRLUP}")
	Sleep($pauze)
	Send("{ENTER}")
	Sleep($pauze)
	Send("SELECT setval(pg_get_serial_sequence(' " & $clipboard & "', ' " & $clipboard & "_id'), coalesce(max(" & $clipboard & "_id),0) +" & " 1, false) FROM " & $clipboard & ";")
	Sleep($pauze)
EndFunc

Func Click($vButton, $x, $y)
	ConsoleWrite(@ScriptLineNumber & ":Click" & @CRLF)
	ConsoleWrite($vButton & "," & $x & "," & $y & @CRLF)
	MouseClick($vButton, $x, $y)
EndFunc

Func BleepStart()
	If _IsChecked($cBleep) Then
		Beep(2500, 100)
	EndIf
EndFunc

Func BleepStop()
	If _IsChecked($cBleep) Then
		Beep(500, 1000)
	EndIf
EndFunc

Func _IsChecked($iControlID)
	Return BitAND(GUICtrlRead($iControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $bStart
			Start()
	EndSwitch
	Sleep(10)
WEnd
