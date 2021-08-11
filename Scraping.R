### スクレイピングの実装 ###
# パッケージのインストール
# install.packages("rvest")

# パッケージの呼び出し
library(rvest)
library(tidyverse)

# 対象のサイトのURLを指定
# url <- read_html("https://review.rakuten.co.jp/search/-/100026/cu1001-d0/")
guess_encoding("https://review.rakuten.co.jp/search/-/100026/cu1001-d0/")

# エンコードを指定して再度読み込み
url <- read_html("https://review.rakuten.co.jp/search/-/100026/cu1001-d0/", 
                 encoding = "EUC-JP")

# データの取得
reviews <- url %>% 
  html_nodes(xpath = '//*[@class="ratCustomAppearTarget"]') %>%  # 欲しい情報の位置を指定
  html_text()                                                    # 文字列で出力
# 確認
head(reviews, n = 10)

# \n を削除
reviews <- reviews %>% 
  str_replace_all(pattern = '\n', replacement = '')

# 確認
head(reviews, n = 10)

# データを取得
for(i in 2:10){
  url_tmp <- paste0("https://review.rakuten.co.jp/search/-/100026/cu1001-d0-p", i, "/") %>% # iページ目のURLを作成
    read_html(encoding = "EUC-JP")                                  # 読み込み
  url_tmp
  reviews_tmp <- url_tmp %>% 
    html_nodes(xpath = '//*[@class="ratCustomAppearTarget"]') %>%   # データの位置を指定 
    html_text() %>%                                                 # 文字列の形式で出力
    str_replace_all(pattern = "\n", replacement = "")               # 文字を整える
  reviews <- c(reviews, reviews_tmp)                                # (i-1)ページ目までのデータと結合
  Sys.sleep(1)                                                      # 1秒時間を空ける
}

# 確認
reviews[201:210]

#グループワーク
#下記、3つを取得する
# 1.店舗名
# 2.住所
# 3.口コミ数

guess_encoding("https://www.homemate-research-convenience-store.com/13103/")
# url2 <- read_html("https://www.homemate-research-convenience-store.com/13103/13/")
# tmp <- url2 %>% 
# html_nodes(xpath = '//*[@class="fa_name"]') %>%  # 欲しい情報の位置を指定
# html_text()                                                    # 文字列で出力
# 確認
# head(tmp, n = 10)

shop_names <- c()
addresses <- c()
review_count <- c()

for(i in 1:13){
  url_tmp <- paste0("https://www.homemate-research-convenience-store.com/13103/", i, "/") %>% # iページ目のURLを作成
    read_html()                                  # 読み込み
  shop_names_tmp <- url_tmp %>% 
    html_nodes(xpath = '//*[@class="fa_name"]') %>%   # データの位置を指定 
    html_text()                                                # 文字列の形式で出力
  # str_replace_all(pattern = "\n", replacement = "")               # 文字を整える
  shop_names <- c(shop_names, shop_names_tmp)                                # (i-1)ページ目までのデータと結合
  addresses_tmp <- url_tmp %>% 
    html_nodes(xpath = '//*[@class="fa_address"]') %>%   # データの位置を指定 
    html_text()                                                 # 文字列の形式で出力
  # str_replace_all(pattern = "\n", replacement = "")               # 文字を整える
  addresses <- c(addresses, addresses_tmp)                                # (i-1)ページ目までのデータと結合
  review_count_tmp <- url_tmp %>% 
    html_nodes(xpath = '//*[@class="p7"]') %>%   # データの位置を指定 
    html_text()                                                 # 文字列の形式で出力
  # str_replace_all(pattern = "\n", replacement = "")               # 文字を整える
  review_counts <- c(review_count,review_count_tmp)                                # (i-1)ページ目までのデータと結合
  Sys.sleep(1)                                                      # 1秒時間を空ける
}

shop_names[1:50]
addresses[1:50]
review_counts[1:50]

df_shop <- data.frame(SHOP_NAME=shop_names, ADDRES=addresses, REVIEW_COUNT=review_counts) 
View(df_shop)
