﻿#SingleInstance off
seasons := ["Winter", "Autumn", "Summer", "Spring"]
suffixes := ["", "k", "M", "G", "T", "P", "E"]
useSecondDeriv = 0
digitLimits := [10, 20, 50, 100, 1000, 10000]
defaultStart = 20150111090000
defaultEnd = 20150328010000

closestFraction(inputNumber, denominatorBoundKey) {
	global digitLimits
	smallNumerator := 0, smallDenominator := 1, largeNumerator := 1, largeDenominator := 1
	denominatorLimit := digitLimits[denominatorBoundKey]
	while (smallDenominator <= denominatorLimit && largeDenominator <= denominatorLimit)
	{
		mediant := (smallNumerator + largeNumerator) / (smallDenominator + largeDenominator)
		if (inputNumber = mediant) {
			if (smallDenominator + largeDenominator <= denominatorLimit)
				return (smallNumerator + largeNumerator) . "/" . (smallDenominator + largeDenominator)
			else if (largeDenominator > smallDenominator)
				return largeNumerator "/" largeDenominator
			else
				return smallNumerator "/" smallDenominator
		}
		else if (inputNumber > mediant)
			smallNumerator += largeNumerator, smallDenominator += largeDenominator
		else
			largeNumerator += smallNumerator, largeDenominator += smallDenominator
	}
	if (smallDenominator > denominatorLimit)
		return largeNumerator "/" largeDenominator
	else
		return smallNumerator "/" smallDenominator
}

GUI font, s9, Segoe UI
GUI add, DateTime, vFrom Choose%defaultStart% gUpdateTotalTime, yyyy·MM·dd HH:mm:ss 
GUI add, text, x+5 yp, →
GUI add, DateTime, vTo x+5 yp Choose%defaultEnd% gUpdateTotalTime, yyyy·MM·dd HH:mm:ss 
GUI add, checkbox, vUseThisTime xm y+5 gtoggleNow, Use this time as now instead of actual current time:
GUI add, DateTime, vSetNow x+5 yp gUpdateTotalTime disabled, yyyy·MM·dd HH:mm:ss 
Gui Add, Progress, w600 h20 xm y+5 c00CC00 Background004400 vRawProgress Range0-100000
Gui Add, Progress, w600 h20 xm y+0 cCCCC00 Background444400 vRawProgressMagnified Range0-100000
;Gui Add, Progress, w600 h20 xm y+0 cCC0000 vRawProgressMagnifiedTwice Range0-100000
GUI add, GroupBox, w295 h8 Center, Percentage
GUI add, GroupBox, w295 h8 x+5 yp Center vDerivLabel, First Derivative (Inverted)
GUI font, s15, Consolas
GUI add, edit, Center w295 ReadOnly xm y+10 vRawProgressPercent
GUI font, s9, Segoe UI
GUI add, Button, Center w20 ReadOnly yp x+5 gChangeDerivMode vChangeButton, 0
GUI font, s15, Consolas
GUI add, edit, Center w270 ReadOnly yp x+5 vRatio
GUI font, s9, Segoe UI
GUI add, GroupBox, w295 h8 xm Center, Time Remaining
GUI add, GroupBox, w295 h8 x+5 yp Center, Total Time
GUI font, s15, Consolas
GUI add, edit, Center w295 ReadOnly xm y+10 vTrem
GUI add, edit, Center w295 ReadOnly yp x+5 vTtime
GUI font, s9, Segoe UI
GUI add, GroupBox, w600 h8 xm Center, Now
GUI font, s15, Consolas
GUi add, edit, w140 ReadOnly xm y+10 vDispYearNow Right
GUI font, s9, Segoe UI
GUI add, radio, w40 disabled yp x+5 section, Myr
GUI add, radio, w40 disabled xp y+1, kyr
GUI add, radio, w40 disabled ys x+5, BC
GUI add, radio, w40 disabled xp y+1 checked, AD
GUI font, s15, Consolas
GUi add, edit, w140 ReadOnly ys x+5 vDispDateNow Center
GUI font, s9, Segoe UI
GUI add, radio, w40 disabled yp x+5 section checked, date
GUI add, radio, w40 disabled xp y+1, yr
GUI font, s15, Consolas
GUI add, edit, Center w120 ReadOnly ys x+5 vDispTimeNow
GUI font, s9, Segoe UI
GUI add, radio, w40 disabled yp x+5 section checked, time
GUI add, radio, w40 disabled xp y+1, days
GUI font, s9, Segoe UI
GUI add, GroupBox, w600 h8 xm Center, Associated Date
GUI font, s15, Consolas
GUi add, edit, w140 ReadOnly xm y+10 vDispYear Right
GUI font, s9, Segoe UI
GUI add, radio, w40 disabled yp x+5 vmyearp section, Myr
GUI add, radio, w40 disabled xp y+1 vkyearp, kyr
GUI add, radio, w40 disabled ys x+5 vbcp, BC
GUI add, radio, w40 disabled xp y+1 vadp checked, AD
GUI font, s15, Consolas
GUi add, edit, w140 ReadOnly ys x+5 vDispDate Center
GUI font, s9, Segoe UI
GUI add, radio, w40 disabled yp x+5 vdtimep section checked, date
GUI add, radio, w40 disabled xp y+1 vdmonsp, yr
GUI font, s15, Consolas
GUI add, edit, Center w120 ReadOnly ys x+5 vDispTime
GUI font, s9, Segoe UI
GUI add, radio, w40 disabled yp x+5 vttimep section, time
GUI add, radio, w40 disabled xp y+1 vtdaysp, hr
GUI add, radio, w40 disabled xp y+1 vtseasp, seas
GUI font, s9, Segoe UI
GUI add, button, xm gReload, Reload
GUI add, button, yp x+5 gRecalculate, Timer on
GUI add, button, yp x+5 gOffItems, Timer off
GUI Show
GUI Submit, NoHide
now -= 19700101000000,seconds
From -= 19700101000000,seconds
To -= 19700101000000,seconds
if (From < now && now < to)
	SetTimer, SetItems, 50
