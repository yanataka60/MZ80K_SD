GETL		EQU		00EFH
LETLN		EQU		07EFH
MSGPR		EQU		04EFH
GETKEY		EQU		0CEFH
PRTBYT		EQU		1AEFH
PRNT		EQU		01EFH
DISPCH		EQU		01EFH
DPCT		EQU		01EFH
IBUFE		EQU		1300H
FNAME		EQU		1301H
EADRS		EQU		1312H
FSIZE		EQU		1312H
SADRS		EQU		1314H
EXEAD		EQU		1316H
DSPX		EQU		0003H
LBUF		EQU		1380H
MBUF		EQU		138BH
MONITOR		EQU		0151H

FSAVE		EQU		0401H+1200H			;0E
PSAVE		EQU		0442H+1200H			;0F
FLOAD		EQU		03B4H+1200H			;10
PLOAD		EQU		03DAH+1200H			;11
VERIFY		EQU		03E6H+1200H			;12

PPI_A		EQU		0D8H
PPI_B		EQU		PPI_A+1
PPI_C		EQU		PPI_A+2
PPI_R		EQU		PPI_A+3

;0D8H PORTA 送信データ(下位4ビット)
;0D9H PORTB 受信データ(8ビット)
;
;0DAH PORTC Bit
;7 IN  CHK
;6 IN
;5 IN
;4 IN 
;3 OUT
;2 OUT FLG
;1 OUT
;0 OUT
;
;0DBH コントロールレジスタ

		ORG		2800H

		LD		A,0C3H				;FSAVEジャンプ先変更
		LD		(FSAVE),A
		LD		HL,ENT1
		LD		(FSAVE+1),HL
		
		LD		A,0C3H				;PSAVEジャンプ先変更
		LD		(PSAVE),A
		LD		HL,ENT2
		LD		(PSAVE+1),HL
		
		LD		A,0C3H				;FLOADジャンプ先変更
		LD		(FLOAD),A
		LD		HL,ENT3
		LD		(FLOAD+1),HL
		
		LD		A,0C3H				;PLOADジャンプ先変更
		LD		(PLOAD),A
		LD		HL,ENT4
		LD		(PLOAD+1),HL
		
		LD		A,0C3H				;VERIFYジャンプ先変更
		LD		(VERIFY),A
		LD		HL,ENT5
		LD		(VERIFY+1),HL
		
		OUT		(0E1H),A			;D00H～FFFFH DRAM切替
		LD		HL,ENT
		LD		DE,ENT1
		LD		BC,ENT6-ENT1
		LDIR						;SDアクセスルーチン転送 F800H～
		OUT		(0E4H),A			;一応バンク切替戻し
		JP		2700H				;TS-700起動プロセスへ

ENT:
		ORG		0F800H

;******************** MONITOR CMTルーチン代替 *************************************
ENT1:	JP		MSHED
ENT2:	JP		MSDAT
ENT3:	JP		MLHED
ENT4:	JP		MLDAT
ENT5:	JP		MVRFY

		
;**** 8255初期化 ****
;PORTC下位BITをOUTPUT、上位BITをINPUT、PORTBをINPUT、PORTAをOUTPUT
INIT:	LD		A,8AH
		OUT		(PPI_R),A
;出力BITをリセット
INIT2:	LD		A,00H      ;PORTA <- 0
		OUT		(PPI_A),A
		OUT		(PPI_C),A   ;PORTC <- 0
		RET

;データ受信
DBRCV:	LD		DE,(FSIZE)
		LD		HL,(SADRS)
DBRLOP:	CALL	RCVBYTE
		LD		(HL),A
		DEC		DE
		LD		A,D
		OR		E
		INC		HL
		JR		NZ,DBRLOP   ;DE=0までLOOP
		RET

STSV2:                      ;ファイルネームの取得に失敗
		LD		DE,MSG_FNAME
		JR		ERRMSG

SVER0:
		POP		DE         ;CALL元STACKを破棄する
SVERR:
		CP		0F0H
		JR		NZ,ERR3
		LD		DE,MSG_F0  ;SD-CARD INITIALIZE ERROR
		JR		ERRMSG
ERR3:	CP		0F1H
		JR		NZ,ERR4
		LD		DE,MSG_F1  ;NOT FIND FILE
		JR		ERRMSG
ERR4:	CP		0F3H
		JR		NZ,ERR5
		LD		DE,MSG_F3  ;FILE EXIST
		JR		ERRMSG
ERR5:	CP		0F4H
		JR		NZ,ERR99
		LD		DE,MSG_CMD
		JR		ERRMSG
