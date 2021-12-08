# MZ-80KでSD-Cardとロード、セーブができるアダプタ

　ROMをF000Hに置くことでMZ-80Kにフロッピーディスク装置を外付けした際に起動するためのFDコマンドを利用できますが、フロッピーディスク装置の代わりにSD-CARDを繋いでしまおうというものです。

　アダプタを繋ぐだけでもBASIC SP-5030が約4秒で起動できるようになるなどアプリケーションランチャーとして便利に使えますが、MONITOR SP-1002にパッチをあてることでBASIC SP-5030はもちろん、ほとんどのMZ-80KアプリケーションがSD-CARD対応となります。

　MZ-700もMZ-80K用アプリケーションについては同様にSD-CARD対応となりますが、MZ-700用アプリケーションはMONITOR 1Z-009BのCMTルーチンを利用していないものが多いためMONITOR 1Z-009BにパッチをあてただけではSD-CARD対応とならず、アプリケーション個別にパッチあてが必要となり、現在対応はしていません。

　ただし、MZ-700もFDxコマンドは機能しますのでMZ-700用アプリケーションランチャーとしては利用できます。

## 回路図
　KiCadフォルダ内のSCH参照

## 部品
　28C64又は同等品               x 1

　GAL22V10                    x 1

　8255                        x 1

　Arduino Pro Mini 5V又は同等品 x 1

　Micro SD Card Kit又は同等品   x 1

　セラミックコンデンサ 0.1μF          x 3

　電解コンデンサ 16v10μF          x 1

　3Pスライドスイッチ                x 2

　DCジャック                     x 1

　ピンヘッダ 2Pin                 x 1

　50Pinコネクタ                  x 1

　50Pinケーブル                  x 1

　ケーブル少々                   x 1

　本体ROMにパッチをあてる場合、27C32等を2532ソケットに差すためのをアダプタ x 1

## ROMプログラムについて
　FD_rom1.bin、FD_rom2.bin、FD_rom.binと3つありますが、SD-CARDを利用するためのプログラムFD_rom1.bin(28C64の下位に配置)、MONITORをCMT利用に戻すためのプログラムFD_rom2.bin(28C64の上位に配置)、2つを合わせたプログラムFD_rom.binとなっています。

　28C64にFD_rom.binを焼くことでスライドスイッチによりSDとCMTを切り替えられるようにしてあります。

　ただし、稼働中に切り替えるとタイミングによってはMZ-80Kが暴走する時があります。基本的には電源を切って切り替えてください。

　また、FD_rom2の領域には4023Byte分の空きエリアがあります。私はここに月刊I/O '82/9月号 小野敏男さんのMZ版多機能チェンジ・メモリのデータをいれてあり、スイッチを切り替えるとFDコマンドで多機能チェンジ・メモリのプログラムが正規の実行アドレスに転送され起動するようにしています。

　今回プログラムのデバッグにも非常に便利に使いました。

　なお、MZ-700でMONITOR 1Z-009BにMZ-80K_SD用のパッチをあてた状態でもCMT側に切り替えれば紅茶羊羹さんの「MZ⇔PC間でデータを転送する（USB版）」が問題なく使用できます。

## 電源
　MZ-80Kのバスには+5Vが出ていないため、最初はDCジャックから外部電源を供給するつもりだったのですが、本体と電源が一緒のほうが扱いが楽そうだったので本体から+5Vを引き出して供給する用のピンヘッダと二通りを用意しています。

## MONITOR ROMの差し替え
　MONITOR SP-1002、MONITOR 1Z-009Bとも以下のパッチをあててください。

　0437 : D5 C3

　0438 : C5 04

　0439 : E5 F0

　0476 : D5 C3

　0477 : C5 07

　0478 : E5 F0

　04D9 : D5 C3

　04DA : C5 0A

　04DB : E5 F0

　04F9 : D5 C3

　04FA : C5 0D

　04FB : E5 F0

　0589 : D5 C3

　058A : C5 10

　058B : E5 F0

　また、紅茶羊羹さんの「MZ⇔PC間でデータを転送する（USB版）」でMZTrans用パッチをMONITOR 1Z-009Bに当てているとFコマンドが使えないので以下のパッチを当てることで'#'コマンドをつぶして'F'コマンドを復活させます。

