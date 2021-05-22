//
//  HowToUseToBuyListViewController.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import UIKit

final class HowToUseToBuyListViewController: UIViewController {
    private enum ImageType {
        case image1
        case image2
        case image3
        case image4
        case image5
        var name: String {
            switch self {
            case .image1: return "HowToUseToBuyListImage1"
            case .image2: return "HowToUseToBuyListImage2"
            case .image3: return "HowToUseToBuyListImage3"
            case .image4: return "HowToUseToBuyListImage4"
            case .image5: return "HowToUseToBuyListImage5"
            }
        }
    }
    private enum ButtonTextType {
        case next
        case close
        var title: String {
            switch self {
            case .next: return "次へ"
            case .close: return "閉じる"
            }
        }
    }
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var button1: UIButton!
    private var button2: UIButton!
    private var button3: UIButton!
    private var button4: UIButton!
    private var button5: UIButton!
    private var width: CGFloat { UIScreen.main.bounds.width }
    private var height: CGFloat { UIScreen.main.bounds.height }
    private let pageSize: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupImage()
        setupPageControl()
        setupButtonAction()
    }

    private func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.minY, width: width, height: height))
        scrollView.contentSize = CGSize(width: width * pageSize, height: height)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }

    private func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: height - 100, width: width, height: 30))
        pageControl.numberOfPages = Int(pageSize)
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = UIColor.black.themeColor
        self.view.addSubview(pageControl)
    }

    private func setupImage() {
        var imageHeight: CGFloat = 0
        imageHeight = (height > 800) ? height - 130 : height
        let imageView1 = setImage(x: width * 0, y: 0, width: width, height: imageHeight, imageType: .image1)
        let imageView2 = setImage(x: width * 1, y: 0, width: width, height: imageHeight, imageType: .image2)
        let imageView3 = setImage(x: width * 2, y: 0, width: width, height: imageHeight, imageType: .image3)
        let imageView4 = setImage(x: width * 3, y: 0, width: width, height: imageHeight, imageType: .image4)
        let imageView5 = setImage(x: width * 4, y: 0, width: width, height: imageHeight, imageType: .image5)
        scrollView.addSubview(imageView1)
        scrollView.addSubview(imageView2)
        scrollView.addSubview(imageView3)
        scrollView.addSubview(imageView4)
        scrollView.addSubview(imageView5)
    }

    private func setImage(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, imageType: ImageType) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named: imageType.name)
        imageView.image = image
        return imageView
    }

    private func setupButton(button: UIButton, buttonSize: CGFloat, buttonTextType: ButtonTextType, page: Int) {
        button.setTitle(buttonTextType.title, for: .normal)
        button.setTitleColor(UIColor.black.themeColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .white
        button.layer.cornerRadius = buttonSize / 2
        scrollView.addSubview(button)
    }

    private func setupButtonAction() {
        let buttonSize: CGFloat = 50
        button1 = UIButton(frame: CGRect(x: width * 1 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button1, buttonSize: buttonSize, buttonTextType: .next, page: 1)
        button1.addTarget(self, action: #selector(button1DidTapped), for: .touchUpInside)

        button2 = UIButton(frame: CGRect(x: width * 2 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button2, buttonSize: buttonSize, buttonTextType: .next, page: 2)
        button2.addTarget(self, action: #selector(button2DidTapped), for: .touchUpInside)

        button3 = UIButton(frame: CGRect(x: width * 3 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button3, buttonSize: buttonSize, buttonTextType: .next, page: 3)
        button3.addTarget(self, action: #selector(button3DidTapped), for: .touchUpInside)

        button4 = UIButton(frame: CGRect(x: width * 4 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button4, buttonSize: buttonSize, buttonTextType: .next, page: 4)
        button4.addTarget(self, action: #selector(button4DidTapped), for: .touchUpInside)

        button5 = UIButton(frame: CGRect(x: width * 5 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button5, buttonSize: buttonSize, buttonTextType: .close, page: 5)
        button5.addTarget(self, action: #selector(button5DidTapped), for: .touchUpInside)
    }

    @objc
    func button1DidTapped() {
        scrollToPage(page: 1)
    }

    @objc
    func button2DidTapped() {
        scrollToPage(page: 2)
    }

    @objc
    func button3DidTapped() {
        scrollToPage(page: 3)
    }

    @objc
    func button4DidTapped() {
        scrollToPage(page: 4)
    }

    @objc
    func button5DidTapped() {
        dismiss(animated: true)
    }

    private func scrollToPage(page: Int) {
        var frame: CGRect = self.scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
    }
}

extension HowToUseToBuyListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
