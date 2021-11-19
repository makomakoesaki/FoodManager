////
////  ChartViewController.swift
////  FoodManager
////
////  Created by ESAKI MAKOTO on 2021/11/04.
////
//
//import UIKit
//import Charts
//import FirebaseFirestore
//
//struct SpendingChart {
//    var spending: Int
//    var yearMonth: String
//}
//
//struct IncomeChart {
//    var income: Int
//    var yearMonth: String
//}
//
//class ChartViewController: UIViewController {
//
//    var spendingArray: [SpendingChart] = []
//    var incomeArray: [IncomeChart] = []
//    var monthArray: [String] = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
//
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var yearLabel: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scrollView.frame = CGRect(x: 0,y: 0,width: scrollView.superview!.frame.width,height: scrollView.superview!.frame.height)
//        scrollView.isPagingEnabled = true
//        let current = Calendar.current
//        let date = current.component(.year, from: Date())
//        yearLabel.text = String(date) + "年"
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        Firestore.firestore().collection(Collection.documentPath).order(by: "timestamp", descending: false).getDocuments { (querySnapShot, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            } else {
//                for document in querySnapShot!.documents {
//                    let documenttTimestamp = document.data()["timestamp"] as! Timestamp
//                    let documentPrice = document.data()["price"] as! Int
//                    let documentBalanceOfPayments = document.data()["balanceOfPayments"] as! String
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "MM月"
//                    var stringTimestamp = formatter.string(from: documenttTimestamp.dateValue())
//                    if let zero = stringTimestamp.firstIndex(of: "0") {
//                        stringTimestamp.remove(at: zero)
//                    }
//                    var hitSpendingIndex: Int?
//                    for (index, spending) in self.spendingArray.enumerated() {
//                        if spending.yearMonth == stringTimestamp {
//                            hitSpendingIndex = index
//                        }
//                    }
//                    if let hitSpendingIndex = hitSpendingIndex {
//                        if documentBalanceOfPayments == "支出" {
//                            var sumally = self.spendingArray[hitSpendingIndex]
//                            sumally.spending = sumally.spending + documentPrice
//                            self.spendingArray[hitSpendingIndex] = sumally
//                        }
//                    } else {
//                        if documentBalanceOfPayments == "支出" {
//                            self.spendingArray.append(SpendingChart(spending: documentPrice, yearMonth: stringTimestamp))
//                        }
//                    }
//                    var hitIncomeIndex: Int?
//                    for (index, income) in self.incomeArray.enumerated() {
//                        if income.yearMonth == stringTimestamp {
//                            hitIncomeIndex = index
//                        }
//                    }
//                    if let hitIncomeIndex = hitIncomeIndex {
//                        if documentBalanceOfPayments == "収入" {
//                            var sumally = self.incomeArray[hitIncomeIndex]
//                            sumally.income = sumally.income + documentPrice
//                            self.incomeArray[hitIncomeIndex] = sumally
//                        }
//                    } else {
//                        if documentBalanceOfPayments == "収入" {
//                            self.incomeArray.append(IncomeChart(income: documentPrice, yearMonth: stringTimestamp))
//                        }
//                    }
//                }
//            }
//            print(self.spendingArray)
//            let contentsView = self.createContentsView(of: self.spendingArray.map({ SpendingChart(spending: $0.spending, yearMonth: $0.yearMonth ) }),barsCountPerPage: 12)
//            self.scrollView.addSubview(contentsView)
//            self.scrollView.contentSize = contentsView.frame.size
//        }
//        self.spendingArray.removeAll()
//        self.incomeArray.removeAll()
//    }
//
//    func createBarChartView(of items: [SpendingChart]) -> BarChartView {
//        let barChartView = BarChartView()
//        barChartView.delegate = self
//        barChartView.animate(yAxisDuration: 1)
//        barChartView.data = createBarChartData(of: items.map({SpendingChart(spending: $0.spending, yearMonth: $0.yearMonth)}))
//        barChartView.xAxis.labelCount = spendingArray.count
//        barChartView.xAxis.labelPosition = .bottom
//        barChartView.xAxis.drawGridLinesEnabled = false
//        barChartView.xAxis.valueFormatter = (IndexAxisValueFormatter(values: items.map({ $0.yearMonth })) as IAxisValueFormatter)
//        barChartView.leftAxis.enabled = false
//        barChartView.leftAxis.axisMinimum = 0.0
//        barChartView.rightAxis.enabled = false
//        barChartView.legend.enabled = false
//        barChartView.pinchZoomEnabled = false
//        barChartView.doubleTapToZoomEnabled = false
//        return barChartView
//    }
//
//    private func createBarChartData(of items: [SpendingChart]) -> BarChartData {
//        let entries: [BarChartDataEntry] = items.enumerated().map {
//            let (i, item) = $0
//            return BarChartDataEntry(x: Double(i), y: Double(item.spending))
//        }
//        let barChartDataSet = BarChartDataSet(entries: entries, label: "Label")
//        barChartDataSet.drawValuesEnabled = false
//        barChartDataSet.valueFormatter = ValueFormatter(of: items)
//        if self.spendingArray.isEmpty {
//            barChartDataSet.removeAll()
//        }
//        let barChartData = BarChartData(dataSet: barChartDataSet)
//        return barChartData
//    }
//
//    private func createContentsView(of items: [SpendingChart], barsCountPerPage: Int) -> UIView {
//        let itemsPerPage = stride(from: 0, to: items.count, by: barsCountPerPage).map { Array(items[$0 ..< min($0 + barsCountPerPage, items.count)]) }
//        let contentsView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width * CGFloat(itemsPerPage.count), height: scrollView.frame.height))
//        for (i, items) in itemsPerPage.enumerated() {
//            let barChartView = createBarChartView(of: items)
//            let percent = CGFloat(items.count) / CGFloat(itemsPerPage[0].count)
//            barChartView.frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width * percent, height:scrollView.frame.height)
//            contentsView.addSubview(barChartView)
//        }
//        return contentsView
//    }
//}
//
//extension ChartViewController: ChartViewDelegate {
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        let axisFormatter = chartView.xAxis.valueFormatter!
//        let label = axisFormatter.stringForValue(entry.x, axis: nil)
//        print(label, entry.y)
//    }
//}
//
//class ValueFormatter: IValueFormatter {
//    let items: [SpendingChart]
//    init(of items: [SpendingChart]) {
//        self.items = items
//    }
//    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        return "\(Int(value))"
//    }
//}