　00D2 : 23 46

　00D4 : 86 21

## 操作方法
　MONITORコマンド入力待ちから以下のコマンドが利用できます。

　なお、MZ-700のフロッピーディスク装置起動コマンドは本来'F'の一文字ですが、操作方法としては'FD'に統一しました。

　以下、SD-CARD内のファイルに付けられるファイル名をDOSファイル名、MZT形式ファイルのインフォメーションブロック内ファイル名をIBFファイル名とします。

### FD
　FDのみでDOSファイル名「0000.MZT」がLOAD及び実行されます。

　「0000.MZT」は、パソコンで作成しても大丈夫ですが、FDAコマンドから作ることができます。

### FD DOSファイル名
　DOSファイル名で指定したバイナリファイルをLOADして実行します。

　「.MZT」は省略可能です。

　MONITORのLOADコマンドの代替として使えます。なお、LOADコマンドも使えますが、アプリケーションからのLOADと同じ扱いになります。

例)

FD TEST[CR]

### FDL
　SD-CARDルートディレクトリにあるファイルの一覧を表示します。20件表示したところで指示待ちになるので打ち切るならSHIFT+BREAK又は↑を入力すると打ち切られ、それ以外のキーで次の20件を表示します。

　行頭に「*FD」を付加して表示してあるので実行したいファイルにカーソルキーを合わせてCRを押すだけでLOAD、実行が可能です。

　表示される順番は、登録順となりファイル名アルファベッド順などのソートした順で表示することはできません。

### FDL n
20件を1ページとしてnページの20件のファイルを一覧表示します。

### FDA DOSファイル名
　DOSファイル名で指定したファイルを「0000.MZT」という名前でコピーします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「A」だけ付加すれば簡単です。

### FDS SAVE開始アドレス SAVE終了アドレス 実行開始アドレス DOSファイル名
　SAVE開始アドレスからSAVE終了アドレスまでをDOSファイル名でSAVEします。

　SAVE開始アドレス、SAVE終了アドレス、実行開始アドレスは16進数4桁で指定します。DOSファイル名の「.MZT」は省略可能です。

例)

FDS 1200 2FFF 1200 TEST

### FDC DOSファイル名
　DOSファイル名で指定したファイルをコピーします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「C」だけ付加すれば簡単です。

　DOSファイル名を入力し、CRを押すと「NEW NAME:」と聞いてくるので新しいDOSファイル名を入力してCRを押します。

　新しいDOSファイル名に既にあるDOSファイル名を指定するとコピーせずに中断します。

例)

FDC TEST[CR]

NEW NAME:TEST2[CR]

### FDR DOSファイル名
　DOSファイル名で指定したファイルをリネームします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「R」だけ付加すれば簡単です。

　DOSファイル名を入力し、CRを押すと「NEW NAME:」と聞いてくるので新しいDOSファイル名を入力してCRを押します。

　新しいDOSファイル名に既にあるDOSファイル名を指定するとリネームせずに中断します。

例)

FDR TEST[CR]

NEW NAME:TEST2[CR]

### FDD DOSファイル名
　DOSファイル名で指定したファイルを削除します。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「D」だけ付加すれば簡単です。

　DOSファイル名を入力し、CRを押すと「FILE DELETE?(Y:OK ELSE:CANSEL)」と聞いてくるのでYを押せば削除されます。Y以外のキーを押すとキャンセルとなります。

### FDP DOSファイル名
　DOSファイル名で指定したファイルの内容をDUMPします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「P」だけ付加すれば簡単です。

　DOSファイル名を入力し、CRを押すとファイルの内容を128Byteを一画面として表示します。

　一画面表示したところで「NEXT:ANY BACK:B BREAK:SHIFT+BREAK」と表示して指示待ちとなるのでBで前の128Byteを表示、SHIFT+BREAKで中止、それ以外のキーで次の128Byteの表示となります。

　ファイルサイズが128Byteで割り切れない場合には最後のページは128Byteに揃うまで00Hで埋められます。

　ファイル内容を書き換えることはできません。

### アプリケーションからのLOAD
　L、LOAD等アプリケーションが指定したコマンドの後ろにはIBFファイル名を指定可となっていますが、指定せずにL、LOAD等のコマンドのみでCRを押します。

