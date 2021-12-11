# MZ-80KにSD-Cardとのロード、セーブ機能を

　ROMをF000Hに置くことでMZ-80Kにフロッピーディスク装置を外付けした際に起動するためのFDコマンドを利用できますが、フロッピーディスク装置の代わりにSD-CARDを繋いでしまおうというものです。

　アダプタを繋ぐだけでもBASIC SP-5030が約4秒で起動できるようになるなどアプリケーションランチャーとして便利に使えますが、MONITOR SP-1002にパッチをあてることでBASIC SP-5030はもちろん、ほとんどのMZ-80KアプリケーションがSD-CARD対応となります。

　MZ-700もMZ-80K用アプリケーションについては同様にSD-CARD対応となりますが、標準添付のS-BASIC、Hu-basicともMONITOR 1Z-009BのCMTルーチンを利用していないためMONITOR 1Z-009BにパッチをあてただけではSD-CARD対応とならず、起動後はCMTでの運用となります。

　ただし、MZ-700もFDxコマンドは機能しますのでMZ-700用アプリケーションランチャーとしては利用できます。

## 回路図
　KiCadフォルダ内のSCH参照

## 部品
　U1: GAL22V10

　U2: 28C64又は同等品

　U3: 8255

　U4: Arduino Pro Mini 5V又は同等品(注1)

　J2: Micro SD Card Kit又は同等品(プリント基板では、秋月電子通商　AE-microSD-LLCNVを使ってます)(注2)

　C1 C2 C3: セラミックコンデンサ 0.1μF

　C4: 電解コンデンサ 16v10μF

　S1 S2: 3Pスライドスイッチ

　J4: DCジャック

　J3: コネクタ 2Pin(ピンヘッダで代用するときはGNDと間違えないよう1Pinで5Vだけにしたほうが良いと思います)

　J1: 50Pinコネクタ

　50Pinケーブル

　本体内から5Vを取る場合、ケーブル少々

　本体ROMにパッチをあてる場合、27C32等を2532ソケットに差すためのアダプタ


　　　注1)Arduino Pro MiniはA4、A5ピンも使っています。

　　　注2)秋月電子通商　AE-microSD-LLCNVのJ1ジャンパはショートしてください。

## ROMプログラムについて
　FD_rom1.bin、FD_rom2.bin、FD_rom.binと3つありますが、SD-CARDを利用するためのプログラムFD_rom1.bin(28C64の下位に配置)、MONITORをCMT利用に戻すためのプログラムFD_rom2.bin(28C64の上位に配置)、2つを合わせたプログラムFD_rom.binとなっています。

　28C64にFD_rom.binを焼くことでスライドスイッチによりSDとCMTを切り替えられるようにしてあります。

　ただし、稼働中に切り替えるとタイミングによってはMZ-80Kが暴走する時があります。基本的には電源を切って切り替えてください。

　また、FD_rom2の領域には4023Byte分の空きエリアがあります。自由に使っていただいて構いません。

　なお、MZ-700でMONITOR 1Z-009BにMZ-80K_SD用のパッチをあてた状態でもCMT側に切り替えれば紅茶羊羹さんの「MZ⇔PC間でデータを転送する（USB版）」が問題なく使用できます。

## Arduinoプログラム
　Arduinoフォルダ内のMZ-80K_SD.inoを書き込みます。

　SdFatライブラリを使用していますのでライブラリの管理からライブラリマネージャを立ち上げて「SdFat」をインストールしてください。

　「SdFat」で検索すれば見つかります。「SdFat」と「SdFat - Adafruit Fork」が見つかりますが「SdFat」のほうを使っています。

## GAL22V10プログラム
　WinCuplフォルダ内の22V10.jedを書き込みます。

　書き込みにはTL866IIPLUSを使いました。

## 電源
　MZ-80Kのバスには+5Vが出ていないため、最初はDCジャックから外部電源を供給するつもりだったのですが、本体と電源が一緒のほうが扱いが楽そうだったので本体から+5Vを引き出して供給する用のピンヘッダと二通りを用意しています。

　27C32等を2532ソケットに差すためのアダプタから引っ張ってくるのが簡単だと思います。

## MONITOR ROMの差し替え
　MONITOR SP-1002、MONITOR 1Z-009Bとも以下のパッチをあててください。

