;���|�R(�̌���)�Ή�(�����A�f�[�^�u���b�N�݂̂�CMT WRITE�AREAD�ėp)
;�C���t�H���[�V�����u���b�N��WRITE�AREAD��CALL���ꂸ�Ƀf�[�^�u���b�N��WRITE�AREAD�����s����A�v���P�[�V�����ɑΉ��B
;
;�f�[�^�u���b�NWTITE �Ăяo����
;  IFB��FNAME��DOS�t�@�C�����Ƃ���Arduino�֑��M(�t�@�C�����쐬)���AIFB 128Byte��Arduino�֑��M(���o��)
;  IFB��START ADDRESS����FILE SIZE���̃f�[�^������������ǂݏo����Arduino�֑��M(���o��)
;
;�f�[�^�u���b�NREAD �Ăяo����
;  IFB��FNAME��DOS�t�@�C�����Ƃ���Arduino�֑��M(�t�@�C���I�[�v��)�AIFB 128Byte��Arduino������M(��M���Ĕp��)
;  IFB��FILE SIZE���̃f�[�^��Arduino�����M���ASTART ADDRESS����̃������֏�������
;
LETLN		EQU		0006H
MSGPR		EQU		0015H
PRTBYT		EQU		03C3H
IBUFE		EQU		10F0H
FNAME		EQU		10F1H
FSIZE		EQU		1102H
SADRS		EQU		1104H

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

		
START:		JP	0000H

;**** 8255������ ****
;PORTC����BIT��OUTPUT�A���BIT��INPUT�APORTB��INPUT�APORTA��OUTPUT
INIT:	LD		A,8AH
		OUT		(0DBH),A
;�o��BIT�����Z�b�g
INIT2:	LD		A,00H      ;PORTA <- 0
		OUT		(0D8H),A
		OUT		(0DAH),A   ;PORTC <- 0
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

;******** MESSAGE DATA ********************
WRMSG:
		DB		'WRITING '
		DB		0DH

LDMSG:
		DB		'LOADING '
		DB		0DH

MSG_F0:
		DB		'SD-CARD INITIALIZE ERROR'
		DB		0DH
		
MSG_F1:
		DB		'NOT FIND FILE'
		DB		0DH
		
MSG99:
		DB		' ERROR'
		DB		0DH
		
;*********************** 0436H MONITOR ���C�g �C���t�H���[�V������֏��� ************
MSHED:
		DI
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
		DI
;MZT�t�@�C���uROPOKO.MZT�v�ɕۑ�
		CALL	MSHED

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
		DI
		PUSH	DE
		PUSH	BC
		PUSH	HL
		CALL	INIT

		LD		A,93H      ;HEADER LOAD�R�}���h93H
		CALL	MCMD       ;�R�}���h�R�[�h���M
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		LD		DE,FNAME
MLH2:	LD		B,10H
MLH4:	LD		A,(DE)     ;FNAME���M
		CALL	SNDBYTE
		INC		DE
		DEC		B
		JR		NZ,MLH4

		LD		B,11H
		LD		A,0DH
MLH3:	CALL	SNDBYTE
		DEC		B
		JR		NZ,MLH3

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		LD		B,80H
MLH5:	CALL	RCVBYTE    ;�ǂ݂����ꂽ�C���t�H���[�V�����u���b�N�����M
		DEC		B
		JR		NZ,MLH5

		CALL	RCVBYTE    ;��Ԏ擾(00H=OK)
		AND		A          ;00�ȊO�Ȃ�ERROR
		JP		NZ,MERR

		JP		MRET       ;����RETURN


;**************************** 04F8H MONITOR ���[�h �f�[�^��֏��� ********************
MLDAT:
		DI
;MZT�t�@�C���uROPOKO.MZT�v��I��
		CALL	MLHED
		CALL	LETLN
		LD		DE,LDMSG   ;'LOADING '
		CALL	MSGPR        ;���b�Z�[�W�\��
		LD		DE,FNAME     ;�t�@�C���l�[��
		CALL	MSGPR       ;���b�Z�[�W�\��


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
MVRFY:
		DI
		PUSH	DE
		PUSH	BC
		PUSH	HL
		JP	058CH

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

			END