ERR99:	DW		PRTBYT
		DW		PRNT
		LD		DE,MSG99   ;その他ERROR
ERRMSG:	DW		MSGPR
		DW		LETLN
MON:	JP		MONITOR

;ヘッダ送信
HDSEND:	PUSH	HL
		LD		B,20H
SS1:	LD		A,(HL)     ;FNAME送信
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,SS1
		LD		A,0DH
		CALL	SNDBYTE
		POP		HL
		LD		B,10H
SS2:	LD		A,(HL)     ;PNAME送信
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,SS2
		LD		A,0DH
		CALL	SNDBYTE
		LD		HL,SADRS   ;SADRS送信
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE
		LD		HL,EADRS   ;EADRS送信
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE
		LD		HL,EXEAD   ;EXEAD送信
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE
		RET

;データ送信
;SADRSからEADRSまでを送信
DBSEND:	LD		HL,(EADRS)
		EX		DE,HL
		LD		HL,(SADRS)
DBSLOP:	LD		A,(HL)
		CALL	SNDBYTE
		LD		A,H
		CP		D
		JR		NZ,DBSLP1
		LD		A,L
		CP		E
		JR		Z,DBSLP2   ;HL = DE までLOOP
DBSLP1:	INC		HL
		JR		DBSLOP
DBSLP2:	RET


;**** DIRLIST ****
STLT:	INC		DE
		LD		HL,DEFDIR         ;行頭に'*FD 'を付けることでカーソルを移動させリターンで実行できるように
		LD		BC,DEND-DEFDIR
		CALL	DIRLIST
		AND		A                 ;00以外ならERROR
		JP		NZ,SVERR
		JP		MON


;**** DIRLIST本体 (HL=行頭に付加する文字列の先頭アドレス BC=行頭に付加する文字列の長さ) ****
;****              戻り値 A=エラーコード ****
DIRLIST:
		LD		A,83H      ;DIRLISTコマンド83Hを送信
		CALL	STCD       ;コマンドコード送信
		AND		A          ;00以外ならERROR
		JP		NZ,DLRET
		
		PUSH	BC
		LD		B,21H
STLT1:	LD		A,(DE)
		CP		0DH
		JR		NZ,STLT2
		LD		A,00H
STLT2:	CALL	SNDBYTE           ;ページ指示を送信
		INC		DE
		DEC		B
		JR		NZ,STLT1
		POP		BC
DL1:
		PUSH	HL
		PUSH	BC
		LD		DE,LBUF
		LDIR
		EX		DE,HL
DL2:	CALL	RCVBYTE           ;'00H'を受信するまでを一行とする
		CP		00H
		JR		Z,DL3
		CP		0FFH              ;'0FFH'を受信したら終了
		JR		Z,DL4
		CP		0FEH              ;'0FEH'を受信したら一時停止して一文字入力待ち
		JR		Z,DL5
		LD		(HL),A
		INC		HL
		JR		DL2
DL3:	LD		DE,LBUF           ;'00H'を受信したら一行分を表示して改行
		DW		MSGPR
		DW		LETLN
		POP		BC
		POP		HL
		JR		DL1
DL4:	CALL	RCVBYTE           ;状態取得(00H=OK)
		POP		BC
		POP		HL
		JR		DLRET

DL5:	LD		DE,MSG_KEY1        ;HIT ANT KEY表示
		DW		MSGPR
		LD		A,82H
		DW		DISPCH
		LD		DE,MSG_KEY2        ;HIT ANT KEY表示
		DW		MSGPR
		DW		LETLN
DL6:	DW		GETKEY            ;1文字入力待ち
		CP		00H
		JR		Z,DL6
		CP		0BH               ;SHIFT+BREAKで打ち切り
		JR		Z,DL7
		CP		02H               ;カーソル↑で打ち切り
		JR		Z,DL9
		CP		42H               ;「B」で前ページ
		JR		Z,DL8
		LD		A,00H             ;それ以外で継続
		JR		DL8
DL9:	LD		A,02H            ;カーソル↑で打ち切ったときにカーソル2行上へ
		DW		DPCT
		LD		A,02H
		DW		DPCT
DL7:	LD		A,0FFH            ;0FFH中断コードを送信
DL8:	CALL	SNDBYTE
		DW		LETLN
		JR		DL2
		
DLRET:		
		RET
		

;**** 1BYTE受信 ****
;受信DATAをAレジスタにセットしてリターン
RCVBYTE:
		CALL	F1CHK      ;PORTC BIT7が1になるまでLOOP
		IN		A,(PPI_B)   ;PORTB -> A
		PUSH 	AF
		LD		A,05H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 1
		CALL	F2CHK      ;PORTC BIT7が0になるまでLOOP
		LD		A,04H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 0
		POP 	AF
		RET
		