GoSub updateTotalTime
Return



Recalculate:
	SetTimer, SetItems, 50
Return

OffItems:
	SetTimer, SetItems, Off
Return

ToggleNow:
	GuiControlGet, toggleNowOnP,, UseThisTime
	if toggleNowOnP
		GuiControl, Enable, SetNow
	else
		GUIControl, Disable, SetNow
Return

UpdateTotalTime:
	GUIControlGet, From,, From
	GUIControlGet, To,, To
	diffd := to, diffh := to, diffm := to, diffs := to
	diffd -= %from%, Days
	diffh -= %from%, Hours
	diffm -= %from%, Minutes
	diffs -= %from%, Seconds
	GUIControl,, Ttime, % diffd " days, " SubStr("0" mod(diffh, 24), -1) ":" SubStr("0" mod(diffm, 60), -1) ":" SubStr("0" mod(diffs, 60), -1) 
return

ChangeDerivMode:
useSecondDeriv := mod(useSecondDeriv + (GetKeyState("Shift") ? digitLimits.MaxIndex() : 1), digitLimits.MaxIndex() + 1)
GUIControl,, ChangeButton, %useSecondDeriv%
if useSecondDeriv = 0
	GUIControl,, DerivLabel, First Derivative (Inverted)
else
	GUIControl,, DerivLabel, % "Closest Fraction (denominator < " digitLimits[useSecondDeriv] ")"
	
Return

