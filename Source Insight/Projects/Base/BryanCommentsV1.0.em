/*  
  *************************************************************  
  *                     Comments Add File  
  *             Copy Rights by BryanZhu @2010-2046  
  *  
  * FileName: BryanCommentsV1.0.em  
  * Author: BryanZhu  
  * Email: hbzqiang@163.com  
  * Date: 2010-08-29  
  *  
  *************************************************************  
*/    
  
/*  
  *************************************************************  
  * FunctionName : GetStandardTimeString  
  * Description : get the system time by YYYY/MM/DD format.  
  * ReturnValue : return a system time string.  
  * Parameter[0] :  
  * Parameter[1] :   
  * Author : BryanZhu  
  * Date : 2010-08-29  
  *************************************************************  
*/    
macro GetStandardTimeString()  
{  
    var szSysTime  
    var szYear  
    var szMonth  
    var szDay  
    var szTempMonth  
    var szTempDay  
    var szTimeString  
  
    szSysTime = GetSysTime(1)  
    szYear = szSysTime.Year  
    szTempMonth = szSysTime.Month  
    szTempDay = szSysTime.Day  
  
    if(szTempMonth < 10)  
    {  
        szMonth = "0@szTempMonth@"  
    }  
    else  
    {  
        szMonth = szTempMonth  
    }  
  
    if(szTempDay < 10)  
    {  
        szDay = "0@szTempDay@"  
    }  
    else  
    {  
        szDay = szTempDay  
    }  
      
    szTimeString = "@szYear@-@szMonth@-@szDay@"  
  
    return szTimeString  
}  
  
  
/*  
  *************************************************************  
  * FunctionName : InsertCommentsInfo  
  * Description : Save Basic Comments Info in a special file to parse the info.  
  *              by other macro functions.  
  * ReturnValue : NONE  
  * Parameter[0] :  
  * Parameter[1] :   
  * Author : BryanZhu  
  * Date : 2010-08-29  
  *************************************************************  
*/   
macro InsertCommentsInfo(hbuf)  
{  
    var szModifyID  
    var szAuthorName  
    var szComment  
  
    szModifyID = "ModifyID:"  
    szAuthorName = "AuthorName:whmiao"  
    szComment = "Comment:"  
  
    InsBufLine(hbuf, 0, szModifyID)  
    InsBufLine(hbuf, 1, szAuthorName)  
    InsBufLine(hbuf, 2, szComment)  
}  
  
  
/*  
  *************************************************************  
  * FunctionName : BryanSaveCommentsInfo  
  * Description : save the infomation of comments  
  * ReturnValue : NONE  
  * Parameter[0] :  
  * Parameter[1] :   
  * Author : BryanZhu  
  * Date : 2010-08-29  
  *************************************************************  
*/    
macro BryanSaveCommentsInfo()  
{  
    var filename  
    var NewFileBufName  
    var hbuf  
    var hwnd  
  
    var hprj  
    var nProjFileCount  
    var iFileIndex  
    var tempFileName  
      
    filename = "CommentsConfigFile.bryan"  
  
    //judge the comments info file if is in current project.  
    hprj = GetCurrentProj()  
    nProjFileCount = GetProjFileCount(hprj)  
  
    iFileIndex = 0  
    while(iFileIndex < nProjFileCount)  
    {  
        tempFileName = GetProjFileName(hprj, iFileIndex)  
        if(tempFileName == filename)  
        {  
            //Msg("@filename@ file is existed in this project...")  
            hbuf = OpenBuf(filename)              
            if(hbuf != hNil)  
            {  
                hwnd = NewWnd(hbuf)  
                if(hwnd != hNil)  
                {  
                    SaveBufAs(hbuf, filename)  
                    AddFileToProj(hprj, filename)  
                }  
                else  
                {  
                    Msg("Create new window error!-1")  
                }  
            }  
            else  
            {  
                Msg("Create new empty file buffer error!-1")  
            }  
            break  
        }  
        else  
        {  
            iFileIndex = iFileIndex + 1  
            if(iFileIndex == nProjFileCount)  
            {  
                //Msg("@filename@ file is not existed in this project...")  
                hbuf = NewBuf(NewFileBufName)                 
                if(hbuf != hNil)  
                {  
                    hwnd = NewWnd(hbuf)  
                    if(hwnd != hNil)  
                    {  
                        hprj = GetCurrentProj()  
                        InsertCommentsInfo(hbuf)  
                        SaveBufAs(hbuf, filename)  
                        AddFileToProj(hprj, filename)  
                    }  
                    else  
                    {  
                        Msg("Create new window error!-2")  
                    }  
                    //CloseBuf(hbuf)  
                }  
                else  
                {  
                    Msg("Create new empty file buffer error!-2")  
                }                 
                break  
            }  
        }  
    }  
    stop  
}  
  
