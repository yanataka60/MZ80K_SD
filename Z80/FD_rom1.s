GETL		EQU		0003H
LETLN		EQU		0006H
NEWLIN		EQU		0009H
PRNTS		EQU		000CH
MSGPR		EQU		0015H
PLIST		EQU		0018H
GETKEY		EQU		001BH
PRTWRD		EQU		03BAH
PRTBYT		EQU		03C3H
HLHEX		EQU		0410H
TWOHEX		EQU		041FH
ADCN		EQU		0BB9H
DISPCH		EQU		0DB5H
DPCT		EQU		0DDCH
IBUFE		EQU		10F0H
FNAME		EQU		10F1H
EADRS		EQU		1102H
FSIZE		EQU		1102H
SADRS		EQU		1104H
EXEAD		EQU		1106H
DSPX		EQU		1171H
LBUF		EQU		11A3H
MBUF		EQU		11AEH
MONITOR_80K	EQU		0082H
MONITOR_700	EQU		00ADH

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


       ORG		0F000H

		NOP                   ;ROM識別コード
		JP		START
;******************** MONITOR CMTルーチン代替 *************************************
		JP		MSHED
		JP		MSDAT
		JP		MLHED
		JP		MLDAT
		JP		MVRFY

		
START:	CALL	INIT
		LD		DE,LBUF     ;MZ-80K、MZ-700とも起動コマンドは'*FD'に統一
		LD		A,(DE)
		CP		'*'
		JP		NZ,MON
		INC 	DE
		LD		A,(DE)
		CP		'F'
		JP		NZ,MON
		INC		DE
		LD		A,(DE)
		CP		'D'
		JP		NZ,MON
		
		INC		DE          ;FDの次の文字へ移動
STT2:	LD		A,(DE)
		CP		20H         ;FDの後に1文字空白があれば以降をファイルネームとしてロード(ファイルネームは32文字まで)
		JR		Z,SDLOAD
		CP		'/'         ;FDの後が'/'なら以降をファイルネームとしてロード、実行はしない(ファイルネームは32文字まで)
		JR		Z,SDLOAD
		CP		0DH         ;FDだけで改行の場合にはDEFNAMEの文字列をファイルネームとしてロード
		JR		NZ,STETC    ;該当なしなら他コマンドをチェック
STT3:	PUSH	DE          ;設定ファイル名(0000.mzt)を転送
		LD		HL,DEFNAME
		INC		DE
		LD		BC,NEND-DEFNAME
		LDIR
		POP		DE
		JR		SDLOAD      ;LOAD処理へ
STETC:
		CP		'S'         ;FDS:SAVE処理へ
		JP		Z,STSV
		CP		'A'			;FDA:自動起動ファイル設定処理へ
		JP		Z,STAS
		CP		'L'         ;FDL:ファイル一覧表示
		JP		Z,STLT
		CP		'D'         ;FDD:DELETE
		JP		Z,STDE
		CP		'R'         ;FDR:RENAME
		JP		Z,STRN
		CP		'P'         ;FDP:DUMP
		JP		Z,STPR
		CP		'C'         ;FDC:COPY
		JP		Z,STCP
		CP		'M'         ;FDM:MEMORY DUMP
		JP		Z,STMD
		CP		'W'         ;FDW:MEMORY WRITE
		JP		Z,STMW
		JP		CMDERR

;**** 8255初期化 ****
;PORTC下位BITをOUTPUT、上位BITをINPUT、PORTBをINPUT、PORTAをOUTPUT
INIT:	LD		A,8AH
		OUT		(0DBH),A
;出力BITをリセット
INIT2:	LD		A,00H      ;PORTA <- 0
		OUT		(0D8H),A
		OUT		(0DAH),A   ;PORTC <- 0
		RET

;**** LOAD ****
;受信ヘッダ情報をセットし、SDカードからLOAD実行
SDLOAD:	LD		A,81H  ;LOADコマンド81H
		CALL	STCMD
		CALL	HDRCV      ;ヘッダ情報受信
		CALL	DBRCV      ;データ受信
		LD		A,(LBUF+3)
		CP		'/'        ;'*FD/'であれば実行アドレスに飛ばずにMONITORコマンド待ちに戻る
		JP		Z,MON
		LD		HL,(EXEAD)
		JP		(HL)

