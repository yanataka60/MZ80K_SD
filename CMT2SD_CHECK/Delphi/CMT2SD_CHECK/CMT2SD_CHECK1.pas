unit CMT2SD_CHECK1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.ExtCtrls, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    procedure Memo1DragLeave(Sender: TObject);
    procedure Memo1DragOver(Sender: TObject; const Data: TDragObject;
      const Point: TPointF; var Operation: TDragOperation);
    procedure check;
  private
    { private 宣言 }
  public
    { public 宣言 }
  end;

var
  Form1: TForm1;
  fname:string;

implementation

{$R *.fmx}

procedure TForm1.Memo1DragLeave(Sender: TObject);
begin
  check;
end;

procedure TForm1.Memo1DragOver(Sender: TObject; const Data: TDragObject;
  const Point: TPointF; var Operation: TDragOperation);
begin
    fname:=Data.files[0];
end;

procedure tform1.check;
var
  F1,F2 : File;
  F3 : textfile;
  buf : array[1..10] of char;
  buf2 : array[1..65536] of char;
  i1,CNT1,flen,cnt2:integer;
  S1,s2,s3,fname2,fname3:string;
begin
  cnt2:=0;
  memo1.Lines.clear;
  S1 := fname;
  memo1.Lines.Add('ファイル名:'+extractfilename(fname));
  memo1.Lines.Add('');
  fname2:=ChangeFileExt(fname,'')+'_SD'+ExtractFileext(fname);
  fname3:=ChangeFileExt(fname,'')+'_SD.txt';
  IF FILEEXISTS(S1) THEN
    BEGIN
      flen:=0;
      ASSIGNFILE(F1,S1);
      RESET(F1,1);
      while not(eof(f1)) do
        begin
          blockread(f1,buf,1,i1);
          buf2[flen+1]:=buf[1];
          flen:=flen+1;
        end;
      CLOSEFILE(F1);

      CNT1 := 1;
      s2 := '000000';
      WHILE cnt1<=flen+1 DO
        BEGIN
          s2:=copy(s2,3,4)+inttohex(ord(buf2[cnt1]),2);
          if s2='CD2100' then
            begin
              s3:='WRINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD04F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($04);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C32100' then
            begin
              s3:='WRINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C304F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($04);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CD2400' then
            begin
              s3:='WRDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD07F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($07);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C32400' then
            begin
              s3:='WRDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C307F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($07);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CD2700' then
            begin
              s3:='RDINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD0AF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($0A);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C32700' then
            begin
              s3:='RDINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C30AF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($0A);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CD2A00' then
            begin
              s3:='RDDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD0DF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($0D);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C32A00' then
            begin
              s3:='RDDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C30DF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($0D);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CD2D00' then
            begin
              s3:='VERFY : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD10F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($10);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C32D00' then
            begin
              s3:='VERFY : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C310F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($10);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;

          if s2='CD3604' then
            begin
              s3:='WRINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD04F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($04);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C33604' then
            begin
              s3:='WRINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C304F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($04);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CD7504' then
            begin
              s3:='WRDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD07F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($07);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C37504' then
            begin
              s3:='WRDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C307F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($07);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CDD804' then
            begin
              s3:='RDINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD0AF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($0A);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C3D804' then
            begin
              s3:='RDINF : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C30AF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($0A);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CDF804' then
            begin
              s3:='RDDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD0DF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($0D);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C3F804' then
            begin
              s3:='RDDAT : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C30DF0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($0D);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='CD8805' then
            begin
              s3:='VERFY : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> CD10F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($CD);
              buf2[cnt1-1]:=chr($10);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          if s2='C38805' then
            begin
              s3:='VERFY : ADRS '+inttohex(CNT1-3,4)+'h : '+s2+' -> C310F0';
              memo1.Lines.Add(s3);
              buf2[cnt1-2]:=chr($C3);
              buf2[cnt1-1]:=chr($10);
              buf2[cnt1]:=chr($F0);
              cnt2:=cnt2+1;
            end;
          CNT1 := CNT1 + 1;
        END;
      if cnt2 > 0 then
        begin
          memo1.Lines.Add('');
          memo1.Lines.Add('発見数:'+inttostr(cnt2));
          memo1.Lines.Add('修正ファイル名:'+extractfilename(fname2));
          memo1.Lines.Add('修正箇所ファイル名:'+extractfilename(fname3));
          memo1.Lines.Add('');
          memo1.lines.add('なお、発見修正した個所は、たまたまコードが一致しただけの可能性もあります。');
          memo1.lines.add('動作がおかしい場合はバイナリエディタで修正を戻してください。');

          assignfile(F3,fname3);
          rewrite(F3);
          cnt1:=0;
          while cnt1 < memo1.lines.count do
            begin
              s3:= memo1.Lines.Strings[cnt1];
              writeln(F3,s3);
              cnt1:=cnt1+1;
            end;
          closefile(F3);
          cnt1:=0;
          assignfile(F2,fname2);
          rewrite(F2,1);
          while cnt1<flen do
            begin
              buf[1]:=buf2[cnt1+1];
              blockwrite(f2,buf,1,i1);
              cnt1:=cnt1+1;
            end;
          CLOSEFILE(F2);
        end
       else
        begin
          memo1.Lines.Add('CMTアクセスルーチンをコールしている箇所はありません。');
          memo1.Lines.Add('');
          memo1.lines.add('なお、HLレジスタにコール先を設定してコールする等特殊な方法で行っている場合');
          memo1.lines.add('には発見できません。');
        end;
    END;
end;

end.
