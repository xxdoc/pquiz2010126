VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsTG01"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
Option Base 0

'�Ӽ����� ���� ���� ����
Private mvargijunilja As String '���� ����
Private isNoticeThat As Boolean '���� �Դ� ���������� ���� ����
Public Property Let gijunilja(ByVal vData As String)
'���Թ��� ���ʿ��� �Ӽ��� ���� �Ҵ��� �� ���˴ϴ�.
'Syntax: X.gijunilja = 5
    mvargijunilja = vData
End Property


Public Property Get gijunilja() As String
'���Թ��� �����ʿ��� �Ӽ����� �˻��� �� ���˴ϴ�.
'Syntax: Debug.Print X.gijunilja
    gijunilja = mvargijunilja
End Property



Public Sub cal_gijunilja()
    gijunilja = Format(Now, "YYYYMMDD")
    
End Sub

Public Sub add_next(userid As String, subj As String)

Dim affected As Long
Dim ymd As String
cal_gijunilja
ymd = gijunilja
sSql = ""

frmQuiz.cQuiz.user_ans = 0
If frmQuiz.optA.Value = True Then
    frmQuiz.cQuiz.user_ans = 1
ElseIf frmQuiz.optB.Value = True Then
    frmQuiz.cQuiz.user_ans = 2
ElseIf frmQuiz.optC.Value = True Then
    frmQuiz.cQuiz.user_ans = 3
ElseIf frmQuiz.optD.Value = True Then
    frmQuiz.cQuiz.user_ans = 4
ElseIf frmQuiz.optE.Value = True Then
    frmQuiz.cQuiz.user_ans = 5
End If

If frmQuiz.cQuiz.forReview = False And frmQuiz.cQuiz.isNew Then
    sSql = "update tg01 set next_cnt=next_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
Else
    If frmQuiz.cQuiz.forReview = False And frmQuiz.cQuiz.update_ymd = "" Then
        If frmQuiz.cQuiz.Correct Then
            sSql = "update tg01 set next_cnt=next_cnt+1,o_cnt=o_cnt+1,new_cnt=new_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
        Else
            sSql = "update tg01 set next_cnt=next_cnt+1,x_cnt=x_cnt+1,new_cnt=new_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
        End If
    ElseIf frmQuiz.cQuiz.forReview = False And frmQuiz.cQuiz.update_ymd <> ymd Then
        If frmQuiz.cQuiz.reserve_ymd = "99999999" Or frmQuiz.cQuiz.reserve_ymd < date2Str(DateAdd("d", Module1.ALLOW_AFFECT_DATE, Now)) Or frmQuiz.cQuiz.update_ymd < date2Str(DateAdd("d", Module1.ALLOW_AFFECT_DATE30, Now)) Then '1��ġ �̸� �н����� ������ ��ȿ�ϴٰ� �������ش�? �ƴϴ�. �Ϸ�� ����.
            If frmQuiz.cQuiz.Correct Then
                sSql = "update tg01 set next_cnt=next_cnt+1,o_cnt=o_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
            Else
                sSql = "update tg01 set next_cnt=next_cnt+1,x_cnt=x_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
            End If
        Else '���� �Դ� �н��� ���� ��ȿ�н����� ������ ���� �ʴ´�.
            If isNoticeThat = False Then
                MsgBox "�ش繮���� ��ȿ�н����� �������� �ʾҽ��ϴ�." & vbNewLine & "[����: �ش繮���� " & str2Date(frmQuiz.cQuiz.reserve_ymd) & " ���Ŀ� �н��ؾ� ��ȿ�� �н����� �����˴ϴ�]", vbExclamation + vbOKOnly
                isNoticeThat = True
            Else
                status.Text = "��ȿ�н����� �������� �ʾҽ��ϴ�. ��ȿ�н���" & frmQuiz.cQuiz.reserve_ymd & " ����:[" & frmQuiz.cQuiz.quiz & "]"
            End If
        End If
        
    Else
        sSql = "" '�������� �������� �ʴ´�."
    End If
End If
Dim conflag As Boolean
If Con.State = 0 Then
    Con_Open
    conflag = True
End If

If (sSql <> "") Then
    affected = Fn_SQLExec(sSql).nrow
Else
    affected = 0
End If

'-2147467259 '�ܵ����� ����
'-2147217904 '�÷� ������

