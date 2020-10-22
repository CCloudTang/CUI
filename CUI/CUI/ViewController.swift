//
//  ViewController.swift
//  CUI
//
//  Created by CC on 2020/4/28.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var header: TabHeader?
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = UIScreen.main.bounds.size.width
        
        let header1 = TabHeader(with: ["新闻","电影","纪录片"])
        view.addSubview(header1)
        header1.frame = CGRect(x: 0, y: 100, width: width, height: 40)
        
        var style2 = TabHeaderStyle()
        style2.defaultSelectIndex = 1
        style2.titleSelectedFont = UIFont.boldSystemFont(ofSize: 16)
        let header2 = TabHeader(with: ["精选","早间新闻直播间","电影","纪录片"], style: style2)
        view.addSubview(header2)
        header2.translatesAutoresizingMaskIntoConstraints = false
        header2.selectHandle = { index in
            print(index)
        }
        
        var style3 = TabHeaderStyle()
        style3.type = TabHeaderStyle.StyleType.scrollable
        style3.defaultSelectIndex = 8
        let titles3 = ["精选","早间新闻","电影","纪录片","How","漫画","小知识","草场莺飞","U","12345","游戏"]
        let header3 = TabHeader(with: titles3, style: style3)
        view.addSubview(header3)
        header3.translatesAutoresizingMaskIntoConstraints = false
        header3.delegate = self
        header = header3
        
        var style4 = TabHeaderStyle()
        style4.type = TabHeaderStyle.StyleType.scrollable
        style4.defaultSelectIndex = 8
        let titles4: [String] = []
        let header4 = TabHeader(with: titles4, style: style4)
        view.addSubview(header4)
        header4.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            header2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            header2.topAnchor.constraint(equalTo: header1.bottomAnchor, constant: 30),
            header2.heightAnchor.constraint(equalToConstant: 40),
            
            header3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            header3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            header3.topAnchor.constraint(equalTo: header2.bottomAnchor, constant: 30),
            header3.heightAnchor.constraint(equalToConstant: 40),
            
            header4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            header4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            header4.topAnchor.constraint(equalTo: header3.bottomAnchor, constant: 30),
            header4.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        header4.updateTitles(["精选","A","B","早间新闻","电影","纪录片","How","漫画","小知识","草场莺飞","U","12345","游戏"])
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            header4.updateTitles(["C","A","B","D","电影","DDFER","How","漫画","小知识","草场莺飞","U","12345","游戏"])
        }

        var style5 = TabHeaderStyle()
        style5.type = .fixed(false)
        style5.indicatorType = .background
        style5.titleSelectedColor = .white
        style5.titleNormalColor = .red
        let titles5: [String] = []
        let header5 = TabHeader(with: titles5, style: style5)
        view.addSubview(header5)
        header5.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header5.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            header5.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            header5.topAnchor.constraint(equalTo: header4.bottomAnchor, constant: 30),
            header5.heightAnchor.constraint(equalToConstant: 40),
        ])
        header5.updateTitles(["早间新闻","电影","纪录片"])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        header?.selectIndex(2)
    }

}
extension ViewController: TabHeaderDelegate {
    func tabSelect(at index: Int) {
        print(index)
    }
}

