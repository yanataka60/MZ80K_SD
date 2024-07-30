;
GETL		EQU		0003H
LETLN		EQU		0006H
MSGPR		EQU		0015H
PRTBYT		EQU		03C3H
DPCT		EQU		0DDCH
IBUFE		EQU		10F0H
FNAME		EQU		10F1H
FSIZE		EQU		1102H
SADRS		EQU		1104H
DSPX		EQU		1171H
LBUF		EQU		11A3H
MBUF		EQU		11AEH

;*********** MZ-80K_SD  *****************
PPI_A		EQU		0D8H

PPI_B		EQU		PPI_A+1
PPI_C		EQU		PPI_A+2
PPI_R		EQU		PPI_A+3

;PPI_A PORTA 送信データ(下位4ビット)
;PPI_B PORTB 受信データ(8ビット)
;
;PPI_C PORTC Bit
;7 IN  CHK
;6 IN
;5 IN
;4 IN 
;3 OUT
;2 OUT FLG
;1 OUT
;0 OUT
;
;PPI_R コントロールレジスタ

		ORG		0CC4FH
		
		IN		A,(0F8H)
		IN		A,(0F9H)
		CP		0A5H
		JR		NZ,ST
		LD		A,0A0H
		LD		(P1+1),A
		LD		(P2+1),A
		INC		A
		LD		(P3+1),A
		INC		A
		LD		(P4+1),A
		LD		(P5+1),A
		LD		(P6+1),A
		INC		A
		LD		(P7+1),A
		LD		(P8+1),A
		LD		(P9+1),A
		LD		(P10+1),A
		LD		(P11+1),A

ST:		LD		DE,NAME
		CALL	MLHED2
		CALL	MLDAT

		LD		A,(1438H)
		CP		27H
		JR		NZ,FERR
		LD		A,(1443H)
		CP		2AH
		JR		NZ,FERR
		LD		A,(1929H)
		CP		21H
		JR		NZ,FERR
		LD		A,(192CH)
		CP		24H
		JR		NZ,FERR

		LD		HL,ENT3
		LD		(1438H),HL
		LD		HL,ENT4
		LD		(1443H),HL
		LD		HL,ENT1
		LD		(1929H),HL
		LD		HL,ENT2
		LD		(192CH),HL
		
		JP		1200H

FERR:
		CALL	LETLN
		LD		DE,FEMSG   ;
		CALL	MSGPR        ;メッセージ表示
		JP		00ADH

MLHED2:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		CALL	INIT
		JP		MLH7

NAME:	DB		'ROPOKO-TR',0DH
FEMSG:
		DB		'NOT ROPOKO-PR OR DIFFERRENT VERSION'
		DB		0DH


ENTX:

       ORG		0CD00H

ENT0:
		JP		START
;******************** MONITOR CMTルーチン代替 *************************************
ENT1:	JP		MSHED		;0021H
ENT2:	JP		MSDAT		;0024H
ENT3:	JP		MLHED		;0027H
ENT4:	JP		MLDAT		;002AH
ENT5:	JP		MVRFY		;002DH
		
START:	CALL	INIT
		RET

;**** 8255初期化 ****
;PORTC下位BITをOUTPUT、上位BITをINPUT、PORTBをINPUT、PORTAをOUTPUT
INIT:	LD		A,8AH
P7:		OUT		(PPI_R),A
;出力BITをリセット
INIT2:	LD		A,00H      ;PORTA <- 0
P1:		OUT		(PPI_A),A
P4:		OUT		(PPI_C),A   ;PORTC <- 0
		RET

;**** 1BYTE受信 ****
;受信DATAをAレジスタにセットしてリターン
RCVBYTE:
		CALL	F1CHK      ;PORTC BIT7が1になるまでLOOP
P3:		IN		A,(PPI_B)   ;PORTB -> A
		PUSH 	AF
		LD		A,05H
P8:		OUT		(PPI_R),A    ;PORTC BIT2 <- 1
		CALL	F2CHK      ;PORTC BIT7が0になるまでLOOP
		LD		A,04H
