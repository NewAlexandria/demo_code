#!/bin/ruby

# Maximizing Profit from Stocks
# Your algorithms have become so good at predicting the market that you now know what the share price of Silly Purple
# Toothpicks Inc. (SPT) will be for a number of minutes going forward. Each minute, your high frequency trading platform allows you to either buy one share of SPT, sell any number of shares of SPT that you own, or not make any transaction at all.
# Find the maximum profit you can obtain with an optimal trading strategy.
# Purchases are negative and sales are positive cash flows in the following equations. For example, if predicted prices over the
# next n = 6 minutes are prices = [3, 4, 5, 3, 5, 2], one way to the
# best outcome is to purchase a share in each of the first 2
# minutes for cash flows -3 + -4 = -7, then sell them at the third
# minute for 2 * 5 = 10. Purchase a share in the 4th minute for 3
# and sell it in the 5th minute for 5. Total profits are - 3 - 4 + 10 - 3 +
# 5 = 5. Another way to the same outcome is to purchase a share
# in each of the st and and 4th minutes for -3-4 - 3 =-10, do nothing at minute 2 then sell all three shares at 5 (total 3 * 5 =
# 15) on the 5th minute, again for a total profit of - 10 + 15 = 5.
# There is no reason to purchase in the last minute as there is no time to sell.
# Function Description
# Complete the maximumProfit function in the editor below. The function must return a long integer that denotes the maximum possible profit.
# maximumProfit has the following parameter:
# price: an array of n integers that denote the stock prices at minutes 1 through n.
# Constraints
# • 1 <= t <= 10
# • 1 <= n <= 5x10^5
# • 1 <= price[i] <= 10^5
module Maths
  class MaximizeProfits
    require 'json'
    require 'stringio'

    def initialiaze(debug: false)
      @debug = debug
    end

    def simulate_predictons(runs = 20, predict_length = 10, max_amt = 400)
      (1..runs)
        .map { |zz| (1..predict_length).map{|x| rand(max_amt) } }
        .tap { |runs| runs.map {|r| puts r.join(',')} if @debug }
        .map do |prices|
          predict_earnings(create_order_book(prices, find_peaks(prices)))
        end
    end

    def find_peaks(prices)
      cursor = 0
      pmaxs = []
      pmax_idxs = []
      not_done = true
      runs = 0

      # calculate triangles
      while not_done
        puts "R: #{runs += 1}"              if @debug
        t_pmax = prices[cursor..-1].max
        t_pmax_idx = (prices[cursor..-1].index(t_pmax) || 0) + cursor
        puts "Tv: #{t_pmax}"                if @debug
        puts "Ti: #{t_pmax_idx}"            if @debug
        puts "Tl: #{(pmax_idxs.last || 0)}" if @debug
        puts "C: #{cursor = t_pmax_idx+1}" if @debug

        if (t_pmax_idx - (pmax_idxs.last || 0)) >= 2
          pmaxs << t_pmax
          pmax_idxs << t_pmax_idx
        else
          pmaxs << 'skip'
          pmax_idxs << t_pmax_idx
        end

        puts "* #{pmaxs}"                 if @debug
        puts "* #{pmax_idxs}"             if @debug

        cursor = t_pmax_idx+1

        is_last_one = pmax_idxs.last == (prices.size - 1)
        # remaining_has_max_first_pos

        not_done = false if is_last_one || runs > prices.size
      end
      return { peaks: pmaxs, idxs: pmax_idxs }
    end

    def create_order_book(prices = [], peaks_meta = {})
      # pivot
      pm = peaks_meta.values[0]
        .zip(peaks_meta.values[1])
        .map{|(peaks,idx)| { peaks: , idx: } }

      # fill with buys, costs
      template = prices.map{|val| { value: val, action: 'buy' } }
      # merge with sells , skips
      pm.reduce(template) do |ob,peak_meta|
        meta = (peak_meta[:peaks] == 'skip') \
          ? { action: 'skip', value: nil } \
          : { action: 'sell', value: peak_meta[:peaks]}
        ob[peak_meta[:idx]] = ob[peak_meta[:idx]].merge(meta)
        ob
      end
    end

    def predict_earnings(order_book = {})
      order_book.reject! {|x| x[:value].nil? }
      # split by sell
      sell = order_book.select  {|x| x[:action] == 'sell' }
      sets = order_book.split {|x| x[:action] == 'sell' }.reject(&:empty?).zip(sell)
      net = sets.map do |set|
        gross = set.last[:value] * set.first.size
        cost  = set.first.map{|x| x[:value] }.sum
        gross - cost
      end.sum
    end

  end
end