If affected = 0 Then
    Dim SSQL2 As String
    If (sSql <> "") Then
        SSQL2 = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h, userid,SUBJ,next_cnt,totalsec,new_cnt,reword_cnt,o_cnt,x_cnt,chk_cnt,backNew_cnt,backReview_cnt) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',1,0,0,0,0,0,0,0,0)"
        affected = Fn_SQLExec(SSQL2).nrow
        affected = affected + Fn_SQLExec(sSql).nrow
        Debug.Assert affected >= 1
    End If
    'Debug.Assert affected = 1
    
End If
If conflag Then
Con_Close
End If


End Sub

Public Sub add_back(userid As String, subj As String, bisNew As Boolean)

Dim affected As Long
Dim ymd As String
cal_gijunilja
ymd = gijunilja

If bisNew Then
    sSql = "update tg01 set backNew_cnt=backNew_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
Else
    sSql = "update tg01 set backReview_cnt=backReview_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
End If
Dim conflag As Boolean
If Con.State = 0 Then
    Con_Open
    conflag = True
End If

affected = Fn_SQLExec(sSql).nrow

'-2147467259 '�ܵ����� ����
'-2147217904 '�÷� ������

If affected = 0 Then
    If bisNew Then 'next_cnt,totalsec,new_cnt,review_cnt,o_cnt,x_cnt,chk_cnt,backNew_cnt,backReview_cnt
        sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,next_cnt,totalsec,new_cnt,reword_cnt,o_cnt,x_cnt,chk_cnt,backNew_cnt,backReview_cnt) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',0,0,0,0,0,0,0,0,1)"
    Else
        sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,next_cnt,totalsec,new_cnt,reword_cnt,o_cnt,x_cnt,chk_cnt,backNew_cnt,backReview_cnt) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',0,0,0,0,0,0,0,0,1)"
    End If
    affected = Fn_SQLExec(sSql).nrow
    Debug.Assert affected = 1
End If
If conflag Then
Con_Close
End If



End Sub

Public Sub add_review(userid As String, subj As String, bCancel As Boolean)

'Dim affected As Long
'Dim ymd As String
'If bCancel Then Exit Sub
'cal_gijunilja
'ymd = gijunilja
'
'sSql = "update tg01 set review_cnt=review_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
'Dim conflag As Boolean
'If Con.State = 0 Then
'    Con_Open
'    conflag = True
'End If
'
'affected = Fn_SQLExec(sSql).nrow
'
''-2147467259 '�ܵ����� ����
''-2147217904 '�÷� ������
'
'If affected = 0 Then
'    sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,review_cnt,totalsec) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',1,0)"
'    affected = Fn_SQLExec(sSql).nrow
'    Debug.Assert affected = 1
'
'End If
'If conflag Then
'Con_Close
'End If



End Sub

Public Sub add_new(userid As String, subj As String, bCancel As Boolean)

    Dim affected As Long
    Dim ymd As String
    If bCancel Then Exit Sub
    cal_gijunilja
    ymd = gijunilja
    
    sSql = "update tg01 set new_cnt=new_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
    Dim conflag As Boolean
    If Con.State = 0 Then
        Con_Open
        conflag = True
    End If
    affected = Fn_SQLExec(sSql).nrow
    
    '-2147467259 '�ܵ����� ����
    '-2147217904 '�÷� ������
    
    If affected = 0 Then
        sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,new_cnt,totalsec) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',1,0)"
        affected = Fn_SQLExec(sSql).nrow
        Debug.Assert affected = 1
    
    End If
    If conflag Then
        Con_Close
    End If
End Sub

Public Sub add_chk(userid As String, subj As String)

Dim affected As Long
Dim ymd As String
cal_gijunilja
ymd = gijunilja

sSql = "update tg01 set chk_cnt=chk_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
Dim conflag As Boolean
If Con.State = 0 Then
    Con_Open
    conflag = True
End If

affected = Fn_SQLExec(sSql).nrow

'-2147467259 '�ܵ����� ����
'-2147217904 '�÷� ������

If affected = 0 Then
    sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,chk_cnt,totalsec) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',1,0)"
    affected = Fn_SQLExec(sSql).nrow
    Debug.Assert affected = 1
    
End If
If conflag Then
Con_Close
End If


End Sub

