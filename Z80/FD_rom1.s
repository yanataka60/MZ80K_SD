;2021.12.12 MZ-700��FDP�AFDM�������������錻�ۂɑΏ�
;2022. 1.23 04D8H MONITOR ���[�h �C���t�H���[�V������֏����̃o�O���C��
;2022. 1.24 �t�@�C���l�[���̌���20h�l�߂�0dh�ɏC�����邽�߂̏�����Arduino������MZ-80K���ɏC��
;2022. 1.25 0475H MONITOR ���C�g �f�[�^��֏����A04F8H MONITOR ���[�h �f�[�^��֏����ł�8255��������p�~
;2022. 1.26 FD�R�}���h�Ń��[�h�\�ȃt�@�C����ރR�[�h��0x01�݂̂Ƃ��Ă���������P�p
;2022. 1.29 CMT��֏���RETURN���̊����݋���(EI)���폜
;2022. 1.31 FD�R�}���h���s��A�v�����삪�ł܂��Ă��܂��@�B�A�A�v���ւ̑Ώ�
;2022. 1.31 FDL�R�}���h�d�l�ύX FDL x�̏ꍇ�A�t�@�C�����擪�ꕶ�����r���Ĉ�v�������̂������o��
;           B�L�[�őO��20����\��
;2022. 2. 8 FDL�R�}���h�d�l�ύX FDL x�̏ꍇ�A�t�@�C�����擪1�����`32�����܂łɊg��
;2022. 2.10 04D8H MONITOR ���[�h �C���t�H���[�V������֏����̒�����FDL�R�}���h���g����悤�ɏC��
;           FDL�R�}���h�������T�u���[�`����
;
GETL		EQU		0003H
LETLN		EQU		0006H
NEWLIN		EQU		0009H
PRNTS		EQU		000CH
MSGPR		EQU		0015H
PLIST		EQU		0018H
GETKEY		EQU		001BH
TIMST		EQU		0033H
CMPSTR		EQU		0180H
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

;0D8H PORTA ���M�f�[�^(����4�r�b�g)
;0D9H PORTB ��M�f�[�^(8�r�b�g)
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
;0DBH �R���g���[�����W�X�^


       ORG		0F000H

		NOP                   ;ROM���ʃR�[�h
		JP		START
;******************** MONITOR CMT���[�`����� *************************************
ENT1:	JP		MSHED
ENT2:	JP		MSDAT
ENT3:	JP		MLHED
ENT4:	JP		MLDAT
ENT5:	JP		MVRFY

		
START:	CALL	INIT
		LD		DE,LBUF     ;MZ-80K�AMZ-700�Ƃ��N���R�}���h��'*FD'�ɓ���
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
		
		INC		DE          ;FD�̎��̕����ֈړ�
STT2:	LD		A,(DE)
		CP		20H         ;FD�̌��1�����󔒂�����Έȍ~���t�@�C���l�[���Ƃ��ă��[�h(�t�@�C���l�[����32�����܂�)
		JR		Z,SDLOAD
		CP		'/'         ;FD�̌オ'/'�Ȃ�ȍ~���t�@�C���l�[���Ƃ��ă��[�h�A���s�͂��Ȃ�(�t�@�C���l�[����32�����܂�)
		JR		Z,SDLOAD
		CP		0DH         ;FD�����ŉ��s�̏ꍇ�ɂ�DEFNAME�̕�������t�@�C���l�[���Ƃ��ă��[�h
		JR		NZ,STETC    ;�Y���Ȃ��Ȃ瑼�R�}���h���`�F�b�N
STT3:	PUSH	DE          ;�ݒ�t�@�C����(0000.mzt)��]��
		LD		HL,DEFNAME
		INC		DE
		LD		BC,NEND-DEFNAME
		LDIR
		POP		DE
		JR		SDLOAD      ;LOAD������
STETC:
		CP		'S'         ;FDS:SAVE������
		JP		Z,STSV
		CP		'A'			;FDA:�����N���t�@�C���ݒ菈����
		JP		Z,STAS
		CP		'L'         ;FDL:�t�@�C���ꗗ�\��
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
		CP		'Z'         ;FDZ:MZ-700 PATCH START
		JP		Z,STMZ
		CP		'U'         ;FDU:MZ-700 ��RAM START
		JP		Z,STURA
		JP		CMDERR

;**** 8255������ ****
;PORTC����BIT��OUTPUT�A���BIT��INPUT�APORTB��INPUT�APORTA��OUTPUT
INIT:	LD		A,8AH
		OUT		(0DBH),A
;�o��BIT�����Z�b�g
INIT2:	LD		A,00H      ;PORTA <- 0
		OUT		(0D8H),A
		OUT		(0DAH),A   ;PORTC <- 0
		RET

;**** LOAD ****
;��M�w�b�_�����Z�b�g���ASD�J�[�h����LOAD���s
SDLOAD:	LD		A,81H  ;LOAD�R�}���h81H
		CALL	STCMD
		CALL	HDRCV      ;�w�b�_����M
		CALL	DBRCV      ;�f�[�^��M
		LD		A,(LBUF+3)
		CP		'/'        ;'*FD/'�ł���Ύ��s�A�h���X�ɔ�΂���MONITOR�R�}���h�҂��ɖ߂�
		JP		Z,MON
; FD�R�}���h���s��A�v�����삪�ł܂��Ă��܂��@�B�A�A�v���ւ̑Ώ�
		LD		A,00H
		LD		DE,0000H
		CALL	TIMST
		
		LD		HL,(EXEAD)
		JP		(HL)

;�w�b�_��M
HDRCV:	LD		HL,FNAME
		LD		B,11H
HDRC1:	CALL	RCVBYTE    ;�t�@�C���l�[����M
		LD		(HL),A
		INC		HL
		DEC		B
		JR		NZ,HDRC1
		LD		DE,MSG_LD  ;�t�@�C���l�[��LOADING�\��
		CALL	MSGPR
		LD		DE,FNAME
		CALL	MSGPR
		CALL	LETLN
		LD		HL,SADRS  ;SADRS�擾
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
		LD		HL,FSIZE   ;FSIZE�擾
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
		LD		HL,EXEAD   ;EXEAD�擾
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
		RET

;�f�[�^��M
DBRCV:	LD		DE,(FSIZE)
		LD		HL,(SADRS)
DBRLOP:	CALL	RCVBYTE
		LD		(HL),A
		DEC		DE
		LD		A,D
		OR		E
		INC		HL
		JR		NZ,DBRLOP   ;DE=0�܂�LOOP
		RET

;**** SAVE ****
STSV:	INC		DE
		INC		DE
		PUSH	DE
		CALL	HLHEX       ;1�����󂯂�4����16�i���ł����SADRS�ɃZ�b�g���đ��s
		JR		C,STSV1

		LD		(SADRS),HL      ;SARDS�ۑ�
		POP		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		PUSH	DE          ;5�����i�߂�4����16�i���ł����EADRS�ɃZ�b�g���đ��s
		CALL	HLHEX
		JR		C,STSV1
		PUSH	HL
		LD		BC,(SADRS)
		SBC		HL,BC       ;EADRS��SADRS���傫���Ȃ��ꍇ�̓G���[
		POP		HL
		JR		Z,STSV1
		JR		C,STSV1

		LD		(EADRS),HL      ;EADRS�ۑ�
		POP		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE          ;5�����i�߂�4����16�i���ł����EXEAD�ɃZ�b�g���đ��s
		PUSH	DE
		CALL	HLHEX
		JR		C,STSV1
		
		LD		(EXEAD),HL      ;EXEAD�ۑ�
		POP		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE
		INC		DE			;5�����i�߂ăt�@�C���l�[��������Α��s
		LD		A,(DE)
		CP		31H
		JR		C,STSV2
		EX		DE,HL
		JR		SDSAVE      ;SAVE������
STSV1:                      ;16�i��4���̎擾�Ɏ��s����EADRS��SARDS���傫���Ȃ�
		LD		DE,MSG_AD
		JR		ERRMSG
STSV2:                      ;�t�@�C���l�[���̎擾�Ɏ��s
		LD		DE,MSG_FNAME
		JR		ERRMSG
CMDERR:                     ;�R�}���h�ُ�
		LD		DE,MSG_CMD
		JR		ERRMSG

;���M�w�b�_�����Z�b�g���ASD�J�[�h��SAVE���s
SDSAVE:	LD		A,80H      ;SAVE�R�}���h80H
		CALL	STCD
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,SVERR
		CALL	HDSEND     ;�w�b�_��񑗐M
		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JR		NZ,SVERR
		CALL	DBSEND     ;�f�[�^���M
		LD		DE,MSG_SV
		JR		ERRMSG

SVER0:
		POP		DE         ;CALL��STACK��j������
SVERR:
		CP		0F0H
		JR		NZ,ERR3
		LD		DE,MSG_F0  ;SD-CARD INITIALIZE ERROR
		JR		ERRMSG
;FD�R�}���h�Ń��[�h�\�ȃt�@�C����ރR�[�h��0x01�݂̂Ƃ��Ă���������P�p
;ERR2:	CP		0F2H
;		JR		NZ,ERR3
;		LD		DE,MSG_F2  ;NOT OBJECT FILE
;		JR		ERRMSG
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
ERR99:	CALL	PRTBYT
		LD		DE,MSG99   ;���̑�ERROR
ERRMSG:	CALL	MSGPR
		CALL	LETLN
MON:	LD		HL,014EH
		LD		A,(HL)
		CP		'P'             ;014EH��'P'�Ȃ�MZ-80K
		JP		Z,MONITOR_80K
		CP		'N'             ;014EH��'N'�Ȃ�FN-700
		JP		Z,MONITOR_80K
		LD		HL,06EBH
		LD		A,(HL)
		CP		'M'             ;06EBH��'M'�Ȃ�MZ-700
		JP		Z,MONITOR_700
		JP		0000H           ;���ʂł��Ȃ�������0000H�փW�����v

;�w�b�_���M
HDSEND:	PUSH	HL
		LD		B,20H
SS1:	LD		A,(HL)     ;FNAME���M
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,SS1
		LD		A,0DH
		CALL	SNDBYTE
		POP		HL
		LD		B,10H
SS2:	LD		A,(HL)     ;PNAME���M
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,SS2
		LD		A,0DH
		CALL	SNDBYTE
		LD		HL,SADRS   ;SADRS���M
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE
		LD		HL,EADRS   ;EADRS���M
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE
		LD		HL,EXEAD   ;EXEAD���M
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE
		RET

;�f�[�^���M
;SADRS����EADRS�܂ł𑗐M
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
		JR		Z,DBSLP2   ;HL = DE �܂�LOOP
DBSLP1:	INC		HL
		JR		DBSLOP
DBSLP2:	RET

;**** AUTO START SET ****
STAS:	LD		A,82H      ;AUTO START SET�R�}���h82H
		CALL	STCMD
		LD		DE,MSG_AS
		JP		ERRMSG


;**** DIRLIST ****
STLT:	INC		DE
		LD		HL,DEFDIR         ;�s����'*FD '��t���邱�ƂŃJ�[�\�����ړ��������^�[���Ŏ��s�ł���悤��
		LD		BC,DEND-DEFDIR
		CALL	DIRLIST
		AND		A                 ;00�ȊO�Ȃ�ERROR
		JP		NZ,SVERR
		JP		MON


;**** DIRLIST�{�� (HL=�s���ɕt�����镶����̐擪�A�h���X BC=�s���ɕt�����镶����̒���) ****
;****              �߂�l A=�G���[�R�[�h ****
DIRLIST:
		LD		A,83H      ;DIRLIST�R�}���h83H�𑗐M
		CALL	STCD       ;�R�}���h�R�[�h���M
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,DLRET
		
		PUSH	BC
		LD		B,21H
STLT1:	LD		A,(DE)
		CP		0DH
		JR		NZ,STLT2
		LD		A,00H
STLT2:	CALL	SNDBYTE           ;�y�[�W�w���𑗐M
		INC		DE
		DEC		B
		JR		NZ,STLT1
		POP		BC
DL1:
		PUSH	HL
		PUSH	BC
;		LD		HL,DEFDIR         ;�s����'*FD '��t���邱�ƂŃJ�[�\�����ړ��������^�[���Ŏ��s�ł���悤��
		LD		DE,LBUF
;		LD		BC,DEND-DEFDIR
		LDIR
		EX		DE,HL
DL2:	CALL	RCVBYTE           ;'00H'����M����܂ł���s�Ƃ���
		CP		00H
		JR		Z,DL3
		CP		0FFH              ;'0FFH'����M������I��
		JR		Z,DL4
		CP		0FEH              ;'0FEH'����M������ꎞ��~���Ĉꕶ�����͑҂�
		JR		Z,DL5
		LD		(HL),A
		INC		HL
		JR		DL2
DL3:	LD		DE,LBUF           ;'00H'����M�������s����\�����ĉ��s
		CALL	MSGPR
		CALL	LETLN
		POP		BC
		POP		HL
		JR		DL1
DL4:	CALL	RCVBYTE           ;��Ԏ擾(00H=OK)
		POP		BC
		POP		HL
		JR		DLRET

DL5:	LD		DE,MSG_KEY1        ;HIT ANT KEY�\��
		CALL	MSGPR
		LD		A,0C2H
		CALL	DISPCH
		LD		DE,MSG_KEY2        ;HIT ANT KEY�\��
		CALL	MSGPR
		CALL	LETLN
DL6:	CALL	GETKEY            ;1�������͑҂�
		CP		00H
		JR		Z,DL6
		CP		64H               ;SHIFT+BREAK�őł��؂�
		JR		Z,DL7
		CP		12H               ;�J�[�\�����őł��؂�
		JR		Z,DL9
		CP		42H               ;�uB�v�őO�y�[�W
		JR		Z,DL8
		LD		A,00H             ;����ȊO�Ōp��
		JR		DL8
DL9:	LD		A,0C2H            ;�J�[�\�����őł��؂����Ƃ��ɃJ�[�\��2�s���
		CALL	DPCT
		LD		A,0C2H
		CALL	DPCT
DL7:	LD		A,0FFH            ;0FFH���f�R�[�h�𑗐M
DL8:	CALL	SNDBYTE
		CALL	LETLN
		JR		DL2
		
DLRET:		
		RET
		

;**** FILE DELETE ****
STDE:	LD		A,84H      ;FILE DELETE�R�}���h84H
		CALL	STCMD

		LD		DE,MSG_DELQ ;'DELETE?'�\��
		CALL	MSGPR
		CALL	LETLN
STDE3:	CALL	GETKEY
		CP		00H
		JR		Z,STDE3
		CP		59H         ;'Y'�Ȃ�OK�Ƃ���00H�𑗐M
		JR		NZ,STDE4
		LD		A,00H
		JR		STDE5
STDE4:	LD		A,0FFH      ;'Y'�ȊO�Ȃ�CANSEL�Ƃ���0FFH�𑗐M
STDE5:	CALL	SNDBYTE
		CALL	RCVBYTE
		CP		00H         ;00H����M�����DELETE����
		JR		NZ,STDE6
		LD		DE,MSG_DELY ;'DELETE OK'�\��
		JR		STDE8
STDE6:	CP		01H         ;01H����M�����CANSEL����
		JR		NZ,STDE7
		LD		DE,MSG_DELN ;'DELETE CANSEL'�\��
		JR		STDE8
STDE7:	JP		SVERR
STDE8:	JP		ERRMSG

;**** FILE RENAME ****
STRN:	LD		A,85H      ;FILE RENAME�R�}���h85H
		CALL	STCMD

		LD		DE,MSG_REN ;'NEW NAME:'�\��
		CALL	MSGPR
		
		LD		A,09H
		LD		(DSPX),A  ;�J�[�\���ʒu��'NEW NAME:'�̎���
		LD		DE,LBUF    ;NEW FILE NAME���擾
		CALL	GETL
		LD		DE,LBUF+8  ;NEW FILE NAME�𑗐M
		CALL	STFN
		CALL	STFS
		
		CALL	RCVBYTE
		CP		00H         ;00H����M�����RENAME����
		JP		NZ,SVERR
		LD		DE,MSG_RENY
		JP		ERRMSG

;**** FILE DUMP ****
STPR:	LD		A,86H      ;FILE DUMPE�R�}���h86H
		CALL	STCMD

;		LD		A,0C6H     ;��ʃN���A
;		CALL	DPCT
STPR6:	LD		HL,SADRS   ;SADRS�擾
		CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		CALL	RCVBYTE
		LD		(HL),A
		LD		HL,(SADRS)
		LD		A,H
		CP		0FFH        ;ADRS��0FFFFH�����M����Ă�����DUMP�����I��
		JR		NZ,STPR7
		LD		A,L
		CP		0FFH
		JR		NZ,STPR7
		JP		STPR8
STPR7:	LD		DE,MSG_AD1 ;DUMP TITLE�\��
		CALL	MSGPR
		CALL	LETLN
		LD		C,10H      ;16�s(128Byte)��\��
STPR0:	PUSH	BC
		LD		B,08H      ;��s(8Byte)����M
		LD		HL,LBUF
STPR1:	CALL	RCVBYTE
		LD		(HL),A
		INC		HL
		DEC		B
		JR		NZ,STPR1

		LD		HL,(SADRS) ;�A�h���X�\��
		CALL	PRTWRD
		LD		DE,0008H   ;����(128Byte)���̓A�h���X���󂯎��Ȃ��̂Ŏ��O�ŃC���N�������g
		ADD		HL,DE
		LD		(SADRS),HL
		
		LD		B,08H      ;��s(8Byte)�̃f�[�^��16�i���\��
		LD		DE,LBUF
STPR2:	CALL	PRNTS
		LD		A,(DE)
		CALL	PRTBYT
		INC		DE
		DEC		B
		JR		NZ,STPR2
		
		CALL	PRNTS
		LD		DE,LBUF    ;��s(8Byte)�̃f�[�^���L�����N�^�\��
		LD		B,08H
STPR9:	LD		A,(DE)
		CP		10H        ;MZ-700�ł̕��������ɑΏ�
		JR		NC,STPRA
		LD		A,20H
STPRA:	CALL	ADCN
		CALL	DISPCH
		INC		DE
		DEC		B
		JR		NZ,STPR9

		CALL	LETLN
		POP		BC
		DEC		C
		JR		NZ,STPR0
		
		LD		DE,MSG_AD2        ;���͑҂����b�Z�[�W�\��
		CALL	MSGPR
		CALL	LETLN
		CALL	LETLN
STPR3:	CALL	GETKEY            ;1�������͑҂�
		CP		00H
		JR		Z,STPR3
		CP		64H               ;SHIFT+BREAK�őł��؂�
		JR		Z,STPR4
		CALL	SNDBYTE           ;SHIFT+BREAK�ȊO��ASCII�R�[�h�̂܂ܑ��M�AARDUINO����'B'������
		JP		STPR6
STPR4:	LD		A,0FFH            ;0FFH���f�R�[�h�𑗐M
STPR5:	CALL	SNDBYTE
		CALL	RCVBYTE           ;SHIFT+BREAK�ł̒��f����ADRS'0FFFFH'�̎�M�y�я�ԃR�[�h�̎�M��j��
		CALL	RCVBYTE
STPR8:	CALL	RCVBYTE
		JP		MON

;**** FILE COPY ****
STCP:	LD		A,87H      ;FILE COPY�R�}���h87H
		CALL	STCMD
		LD		DE,MSG_REN ;'NEW NAME:'�\��
		CALL	MSGPR
		
		LD		A,09H
		LD		(DSPX),A    ;�J�[�\���ʒu��'NEW NAME:'�̎���
		LD		DE,LBUF      ;NEW FILE NAME���擾
		CALL	GETL
		LD		DE,LBUF+8    ;NEW FILE NAME�𑗐M
		CALL	STFN
		CALL	STFS
		
		CALL	RCVBYTE
		CP		00H         ;00H����M�����RENAME����
		JP		NZ,SVERR
		LD		DE,MSG_CPY
		JP		ERRMSG

;**** MEMORY DUMP ****
STMD:	INC		DE
		INC		DE
		CALL	HLHEX       ;1�����󂯂�4����16�i���ł����SADRS�ɃZ�b�g���đ��s
		JP		C,STSV1
		LD		(SADRS),HL      ;SARDS�ۑ�

STMD6:	LD		DE,MSG_AD1 ;DUMP TITLE�\��
		CALL	MSGPR
		CALL	LETLN
		LD		C,10H      ;16�s(128Byte)��\��
STMD7:	LD		HL,(SADRS) ;�A�h���X�\��
		CALL	PRTWRD
		CALL	PRNTS

		
		LD		B,08H      ;��s(8Byte)�̃f�[�^��16�i���\��
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
		LD		B,08H      ;��s(8Byte)�̃f�[�^���L�����N�^�\��
STMD2:	LD		A,(HL)
		CP		10H        ;MZ-700�ł̕��������ɑΏ�
		JR		NC,STMD8
		LD		A,20H
STMD8:	CALL	ADCN
		CALL	DISPCH
		CALL	GETKEY
		CP		64H        ;�\���r���ł�SHIFT+BREAK�őł��؂�
		JR		Z,STMD4
		INC		HL
		DEC		B
		JR		NZ,STMD2

		LD		(SADRS),HL
		CALL	LETLN

		DEC		C
		JR		NZ,STMD7
		
		LD		DE,MSG_AD2        ;���͑҂����b�Z�[�W�\��
		CALL	MSGPR
		CALL	LETLN
		CALL	LETLN
STMD3:	CALL	GETKEY            ;1�������͑҂�
		CP		00H
		JR		Z,STMD3
		CP		64H               ;SHIFT+BREAK�őł��؂�
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
		CALL	HLHEX       ;1�����󂯂�4����16�i���ł����HL�ɃZ�b�g���đ��s
		JP		C,STSV1

		INC		DE
		INC		DE
		INC		DE
		INC		DE
STSP1:	LD		A,(DE)
		CP		0DH
		JR		Z,STMW9     ;�A�h���X�݂̂Ȃ�I��
		CP		20H
		JR		NZ,STMW1
		INC		DE          ;�󔒂͔�΂�
		JR		STSP1

STMW1:
		CALL	TWOHEX
		JR		C,STMW8
		LD		(HL),A      ;2����16�i���������(HL)�ɏ�������
		INC		HL

STSP2:	LD		A,(DE)
		CP		0DH         ;��s�I��
		JR		Z,STMW8
		CP		20H
		JR		NZ,STMW1
		INC		DE          ;�󔒂͔�΂�
		JR		STSP2

STMW8:	
		LD		DE,MSG_FDW  ;�s����'*FDW '
		CALL	MSGPR
		CALL	PRTWRD      ;�A�h���X�\��
		CALL	PRNTS
		LD		DE,LBUF     ;��s����
		CALL	GETL
		LD		DE,LBUF
		LD		A,(DE)
		CP		1BH
		JR		Z,STMW9     ;SHIFT+BREAK�Ŕj���A�I��
		LD		DE,LBUF+3
		JR		STMW
STMW9:	JP		MON

;**** MZ-700 PATCH START ****
STMZ:	DI
		LD		HL,0000H      ;ROM��2000H�ɃR�s�[
		LD		DE,2000H
		LD		BC,1000H
		LDIR
		OUT		(0E0H),A      ;��RAM ON
		LD		HL,2000H      ;��RAM��ROM�̓��e���R�s�[
		LD		DE,0000H
		LD		BC,1000H
		LDIR
		LD		HL,STMZ2      ;���������A�h���X
		LD		DE,STMZ3      ;���������f�[�^
		LD		B,0FH
STMZ1:	PUSH	BC
		LD		C,(HL)
		INC		HL
		LD		B,(HL)
		LD		A,(DE)
		LD		(BC),A
		POP		BC
		INC		DE
		INC		HL
		DEC		B
		JR		NZ,STMZ1
		LD		HL,00ADH
		LD		A,(HL)
		CP		0CDH
		JP		NZ,0000H         ;MZ-700�Ɣ��f�ł��Ȃ����0000H����X�^�[�g
		LD		DE,MSG_ST
		CALL	MSGPR
		CALL	LETLN
		JP		MONITOR_700      ;MZ-700�Ɣ��f�ł����00ADH����X�^�[�g

STMZ2:	DW		0437H,0438H,0439H
		DW		0476H,0477H,0478H
		DW		04D9H,04DAH,04DBH
		DW		04F9H,04FAH,04FBH
		DW		0589H,058AH,058BH

STMZ3:	DB		0C3H
		DW		ENT1
		DB		0C3H
		DW		ENT2
		DB		0C3H
		DW		ENT3
		DB		0C3H
		DW		ENT4
		DB		0C3H
		DW		ENT5

;**** MZ-700 ��RAM START ****
STURA:	OUT		(0E0H),A      ;��RAM ON
		LD		HL,00ADH
		LD		A,(HL)
		CP		0CDH
		JP		NZ,0000H         ;0CDH�łȂ����NZ-700�ȂǂƔ��f����0000H����X�^�[�g
		LD		DE,MSG_ST
		CALL	MSGPR
		CALL	LETLN
		JP		MONITOR_700      ;(00ADH)��0CDH�Ȃ�1Z-009A����1Z-009B�̃p�b�`�ς�MONITOR�Ɣ��f����00ADH����X�^�[�g

;**** 1BYTE��M ****
;��MDATA��A���W�X�^�ɃZ�b�g���ă��^�[��
RCVBYTE:
		CALL	F1CHK      ;PORTC BIT7��1�ɂȂ�܂�LOOP
		IN		A,(0D9h)   ;PORTB -> A
		PUSH 	AF
		LD		A,05H
		OUT		(0DBH),A    ;PORTC BIT2 <- 1
		CALL	F2CHK      ;PORTC BIT7��0�ɂȂ�܂�LOOP
		LD		A,04H
		OUT		(0DBH),A    ;PORTC BIT2 <- 0
		POP 	AF
		RET
		
;**** 1BYTE���M ****
;A���W�X�^�̓��e��PORTA����4BIT��4BIT�����M
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

;**** 4BIT���M ****
;A���W�X�^����4�r�b�g�𑗐M����
SND4BIT:
		OUT		(0D8H),A
		LD		A,05H
		OUT		(0DBH),A    ;PORTC BIT2 <- 1
		CALL	F1CHK      ;PORTC BIT7��1�ɂȂ�܂�LOOP
		LD		A,04H
		OUT		(0DBH),A    ;PORTC BIT2 <- 0
		CALL	F2CHK
		RET
		
;**** BUSY��CHECK(1) ****
; 82H BIT7��1�ɂȂ�܂�LOP
F1CHK:	IN		A,(0DAH)
		AND		80H        ;PORTC BIT7 = 1?
		JR		Z,F1CHK
		RET

;**** BUSY��CHECK(0) ****
; 82H BIT7��0�ɂȂ�܂�LOOP
F2CHK:	IN		A,(0DAH)
		AND		80H        ;PORTC BIT7 = 0?
		JR		NZ,F2CHK
		RET

;****** FILE NAME �擾 (IN:DE �R�}���h�����̎��̕��� OUT:HL �t�@�C���l�[���̐擪)*********
STFN:	PUSH	AF
STFN1:	INC		DE         ;�t�@�C���l�[���܂ŃX�y�[�X�ǂݔ�΂�
		LD		A,(DE)
		CP		20H
		JR		Z,STFN1
		CP		30H        ;�u0�v�ȏ�̕����łȂ���΃G���[�Ƃ���
		JP		C,STSV2
		EX		DE,HL
		POP		AF
		RET

;**** �R�}���h���M (IN:A �R�}���h�R�[�h)****
STCD:	CALL	SNDBYTE    ;A���W�X�^�̃R�}���h�R�[�h�𑗐M
		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		RET

;**** �t�@�C���l�[�����M(IN:HL �t�@�C���l�[���̐擪) ******
STFS:	LD		B,20H
STFS1:	LD		A,(HL)     ;FNAME���M
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,STFS1
		LD		A,0DH
		CALL	SNDBYTE
		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		RET

;**** �R�}���h�A�t�@�C�������M (IN:A �R�}���h�R�[�h HL:�t�@�C���l�[���̐擪)****
STCMD:	CALL	STFN       ;�t�@�C���l�[���擾
		PUSH	HL
		CALL	STCD       ;�R�}���h�R�[�h���M
		POP		HL
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,SVER0
		CALL	STFS       ;�t�@�C���l�[�����M
		AND		A          ;00�ȊO�Ȃ�ERROR
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
		
;MSG_F2:
;		DB		'NOT OBJECT FILE'
;		DB		0DH
		
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

;*********************** 0436H MONITOR ���C�g �C���t�H���[�V������֏��� ************
MSHED:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		CALL	INIT
		LD		A,91H      ;HEADER SAVE�R�}���h91H
		CALL	MCMD       ;�R�}���h�R�[�h���M
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

;S-OS SWORD�A8080�p�e�L�X�g�E�G�f�B�^���A�Z���u���̓t�@�C���l�[���̌�낪20h�l�߂ƂȂ邽��0dh�ɏC��
		LD		B,11H
		LD		HL,FNAME+10H     ;�t�@�C���l�[��
		LD		A,0DH            ;17�����ڂɂ͏��0DH���Z�b�g����
		LD		(HL),A
MSH0:	LD		A,(HL)
		CP		0DH              ;0DH�ł���΂ЂƂO�̕����̌����Ɉڂ�
		JR		Z,MSH1
		CP		20H              ;20H�ł����0DH���Z�b�g���ĂЂƂO�̕����̌����Ɉڂ�
		JR		NZ,MSH2          ;0DH�A20H�ȊO�̕����ł���ΏI��
		LD		A,0DH
		LD		(HL),A
		
MSH1:	DEC		HL
		DEC		B
		JR		NZ,MSH0

MSH2:	CALL	LETLN
		LD		DE,WRMSG   ;'WRITING '
		CALL	MSGPR        ;���b�Z�[�W�\��
		LD		DE,FNAME     ;�t�@�C���l�[��
		CALL	MSGPR       ;���b�Z�[�W�\��

		LD		HL,IBUFE
		LD		B,80H
MSH3:	LD		A,(HL)     ;�C���t�H���[�V���� �u���b�N���M
		CALL	SNDBYTE
		INC		HL
		DEC		B
		JR		NZ,MSH3

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		JP		MRET       ;����RETURN

;******************** 0475H MONITOR ���C�g �f�[�^��֏��� **********************
MSDAT:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		LD		A,92H      ;DATA SAVE�R�}���h92H
		CALL	MCMD       ;�R�}���h�R�[�h���M
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		LD		HL,FSIZE   ;FSIZE���M
		LD		A,(HL)
		CALL	SNDBYTE
		INC		HL
		LD		A,(HL)
		CALL	SNDBYTE

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		LD		DE,(FSIZE)
		LD		HL,(SADRS)
MSD1:	LD		A,(HL)
		CALL	SNDBYTE      ;SADRS����FSIZE Byte�𑗐M�B�����Z�[�u�̏ꍇ�A���O��0436H��OPEN���ꂽ�t�@�C����ΏۂƂ���256�o�C�g����0475H��CALL�����B
		DEC		DE
		LD		A,D
		OR		E
		INC		HL
		JR		NZ,MSD1
		
		JP		MRET       ;����RETURN

;************************** 04D8H MONITOR ���[�h �C���t�H���[�V������֏��� *****************
MLHED:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		CALL	INIT

		LD		A,00H
		LD		DE,0000H
		CALL	TIMST

		LD		B,08H      ;LBUF��0DH�Ŗ��߃t�@�C���l�[�����w�肳��Ȃ��������Ƃɂ���
		LD		DE,LBUF
		LD		A,0DH
MLH0:	LD		(DE),A
		INC		DE
		DEC		B
		JR		NZ,MLH0

		LD		A,03H          ;��s�����N���A���邽��3�����폜�A37�����o��
		LD		(DSPX),A
		LD		A,0C7H
		CALL	DPCT
		CALL	DPCT
		CALL	DPCT
MLH6:	LD		DE,MSG_DNAME   ;'DOS FILE:'
		CALL	MSGPR
		LD		A,09H          ;�J�[�\����9�����ڂɖ߂�
		LD		(DSPX),A

		LD		DE,MBUF    ;�t�@�C���l�[�����w�����邽�߂̋���̍�BLOAD�R�}���h�Ƃ��Ă̓t�@�C���l�[���Ȃ��Ƃ��ĉ��s�����̂��ɍs�o�b�t�@�̈ʒu�����炵��DOS�t�@�C���l�[������͂���B
		CALL	GETL
		
		LD		DE,MBUF+9
		
		LD		A,(DE)
;**** �t�@�C���l�[���̐擪��'*'�Ȃ�g���R�}���h�����ֈڍs ****
		CP		'*'
		JR		Z,MLHCMD

		LD		A,93H      ;HEADER LOAD�R�}���h93H
		CALL	MCMD       ;�R�}���h�R�[�h���M
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

MLH1:
		LD		A,(DE)
		CP		20H                 ;�s���̃X�y�[�X���t�@�C���l�[���܂œǂݔ�΂�
		JR		NZ,MLH2
		INC		DE
		JR		MLH1

MLH2:	LD		B,20H
MLH4:	LD		A,(DE)     ;FNAME���M
		CALL	SNDBYTE
		INC		DE
		DEC		B
		JR		NZ,MLH4
		LD		A,0DH
		CALL	SNDBYTE
		
		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		LD		HL,IBUFE
		LD		B,80H
MLH5:	CALL	RCVBYTE    ;�ǂ݂����ꂽ�C���t�H���[�V�����u���b�N����M
		LD		(HL),A
		INC		HL
		DEC		B
		JR		NZ,MLH5

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		JP		MRET       ;����RETURN

;**************************** �A�v���P�[�V������SD-CARD���쏈�� **********************
MLHCMD:
;**** HL�ADE�ABC���W�X�^��ۑ� ****
		PUSH	HL
		PUSH	DE
		PUSH	BC
		INC		DE
		LD		B,03H
;**** FDL�R�}���h ****
		LD		HL,CMD1
		CALL	CMPSTR
		JR		Z,MLHCMD2
		POP		BC
		POP		DE
		POP		HL
;**** �t�@�C���l�[�����͂֕��A ****
		JR		MLH6

MLHCMD2:
		INC		DE
		INC		DE
		INC		DE
		LD		HL,MSG_DNAME         ;�s����'DOS FILE:'��t���邱�ƂŃJ�[�\�����ړ��������^�[���Ŏ��s�ł���悤��
		LD		BC,MSG_DNAMEEND-MSG_DNAME
;**** FDL�R�}���h�Ăяo�� ****
		CALL	DIRLIST
		AND		A          ;00�ȊO�Ȃ�ERROR
		JR		NZ,SERR
		POP		BC
		POP		DE
		POP		HL
;**** �t�@�C���l�[�����͂֕��A ****
		JP		MLH6

;******* �A�v���P�[�V������SD-CARD���쏈���pERROR���� **************
SERR:
		CP		0F0H
		JR		NZ,SERR3
		LD		DE,MSG_F0
		JR		SERRMSG
		
SERR3:	CP		0F1H
		JR		NZ,SERR99
		LD		DE,MSG_F1
		JR		SERRMSG
		
SERR99:	CALL	PRTBYT
		LD		DE,MSG99
		
SERRMSG:
		CALL	MSGPR
		CALL	LETLN
		POP		BC
		POP		DE
		POP		HL
;**** �t�@�C���l�[�����͂֕��A ****
		JP		MLH6

;**** �R�}���h���X�g ****
; �����g���p
CMD1:	DB		'FDL',0DH


;**************************** 04F8H MONITOR ���[�h �f�[�^��֏��� ********************
MLDAT:
		PUSH	DE
		PUSH	BC
		PUSH	HL
		LD		A,94H      ;DATA LOAD�R�}���h94H
		CALL	MCMD       ;�R�}���h�R�[�h���M
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		LD		DE,FSIZE   ;FSIZE���M
		LD		A,(DE)
		CALL	SNDBYTE
		INC		DE
		LD		A,(DE)
		CALL	SNDBYTE
		CALL	DBRCV      ;FSIZE���̃f�[�^����M���ASADRS����i�[�B�������[�h�̏ꍇ�A���O��0436H��OPEN���ꂽ�t�@�C����ΏۂƂ���256�o�C�g����SADRS�����Z�����04F8H��CALL�����B

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		JR		MRET       ;����RETURN

;************************** 0588H VRFY CMT �x���t�@�C��֏��� *******************
MVRFY:	XOR		A          ;����I���t���O
;		EI

		RET

;******* ��֏����p�R�}���h�R�[�h���M (IN:A �R�}���h�R�[�h) **********
MCMD:
;		PUSH	AF
;		CALL	INIT
;		POP		AF
		CALL	SNDBYTE    ;�R�}���h�R�[�h���M
		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		RET

;****** ��֏����p����RETURN���� **********
MRET:	POP		HL
		POP		BC
		POP		DE
		XOR		A          ;����I���t���O
;		EI
		
		RET

;******* ��֏����pERROR���� **************
MERR:
		CP		0F0H
		JR		NZ,MERR3
		LD		DE,MSG_F0
		JR		MERRMSG
;��֏����ł̓t�@�C����ރR�[�h�̔��ʂȂ�
;MERR2:	CP		0F2H
;		JR		NZ,MERR3
;		LD		DE,MSG_F2
;		JR		MERRMSG
		
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
;		EI

		RET

		END
