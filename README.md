# Penguin Computer

Linuxプリインストールの整備済み中古パソコンをお届けします。

## setup.sh

4GB+ チューニングスクリプト（zram + swap + swappiness 最適化）

```bash
curl -sL https://penguin-computer.github.io/penguin-computer/setup.sh | sudo bash
```

### 設定内容

| 項目 | 設定値 | 効果 |
|------|--------|------|
| zram | RAM の 50% | メモリ圧縮で実効容量拡大 |
| スワップファイル | 4GB | セーフティネット |
| swappiness | 15 | RAM を優先使用 |

### 動作確認済み環境

- Dell OptiPlex 3050 SFF (i5-7500 / 4GB / SED 128GB)
- HP ProDesk 400 G1 (i5-4590 / 4GB / SED 128GB)
- FUJITSU LIFEBOOK S938/S (i5-8350U / 4GB / SED 256GB)

## ライセンス

MIT License
