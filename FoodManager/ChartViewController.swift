//
//  ChartViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/04.
//

import UIKit
import Charts
import TinyConstraints
import FirebaseFirestore

struct BarChartModel {
    let value: Int
    let name: String
}

class ChartViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var maxVal: Int = barItems.map({ $0.0 }).max()!
    var foodData: FoodData!

    let barItems = [
        (7, "太郎"), (1, "次郎"), (2, "三郎"), (6, "四郎"), (3, "五郎"),
        (9, "六郎"), (2, "七郎"), (3, "八郎"), (1, "九郎"), (5, "十郎"),
        (1, "十一郎"), (1, "十二郎"), (6, "十三郎")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let barChartView = createBarChartView()
        self.view.addSubview(barChartView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        barChartView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90).isActive = true
        barChartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        barChartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.frame = CGRect(x: 0,y: 0,width: scrollView.superview!.frame.width,height: scrollView.superview!.frame.height)
        let contentsView = createContentsView(of: barItems.map({ BarChartModel(value: $0.0, name: $0.1 ) }),barsCountPerPage: 5)
        scrollView.addSubview(contentsView)
        scrollView.contentSize = contentsView.frame.size
        scrollView.isPagingEnabled = true
    }
    
    func createBarChartView() -> BarChartView {
        let barChartView = BarChartView()
        barChartView.delegate = self
        barChartView.animate(yAxisDuration: 1)
        barChartView.data = createBarChartData(of: barItems.map({BarChartModel(value: $0.0, name: $0.1)}))
        barChartView.xAxis.labelCount = barItems.count
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.legend.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.leftAxis.axisMaximum = Double(maxVal) + 1
        return barChartView
    }
    
    private func createBarChartData(of items: [BarChartModel]) -> BarChartData {
        let barChartView = BarChartView()
        let entries: [BarChartDataEntry] = items.enumerated().map {
            let (i, item) = $0
            return BarChartDataEntry(x: Double(i), y: Double(item.value))
        }
        let barChartDataSet = BarChartDataSet(entries: entries, label: "Label")
        barChartDataSet.valueFont = .systemFont(ofSize: 20)
        barChartDataSet.valueFormatter = ValueFormatter(of: items)
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: items.map({$0.name}))
        barChartDataSet.colors = items.map { $0.value == maxVal ? .systemOrange : .systemBlue }
        let barChartData = BarChartData(dataSet: barChartDataSet)
        return barChartData
    }
    
    private func createContentsView(of items: [BarChartModel], barsCountPerPage: Int) -> UIView {
        let itemsPerPage = stride(from: 0, to: items.count, by: barsCountPerPage).map { Array(items[$0 ..< min($0 + barsCountPerPage, items.count)]) }
        let contentsView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width * CGFloat(itemsPerPage.count), height: scrollView.frame.height))
        for (i, items) in itemsPerPage.enumerated() {
            let barChartView = createBarChartView()
            let percent = CGFloat(items.count) / CGFloat(itemsPerPage[0].count)
            barChartView.frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width * percent, height: scrollView.frame.height)
            contentsView.addSubview(barChartView)
        }
        return contentsView
    }
}

extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let axisFormatter = chartView.xAxis.valueFormatter!
        let label = axisFormatter.stringForValue(entry.x, axis: nil)
        print(label, entry.y)
    }
}

class ValueFormatter: IValueFormatter {
    let items: [BarChartModel]
    init(of items: [BarChartModel]) {
        self.items = items
    }
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))"
    }
}
