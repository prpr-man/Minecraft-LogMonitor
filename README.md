## なにこれ
 マイクラサーバーのログにwarningとerrorが出た時にその内容を通知するやつ．  
 通知にはPushoverを使ってるけども書き換えれば他のサービスでも使えるはず．

## 使い方
/home/minecraft/minecraft にサーバーが置いてある前提．  
info.confを自分用に設定して，

```
$ gem install watchr
$ watchr monitor.rb
```

で動くはず．

## Lisence
 This software is released under the MIT License, see LICENSE.
