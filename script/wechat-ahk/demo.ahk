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


Sleep 3000

result := findAndClickElementWithResDic("address-book-not-select,address-book-select",0,0)  

;result := findAndClickElementWithResDic("chat-not-select,chat-select",0,0)  

MsgBox, %result%

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