　0437 : D5 → C3

　0438 : C5 → 04

　0439 : E5 → F0

　0476 : D5 → C3

　0477 : C5 → 07

　0478 : E5 → F0

　04D9 : D5 → C3

　04DA : C5 → 0A

　04DB : E5 → F0

　04F9 : D5 → C3

　04FA : C5 → 0D

　04FB : E5 → F0

　0589 : D5 → C3

　058A : C5 → 10

　058B : E5 → F0

　また、紅茶羊羹さんの「MZ⇔PC間でデータを転送する（USB版）」でMZTrans用パッチをMONITOR 1Z-009Bに当てているとFコマンドが使えないので以下のパッチを当てることで'#'コマンドをつぶして'F'コマンドを復活させます。

　00D2 : 23 → 46

　00D4 : 86 → 21

## BASIC SP-5030 バージョン違い

　BASIC SP-5030には、旧・新・VER1.0Aの３種類のバージョンがあるそうで、そのうち新・VER1.0Aの二つはパッチをあてる必要があります。以下のアドレスが4049H、4069Hを指している場合には新・VER1.0Aのどちらかですので以下のように修正する必要があります。

アドレスはMZTファイルのアドレスです。実アドレスは()内

　18C5(1845) : 49 → 27

　18C6(1846) : 40 → 00

　1939(18B9) : 69 → 2A

　193A(18BA) : 40 → 00

　19EA(196A) : 69 → 2A

　19EB(196B) : 40 → 00

　1AE0(1A60) : 69 → 2A

　1AE1(1A60) : 40 → 00


## 操作方法
　MONITORコマンド入力待ちから以下のコマンドが利用できます。

　なお、MZ-700のフロッピーディスク装置起動コマンドは本来'F'の一文字ですが、操作方法としては'FD'に統一しました。

　以下、SD-CARD内のファイルに付けられるファイル名をDOSファイル名、MZT形式ファイルのインフォメーションブロック内ファイル名をIBFファイル名とします。

### FD[CR]
　FDのみでDOSファイル名「0000.MZT」がLOAD及び実行されます。

　「0000.MZT」は、パソコンでBASIC SP-5030等をリネームコピーして作成しても大丈夫ですが、FDAコマンドから作ることもできます。

### FD　DOSファイル名[CR]
　DOSファイル名で指定したバイナリファイルをLOADして実行します。

　「.MZT」は省略可能です。

　MONITORのLOADコマンドの代替として使えます。なお、LOADコマンドも使えますが、アプリケーションからのLOADと同じ扱いになります。

例)

FD　TEST[CR]

### FD/DOSファイル名[CR] 又は FD/　DOSファイル名[CR]
　DOSファイル名で指定したバイナリファイルをLOADします。実行はしません。

　「.MZT」は省略可能です。

例)

FD/TEST[CR]

FD/　TEST[CR]

### FDL[CR]
　SD-CARDルートディレクトリにあるファイルの一覧を表示します。20件表示したところで指示待ちになるので打ち切るならSHIFT+BREAK又は↑を入力すると打ち切られ、それ以外のキーで次の20件を表示します。

　行頭に「*FD」を付加して表示してあるので実行したいファイルにカーソルキーを合わせて[CR]キーを押すだけでLOAD、実行が可能です。

　表示される順番は、登録順となりファイル名アルファベッド順などのソートした順で表示することはできません。

### FDL　n[CR]
20件を1ページとしてnページの20件のファイルを一覧表示します。

nは1～9、A～Zです。nに0を指定した場合にはFDL[CR]と同じ意味になります。

### FDA　DOSファイル名[CR]
　DOSファイル名で指定したファイルを「0000.MZT」という名前でリネームコピーします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「A」だけ付加して[CR]キーを押せば簡単です。

### FDS　SAVE開始アドレス　SAVE終了アドレス　実行開始アドレス　DOSファイル名[CR]
　SAVE開始アドレスからSAVE終了アドレスまでをDOSファイル名でSAVEします。

　SAVE開始アドレス、SAVE終了アドレス、実行開始アドレスは16進数4桁で指定します。DOSファイル名の「.MZT」は省略可能です。

例)

FDS　1200　2FFF　1200　TEST[CR]

