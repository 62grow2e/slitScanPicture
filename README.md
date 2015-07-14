# slitScanPicture
slit scan program, it gives a result as a jpeg image

## Environment
- run in [Processing](http://processing.org/)
- using a camera module

## how to use
- this program scans a caputured image as lines, and integrates those lines into a output image
  - this default program scans vertical center lines of a input image
- all you have to do at first is edit a method named `getScanPos()`
  - `getScanPos()` returns array of coordinates (x, y)
  - scan a input image according to this array
  - you can edit this method to get colors optinally
- if you get used to this, please edit other parts 

## others
- I take no responsibility, if any issue is happened.

---

# slitScanPicture
スリットスキャンするプログラムです。jpeg画像として出力します

## 実行環境
- [Processing](http://processing.org/)で動作します
- カメラモジュールを利用します

## 使い方
- このプログラムはキャプチャ画像から直線をスキャンして、それらを繋げたものを出力します
  - デフォルトでは、インプット画像の中心の縦一列をスキャンします
- 最初は関数`getScanPos()`を修正するといいと思います
  - `getScanPos()`は座標(x, y)の配列を返します
  - この座標の配列の点をスキャンします
  - 任意の点を選ぶように加筆するのがいいと思います
- 慣れてきたら、他のところを修正するのがいいと思います

## その他
- これを使って起きた問題に私は一切責任を負いません
