#Include config.ahk
#Include FindText.ahk

; 激活微信App
initWechatApp(element)
{

    Loop, Reg, HKEY_CURRENT_USER\Software\Tencent\WeChat, KV
    {
        if (A_LoopRegType = "key")
            value := ""
        else
        {
            RegRead, value
            if ErrorLevel
                value := "*error*"
        }
        
        if (A_LoopRegName == "InstallPath")
            break
     }
     
    wechatPath:= value . "\Wechat.exe"
    
    Tip("启动微信")
    
    Run %wechatPath%   
    
    Sleep 1000
    
    WinGetPos, X, Y, W, H,ahk_class WeChatMainWndForPC

    if !(W && H)
    {
        X:= 0
        Y:= 0
        W:= A_ScreenWidth
        H:= A_ScreenHeight
    }
    
    
    switch element
    {
        case "chat": 
        {        
           findAndClickElementWithResDic("chat-not-select,chat-select",0,0)   
        }
        case "address_book":  
        {
           findAndClickElementWithResDic("address-book-not-select,address-book-select",0,0,2,0,0,0,0,0,0.1)     
        }  
    } 
      
}

findAndClickElementWithResDic(res_id,move_x,move_y,clickTimes:=1,x1:=0,y1:=0,x2:=0,y2:=0,fault2text:=0,fault2background:=0)
{
    ;SysGet, MonitorName, MonitorName
    ;SysGet, Monitor, Monitor
    ;SysGet, MonitorWorkArea, MonitorWorkArea
    ;MsgBox, Monitor:`tName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
    
    sp := ","
    StringGetPos, pos, res_id, %sp%
    
    if (pos >= 0)
    {
        res_ids := StrSplit(res_id, sp) 
    }
    
    if (A_ScreenDPI >= 180)
    {
       if (res_ids)
       {
            Loop % res_ids.MaxIndex()
            {
                if (element)
                    element .= WechatConfig.RES_Dic_200DPI[res_ids[A_Index]]
                else
                    element := WechatConfig.RES_Dic_200DPI[res_ids[A_Index]]
            }
       }
       else
          element := WechatConfig.RES_Dic_200DPI[res_id]
    }
    else
    {
        if (res_ids)
        {
            Loop % res_ids.MaxIndex()
            {
                if (element)
                    element .= WechatConfig.RES_Dic_100DPI[res_ids[A_Index]]
                else
                    element := WechatConfig.RES_Dic_100DPI[res_ids[A_Index]]
            }
        }
       else
         element := WechatConfig.RES_Dic_100DPI[res_id]
    }

    
    if (element && element != "")
    {
        resultArray := findAndClickElementV2(element,move_x,move_y,clickTimes,x1,y1,x2,y2,fault2text,fault2background)
        
        if (!resultArray)
        {
            msg := "没有找到对应的操作元素：" . res_id 
            Tip(msg)
    
            return false
        }
        else
            return true
    }
    Else
    {
        MsgBox, res_id:%res_id% not correct!
    }
}


findAndClickElementV2(element,move_x,move_y,clickTimes:=1,x1:=0,y1:=0,x2:=0,y2:=0,fault2text:=0,fault2background:=0)
{
    /*
    if (x2 == 0)
        x2 := A_ScreenWidth
        
    if (y2 == 0)
        y2 := A_ScreenHeight
        
     */
     if (x1 == 0)
        x1 := -150000
        
     if (x2 == 0)
        x2 := 150000
        
     if (y1 == 0)
        y1 := -150000
        
     if (y2 == 0)
        y2 := 150000
     
    
    sleep 1000
  
    resultArray := FindText(X, Y, x1, y1, x2, y2, fault2text, fault2background, element)

    
    if (resultArray = 0)
    {
        ;TrayTip 消息, 没有找到对应的操作元素： + %element%
    
        return false
    }
    else
    {
        ;FindText().Click(X+move_x, Y+move_y, "L")
        FindText().Click(X+move_x, Y+move_y, clickTimes)
        sleep 1000
        
        return true
    }
}

; 定位到对应微信组件
findAndClickElement(element,move_x,move_y,colorValue,x1:=0,y1:=0,x2:=0,y2:=0)
{
    
    if (x2 == 0)
        x2 := A_ScreenWidth
        
    if (y2 == 0)
        y2 := A_ScreenHeight
    
    sleep 1000
    
    tempStr := WechatConfig.RES_PATH . element    
    ImageSearch,FoundX, FoundY,x1,y1,x2,y2,*%colorValue% %tempStr%

    if (ErrorLevel = 2)
    {
        TrayTip 消息, 定位的图片文件地址不对.
        
        return false
    }
    else if (ErrorLevel = 1)
    {
        TrayTip 消息, 没有找到微信对应的操作界面： + %element%
    
        return false
    }
    else
    {
        MouseClick , Left, % FoundX+move_x,FoundY+move_y 
        sleep 1000
        
        return true
    }
}

;定向给客户发消息
SendMessage(chatid,message,attachment)
{
   if !findAndClickElementWithResDic("search",20,0)
   {
        return
   }
        
   Send %chatid%
   Sleep 1000
   Send {Enter}
   Sleep 1000
   Send %message%
   Sleep 500
   Send {Enter}
   
   ;if findAndClickElementWithResDic("emoji",0,0)
   ;    findAndClickElementWithResDic("smile",0,0)
   
   ;Send {Enter}
   Sleep 500
   
   if(attachment && attachment != "")
   {
        findAndClickElementWithResDic("input-chinese",0,0) 
        
        if findAndClickElementWithResDic("attachment",0,0)
        {
            Sleep 500
            
            Send %attachment%{Enter}
            Sleep 500
            Send {Enter}
            ;findAndClickElementWithResDic("save-file-open.png",0,0) 
            
        }
   }
   
   return
}

;解析微信通讯录,type:friend,group,tag
ParseWechatAddressBook(type,save_filepath,startPos:= 0,max_process_line_count:= 100)
{
    contactList := Array()
    cardIndex := 0
    isGroup := 0
    isContact := 0

    if (type == "friend" or type == "group")
    {
        locToAddressBookTop()
        
        remainLineCount := max_process_line_count
        
        if (remainLineCount == 0)
        {
            remainLineCount := 10000
        }
        
        ;定位到处理起点
        if (startPos > 0)
        {
            SendInput {Down %startPos%}
            cardIndex:= cardIndex+startPos
        }
        
        while(remainLineCount > 0)
        {
               
            isContactOrGroupCard := false
            
            if (isContact == 0 && isGroup == 0)
            {
                if (findAndClickElementWithResDic("sendMessage",0,0,0))
                    isContactOrGroupCard := true
            }
            else
            {
                isContactOrGroupCard := true
            }

            if (isContactOrGroupCard)
            {
                ;联系人卡片
                if (findAndClickElementWithResDic("wechatId",70*WechatConfig.SCALING,0,2))
                {
                    if (type == "friend")
                    {
                        wechatId := copyFromClipboard()
                        findAndClickElementWithResDic("area",50*WechatConfig.SCALING,0,2)
                        area := copyFromClipboard()
                        
                        if(findAndClickElementWithResDic("wechatIcon-M,wechatIcon-F",-50*WechatConfig.SCALING,0,2,0,0,0,0,0,0.1))
                            nick := copyFromClipboard()

                        if(findAndClickElementWithResDic("tag",180*WechatConfig.SCALING,0,2))
                            tag := copyFromClipboard()
                           
                        
                        ;MsgBox % type . "," . wechatId . "," . area . "," . nick . "," . tag
                        
                        info :=  type . "," . wechatId . "," . area . "," . nick . "," . tag
                        
                        
                        if(contactList.MaxIndex() && contactList.MaxIndex() >0 )
                        {
                            pre_info := contactList[contactList.MaxIndex()]
                            
                            ;当前的联系人完全等于上一条的联系人，代表解析结束
                            if(pre_info == info)
                                break
                        }
                        
                        contactList.Insert(info)
                    }
                    else
                    {
                        ;如果进入了联系人，那么代表group已经结束
                        if (type == "group")
                            break
                    }
                    
                    isContact := 1
                    
                }
                else{
                    ;群卡片
                    if (type == "group")
                    {
                        if(findAndClickElementWithResDic("sendMessage",0,0))
                        {
                            if (findAndClickElementWithResDic("chat-more",0,0))
                            {
                                if (findAndClickElementWithResDic("groupName",0,30,1))
                                {
                                    findAndClickElementWithResDic("groupName",0,30,2)
                                    groupName := copyFromClipboard()
                                    
                                    if (groupName != "")
                                    {
                                        ;MsgBox % type . "," . groupName . "," . "," . groupName
                        
                                        info := type . "," . groupName . "," . "," . groupName
                                        contactList.Insert(info)
                                    }  
                                }
                            }
                        
                            isGroup := 1
                            
                            findAndClickElementWithResDic("address-book-not-select",0,0) 
                        }
                    }
                      
                }
                
            }
            
            cardIndex := cardIndex +1
            locToAddressBookTop(cardIndex)
            SendInput {Down %cardIndex%}
                    
            remainLineCount := remainLineCount -1 
        
        }
        
            
        totalCount:= saveResultToFile(contactList,save_filepath,true)
    
        return totalCount
  
    }
    else if (type == "tag")
    {
    
    }
       
}

copyFromClipboard()
{
    clipboard := ""
    Send ^c
    Sleep 500
    text := clipboard
    clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
    
    return text     
}


locToAddressBookTop(backStep:=0 )
{

    stepLength := 50

    if !findAndClickElementWithResDic("search",20,200)
       return
            
    if (backStep > 0)
    {
        SendInput {UP %backStep%}
    }
            
    while(!findAndClickElementWithResDic("newFriend",0,0))
    {
       SendInput {UP %stepLength%}
       
       if (stepLength <= 2000)
       {
            stepLength := stepLength + 50
       }
       else
            break
    }
}


checkAndActiveWin(title,killflag:= false)
{
     if !WinActive(title) 
     {
        WinGetTitle, TempTitle, A
        
        if (killflag && TempTitle != title)
            if WinExist(TempTitle) 
                WinKill, %TempTitle%
                
        if WinExist(title)
            WinActivate
     }
}

;解析微信聊天记录
ParseWechatContent(chatid,reg_rule,save_filepath,max_process_line_count)
{
    if !findAndClickElementWithResDic("search",20,0)
        return

    Send %chatid%
    Sleep 2000
    Send {Enter}

    if !findAndClickElementWithResDic("chat-more",0,0)
        return 
        
    if !findAndClickElementWithResDic("chat-record",0,0)
        return 

    Tip("分析微信聊天记录开始")
    sleep 1000
    
    WinGet, active_id, ID, A
    WinGetPos, X, Y, width, height, A  ; "A" 表示获取活动窗口的位置.
    WinGetActiveTitle, Title ; 后续用于比对是否打开了新窗口
    ;MsgBox, The active window is at %X%,%Y%,%width%,%height%

    ; cursor start position 
    newPosX := (width/1100) * 230 
    newPosY := height-5


    ; reg_rule = (13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8} ;正则表达式电话号码
    ; save_filepath := "\\Mac\Home\Desktop\脚本\统计数据\wechatInfo.txt"
    pre_found_index := 0
    pre_found_text := ""
    current_found_index := 0
    current_found_text := ""
    empty_rounds := 0
    chatContentsList := Array()
    remain_process_line_count := 10
    skip_record := false


    if (max_process_line_count)
    {
        remain_process_line_count := max_process_line_count  ;还剩多少条要处理,-1 代表不控制
    }

    Sleep 1000

    Loop
    { 
     ; init vars and position
     current_found_index := 0
     current_found_text := ""
     step := 0
     text := ""
     clipboard := "" 
     skip_record := false
     isfound := false
     
     checkAndActiveWin(Title)

     MouseClick, left, newPosX, newPosY
     
     
     ; inner loop to search chat content 
     Loop, 10
     {

        MouseClick, left, newPosX, newPosY+step, 2
         
        ;MsgBox, contents before: %text%
        Send ^c
        Sleep 500
        text := clipboard
        clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
        
        ;处理文件类型对话
        WinGetTitle, TempTitle, A
        
        if (TempTitle <> Title)
        {
          ;MsgBox % "TempTitle:" . TempTitle . "Title:" Title
          
          waitTimes := 2000
          
          empty_rounds := 0
          isfound := true
     
          while(waitTimes > 0)
          {
            if WinExist(TempTitle) 
                WinKill, %TempTitle%
          
            WinGetTitle, TempTitle, A
          
            if (TempTitle <> Title)
            {
                Sleep 200
                waitTimes :=  waitTimes - 200             
            }
            else
            {
                break
            } 
          }

          break
        }
        
       
        ; process text content, can use RegExMatch 
        if (text <> "")
        {
          empty_rounds := 0
          isfound := true
       
         ; skip common line readin
         if (pre_found_text != "" and pre_found_text == text and A_Index == 0)
         {
           skip_record := true
         }
         
       
         if (!skip_record)
         {
          if (reg_rule <> "")
          {
             foundPos := RegExMatch(text, reg_rule)
        
             if (foundPos >= 1)
             {
               chatContentsList.Insert(text)
             }
          }
          else
          {
             chatContentsList.Insert(text)
          }
         }
         
         current_found_index := A_Index
         current_found_text := text
        
        
         MouseClick, left, newPosX, newPosY+step  ;reset double click
        
         break
        }
        else
        {
         step := step - 10
        }
        
     }
     
     ;再检查一次是否打开了特殊文件窗口
     checkAndActiveWin(Title,true)
     
     ; check to end loop 
     if (pre_found_text <> "")
     {
       if (pre_found_text == current_found_text and pre_found_index == current_found_index)
       {
         ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
         break
       }
     }
     
     if(!isfound)
     {
        empty_rounds := empty_rounds + 1
     
         if (empty_rounds >= 2)
         {
             ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
           break
         }
     }
     

     pre_found_text := current_found_text
     pre_found_index := current_found_index
     
      
     if (remain_process_line_count > 0)
     {
       remain_process_line_count := remain_process_line_count - 1
     }
     
     if (remain_process_line_count = 0) 
     {
      ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
      break
     }
     
     checkAndActiveWin(Title)
     
     MouseClick, WheelUP
     
    }

    ; 处理一下最后一屏幕的数据


    step := 0

    if (remain_process_line_count > 0)
    {
        Loop
        {
            MouseClick, left, newPosX, newPosY+step, 2
             
            ; MsgBox, contents before: %text%
            Send ^c
            Sleep 500
            text := clipboard
            clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
            skip_record := false
            
            ; process image content 
            ;处理文件类型对话
            WinGetTitle, TempTitle, A
            
            if (TempTitle <> Title)
            {
              ;TrayTip 消息, TempTitle:%TempTitle% . Title: %Title%
              
              waitTimes := 2000

              
              while(waitTimes > 0)
              {
                if WinExist(TempTitle) 
                    WinKill, %TempTitle%
              
                WinGetTitle, TempTitle, A
              
                if (TempTitle <> Title)
                {
                    Sleep 200
                    waitTimes :=  waitTimes - 200             
                }
                else
                {
                    break
                } 
              }

            }
            else
            {
                    ; process text content, can use RegExMatch 
                if (text <> "")
                {
               
                     ; skip common line readin
                     if (pre_found_text != "" and pre_found_text == text)
                     {
                       skip_record := true
                     }
                     
                   
                     if (!skip_record)
                     {
                          if (reg_rule <> "")
                          {
                             foundPos := RegExMatch(text, reg_rule)
                        
                             if (foundPos >= 1)
                             {
                               chatContentsList.Insert(text)
                               pre_found_text := text
                             }
                          }
                          else
                          {
                             chatContentsList.Insert(text)
                             pre_found_text := text
                          }
                     }
                     
                     MouseClick, left, newPosX, newPosY+step  ;reset double click
                }
            }
            
            step := step - 20
            
            if (newPosY+step <= 0)
             break
             
            if (remain_process_line_count > 0)
             {
               remain_process_line_count := remain_process_line_count - 1
             }
             
             if (remain_process_line_count = 0) 
             {
              ; MsgBox % "LoopEnd now - totalcount: " + chatContentsList.MaxIndex()
                break
             }
             
             
             ;再检查一次是否打开了特殊文件窗口
             checkAndActiveWin(Title,true)
         }
    }

    Sleep 2000

    totalCount:= saveResultToFile(chatContentsList,save_filepath)
    
     if WinExist(Title)
     {
        WinClose
        Sleep 1000
     }

    return totalCount
}

; 保存到文件里面 
saveResultToFile(result,save_filepath,isAppend:=false)
{
    totalCount := 0
    
    if (result && save_filepath)
    {
        ; 保存到文件里面 
        if (save_filepath && result.MaxIndex() && result.MaxIndex() >0 )
        {
        
             totalCount := result.MaxIndex()
             
             if (isAppend)
                file := FileOpen(save_filepath, "a")
             else
                file := FileOpen(save_filepath, "w")
             
             if !IsObject(file)
             {
                MsgBox Can't open "%save_filepath%" for writing.
             }
             else
             {
                Loop % result.MaxIndex()
                {
                  file.WriteLine(result[A_Index])
                }
             
                file.Close()
              
                Sleep 1000
             }
        }   
    
    }
    
    return totalCount
    
}

Tip(message)
{
    if (WechatConfig.IS_DEBUG)
        TrayTip 消息, %message%
}