### FDC　DOSファイル名[CR]
　DOSファイル名で指定したファイルをコピーします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「C」だけ付加して[CR]キーを押せば簡単です。

　DOSファイル名を入力し、[CR]キーを押すと「NEW NAME:」と聞いてくるので新しいDOSファイル名を入力して[CR]キーを押します。

　新しいDOSファイル名に既にあるDOSファイル名を指定するとコピーせずに中断します。

例)

FDC　TEST[CR]

NEW NAME:TEST2[CR]

### FDR　DOSファイル名[CR]
　DOSファイル名で指定したファイルをリネームします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「R」だけ付加して[CR]キーを押せば簡単です。

　DOSファイル名を入力し、[CR]キーを押すと「NEW NAME:」と聞いてくるので新しいDOSファイル名を入力して[CR]キーを押します。

　新しいDOSファイル名に既にあるDOSファイル名を指定するとリネームせずに中断します。

例)

FDR　TEST[CR]

NEW NAME:TEST2[CR]

### FDD　DOSファイル名[CR]
　DOSファイル名で指定したファイルを削除します。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「D」だけ付加して[CR]キーを押せば簡単です。

　DOSファイル名を入力し、[CR]キーを押すと「FILE DELETE?(Y:OK ELSE:CANSEL)」と聞いてくるのでYを押せば削除されます。Y以外のキーを押すとキャンセルとなります。

### FDP　DOSファイル名[CR]
　DOSファイル名で指定したファイルの内容をDUMPします。

　FDLコマンドで表示されたファイル名をカーソルで選択し、行頭の「*FD」に「P」だけ付加して[CR]キーを押せば簡単です。

　DOSファイル名を入力し、[CR]キーを押すとファイルの内容を128Byteを一画面として表示します。

　一画面表示したところで「NEXT:ANY BACK:B BREAK:SHIFT+BREAK」と表示して指示待ちとなるのでBで前の128Byteを表示、SHIFT+BREAKで中止、それ以外のキーで次の128Byteの表示となります。

　ファイルサイズが128Byteで割り切れない場合には最後のページは128Byteに揃うまで00Hで埋められます。

　ファイル内容を書き換えることはできません。

### FDM　開始アドレス[CR]
　開始アドレスからメモリ内容を128Byteを一画面として表示します。

　一画面表示したところで「NEXT:ANY BACK:B BREAK:SHIFT+BREAK」と表示して指示待ちとなるのでBで前の128Byteを表示、SHIFT+BREAKで中止、それ以外のキーで次の128Byteの表示となります。

　一画面表示している途中でもSHIFT+BREAKでいつでも中止できます。

### FDW　開始アドレス　1Byte(16進2桁)データ[CR]
　開始アドレスから16進2桁データをメモリに書き込みます。

　開始アドレスに続けて16進2桁で書き込むデータを記述し[CR]キーを押します。データの区切りの空白は無視しますのであってもなくても構いません。

　16進2桁のByteデータは一行に収まる範囲なら何Byte分を続けても構いません。

　一行入力して[CR]キーを押すとデータが書き込まれ、次のアドレスが表示されるので続けてデータを入力していけます。

　また、アドレスを修正すれば戻って修正や離れたアドレスにデータを書き込むことも可能です。

　データの書き込みを止めるときは表示されたアドレスにデータを書かずに[CR]キーを押します。

　16進数以外を入力して[CR]キーを押した場合には16進数以外を入力した直前までの有効なデータを書き込み次のアドレスを表示します。

例)

*FDW　1200　01　02　03　04　05　06　07　08[CR]

*FDW　1200　0102030405060708[CR]

*FDW　1200[CR]　(止めるとき)

*FDW　1200　12　34　5/[CR]　(12　34まで書き込まれます)


### アプリケーションからのLOAD
　L、LOAD等アプリケーションが指定したコマンドの後ろにはIBFファイル名を指定可となっていますが、指定せずにL、LOAD等のコマンドのみで[CR]キーを押します。

　CMTの場合にはここでPLAYボタンを押すよう指示が出るところですが、「DOS FILE:」と表示して行入力待ちになっていますのでDOSファイル名を入力して[CR]キーを押します。この時、「.MZT」の入力は省略できます。