;**** 1BYTE送信 ****
;Aレジスタの内容をPORTA下位4BITに4BITずつ送信
SNDBYTE:
		PUSH	AF
		RRA
		RRA
		RRA
		RRA
		AND		0FH
		CALL	SND4BIT
		POP		AF
		AND		0FH
		CALL	SND4BIT
		RET

;**** 4BIT送信 ****
;Aレジスタ下位4ビットを送信する
SND4BIT:
		OUT		(PPI_A),A
		LD		A,05H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 1
		CALL	F1CHK      ;PORTC BIT7が1になるまでLOOP
		LD		A,04H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 0
		CALL	F2CHK
		RET
		
;**** BUSYをCHECK(1) ****
; 82H BIT7が1になるまでLOP
F1CHK:	IN		A,(PPI_C)
		AND		80H        ;PORTC BIT7 = 1?
		JR		Z,F1CHK
		RET

;**** BUSYをCHECK(0) ****
; 82H BIT7が0になるまでLOOP
F2CHK:	IN		A,(PPI_C)
		AND		80H        ;PORTC BIT7 = 0?
		JR		NZ,F2CHK
		RET

;****** FILE NAME 取得 (IN:DE コマンド文字の次の文字 OUT:HL ファイルネームの先頭)*********
STFN:	PUSH	AF
STFN1:	INC		DE         ;ファイルネームまでスペース読み飛ばし
		LD		A,(DE)
		CP		20H
		JR		Z,STFN1
		CP		30H        ;「0」以上の文字でなければエラーとする
		JP		C,STSV2
		EX		DE,HL
		POP		AF
		RET

;**** コマンド送信 (IN:A コマンドコード)****
STCD:	CALL	SNDBYTE    ;Aレジスタのコマンドコードを送信
		CALL	RCVBYTE    ;状態取得(00H=OK)
		RET

;**** ファイルネーム送信(IN:HL ファイルネームの先頭) ******
STFS:	LD		B,20H
STFS1:	LD		A,(HL)     ;FNAME送信
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,STFS1
		LD		A,0DH
		CALL	SNDBYTE
		CALL	RCVBYTE    ;状態取得(00H=OK)
		RET

;**** コマンド、ファイル名送信 (IN:A コマンドコード HL:ファイルネームの先頭)****
STCMD:	CALL	STFN       ;ファイルネーム取得
		PUSH	HL
		CALL	STCD       ;コマンドコード送信
		POP		HL
		AND		A          ;00以外ならERROR
		JP		NZ,SVER0
		CALL	STFS       ;ファイルネーム送信
		AND		A          ;00以外ならERROR
		JP		NZ,SVER0
		RET

;******** MESSAGE DATA ********************
MSG_LD:
		DB		16H
		DB		'LOADING '
		DB		0DH

WRMSG:
		DB		'WRITING '
		DB		0DH

MSG_SV:
		DB		'SAVE FINISHED!'
		DB		0DH
		
MSG_AS:
		DB		'ASTART FINISHED!'
		DB		0DH
		
MSG_ST:
		DB		'PATCHED MONITOR START!'
		DB		0DH
		
MSG_AD:
		DB		'ADDRESS FAILED!'
		DB		0DH
		
MSG_FNAME:
		DB		'FILE NAME FAILED!'
		DB		0DH
		
MSG_CMD:
		DB		'COMMAND FAILED!'
		DB		0DH
		
MSG_F0:
		DB		'SD-CARD INITIALIZE ERROR'
		DB		0DH
		
MSG_F1:
		DB		'NOT FIND FILE'
		DB		0DH
		
MSG_F3:
		DB		'FILE EXIST'
		DB		0DH
		
MSG_KEY1:
		DB		'NEXT:ANY BACK:B BREAK:'
		DB		0DH
MSG_KEY2:
		DB		' OR SHIFT+BREAK'
		DB		0DH
		
MSG_DELQ:
		DB		'FILE DELETE?(Y:OK ELSE:CANSEL)'
		DB		0DH
		
MSG_DELY:
		DB		'DELETE OK'
		DB		0DH
		
MSG_DELN:
		DB		'DELETE CANSEL'
		DB		0DH
		
MSG_REN:
		DB		'NEW NAME:                            '
		DB		0DH
		
MSG_DNAME:
		DB		'DOS FILE:'
MSG_DNAMEEND:
		DB		'                            '
		DB		0DH
		
MSG_RENY:
		DB		'RENAME OK'
		DB		0DH
		