　CMTの場合にはここでPLAYボタンを押すよう指示が出るところですが、「DOS FILE:」と表示して行入力待ちになっていますのでDOSファイル名を入力してCRを押します。この時、「.MZT」の入力は省略できます。

　DOSファイル名は「.MZT」を除いて32文字まで、ただし半角カタカナ、及び一部の記号はArduinoが認識しないので使えません。パソコンでファイル名を付けるときはアルファベット、数字および空白でファイル名をつけてください。

例)BASIC SP-5030

× LOAD "TEST"[CR]

○ LOAD[CR]

　DOS FILE:TEST[CR]

○ LOAD[CR]

　DOS FILE:TEST.MZT[CR]

** 参考 **

　S-OS SWORDでの運用に当たっては起動直後に「DV S:」としてデバイスを各SYSTEMデバイスとしてください。

　FUZZY BASICだけかもしれませんが共通フォーマットデバイスのままだとLOADコマンドでIBFファイル名の省略ができませんでした。

　また、S-OSでアプリケーションをLOADしようとしたとき、最初の一回だけはなぜかインフォメーションブロックの読み込みで止まってしまい、継続してデータブロックを読み込ませるためにはCR等のキーを一回押す必要がありました。

　CMTでも同じ現象が起こることから私の所有するS-OS SWORDバイナリの問題だと思いますが、もし同様の現象が起こるようならCR等を一回押して継続してください。

### アプリケーションからのSAVE
　CMTの時と同様にアプリケーションの指定する入力方法、ルールでファイル名等を入力して保存してください。

　ただし、半角カタカナはArduinoが認識できないため、使用できません。アルファベット、数字および空白で指定してください。

　SAVE時は、入力したファイル名がIBFファイル名、DOSファイル名の両方に適用されます。

　DOSファイル名としての「.MZT」は自動的に付加されます。

例)BASIC SP-5030

○ SAVE "TEST"

## 操作上の注意
　「SD-CARD INITIALIZE ERROR」と表示されたときは、SD-CARDをいったん抜き再挿入したうえでArduinoをリセットしてください。

　SD-CARDにアクセスしていない時に電源が入ったままで SD-CARDを抜いた後、再挿入しSD-CARDにアクセスすると「SD-CARD INITIALIZE ERROR」となる場合があります。再挿入した場合にはSD-CARDにアクセスする前にArduinoを必ずリセットしてください。

　SD-CARDの抜き差しは電源を切った状態で行うほうがより確実です。

## SD-CARDに読み書きできるかを試した結果

　読み書き出来たもの

　　BASE-80 Ver35

　　BASIC SP-5030

　　CAP-Xインタプリタ

　　EDASM V1.2B

　　FORM VER1.0

　　FORTRAN-MZ V.1

　　GAME-MZ80K V.1

　　HU-BASIC V1.3

　　M-FORTH/MZ V1.1

　　micro PASCAL-MZ VER 2.2

　　MONIOS

　　PALL

　　S-OS SWORD(S-OS用アプリ含む)

　　SP-2101 Z80 ASSEMBLER

　　SP-2201 TEXT EDITOR

　　SP-2301 RELOCATE LOADER

　　SP-2401 SYMB DEBUGGER

　　TL1

　　TTL VERSION 1.1

　　WICS INTERPRETER VER 1.1


　読み書き出来なかったもの

　　EDAS FOR MZ-1200 VER 1.2

　　EXIT MONITOR

## MZ700用プログラムで起動確認したもの
　　S-BASIC 1Z-007B　　　　　　起動時間 約7秒(起動後のLOAD、SAVEはCMT)

　　HUBASIC VERSION 2.0A　　　起動時間 約8秒(起動後のLOAD、SAVEはCMT)

　　tiny XEVIOUS mz-700　　　　起動時間 約6秒

　　タイムシークレット　(すべてのプログラムを別ファイルとして保存が必要)

　　タイムトンネル　(すべてのプログラムを別ファイルとして保存が必要)


## 謝辞
　基板の作成に当たり以下のデータを使わせていただきました。ありがとうございました。

　Arduino Pro Mini

　　https://github.com/g200kg/kicad-lib-arduino

　AE-microSD-LLCNV

　　https://github.com/kuninet/PC-8001-SD-8kRAM