macro GetCommentsInfoFileName()  
{  
    return "CommentsConfigFile.bryan"  
}  
  
macro IsCommentsInfoFileExist()  
{  
    var filename  
    var hprj  
    var nProjFileCount  
    var iFileIndex  
    var tempFileName  
      
    filename = "CommentsConfigFile.bryan"  
  
    hprj = GetCurrentProj()  
    nProjFileCount = GetProjFileCount(hprj)  
      
    iFileIndex = 0  
    while(iFileIndex < nProjFileCount)  
    {  
        tempFileName = GetProjFileName(hprj, iFileIndex)  
        if(tempFileName == filename)  
        {  
            return 1    // File is exist.  
        }  
        else  
        {  
            iFileIndex = iFileIndex + 1  
        }  
    }  
    return 0    // File is not exist.  
}  
  
  
macro GetCommentsInfo(iBufLineIndex)  
{  
    var filename  
    var hbuf  
    var szText  
    var nBufLineCount  
    var nTextLength  
  
    filename = GetCommentsInfoFileName()  
  
    if(IsCommentsInfoFileExist())  
    {  
        hbuf = OpenBuf(filename)  
        if(hbuf != hNil)  
        {  
            nBufLineCount = GetBufLineCount(hbuf)             
            if(iBufLineIndex <= nBufLineCount)  
            {  
                szText = GetBufLine(hbuf, iBufLineIndex)  
                nTextLength = strlen(szText)  
                if(iBufLineIndex == 0)  
                {  
                    szText = strmid(szText, 9, nTextLength)  
                }  
                else if(iBufLineIndex == 1)  
                {  
                    szText = strmid(szText, 11, nTextLength)                  
                }  
                else if(iBufLineIndex == 2)  
                {  
                    szText = strmid(szText, 8, nTextLength)               
                }  
                CloseBuf(hbuf)  
                return szText     
            }  
            else  
            {  
                Msg("GetCommentsInfo() parameter @iInfoIndex@ error....")  
            }  
        }  
        else  
        {  
            Msg("GetModifyIDofCommentsInfo(): Open buffer fail...")  
            stop  
        }         
    }  
    else  
    {  
        Msg("@filename@ is not exist...")  
        stop  
    }  
}  
  
  
/*  
  *************************************************************  
  * FunctionName : BryanAddSelBlockComments  
  * Description : add comments to contain the selected block statements.   
  * ReturnValue : NONE  
  * Parameter[0] :  
  * Parameter[1] :   
  * Author : BryanZhu  
  * Date : 2010-08-29  
  *************************************************************  
*/    
macro WhmiaoBryanAddSelBlockComments()  
{  
    var hwnd  
    var hbuf  
    var firstSelLine  
    var lastSelLine  
      
    var sztempFirstRemark  
    var sztempLastRemark  
    var szFirstRemark  
    var szLastRemark  
    var szfirstSelLineText  
    var szTimeString  
  
    var szModifyID  
    var szAuthorName  
    var szComment  
    var ichIndex  
      
      
    sztempFirstRemark = "// <-"  
    sztempLastRemark  = "// ->"  
    szFirstRemark = Nil  
    szLastRemark = Nil  
    szTimeString = GetStandardTimeString()  
  
    szModifyID = GetCommentsInfo(0)  
    szAuthorName = GetCommentsInfo(1)  
    szComment = GetCommentsInfo(2)  
  
    if(IsCommentsInfoFileExist())  
    {  
        sztempFirstRemark = sztempFirstRemark # szModifyID # "-" # szAuthorName # "-" # szTimeString # "-" # szComment  
        sztempLastRemark  = sztempLastRemark  # szModifyID # "-" # szAuthorName  
        hwnd = GetCurrentWnd()  
        hbuf = GetCurrentBuf()  
        firstSelLine = GetWndSelLnFirst(hwnd)  
        lastSelLine = GetWndSelLnLast(hwnd)  
  
        szfirstSelLineText = GetBufLine(hbuf, firstSelLine)  
  
        ichIndex = 0  
        while(szfirstSelLineText[ichIndex] == "" || szfirstSelLineText[ichIndex] == "\t")  
        {  
            if(szfirstSelLineText[ichIndex] == "" )  
            {  
                szFirstRemark = cat(szFirstRemark, "")  
                szLastRemark = cat(szLastRemark, "")  
            }  
            else  
            {  
                szFirstRemark = cat(szFirstRemark, "\t")  
                szLastRemark = cat(szLastRemark, "\t")  
            }  
            ichIndex = ichIndex + 1  
        }  
          
        szFirstRemark = cat(szFirstRemark, sztempFirstRemark)  
        szLastRemark = cat(szLastRemark, sztempLastRemark)  
        InsBufLine(hbuf, firstSelLine, szFirstRemark)  
       // InsBufLine(hbuf, lastSelLine+2, szLastRemark)  //去掉最后一行
  
        SaveBuf(hbuf)  
        
		ln = GetBufLnCur(hbuf)
        SetBufIns(hbuf, ln, 29)
    }  
    else  
    {  
        BryanSaveCommentsInfo()  
    }  
  
    stop  
}  