;ヘッダ受信
HDRCV:	LD		HL,FNAME
		LD		B,11H
HDRC1:	CALL	RCVBYTE    ;ファイルネーム受信
		LD		(HL),A
		INC		HL
		DEC		B
		JR		NZ,HDRC1
		LD		DE,MSG_LD  ;ファイルネームLOADING表示
		CALL	MSGPR
		LD		DE,FNAME
		CALL	MSGPR
		CALL	LETLN
		LD		HL,SADRS  ;SADRS取得
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
		LD		HL,FSIZE   ;FSIZE取得
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
		LD		HL,EXEAD   ;EXEAD取得
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
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

;**** SAVE ****
STSV:	INC		DE
		INC		DE
		PUSH	DE
		CALL	HLHEX       ;1文字空けて4桁の16進数であればSADRSにセットして続行
		JR		C,STSV1

		LD		(SADRS),HL      ;SARDS保存
		POP		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		PUSH	DE          ;5文字進めて4桁の16進数であればEADRSにセットして続行
		CALL	HLHEX
		JR		C,STSV1
		PUSH	HL
		LD		BC,(SADRS)
		SBC		HL,BC       ;EADRSがSADRSより大きくない場合はエラー
		POP		HL
		JR		Z,STSV1
		JP		M,STSV1

		LD		(EADRS),HL      ;EADRS保存
		POP		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE          ;5文字進めて4桁の16進数であればEXEADにセットして続行
		PUSH	DE
		CALL	HLHEX
		JR		C,STSV1
		
		LD		(EXEAD),HL      ;EXEAD保存
		POP		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE			;5文字進めてファイルネームがあれば続行
		LD		A,(DE)
		CP		31H
		JP		M,STSV2
		EX		DE,HL
		JR		SDSAVE      ;SAVE処理へ
STSV1:                      ;16進数4桁の取得に失敗又はEADRSがSARDSより大きくない
		LD		DE,MSG_AD
		JR		ERRMSG
STSV2:                      ;ファイルネームの取得に失敗
		LD		DE,MSG_FNAME
		JR		ERRMSG
CMDERR:                     ;コマンド異常
		LD		DE,MSG_CMD
		JR		ERRMSG

;送信ヘッダ情報をセットし、SDカードへSAVE実行
SDSAVE:	LD		A,80H      ;SAVEコマンド80H
		CALL	STCD
		CALL	HDSEND     ;ヘッダ情報送信
		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JR		NZ,SVERR
		CALL	DBSEND     ;データ送信
		LD		DE,MSG_SV
		JR		ERRMSG

SVERR:
		CP		0F0H
		JR		NZ,ERR2
		LD		DE,MSG_F0  ;SD-CARD INITIALIZE ERROR
		JR		ERRMSG
ERR2:	CP		0F2H
		JR		NZ,ERR3
		LD		DE,MSG_F2  ;NOT OBJECT FILE
		JR		ERRMSG
ERR3:	CP		0F1H
		JR		NZ,ERR4
		LD		DE,MSG_F1  ;NOT FIND FILE
		JR		ERRMSG
ERR4:	CP		0F3H
		JR		NZ,ERR99
		LD		DE,MSG_F3  ;FILE EXIST
		JR		ERRMSG
ERR99:	CALL	PRTBYT
		LD		DE,MSG99   ;その他ERROR
ERRMSG:	CALL	MSGPR
		CALL	LETLN
MON:	LD		HL,014EH
		LD		A,(HL)
		CP		'P'             ;014EHが'P'ならMZ-80K
		JP		Z,MONITOR_80K
		LD		HL,06EBH
		LD		A,(HL)
		CP		'M'             ;06EBHが'M'ならMZ-700
		JP		Z,MONITOR_700
		JP		0000H           ;識別できなかったら0000Hへジャンプ

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

;**** AUTO START SET ****
STAS:	LD		A,82H      ;AUTO START SETコマンド82H
		CALL	STCMD
		LD		DE,MSG_AS
		JP		ERRMSG

