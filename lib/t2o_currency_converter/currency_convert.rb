# coding: utf-8
# ver.160119

# Usage: ruby convert.rb

require 'open-uri'

module T2oCurrencyConverter
  # 様々な通貨ペアの為替レートを得る。
  # @todo もし @rate を別のモジュールから直接アクセスできないようにできるなら、クラスを用いないように書きかえたい。
  class CurrencyConvert
    # 通貨ペア pair の為替レートを求める。
    # @param [String] A currency pair
    def convert(pair)
      # 2016年1月1日現在に情報が提供されている通貨。BTCも含まれている。
      curs = ["AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN","BHD","BIF","BMD","BND","BOB","BRL","BSD","BTC","BTN","BWP","BYR","BZD","CAD","CDF","CHF","CLF","CLP","CNH","CNY","COP","CRC","CUP","CVE","CZK","DEM","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FIM","FJD","FKP","FRF","GBP","GEL","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","IEP","ILS","INR","IQD","IRR","ISK","ITL","JMD","JOD","JPY","KES","KGS","KHR","KMF","KPW","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LTL","LVL","LYD","MAD","MDL","MGA","MKD","MMK","MNT","MOP","MRO","MUR","MVR","MWK","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PGK","PHP","PKG","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD","SHP","SKK","SLL","SOS","SRD","STD","SVC","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TWD","TZS","UAH","UGX","USD","UYU","UZS","VEF","VND","VUV","WST","XAF","XCD","XDR","XOF","XPF","YER","ZAR","ZMK","ZMW","ZWL"]

      # 通貨ペア pair の例: USD/JPY, USDJPY, USD JPY, USD.JPY, USD-JPY
      # 書式は https://en.wikipedia.org/wiki/Currency_pair を参考にした。
      raise "invalid format: #{pair}" unless /[A-Z]{3}[\/\.\ \-]?[A-Z]{3}/.match(pair)
      from = pair[0,3]
      to   = pair[-3,3]
      raise "invalid currency name (from): #{from}" unless curs.include?(from)
      raise "invalid currency name (to): #{to}"   unless curs.include?(to)

      # メモ化されている値があれば返す。
      @rate ||= {}
      @rate[:"#{from}#{to}"] ||= get_rate(from, to)
    end

    # 通貨 from から通貨 to への為替レートを求める。
    # @param from [String] 変換元の通貨
    # @param to   [String] 変換先の通貨
    def get_rate(from, to)
      url = "https://www.google.com/finance/converter?a=1&from=#{from}&to=#{to}"
      if from == to
        1.0
      else
        f = open(url).read
        /<div id=currency_converter_result>1 #{from} = <span class=bld>(\d+(\.\d+)?) #{to}<\/span>/.match(f)

        unless $1
          puts "Googleからデータを取得できませんでした。"
          exit(1)
        end
        if $1.to_f <= 0
          puts "1 #{from} が 0 #{$1}に変換され、異常です。"
          exit(1)
        end
        $1.to_f
      end
    end
  end
end