　DOSファイル名は「.MZT」を除いて32文字まで、ただし半角カタカナ、及び一部の記号はArduinoが認識しないので使えません。パソコンでファイル名を付けるときはアルファベット、数字および空白でファイル名をつけてください。

例)BASIC SP-5030では

× LOAD "TEST"[CR]

○ LOAD[CR]

　DOS FILE:TEST[CR]

○ LOAD[CR]

　DOS FILE:TEST.MZT[CR]

** 参考 **

　S-OS SWORDでの運用に当たっては起動直後に「DV S:」としてデバイスを各SYSTEMデバイスとしてください。

　FUZZY BASICだけかもしれませんが共通フォーマットデバイスのままだとLOADコマンドでIBFファイル名の省略ができませんでした。

　また、S-OSでアプリケーションをLOADしようとしたとき、最初の一回だけはなぜかインフォメーションブロックの読み込みで止まってしまい、継続してデータブロックを読み込ませるためには[CR]等のキーを一回押す必要がありました。

　CMTでも同じ現象が起こることから私の所有するS-OS SWORDバイナリの問題だと思いますが、もし同様の現象が起こるようなら[CR]キー等を一回押して継続してください。

### アプリケーションからのSAVE
　CMTの時と同様にアプリケーションの指定する入力方法、ルールでファイル名等を入力して保存してください。

　ただし、半角カタカナはArduinoが認識できないため、使用できません。アルファベット、数字および空白で指定してください。

　SAVE時は、入力したファイル名がIBFファイル名、DOSファイル名の両方に適用されます。

　DOSファイル名としての「.MZT」は自動的に付加されます。

例)BASIC SP-5030では

○ SAVE "TEST"[CR]

## 操作上の注意
　「SD-CARD INITIALIZE ERROR」と表示されたときは、SD-CARDをいったん抜き再挿入したうえでArduinoをリセットしてください。

　SD-CARDにアクセスしていない時に電源が入ったままで SD-CARDを抜いた後、再挿入しSD-CARDにアクセスすると「SD-CARD INITIALIZE ERROR」となる場合があります。再挿入した場合にはSD-CARDにアクセスする前にArduinoを必ずリセットしてください。

　SD-CARDの抜き差しは電源を切った状態で行うほうがより確実です。

## SD-CARDに読み書きできるかを試した結果

　読み書き出来たもの

　　BASE-80 Ver35

　　BASIC SP-5030(パッチあて必要なバージョンあり)

　　CAP-Xインタプリタ

　　EDASM V1.2B

　　FORM VER1.0

　　FORTRAN-MZ V.1

　　GAME-MZ80K V.1(注1)

　　HU-BASIC V1.3

　　M-FORTH/MZ V1.1(注1)

　　micro PASCAL-MZ VER 2.2

　　MONIOS

　　PALL

　　S-OS SWORD(S-OS用アプリ含む)

　　SP-2101 Z80 ASSEMBLER

　　SP-2201 TEXT EDITOR

　　SP-2301 RELOCATE LOADER

　　SP-2401 SYMB DEBUGGER

　　TL/1(注1)

　　TTL VERSION 1.1

　　WICS INTERPRETER VER 1.1

注1)このアプリケーションはMZ-700非対応です。MZ-700で動かすには、0h!MZ別冊 ADVANCED MZ-700に掲載されているSP-1002のMZ-700対応版 NZ-700が必要です。NZ-700にSP-1002と同じようにMZ-80K_SDのパッチをあてることでMZ-700でも同様にLOAD、SAVEが可能となります。

　読み書き出来なかったもの

　　EDAS FOR MZ-1200 VER 1.2

　　EXIT MONITOR

## MZ700用プログラムで起動確認したもの
　　S-BASIC 1Z-007B(起動後のLOAD、SAVEはCMT)

　　HUBASIC VERSION 2.0A(起動後のLOAD、SAVEはCMT)

　　tiny XEVIOUS mz-700

　　タイムシークレット(すべてのプログラムを別ファイルとして保存が必要)

　　タイムトンネル(すべてのプログラムを別ファイルとして保存が必要)


## 謝辞
　基板の作成に当たり以下のデータを使わせていただきました。ありがとうございました。

　Arduino Pro Mini

　　https://github.com/g200kg/kicad-lib-arduino

　AE-microSD-LLCNV

　　https://github.com/kuninet/PC-8001-SD-8kRAM