;**** DIRLIST ****
STLT:	INC		DE
		LD		A,(DE)
		CP		0DH
		JR		NZ,STLT1
		LD		A,30H
		JR		DIRLIST    ;FDLだけなら'30H'を送信(全ファイルを表示)
STLT1:	INC		DE         ;FDLの後に数字一文字があれば'31H'～'39H','41H'～'5AH'を送信(20件を1ページとしてnページを表示)
		LD		A,(DE)
		CP		30H
		JP		M,CMDERR
		CP		3AH
		JP		P,STLT2
		JR		DIRLIST
STLT2:	CP		41H        ;念のためA～Zにも対応
		JP		M,CMDERR
		CP		5BH
		JP		P,CMDERR
		SUB		07H
DIRLIST:
		PUSH	AF
		LD		A,83H      ;DIRLISTコマンド83Hを送信
		CALL	STCD       ;コマンドコード送信
		POP		AF
		CALL	SNDBYTE           ;ページ指示を送信
DL1:	LD		HL,DEFDIR         ;行頭に'*FD 'を付けることでカーソルを移動させリターンで実行できるように
		LD		DE,LBUF
		LD		BC,DEND-DEFDIR
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
		CALL	MSGPR
		CALL	LETLN
		JR		DL1
DL4:	CALL	RCVBYTE           ;状態取得(00H=OK)
		AND		A                 ;00以外ならERROR
		JP		NZ,SVERR
		JP		MON

DL5:	LD		DE,MSG_KEY1        ;HIT ANT KEY表示
		CALL	MSGPR
		LD		A,0C2H
		CALL	DISPCH
		LD		DE,MSG_KEY2        ;HIT ANT KEY表示
		CALL	MSGPR
		CALL	LETLN
DL6:	CALL	GETKEY            ;1文字入力待ち
		CP		00H
		JR		Z,DL6
		CP		64H               ;SHIFT+BREAKで打ち切り
		JR		Z,DL7
		CP		12H               ;カーソル↑で打ち切り
		JR		Z,DL9
		CALL	LETLN             ;それ以外で継続
		LD		A,00H
		JR		DL8
DL9:	LD		A,0C2H            ;カーソル↑で打ち切ったときにカーソル2行上へ
		CALL	DPCT
		LD		A,0C2H
		CALL	DPCT
DL7:	LD		A,0FFH            ;0FFH中断コードを送信
DL8:	CALL	SNDBYTE
		JR		DL2

;**** FILE DELETE ****
STDE:	LD		A,84H      ;FILE DELETEコマンド84H
		CALL	STCMD

		LD		DE,MSG_DELQ ;'DELETE?'表示
		CALL	MSGPR
		CALL	LETLN
STDE3:	CALL	GETKEY
		CP		00H
		JR		Z,STDE3
		CP		59H         ;'Y'ならOKとして00Hを送信
		JR		NZ,STDE4
		LD		A,00H
		JR		STDE5
STDE4:	LD		A,0FFH      ;'Y'以外ならCANSELとして0FFHを送信
STDE5:	CALL	SNDBYTE
		CALL	RCVBYTE
		CP		00H         ;00Hを受信すればDELETE完了
		JR		NZ,STDE6
		LD		DE,MSG_DELY ;'DELETE OK'表示
		JR		STDE8
STDE6:	CP		01H         ;01Hを受信すればCANSEL完了
		JR		NZ,STDE7
		LD		DE,MSG_DELN ;'DELETE CANSEL'表示
		JR		STDE8
STDE7:	JP		SVERR
STDE8:	JP		ERRMSG

;**** FILE RENAME ****
STRN:	LD		A,85H      ;FILE RENAMEコマンド85H
		CALL	STCMD

		LD		DE,MSG_REN ;'NEW NAME:'表示
		CALL	MSGPR
		
		LD		A,09H
		LD		(DSPX),A  ;カーソル位置を'NEW NAME:'の次へ
		LD		DE,LBUF    ;NEW FILE NAMEを取得
		CALL	GETL
		LD		DE,LBUF+8  ;NEW FILE NAMEを送信
		CALL	STFN
		CALL	STFS
		
		CALL	RCVBYTE
		CP		00H         ;00Hを受信すればRENAME完了
		JP		NZ,SVERR
		LD		DE,MSG_RENY
		JP		ERRMSG

