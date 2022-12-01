#Include WechatSuite.ahk
#Include config.ahk
#Include FindText.ahk

res_dir := A_ScriptDir
resultFile := A_ScriptDir
    
if (InStr(A_ScriptDir, "\") > 0)
{
   WechatConfig.RES_PATH := res_dir . "\res\" 
   resultFile := resultFile . "\微信分析结果文件.txt" 
}
else
{
   WechatConfig.RES_PATH := res_dir . "/res/" 
   resultFile := resultFile . "/微信分析结果文件.txt" 
}


Sleep 2000

;MsgBox % A_ScreenWidth "," A_ScreenHeight "," A_ScreenDPI

;result := findAndClickElementV2("search.png",50,0)


result := findAndClickElementWithResDic("addNewFriend",0,0)
result := findAndClickElementWithResDic("address-book-not-select",0,0)
result := findAndClickElementWithResDic("address-book-select",0,0)
result := findAndClickElementWithResDic("attachment",0,0)
result := findAndClickElementWithResDic("chat-more",0,0)
result := findAndClickElementWithResDic("chat-not-select",0,0)
result := findAndClickElementWithResDic("chat-record",0,0)
result := findAndClickElementWithResDic("chat-select",0,0)




ExitApp