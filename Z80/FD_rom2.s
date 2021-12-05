			ORG	0F000H

			DB	0FFH             ;ROMなし識別コード
			JP		START
;******************** MONITOR CMTルーチンへリターン *************************************
			JP		MSHED
			JP		MSDAT
			JP		MLHED
			JP		MLDAT
			JP		MVRFY
START:							;識別コードをROMあり(00H)に変更し、FDコマンドを有効にした場合、この処理が起動
			LD	HL,DATA			;DATAからLENGTHバイトをTRNSにコピーしてDSTRTから実行
			LD	DE,(TRNS)
			LD	BC,(LENGTH)
			LDIR
			LD	HL,(DSTRT)
			JP	(HL)
LENGTH:
			DW 03C0H
TRNS:
			DW 5A40H
DSTRT:
			DW 5B00H
MSHED:							;JUMPしてきた先にリターン
			PUSH	DE			;PUSH命令をつぶしてJUMPしてきているので代わりにPUSHはしておく
			PUSH	BC
			PUSH	HL
			JP	043AH
MSDAT:
			PUSH	DE
			PUSH	BC
			PUSH	HL
			JP	0479H
MLHED:
			PUSH	DE
			PUSH	BC
			PUSH	HL
			JP	04DCH
MLDAT:
			PUSH	DE
			PUSH	BC
			PUSH	HL
			JP 04FCH
MVRFY:
			PUSH	DE
			PUSH	BC
			PUSH	HL
			JP	058CH
DATA:							;ここから起動したいプログラムを展開(4023Byte利用可能)
			END
