import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        var profit = 0
        
        for (index, price) in prices.enumerated() {
            let nextPrices = prices[index...prices.count-1]
            let maxPrice = nextPrices.max()
            
            if let max = maxPrice, price < max {
                profit += max - price
            }
        }
        
        return profit
    }
}