P9:		OUT		(PPI_R),A    ;PORTC BIT2 <- 0
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
P2:		OUT		(PPI_A),A
		LD		A,05H
P10:	OUT		(PPI_R),A    ;PORTC BIT2 <- 1
		CALL	F1CHK      ;PORTC BIT7が1になるまでLOOP
		LD		A,04H
P11:	OUT		(PPI_R),A    ;PORTC BIT2 <- 0
		CALL	F2CHK
		RET
		
;**** BUSYをCHECK(1) ****
; 82H BIT7が1になるまでLOP
F1CHK:
P5:		IN		A,(PPI_C)
		AND		80H        ;PORTC BIT7 = 1?
		JR		Z,F1CHK
		RET

;**** BUSYをCHECK(0) ****
; 82H BIT7が0になるまでLOOP
F2CHK:
P6:		IN		A,(PPI_C)
		AND		80H        ;PORTC BIT7 = 0?
		JR		NZ,F2CHK
		RET

;******** MESSAGE DATA ********************
WRMSG:
		DB		'WRITING '
		DB		0DH

MSG_F0:
		DB		'SD-CARD INITIALIZE ERROR'
		DB		0DH
		
MSG_F1:
		DB		'NOT FIND FILE'
		DB		0DH
		
MSG_DNAME:
		DB		'DOS FILE:'
MSG_DNAMEEND:
		DB		'                            '
		DB		0DH
		
MSG_SNAME:
		DB		'SAVE NAME:'
MSG_SNAMEEND:
		DB		'                            '
		DB		0DH
		
MSG99:
		DB		' ERROR'
		DB		0DH
		
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

		LD		A,03H          ;一行分をクリアするため3文字削除、37文字出力
		LD		(DSPX),A
		LD		A,0C7H
		CALL	DPCT
		CALL	DPCT
		CALL	DPCT
		LD		DE,MSG_SNAME   ;'SAVE NAME:'
		CALL	MSGPR
		LD		A,0AH          ;カーソルを10文字目に戻す
		LD		(DSPX),A

		LD		DE,MBUF
		CALL	GETL
		
		LD		DE,MBUF+10
		
		LD		B,10H
		LD		HL,FNAME
MSH6:	LD		A,(DE)
		LD		(HL),A
		INC		HL
		INC		DE
		DJNZ	MSH6

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
		DJNZ	MSH0

MSH2:	CALL	LETLN
		LD		DE,WRMSG   ;'WRITING '
		CALL	MSGPR        ;メッセージ表示
		LD		DE,FNAME     ;ファイルネーム
		CALL	MSGPR       ;メッセージ表示

		LD		HL,IBUFE
		LD		B,80H
MSH3:	LD		A,(HL)     ;インフォメーション ブロック送信
		CALL	SNDBYTE
		INC		HL
		DJNZ	MSH3

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
		DJNZ	MLH0

		LD		A,03H          ;一行分をクリアするため3文字削除、37文字出力
		LD		(DSPX),A
		LD		A,0C7H
		CALL	DPCT
		CALL	DPCT
		CALL	DPCT
MLH6:	LD		DE,MSG_DNAME   ;'DOS FILE:'
		CALL	MSGPR
		LD		A,09H          ;カーソルを9文字目に戻す
		LD		(DSPX),A

		LD		DE,MBUF    ;ファイルネームを指示するための苦肉の策。LOADコマンドとしてはファイルネームなしとして改行したのちに行バッファの位置をずらしてDOSファイルネームを入力する。
		CALL	GETL
		
		LD		DE,MBUF+9
		
MLH7:	LD		A,93H      ;HEADER LOADコマンド93H
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
		CP		21H
		JR		NC,MLH3
		LD		A,0DH
MLH3:
		CALL	SNDBYTE
		INC		DE
		DJNZ	MLH4
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
		DJNZ	MLH5

		CALL	RCVBYTE    ;状態取得(00H=OK)
		AND		A          ;00以外ならERROR
		JP		NZ,MERR

		JP		MRET       ;正常RETURN

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

;************************** 0588H VRFY CMT ベリファイ代替処理 *******************
MVRFY:
		XOR		A          ;正常終了フラグ

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

		RET

ENT6:
		END