SetItems:
	GUI submit, NoHide
	now := UseThisTime ? setNow : A_Now
	msec := A_Msec / 1000
	stashedFormat := A_FormatFloat
	SetFormat FloatFast, 012.9
	FormatTime, oYear, %now%, yyyy
	FormatTime, oDate, %now%, MMM dd
	FormatTime, oTime, %now%, HH:mm:ss
	GUIControl,, dispYearNow, %oyear%
	GUIControl,, dispDateNow, %oDate%
	GUIControl,, dispTimeNow, %oTime%
	rems := to, remm := to, remh := to, remd := to
	now -= 19700101000000,seconds
	From -= 19700101000000,seconds
	To -= 19700101000000,seconds
	Percentage := (now + msec - from) / (to - from)
	GUIControl,, RawProgress, % Percentage * 100000
	if (to - from > 100000)
	{
		;ToolTip, % Mod(Floor(percentage * 100), 2)
		if Mod(Floor(percentage * 100000), 2) = 0
		{
			frontcolor = CCCC00
			backcolor = 444400
		}
		else
		{
			frontcolor = 444400
			backcolor = CCCC00
		}
		GUIControl, +c%frontColor% +Background%backColor%, RawProgressMagnified
		GUIControl,, RawProgressMagnified, % Mod(Percentage * 100000 * 100000, 100000)
	}
	else
		GUIControl,, RawProgressMagnified, 0
	;GUIControl,, RawProgressMagnifiedTwice, % Mod(Percentage * 1000000 * 10 * 5, 1000000 * 5)
	GUIControl,, RawProgressPercent, % Percentage * 100 "%"
	if now > %to%
	{
		MsgBox it's over!
		SetTimer, SetItems, Off
		return
	}
	else if now - 10000 < %from%
	{
		MsgBox it isn't happening yet!
		SetTimer, SetItems, off
		return
	}
	TimeBackwards := exp(20.3444 * percentage ** 3 + 3) - exp(3)

	if useSecondDeriv
		derivative := closestFraction(percentage, useSecondDeriv)
	else
	{
		derivative := 1225.88 * exp(20.3444 * percentage ** 3) * percentage ** 2 / (to - from) * 365 * 24 * 3600 - 1
		for k, v in suffixes 
		{
			multiplier := v
			if derivative < 1000
				break	
			SetFormat FloatFast, %stashedFormat%
			derivative /= 1000
		}
		derivative .= multiplier
	}
	GUIControl, , Ratio, %derivative%
	if timeBackwards > 1000000
	{
		millionYearsAgo := Floor(timeBackwards / 1000000)
		oddMonths := Mod(timeBackwards, 1000000) 
		oddDays := Floor(Mod(oddMonths, 1) * 4)
		GUIControl,, dispYear, %millionYearsAgo%
		GuiControl,, Myearp, 1
		GuiControl,, dispDate, % "…" Substr("000000" floor(OddMonths), -5) 
		GuiControl,, dmonsp, 1
		GUIControl,, dispTime, % seasons[oddDays + 1]
		GuiControl,, tseasp, 1
		
	}
	else if (timeBackwards > 20000)
	{
		yearsAgo := Floor(timeBackwards)
		daysAgo := (timeBackwards - yearsAgo) * 365
		hoursAgo := (daysAgo - floor(daysAgo)) * 24
		GUIControl,, dispYear, % round(yearsAgo / 1000, 3)
		GUIControl,, kyearp, 1
		GUIControl,, dtimep, 1
		GUIControl,, dispDate, % Floor(daysAgo)
		GUIControl,, dispTime, % Substr("0" Floor(hoursAgo), -1) ":--:--"
		GUIControl,, tdaysp, 1
	}
	else if (timeBackwards > 410)
	{
		years := A_Year - Floor(timeBackwards)
		if (years < 1)
		{
			GuiControl,, bcp, 1
			; GUIcontrol,, DispYear, % Abs(years)+
		}
		else
		{
			GuiControl,, adp, 1
		}
		now := UseThisTime ? setNow : A_Now
		yearsBack := -(timeBackwards - floor(timeBackwards))
		FormatTime, oDate, %now%, yyyy
		GuiControl,, dtimep, 1
		FormatTime, oTime, %now%, HH:mm:ss
		yearsAgo := Floor(timeBackwards)
		daysAgo := (timeBackwards - yearsAgo) * 365
		hoursAgo := (daysAgo - floor(daysAgo)) * 24
		GUIControl,, dispYear, % abs(years) + ((years < 1) ? 1 : 0)
		GUIControl,, dtimep, 1
		GUIControl,, dispDate, % Floor(365 - daysAgo)
		GUIControl,, dispTime, % Substr("0" Floor(24 - hoursAgo), -1) ":--:--"
		GUIControl,, tdaysp, 1
	}
	else {
		yearsBack := -timeBackwards * 365
		now := UseThisTime ? setNow : A_Now
		EnvAdd now, %yearsBack%, days
		;ToolTip %now%
		FormatTime, oY, %now%, yyyy
		FormatTime, oDate, %now%, MMM dd
		FormatTime, oTime, %now%, HH:mm:ss
		GUIControl,, dispYear, %oY%
		GUIControl,, dispDate, %oDate%
		GUIControl,, dispTime, %oTime%
		GUIControl,, adp, 1
		GUIControl,, ddatep, 1
		GUIControl,, ttimep, 1
	}
	now := UseThisTime ? setNow : A_Now
	rems -= %now%,seconds
	remm -= %now%,minutes
	remh -= %now%,hours
	remd -= %now%,days
	GUIControl,, Trem, % remd " days, " SubStr("0" mod(remh, 24), -1) . (A_MSec < 500 ? ":" : " ")
		. SubStr("0" mod(remm, 60), -1) .  (A_MSec < 500 ? ":" : " ") . SubStr("0" mod(rems, 60), -1) 
	SetFormat FloatFast, %stashedFormat%
Return

Reload:
Reload
Return
		
GuiClose:
ExitApp