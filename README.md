# AnImediate

## Sourceryを使ったコード自動生成

ターミナルで以下のコマンドを叩く
`$ ./sourcery --sources <sources path> --templates <templates path> --output <output path>`

* Animediate用

1. ローカルリポジトリ内のXcode projectフォルダまで移動する。

`cd /Users/<your name>/.../AnImediate/AnImediate`

1. 下記のコマンドを叩く。ソース名は欲しいファイルに応じて変更する。

`./Pods/Sourcery/bin/sourcery --sources ./AppConfig/Sourcery/Sources/<source name>.swift --templates ./AppConfig/Sourcery/Templates --output ./AppConfig/Sourcery/Generated`

1. 生成されたファイルを該当ディレクトリに移動して使用する。`*****.generated.swift`はいらないので削除する。