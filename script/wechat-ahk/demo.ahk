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

Sleep 3000

result := findAndClickElementWithResDic("sendMessage,wechatId,area,wechatIcon-M,wechatIcon-F,tag",0,0,0)

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

/*
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