MSG_AD1:
		DB		'ADRS +0 +1 +2 +3 +4 +5 +6 +7 01234567'
		DB		0DH
		
MSG_AD2:
		DB		'NEXT:ANY BACK:B BREAK:SHIFT+BREAK'
		DB		0DH
		
MSG_CPY:
		DB		'COPY OK'
		DB		0DH
		
MSG_FDW:
		DB		'*FDW '
		DB		0DH

MSG_TYPE:
		DB		'TYPE:'
		DB		0DH

MSG_SADRS:
		DB		'START:'
		DB		0DH

MSG_EADRS:
		DB		'END:'
		DB		0DH

MSG_XADRS:
		DB		'EXECUTE:'
		DB		0DH

MSG99:
		DB		' ERROR'
		DB		0DH
		
DEFNAME:
		DB		'0000'
		DB		0DH
NEND:

DEFDIR:
		DB		'*FD  '
DEND:

;*********************** 0436H MONITOR ライト インフォメーション代替処理 ************
MSHED:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		CALL	INIT
		LD		A,91H      ;HEADER SAVEコマンド91H
		CALL	MCMD       ;コマンドコード送信
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

;S-OS SWORD、8080用テキスト・エディタ＆アセンブラはファイルネームの後ろが20h詰めとなるため0dhに修正
		LD		B,11H
		LD		HL,FNAME+10H     ;ファイルネーム
		LD		A,0DH            ;17文字目には常に0DHをセットする
		LD		(HL),A
MSH0:	LD		A,(HL)
		CP		0DH              ;0DHであればひとつ前の文字の検査に移る
		JR		Z,MSH1
		CP		20H              ;20Hであれば0DHをセットしてひとつ前の文字の検査に移る
		JR		NZ,MSH2          ;0DH、20H以外の文字であれば終了
		LD		A,0DH
		LD		(HL),A
		
MSH1:	DEC		HL
		DEC		B
		JR		NZ,MSH0

MSH2:	DW		LETLN
		LD		DE,WRMSG   ;'WRITING '
		DW		MSGPR        ;メッセージ表示
		LD		DE,FNAME     ;ファイルネーム
		DW		MSGPR       ;メッセージ表示

		LD		HL,IBUFE
		LD		B,80H
MSH3:	LD		A,(HL)     ;インフォメーション ブロック送信
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,MSH3

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		JP		MRET       ;正常RETURN

;******************** 0475H MONITOR ライト データ代替処理 **********************
MSDAT:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		LD		A,92H      ;DATA SAVEコマンド92H
		CALL	MCMD       ;コマンドコード送信
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		LD		HL,FSIZE   ;FSIZE送信
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		LD		DE,(FSIZE)
		LD		HL,(SADRS)
MSD1:	LD		A,(HL)
		CALL	SNDBYTE      ;SADRSからFSIZE Byteを送信。分割セーブの場合、直前に0436HでOPENされたファイルを対象として256バイトずつ0475HがCALLされる。
		DEC		DE
		LD		A,D
		OR		E
		INC		HL
		JR		NZ,MSD1
		
		JP		MRET       ;正常RETURN

;************************** 04D8H MONITOR リード インフォメーション代替処理 *****************
MLHED:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		CALL	INIT

		LD		B,08H      ;LBUFを0DHで埋めファイルネームが指定されなかったことにする
		LD		DE,LBUF
		LD		A,0DH
MLH0:	LD		(DE),A
		INC		DE
		DEC		B
		JR		NZ,MLH0

		LD		A,03H          ;一行分をクリアするため3文字削除、37文字出力
		LD		(DSPX),A
		LD		A,07H
		DW		DPCT
		DW		DPCT
		DW		DPCT
MLH6:	LD		DE,MSG_DNAME   ;'DOS FILE:'
		DW		MSGPR
		LD		A,09H          ;カーソルを9文字目に戻す
		LD		(DSPX),A

		LD		DE,MBUF    ;ファイルネームを指示するための苦肉の策。LOADコマンドとしてはファイルネームなしとして改行したのちに行バッファの位置をずらしてDOSファイルネームを入力する。
		DW		GETL
		
		LD		DE,MBUF+9
		
		LD		A,(DE)
;**** ファイルネームの先頭が'*'なら拡張コマンド処理へ移行 ****
		CP		'*'
		JR		Z,MLHCMD

		LD		A,93H      ;HEADER LOADコマンド93H
		CALL	MCMD       ;コマンドコード送信
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

MLH1:
		LD		A,(DE)
		CP		20H                 ;行頭のスペースをファイルネームまで読み飛ばし
		JR		NZ,MLH2
		INC		DE
		JR		MLH1

