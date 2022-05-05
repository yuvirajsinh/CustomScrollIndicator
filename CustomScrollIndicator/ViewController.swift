//
//  ViewController.swift
//  CustomScrollIndicator
//
//  Created by Yuvrajsinh Jadeja on 01/05/22.
//

import UIKit

class ViewController: UIViewController {

    var scrollView: UIScrollView!
    var indicator: YScrollIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        initializeScrollView()
    }

    private func initializeScrollView() {
        let items = 6
        scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height / 2))
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.systemGray
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(items), height: scrollView.bounds.height)
        view.addSubview(scrollView)
        
        let colors = [UIColor.systemBlue, .systemRed, .systemCyan, .systemFill, .systemPink, .systemTeal, .systemBrown, .systemGreen, .systemMint, .systemPurple]
        
        for index in 0..<items {
            var newFrame = scrollView.frame
            newFrame.origin.x = CGFloat(index) * view.frame.width
            let view = UIView(frame: newFrame)
            view.backgroundColor = colors[index]
            scrollView.addSubview(view)
        }
        
        // Indicator
        indicator = YScrollIndicatorView(frame: CGRect(x: 20.0, y: scrollView.frame.maxY + 20.0, width: 150.0, height: 16.0))
        indicator.indicatorColor = UIColor.white
        indicator.diamondColor = UIColor(red: 201/255, green: 160/255, blue: 255/255, alpha: 1)
        view.addSubview(indicator)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        indicator.adjustIndicator(scrollView: scrollView)
    }
}
