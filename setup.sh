#!/bin/bash
# ============================================================
# Penguin Computer — zram + swap セットアップスクリプト
# 使い方: sudo bash penguin-setup.sh
# ============================================================

set -e

echo "======================================"
echo " Penguin Computer セットアップ"
echo " zram + swap + swappiness 最適化"
echo "======================================"
echo ""

# root権限チェック
if [ "$EUID" -ne 0 ]; then
    echo "[エラー] root権限が必要です。sudo bash penguin-setup.sh で実行してください。"
    exit 1
fi

# 現在の状態を表示
echo "[1/5] 現在の状態を確認中..."
echo "--- メモリ ---"
free -h
echo ""
echo "--- スワップ ---"
swapon --show
echo ""
echo "--- swappiness ---"
echo "現在の値: $(cat /proc/sys/vm/swappiness)"
echo ""

# zram導入
echo "[2/5] zram-config をインストール中..."
if dpkg -l | grep -q zram-config; then
    echo "  → zram-config は既にインストール済みです"
else
    apt install -y zram-config
    echo "  → zram-config インストール完了"
fi

# 既存のスワップファイルを確認
echo "[3/5] スワップファイルを設定中..."
if [ -f /swapfile ]; then
    echo "  → /swapfile は既に存在します"
    swapon --show
else
    fallocate -l 4G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    # fstabに追記（重複防止）
    if ! grep -q '/swapfile' /etc/fstab; then
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
    fi
    echo "  → 4GB スワップファイル作成完了"
fi

# swappiness設定
echo "[4/5] swappiness を 15 に設定中..."
sysctl vm.swappiness=15
# sysctl.confに追記（重複防止）
if grep -q 'vm.swappiness' /etc/sysctl.conf; then
    sed -i 's/vm.swappiness=.*/vm.swappiness=15/' /etc/sysctl.conf
else
    echo 'vm.swappiness=15' >> /etc/sysctl.conf
fi
echo "  → swappiness = 15 に設定完了"

# 結果確認
echo "[5/5] 設定完了。最終状態:"
echo ""
echo "--- メモリ ---"
free -h
echo ""
echo "--- スワップ ---"
swapon --show
echo ""
echo "--- swappiness ---"
echo "値: $(cat /proc/sys/vm/swappiness)"
echo ""
echo "======================================"
echo " セットアップ完了"
echo " 再起動後も設定は維持されます"
echo "======================================"