;**** FILE DUMP ****
STPR:	LD		A,86H      ;FILE DUMPEコマンド86H
		CALL	STCMD

;		LD		A,0C6H     ;画面クリア
;		CALL	DPCT
STPR6:	LD		HL,SADRS   ;SADRS取得
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
		LD		HL,(SADRS)
		LD		A,H
		CP		0FFH        ;ADRSに0FFFFHが送信されてきたらDUMP処理終了
		JR		NZ,STPR7
		LD		A,L
		CP		0FFH
		JR		NZ,STPR7
		JP		STPR8
STPR7:	LD		DE,MSG_AD1 ;DUMP TITLE表示
		CALL	MSGPR
		CALL	LETLN
		LD		C,10H      ;16行(128Byte)を表示
STPR0:	PUSH	BC
		LD		B,08H      ;一行(8Byte)を受信
		LD		HL,LBUF
STPR1:	CALL	RCVBYTE
		LD		(HL),A
		DEC		B
		INC		HL
		JR		NZ,STPR1

		LD		HL,(SADRS) ;アドレス表示
		CALL	PRTWRD
		LD		DE,0008H   ;一画面(128Byte)中はアドレスを受け取らないので自前でインクリメント
		ADD		HL,DE
		LD		(SADRS),HL
		
		LD		B,08H      ;一行(8Byte)のデータを16進数表示
		LD		DE,LBUF
STPR2:	CALL	PRNTS
		LD		A,(DE)
		CALL	PRTBYT
		INC		DE
		DEC		B
		JR		NZ,STPR2
		
		CALL	PRNTS
		LD		DE,LBUF
		LD		B,08H
STPR9:	LD		A,(DE)
		CALL	ADCN
		CALL	DISPCH
		INC		DE
		DEC		B
		JR		NZ,STPR9

		CALL	LETLN
		POP		BC
		DEC		C
		JR		NZ,STPR0
		
		LD		DE,MSG_AD2        ;入力待ちメッセージ表示
		CALL	MSGPR
		CALL	LETLN
		CALL	LETLN
STPR3:	CALL	GETKEY            ;1文字入力待ち
		CP		00H
		JR		Z,STPR3
		CP		64H               ;SHIFT+BREAKで打ち切り
		JR		Z,STPR4
		CALL	SNDBYTE           ;SHIFT+BREAK以外はASCIIコードのまま送信、ARDUINO側で'B'を処理
		JP		STPR6
STPR4:	LD		A,0FFH            ;0FFH中断コードを送信
STPR5:	CALL	SNDBYTE
		CALL	RCVBYTE           ;SHIFT+BREAKでの中断時はADRS'0FFFFH'の受信及び状態コードの受信を破棄
		CALL	RCVBYTE
STPR8:	CALL	RCVBYTE
		JP		MON

;**** FILE COPY ****
STCP:	LD		A,87H      ;FILE COPYコマンド87H
		CALL	STCMD
		LD		DE,MSG_REN ;'NEW NAME:'表示
		CALL	MSGPR
		
		LD		A,09H
		LD		(DSPX),A    ;カーソル位置を'NEW NAME:'の次へ
		LD		DE,LBUF      ;NEW FILE NAMEを取得
		CALL	GETL
		LD		DE,LBUF+8    ;NEW FILE NAMEを送信
		CALL	STFN
		CALL	STFS
		
		CALL	RCVBYTE
		CP		00H         ;00Hを受信すればRENAME完了
		JP		NZ,SVERR
		LD		DE,MSG_CPY
		JP		ERRMSG

;**** MEMORY DUMP ****
STMD:	INC		DE
		INC		DE
		CALL	HLHEX       ;1文字空けて4桁の16進数であればSADRSにセットして続行
		JP		C,STSV1
		LD		(SADRS),HL      ;SARDS保存

