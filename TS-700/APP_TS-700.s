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

		ORG		2800H

		LD		A,0C3H				;FSAVE�W�����v��ύX
		LD		(FSAVE),A
		LD		HL,ENT1
		LD		(FSAVE+1),HL
		
		LD		A,0C3H				;PSAVE�W�����v��ύX
		LD		(PSAVE),A
		LD		HL,ENT2
		LD		(PSAVE+1),HL
		
		LD		A,0C3H				;FLOAD�W�����v��ύX
		LD		(FLOAD),A
		LD		HL,ENT3
		LD		(FLOAD+1),HL
		
		LD		A,0C3H				;PLOAD�W�����v��ύX
		LD		(PLOAD),A
		LD		HL,ENT4
		LD		(PLOAD+1),HL
		
		LD		A,0C3H				;VERIFY�W�����v��ύX
		LD		(VERIFY),A
		LD		HL,ENT5
		LD		(VERIFY+1),HL
		
		OUT		(0E1H),A			;D00H�`FFFFH DRAM�ؑ�
		LD		HL,ENT
		LD		DE,ENT1
		LD		BC,ENT6-ENT1
		LDIR						;SD�A�N�Z�X���[�`���]�� F800H�`
		OUT		(0E4H),A			;�ꉞ�o���N�֖ؑ߂�
		JP		2700H				;TS-700�N���v���Z�X��

ENT:
		ORG		0F800H

;******************** MONITOR CMT���[�`����� *************************************
ENT1:	JP		MSHED
ENT2:	JP		MSDAT
ENT3:	JP		MLHED
ENT4:	JP		MLDAT
ENT5:	JP		MVRFY

		
;**** 8255������ ****
;PORTC����BIT��OUTPUT�A���BIT��INPUT�APORTB��INPUT�APORTA��OUTPUT
INIT:	LD		A,8AH
		OUT		(PPI_R),A
;�o��BIT�����Z�b�g
INIT2:	LD		A,00H      ;PORTA <- 0
		OUT		(PPI_A),A
		OUT		(PPI_C),A   ;PORTC <- 0
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

STSV2:                      ;�t�@�C���l�[���̎擾�Ɏ��s
		LD		DE,MSG_FNAME
		JR		ERRMSG

SVER0:
		POP		DE         ;CALL��STACK��j������
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
		LD		DE,MSG99   ;���̑�ERROR
ERRMSG:	DW		MSGPR
		DW		LETLN
MON:	JP		MONITOR

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
		LD		DE,LBUF
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
		DW		MSGPR
		DW		LETLN
		POP		BC
		POP		HL
		JR		DL1
DL4:	CALL	RCVBYTE           ;��Ԏ擾(00H=OK)
		POP		BC
		POP		HL
		JR		DLRET

DL5:	LD		DE,MSG_KEY1        ;HIT ANT KEY�\��
		DW		MSGPR
		LD		A,82H
		DW		DISPCH
		LD		DE,MSG_KEY2        ;HIT ANT KEY�\��
		DW		MSGPR
		DW		LETLN
DL6:	DW		GETKEY            ;1�������͑҂�
		CP		00H
		JR		Z,DL6
		CP		0BH               ;SHIFT+BREAK�őł��؂�
		JR		Z,DL7
		CP		02H               ;�J�[�\�����őł��؂�
		JR		Z,DL9
		CP		42H               ;�uB�v�őO�y�[�W
		JR		Z,DL8
		LD		A,00H             ;����ȊO�Ōp��
		JR		DL8
DL9:	LD		A,02H            ;�J�[�\�����őł��؂����Ƃ��ɃJ�[�\��2�s���
		DW		DPCT
		LD		A,02H
		DW		DPCT
DL7:	LD		A,0FFH            ;0FFH���f�R�[�h�𑗐M
DL8:	CALL	SNDBYTE
		DW		LETLN
		JR		DL2
		
DLRET:		
		RET
		

;**** 1BYTE��M ****
;��MDATA��A���W�X�^�ɃZ�b�g���ă��^�[��
RCVBYTE:
		CALL	F1CHK      ;PORTC BIT7��1�ɂȂ�܂�LOOP
		IN		A,(PPI_B)   ;PORTB -> A
		PUSH 	AF
		LD		A,05H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 1
		CALL	F2CHK      ;PORTC BIT7��0�ɂȂ�܂�LOOP
		LD		A,04H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 0
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
		OUT		(PPI_A),A
		LD		A,05H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 1
		CALL	F1CHK      ;PORTC BIT7��1�ɂȂ�܂�LOOP
		LD		A,04H
		OUT		(PPI_R),A    ;PORTC BIT2 <- 0
		CALL	F2CHK
		RET
		
;**** BUSY��CHECK(1) ****
; 82H BIT7��1�ɂȂ�܂�LOP
F1CHK:	IN		A,(PPI_C)
		AND		80H        ;PORTC BIT7 = 1?
		JR		Z,F1CHK
		RET

;**** BUSY��CHECK(0) ****
; 82H BIT7��0�ɂȂ�܂�LOOP
F2CHK:	IN		A,(PPI_C)
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

MSH2:	DW		LETLN
		LD		DE,WRMSG   ;'WRITING '
		DW		MSGPR        ;���b�Z�[�W�\��
		LD		DE,FNAME     ;�t�@�C���l�[��
		DW		MSGPR       ;���b�Z�[�W�\��

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

		LD		B,08H      ;LBUF��0DH�Ŗ��߃t�@�C���l�[�����w�肳��Ȃ��������Ƃɂ���
		LD		DE,LBUF
		LD		A,0DH
MLH0:	LD		(DE),A
		INC		DE
		DEC		B
		JR		NZ,MLH0

		LD		A,03H          ;��s�����N���A���邽��3�����폜�A37�����o��
		LD		(DSPX),A
		LD		A,07H
		DW		DPCT
		DW		DPCT
		DW		DPCT
MLH6:	LD		DE,MSG_DNAME   ;'DOS FILE:'
		DW		MSGPR
		LD		A,09H          ;�J�[�\����9�����ڂɖ߂�
		LD		(DSPX),A

		LD		DE,MBUF    ;�t�@�C���l�[�����w�����邽�߂̋���̍�BLOAD�R�}���h�Ƃ��Ă̓t�@�C���l�[���Ȃ��Ƃ��ĉ��s�����̂��ɍs�o�b�t�@�̈ʒu�����炵��DOS�t�@�C���l�[������͂���B
		DW		GETL
		
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
		
SERR99:	DW		PRTBYT
		LD		DE,MSG99
		
SERRMSG:
		DW		MSGPR
		DW		LETLN
		POP		BC
		POP		DE
		POP		HL
;**** �t�@�C���l�[�����͂֕��A ****
		JP		MLH6

;**** �R�}���h�������r ****
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

		RET

;******* ��֏����p�R�}���h�R�[�h���M (IN:A �R�}���h�R�[�h) **********
MCMD:
		CALL	SNDBYTE    ;�R�}���h�R�[�h���M
		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		RET

;****** ��֏����p����RETURN���� **********
MRET:	POP		HL
		POP		BC
		POP		DE
		XOR		A          ;����I���t���O
		
		RET

;******* ��֏����pERROR���� **************
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