macro IFZERODEF()
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#if 0    //  0")
	InsBufLine(hbuf, lnLast+2, "#endif  // 0")
}

/*将一行中鼠标选中部分注释掉*/
macro CommentSelStr()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur(hbuf)
    str = GetBufSelText(hbuf)
    str = cat("/*",str)
    str = cat(str,"*/")
    SetBufSelText (hbuf, str)
    //ln = GetSymbolLine(szFunc)

    SetBufIns(hbuf, ln, 2)
}

/* InsertFileHeader:

   Inserts a comment header block at the top of the current function. 
   This actually works on any type of symbol, not just functions.

   To use this, define an environment variable "MYNAME" and set it
   to your email name.  eg. set MYNAME=raygr
*/

macro InsertFileHeader()
{
    szMyName = getenv(MYNAME)
    
    hbuf = GetCurrentBuf()

    InsBufLine(hbuf, 0, "/*-------------------------------------------------------------------------")
    
    /* if owner variable exists, insert Owner: name */
    InsBufLine(hbuf, 1, "    ")
    if (strlen(szMyName) > 0)
        {
        sz = "    Owner: @szMyName@"
        InsBufLine(hbuf, 2, " ")
        InsBufLine(hbuf, 3, sz)
        ln = 4
        }
    else
        ln = 2
    
    InsBufLine(hbuf, ln, "-------------------------------------------------------------------------*/")
}

// Wrap ifdef <sz> .. endif around the current selection
macro IfdefSz(sz)
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
     
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, lnFirst, "#ifdef WHMIAO")
    InsBufLine(hbuf, lnLast+2, "#endif /* WHMIAO */")
}


macro MACRO_MultiLineComment()

{

    hwnd = GetCurrentWnd()

    selection = GetWndSel(hwnd)

    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号

    LnLast =GetWndSelLnLast(hwnd)      //取末行行号

    hbuf = GetCurrentBuf()

 

    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031"){

        stop

    }

 

    Ln = Lnfirst

    buf = GetBufLine(hbuf, Ln)

    len = strlen(buf)

 

    while(Ln <= Lnlast) {

        buf = GetBufLine(hbuf, Ln)  //取Ln对应的行

        if(buf ==""){                   //跳过空行

            Ln = Ln + 1

            continue

        }

 

        if(StrMid(buf, 0, 1) == "/"){       //需要取消注释,防止只有单字符的行

            if(StrMid(buf, 1, 2) == "/"){

                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))

            }

        }

 

        if(StrMid(buf,0,1) !="/"){          //需要添加注释

            PutBufLine(hbuf, Ln, Cat("//", buf))

        }

        Ln = Ln + 1

    }

 

    SetWndSel(hwnd, selection)

}