#Include WechatSuite.ahk
#Include config.ahk
#Include FindText.ahk

;配置资源目录、聊天记录分析后的存储文件
resultFile := A_ScriptDir
    
if (InStr(A_ScriptDir, "\") > 0)
{
   resultFile := resultFile . "\微信分析结果文件.txt" 
}
else
{
   resultFile := resultFile . "/微信分析结果文件.txt" 
}

reg_rule := ".*渠道.*"


Tip(reg_rule)

Sleep 1000

#SingleInstance, Force
Gui, Color, 390202
Gui, Font, cWhite
Gui, Margin, 10, 10
Gui, +AlwaysOnTop

Gui, Add, Button, x280 y50 w150 h30 gAddStep, Add Step

Gui, Add, Tab, x2 y1 w790 h760 , Tab1|Tab2
Gui, Add, Text, x22 y39 w200 h20 +Center, Configure os Passos:
Gui, Add, Text, x22 y69 w110 h20 , Selecione uma opcao:
Gui, Add, DropDownList, x132 y69 w100 h20 vDropDownList_Action Choose1, Click Map


Gui, Add, GroupBox, x22 y99 w570 h110 , Escolha a marca do Mini Mapa que voce quer andar:
Gui, Add, Radio, x32 y119 w30 h20 vMark1, 1
GuiControl,, Mark1, 1
Gui, Add, Radio, x82 y119 w30 h20 vMark2, 2
Gui, Add, Radio, x132 y119 w30 h20 vMark3, 3
Gui, Add, Radio, x182 y119 w30 h20 vMark4, 4
Gui, Add, Radio, x232 y119 w30 h20 vMark5, 5
Gui, Add, Radio, x282 y119 w30 h20 vMark6, 6
Gui, Add, Radio, x332 y119 w30 h20 vMark7, 7
Gui, Add, Radio, x382 y119 w30 h20 vMark8, 8
Gui, Add, Radio, x432 y119 w30 h20 vMark9, 9
Gui, Add, Radio, x482 y119 w33 h20 vMark10, 10

Gui, Add, GroupBox, x22 y229 w580 h480, 自动发消息
Gui, Add, Radio, x482 y119 w33 h20 vMark11, 11
Gui, Add, Text,, 请输入-好友或者群名称:
Gui, Add, Text,, 请输入-自动发送的聊天内容（文字）:
Gui, Add, Text,, 自动发送的聊天附件（文件）:

;Gui, Add, GroupBox, x22 y229 w580 h480 , Configuracao Atual:
;Gui, Add, ListView, x27 y249 r20 w570 h455, Step|Action




; Generated using SmartGUI Creator 4.0
Gui, Show, x280 y86 h773 w806, New GUI Window
Step := 0
Return


AddStep:
	Step++
	GuiControlGet, DropDownList_Action
	LV_Add("", Step,DropDownList_Action)
RETURN

GuiClose:
ExitApp



/*
;result := findAndClickElementWithResDic("sendMessage,wechatId,area,wechatIcon-M,wechatIcon-F,tag",0,0,0)

;result := findAndClickElementWithResDic("sendMessage,wechatId,area,wechatIcon-M,wechatIcon-F,tag",0,0,0,0,0,0,0,0,0.1)


for key, value in result { 
    FindText().MouseTip(value.x, value.y) 
    MsgBox, % "Result number " key " is located at X" value[1] " Y" value[2] " and it has a width of " value[3] " and a height of " value[4] ". Additionally it has a comment text of " value.id 
    
    if (value.id == "area")
        MsgBox, Here we found the "area" image.
}

findAndClickElementFromArray(result,"wechatId",70*WechatConfig.SCALING,0,2)

Sleep 30000
;ParseWechatAddressBook("friend",resultFile,13,10)

^x::ExitApp


WinGetPos, X, Y, width, height, A

StartTime := A_TickCount

x2 := (2/5) * width

result := findAndClickElementWithResDic("newFriend",0,0)
;result := findAndClickElementWithResDic("newFriend",0,0,0,0,0,x2)
ElapsedTime := A_TickCount - StartTime
MsgBox, %result% : %ElapsedTime% milliseconds have elapsed.

StartTime := A_TickCount

x2 := (2/5) * width

result := findAndClickElementWithResDic("newFriend",0,0,0,0,0,x2)
ElapsedTime := A_TickCount - StartTime
MsgBox, %result% : %ElapsedTime% milliseconds have elapsed.


x1 := (1/5) * width
x2 := (4/5) * width

StartTime := A_TickCount
result := findAndClickElementWithResDic("sendMessage",0,0,0)
;result := findAndClickElementWithResDic("sendMessage",0,0,0,x1,x2)

ElapsedTime := A_TickCount - StartTime
MsgBox, %result% : %ElapsedTime% milliseconds have elapsed.

x1 := (1/5) * width
x2 := (4/5) * width

StartTime := A_TickCount
result := findAndClickElementWithResDic("sendMessage",0,0,0,x1,x2,0,0)

ElapsedTime := A_TickCount - StartTime
MsgBox, %result% : %ElapsedTime% milliseconds have elapsed.

*/

    
Sleep 2000
