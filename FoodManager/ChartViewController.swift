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
//struct BarChartModel {
//    let plice: Int
//    let date: Date
//}
//
//class ChartViewController: UIViewController {
//    
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    lazy var maxVal: Int = barItems.map({ $0.0 }).max()!
//    var barItems: [(plice: Int, date: Date)] = []
//    var foodData: FoodData!
//    
//    func setData(_ foodData: FoodData) {
//        barItems.append(contentsOf: [(foodData.plice, foodData.date)])
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scrollView.frame = CGRect(x: 0,y: 0,width: scrollView.superview!.frame.width,height: scrollView.superview!.frame.height)
//        let contentsView = createContentsView(of: barItems.map({ BarChartModel(plice: $0.0, date: $0.1 ) }),barsCountPerPage: 7)
//        scrollView.addSubview(contentsView)
//        scrollView.contentSize = contentsView.frame.size
//        scrollView.isPagingEnabled = true
//        setData(foodData)
//    }
//    
//    func createBarChartView(of items: [BarChartModel]) -> BarChartView {
//        let barChartView = BarChartView()
//        barChartView.delegate = self
//        barChartView.animate(yAxisDuration: 1)
//        barChartView.data = createBarChartData(of: items.map({BarChartModel(plice: $0.plice, date: $0.date)}))
//        barChartView.xAxis.labelCount = barItems.count
//        barChartView.xAxis.labelPosition = .bottom
//        barChartView.xAxis.drawGridLinesEnabled = false
//        barChartView.xAxis.valueFormatter = DateIntervalFormatter(values: items.map({ $0.date })) as! IAxisValueFormatter
//        barChartView.leftAxis.enabled = false
//        barChartView.rightAxis.enabled = false
//        barChartView.legend.enabled = false
//        barChartView.pinchZoomEnabled = false
//        barChartView.doubleTapToZoomEnabled = false
//        barChartView.leftAxis.axisMaximum = Double(maxVal) + 1
//        return barChartView
//    }
//    
//    private func createBarChartData(of items: [BarChartModel]) -> BarChartData {
//        let entries: [BarChartDataEntry] = items.enumerated().map {
//            let (i, item) = $0
//            return BarChartDataEntry(x: Double(i), y: Double(item.plice))
//        }
//        let barChartDataSet = BarChartDataSet(entries: entries, label: "Label")
//        barChartDataSet.valueFont = .systemFont(ofSize: 20)
//        barChartDataSet.valueFormatter = ValueFormatter(of: items)
//        barChartDataSet.colors = items.map { $0.plice == maxVal ? .systemOrange : .systemBlue }
//        let barChartData = BarChartData(dataSet: barChartDataSet)
//        return barChartData
//    }
//    
//    private func createContentsView(of items: [BarChartModel], barsCountPerPage: Int) -> UIView {
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
//    let items: [BarChartModel]
//    init(of items: [BarChartModel]) {
//        self.items = items
//    }
//    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        return "\(Int(value))"
//    }
//}
//
//class XAxisFormatter: IAxisValueFormatter {
//    
//    let items: [BarChartModel]
//    init(of items: [BarChartModel]) {
//        self.items = items
//    }
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        let index = Int(value)
//        return self.items[index].date
//    }
//}