Public Sub add_x(userid As String, subj As String)
'
'Dim affected As Long
'Dim ymd As String
'cal_gijunilja
'ymd = gijunilja
'
'sSql = "update tg01 set x_cnt=x_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
'Dim conflag As Boolean
'If Con.State = 0 Then
'    Con_Open
'    conflag = True
'End If
'
'affected = Fn_SQLExec(sSql).nrow
'
''-2147467259 '�ܵ����� ����
''-2147217904 '�÷� ������
'
'If affected = 0 Then
'    sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,x_cnt,totalsec) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',1,0)"
'    affected = Fn_SQLExec(sSql).nrow
'    Debug.Assert affected = 1
'
'End If
'If conflag Then
'Con_Close
'End If
'


End Sub

Public Sub add_o(userid As String, subj As String)
'
'
'Dim affected As Long
'Dim ymd As String
'cal_gijunilja
'ymd = gijunilja
'
'sSql = "update tg01 set o_cnt=o_cnt+1 where GIJUNILJA='" & ymd & "' AND userid='" & userid & "' and SUBJ='" & subj & "' and h=" & dfn("h") & ""
'Dim conflag As Boolean
'If Con.State = 0 Then
'    Con_Open
'    conflag = True
'End If
'
'affected = Fn_SQLExec(sSql).nrow
'
''-2147467259 '�ܵ����� ����
''-2147217904 '�÷� ������
'
'If affected = 0 Then
'    sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,o_cnt,totalsec) values('" & ymd & "'," & dfn("yyyy") & "," & dfn("q") & "," & dfn("m") & "," & dfn("y") & "," & dfn("d") & "," & dfn("w") & "," & dfn("ww") & "," & dfn("h") & ",'" & userid & "','" & subj & "',1,0)"
'    affected = Fn_SQLExec(sSql).nrow
'    Debug.Assert affected = 1
'
'End If
'If conflag Then
'Con_Close
'End If
'

End Sub


Public Sub addsec(userid As String, subj As String, Optional pSave As Boolean = False)
Dim affected As Long
Dim ymd As String

cal_gijunilja
ymd = gijunilja
'
'�޸𸮿� ���� �� �� �ϰ� �Է� �ϴ� ������� ��ȯ
'

Static LocalColAddSec As colAddSec
Dim vData As clsAddSec

If LocalColAddSec Is Nothing Then
    Set LocalColAddSec = New colAddSec
    
End If

If subj <> "" Then

pSave = pSave Or ((Not gMutex) And LocalColAddSec.Add(dfn("h"), ymd, subj, userid))
End If

If pSave Then
'========================================================
'�̺κ��� ����Ǹ鼭 ������ ��°� �ߺ����ɼ��� �ִ�.? Ȥ�� ���蹮�� ��°� ���ؼ� ���� ������ �浹�� ���ɼ��� �ִ�.
'FFF
'========================================================
    For Each vData In LocalColAddSec
    
'        sSql = "update tg01 set totalsec=0 where totalsec is null"
'        If Fn_SQLExec(sSql).Error Then Exit Sub
'
        sSql = "update tg01 set totalsec=totalsec+" & vData.totalsec & " where GIJUNILJA='" & vData.gijunilja & "' AND userid='" & vData.userid & "' and SUBJ='" & vData.subj & "' and h=" & vData.sigan & ""
        
        Dim conflag As Boolean
        If Con.State = 0 Then
            Con_Open
            conflag = True
        End If
        
        affected = Fn_SQLExec(sSql).nrow
        
        '-2147467259 '�ܵ����� ����
        '-2147217904 '�÷� ������
        
        If affected = 0 Then
            sSql = "insert into tg01(GIJUNILJA,yyyy,q,m,y,d,w,ww,h,userid,SUBJ,totalsec) values('" & vData.gijunilja & "'," & dfn("yyyy", vData.gijunilja) & "," & dfn("q", vData.gijunilja) & "," & dfn("m", vData.gijunilja) & "," & dfn("y", vData.gijunilja) & "," & dfn("d", vData.gijunilja) & "," & dfn("w", vData.gijunilja) & "," & dfn("ww", vData.gijunilja) & "," & vData.sigan & ",'" & vData.userid & "','" & vData.subj & "'," & vData.totalsec & " )"
            affected = Fn_SQLExec(sSql).nrow
            Debug.Assert affected = 1
            
        End If
        
        If conflag Then
        Con_Close
        End If
    Next
    
    Set LocalColAddSec = Nothing
    
End If

End Sub

Public Function dfn(param1 As String, Optional sDate As String) As Integer
If Len(sDate) = 0 Then
    dfn = DatePart(param1, Now)
Else
    dfn = DatePart(param1, str2Date(sDate))
End If
End Function