STMD6:	LD		DE,MSG_AD1 ;DUMP TITLE表示
		CALL	MSGPR
		CALL	LETLN
		LD		C,10H      ;16行(128Byte)を表示
STMD7:	LD		HL,(SADRS) ;アドレス表示
		CALL	PRTWRD
		CALL	PRNTS

		
		LD		B,08H
STMD0:	LD		A,(HL)
		CALL	PRTBYT
		CALL	PRNTS
		CALL	GETKEY
		CP		64H
		JR		Z,STMD4
		INC		HL
		DEC		B
		JR		NZ,STMD0

		LD		HL,(SADRS)
		LD		B,08H
STMD2:	LD		A,(HL)
		CALL	ADCN
		CALL	DISPCH
		CALL	GETKEY
		CP		64H
		JR		Z,STMD4
		INC		HL
		DEC		B
		JR		NZ,STMD2

		LD		(SADRS),HL
		CALL	LETLN

		DEC		C
		JR		NZ,STMD7
		
		LD		DE,MSG_AD2        ;入力待ちメッセージ表示
		CALL	MSGPR
		CALL	LETLN
		CALL	LETLN
STMD3:	CALL	GETKEY            ;1文字入力待ち
		CP		00H
		JR		Z,STMD3
		CP		64H               ;SHIFT+BREAKで打ち切り
		JR		Z,STMD4
		CP		42H
		JR		NZ,STMD5
		LD		HL,(SADRS)
		LD		DE,0100H
		SBC		HL,DE
		LD		(SADRS),HL
STMD5:	JP		STMD6
STMD4:	JP		MON

;**** MEMORY WRITE ****
STMW:	INC		DE
		INC		DE
		CALL	HLHEX       ;1文字空けて4桁の16進数であればHLにセットして続行
		JP		C,STSV1

		INC		DE
		INC		DE
		INC		DE
		INC		DE
STSP1:	LD		A,(DE)
		CP		0DH
		JR		Z,STMW9     ;アドレスのみなら終了
		CP		20H
		JR		NZ,STMW1
		INC		DE          ;空白は飛ばす
		JR		STSP1

STMW1:
		CALL	TWOHEX
		JR		C,STMW8
		LD		(HL),A      ;2桁の16進数があれば(HL)に書き込み
		INC		HL

STSP2:	LD		A,(DE)
		CP		0DH         ;一行終了
		JR		Z,STMW8
		CP		20H
		JR		NZ,STMW1
		INC		DE          ;空白は飛ばす
		JR		STSP2

STMW8:	
		LD		DE,MSG_FDW  ;行頭に'*FDW '
		CALL	MSGPR
		CALL	PRTWRD      ;アドレス表示
		CALL	PRNTS
		LD		DE,LBUF     ;一行入力
		CALL	GETL
		LD		DE,LBUF
		LD		A,(DE)
		CP		1BH
		JR		Z,STMW9     ;SHIFT+BREAKで破棄、終了
		LD		DE,LBUF+3
		JR		STMW
STMW9:	JP		MON

;**** 1BYTE受信 ****
;受信DATAをAレジスタにセットしてリターン
RCVBYTE:
		CALL	F1CHK      ;PORTC BIT7が1になるまでLOOP
		LD		A,05H
		OUT		(0DBH),A    ;PORTC BIT2 <- 1
		IN		A,(0D9h)   ;PORTB -> A
		PUSH 	AF
		CALL	F2CHK      ;PORTC BIT7が0になるまでLOOP
		LD		A,04H
		OUT		(0DBH),A    ;PORTC BIT2 <- 0
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
		OUT		(0D8H),A
		LD		A,05H
		OUT		(0DBH),A    ;PORTC BIT2 <- 1
		CALL	F1CHK      ;PORTC BIT7が1になるまでLOOP
		LD		A,04H
		OUT		(0DBH),A    ;PORTC BIT2 <- 0
		CALL	F2CHK
		RET
		
;**** BUSYをCHECK(1) ****
; 82H BIT7が1になるまでLOP
F1CHK:	IN		A,(0DAH)
		AND		80H        ;PORTC BIT7 = 1?
		JR		Z,F1CHK
		RET