MLH2:	LD		B,20H
MLH4:	LD		A,(DE)     ;FNAME送信
		CALL	SNDBYTE
		INC		DE
		DEC		B
		JR		NZ,MLH4
		LD		A,0DH
		CALL	SNDBYTE
		
		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		LD		HL,IBUFE
		LD		B,80H
MLH5:	CALL	RCVBYTE    ;読みだされたインフォメーションブロックを受信
		LD		(HL),A
		INC		HL
		DEC		B
		JR		NZ,MLH5

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		JP		MRET       ;正常RETURN

;**************************** アプリケーション内SD-CARD操作処理 **********************
MLHCMD:
;**** HL、DE、BCレジスタを保存 ****
		PUSH	HL
		PUSH	DE
		PUSH	BC
		INC		DE
		LD		B,03H
;**** FDLコマンド ****
		LD		HL,CMD1
		CALL	CMPSTR
		JR		Z,MLHCMD2
		POP		BC
		POP		DE
		POP		HL
;**** ファイルネーム入力へ復帰 ****
		JR		MLH6

MLHCMD2:
		INC		DE
		INC		DE
		INC		DE
		LD		HL,MSG_DNAME         ;行頭に'DOS FILE:'を付けることでカーソルを移動させリターンで実行できるように
		LD		BC,MSG_DNAMEEND-MSG_DNAME
;**** FDLコマンド呼び出し ****
		CALL	DIRLIST
		AND		A          ;00以外ならERROR
		JR		NZ,SERR
		POP		BC
		POP		DE
		POP		HL
;**** ファイルネーム入力へ復帰 ****
		JP		MLH6

;******* アプリケーション内SD-CARD操作処理用ERROR処理 **************
SERR:
		CP		0F0H
		JR		NZ,SERR3
		LD		DE,MSG_F0
		JR		SERRMSG
		
SERR3:	CP		0F1H
		JR		NZ,SERR99
		LD		DE,MSG_F1
		JR		SERRMSG
		
SERR99:	DW		PRTBYT
		LD		DE,MSG99
		
SERRMSG:
		DW		MSGPR
		DW		LETLN
		POP		BC
		POP		DE
		POP		HL
;**** ファイルネーム入力へ復帰 ****
		JP		MLH6

;**** コマンド文字列比較 ****
CMPSTR:
		PUSH	BC
		PUSH	DE
CMP1:	LD		A,(DE)
		CP		(HL)
		JR		NZ,CMP2
		DEC		B
		JR		Z,CMP2
		CP		0Dh
		JR		Z,CMP2
		INC		DE
		INC		HL
		JR		CMP1
CMP2:	POP		DE
		POP		BC
		RET

;**** コマンドリスト ****
; 将来拡張用
CMD1:	DB		'FDL',0DH


;**************************** 04F8H MONITOR リード データ代替処理 ********************
MLDAT:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		LD		A,94H      ;DATA LOADコマンド94H
		CALL	MCMD       ;コマンドコード送信
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		LD		DE,FSIZE   ;FSIZE送信
		LD		A,(DE)
		CALL	SNDBYTE
		INC		DE
		LD		A,(DE)
		CALL	SNDBYTE
		CALL	DBRCV      ;FSIZE分のデータを受信し、SADRSから格納。分割ロードの場合、直前に0436HでOPENされたファイルを対象として256バイトずつSADRSが加算されて04F8HがCALLされる。

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		JR		MRET       ;正常RETURN

;************************** 0588H VRFY CMT ベリファイ代替処理 *******************
MVRFY:	XOR		A          ;正常終了フラグ

		RET

;******* 代替処理用コマンドコード送信 (IN:A コマンドコード) **********
MCMD:
		CALL	SNDBYTE    ;コマンドコード送信
		CALL	RCVBYTE    ;状態取得(00H=OK)
		RET

;****** 代替処理用正常RETURN処理 **********
MRET:	POP		HL
		POP		BC
		POP		DE
		XOR		A          ;正常終了フラグ
		
		RET

;******* 代替処理用ERROR処理 **************
MERR:
		CP		0F0H
		JR		NZ,MERR3
		LD		DE,MSG_F0
		JR		MERRMSG
		
MERR3:	CP		0F1H
		JR		NZ,MERR99
		LD		DE,MSG_F1
		JR		MERRMSG
		
MERR99:	DW		PRTBYT
		LD		DE,MSG99
		
MERRMSG:
		DW		MSGPR
		DW		LETLN
		POP		HL
		POP		BC
		POP		DE
		LD		A,02H
		SCF

		RET

ENT6:
		END