;**** BUSYをCHECK(0) ****
; 82H BIT7が0になるまでLOOP
F2CHK:	IN		A,(0DAH)
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
		JP		M,STSV2
		EX		DE,HL
		POP		AF
		RET

;**** コマンド送信 (IN:A コマンドコード)****
STCD:	CALL	SNDBYTE    ;Aレジスタのコマンドコードを送信
		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,SVERR
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
		AND		A          ;00以外ならERROR
		JP		NZ,SVERR
		RET

;**** コマンド、ファイル名送信 (IN:A コマンドコード HL:ファイルネームの先頭)****
STCMD:	CALL	STFN       ;ファイルネーム取得
		PUSH	HL
		CALL	STCD       ;コマンドコード送信
		POP		HL
		CALL	STFS       ;ファイルネーム送信
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
		
MSG_F2:
		DB		'NOT OBJECT FILE'
		DB		0DH
		
MSG_F3:
		DB		'FILE EXIST'
		DB		0DH
		
MSG_KEY1:
		DB		'HIT ANY KEY(BREAK:'
		DB		0DH
MSG_KEY2:
		DB		' OR SHIFT+BREAK)'
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
		DB		'DOS FILE:                            '
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
		LD		A,91H      ;HEADER SAVEコマンド91H
		CALL	MCMD       ;コマンドコード送信

		LD		DE,WRMSG   ;'WRITING '
		CALL	MSGPR        ;メッセージ表示
		LD		DE,FNAME     ;ファイルネーム
		CALL	MSGPR       ;メッセージ表示

		LD		HL,IBUFE
		LD		B,80H
MSH1:	LD		A,(HL)     ;インフォメーション ブロック送信
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,MSH1

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
		LD		A,93H      ;HEADER LOADコマンド93H
		CALL	MCMD       ;コマンドコード送信

		LD		B,08H
		LD		DE,LBUF
		LD		A,0DH
MLH0:	LD		(HL),A
		INC		DE
		DEC		B
		JR		NZ,MLH0

		LD		A,03H          ;一行分をクリアするため3文字削除、37文字出力
		LD		(DSPX),A
		LD		A,0C7H
		CALL	DPCT
		CALL	DPCT
		CALL	DPCT
		LD		DE,MSG_DNAME   ;'DOS FILE:'
		CALL	MSGPR
		LD		A,09H          ;カーソルを9文字目に戻す
		LD		(DSPX),A

		LD		DE,MBUF    ;ファイルネームを指示するための苦肉の策。LOADコマンドとしてはファイルネームなしとして改行したのちに行バッファの位置をずらしてDOSファイルネームを入力する。
		CALL	GETL
		
		LD		DE,MBUF+9
;		LD		DE,MBUF
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

		JR		MRET       ;正常RETURN

;**************************** 04F8H MONITOR リード データ代替処理 ********************
MLDAT:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		LD		A,94H      ;DATA LOADコマンド94H
		CALL	MCMD       ;コマンドコード送信

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
		EI
		RET

;******* 代替処理用コマンドコード送信 (IN:A コマンドコード) **********
MCMD:	PUSH	AF
		CALL	INIT
		POP		AF
		CALL	SNDBYTE    ;コマンドコード送信
		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR
		RET

;****** 代替処理用正常RETURN処理 **********
MRET:	POP		HL
		POP		BC
		POP		DE
		XOR		A          ;正常終了フラグ
		EI
		RET

;******* 代替処理用ERROR処理 **************
MERR:
		CP		0F0H
		JR		NZ,MERR2
		LD		DE,MSG_F0
		JR		MERRMSG
		
MERR2:	CP		0F2H
		JR		NZ,MERR3
		LD		DE,MSG_F2
		JR		MERRMSG
		
MERR3:	CP		0F1H
		JR		NZ,MERR99
		LD		DE,MSG_F1
		JR		MERRMSG
		
MERR99:	CALL	PRTBYT
		LD		DE,MSG99
		
MERRMSG:
		CALL	MSGPR
		CALL	LETLN
		POP		HL
		POP		BC
		POP		DE
		LD		A,02H
		SCF
		EI
		RET

		END
