
import UIKit

//themeColorを共通化

final class HowToUseCalculationViewController: UIViewController {
    private enum ImageType {
        case image1
        case image2
        case image3
        case image4
        case image5
        var name: String {
            switch self {
            case .image1: return "HowToUseCalculationImage1"
            case .image2: return "HowToUseCalculationImage2"
            case .image3: return "HowToUseCalculationImage3"
            case .image4: return "HowToUseCalculationImage4"
            case .image5: return "HowToUseCalculationImage5"
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
    private var themeColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .black
        }
        return UIColor(code: themeColorString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupImage()
        setupPageControl()
        setupButtonAction()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.minY, width: width, height: height))
        scrollView.contentSize = CGSize(width: width*pageSize, height: height)
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
        pageControl.currentPageIndicatorTintColor = themeColor
        self.view.addSubview(pageControl)
    }
    
    private func setupImage() {
        var imageHeight: CGFloat = 0
        if height > 800 {
            imageHeight = height - 130
        }else {
            imageHeight = height
        }
        let imageView1 = setImage(x: width*0, y: 0, width: width, height: imageHeight, imageType: .image1)
        let imageView2 = setImage(x: width*1, y: 0, width: width, height: imageHeight, imageType: .image2)
        let imageView3 = setImage(x: width*2, y: 0, width: width, height: imageHeight, imageType: .image3)
        let imageView4 = setImage(x: width*3, y: 0, width: width, height: imageHeight, imageType: .image4)
        let imageView5 = setImage(x: width*4, y: 0, width: width, height: imageHeight, imageType: .image5)
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
        button.setTitleColor(themeColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .white
        button.layer.cornerRadius = buttonSize/2
        scrollView.addSubview(button)
    }
    
    private func setupButtonAction() {
        let buttonSize: CGFloat = 50
        button1 = UIButton(frame: CGRect(x: width*1 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button1, buttonSize: buttonSize, buttonTextType: .next, page: 1)
        button1.addTarget(self, action: #selector(tappedNextButton1), for: .touchUpInside)
        
        button2 = UIButton(frame: CGRect(x: width*2 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button2, buttonSize: buttonSize, buttonTextType: .next, page: 2)
        button2.addTarget(self, action: #selector(tappedNextButton2), for: .touchUpInside)
        
        button3 = UIButton(frame: CGRect(x: width*3 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button3, buttonSize: buttonSize, buttonTextType: .next, page: 3)
        button3.addTarget(self, action: #selector(tappedNextButton3), for: .touchUpInside)
        
        button4 = UIButton(frame: CGRect(x: width*4 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button4, buttonSize: buttonSize, buttonTextType: .next, page: 4)
        button4.addTarget(self, action: #selector(tappedNextButton4), for: .touchUpInside)
        
        button5 = UIButton(frame: CGRect(x: width*5 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: button5, buttonSize: buttonSize, buttonTextType: .close, page: 5)
        button5.addTarget(self, action: #selector(tappedNextButton5), for: .touchUpInside)
    }

    @objc func tappedNextButton1() {
        scrollToPage(page: 1)
    }
    
    @objc func tappedNextButton2() {
        scrollToPage(page: 2)
    }
    
    @objc func tappedNextButton3() {
        scrollToPage(page: 3)
    }
    
    @objc func tappedNextButton4() {
        scrollToPage(page: 4)
    }
    
    @objc func tappedNextButton5() {
        dismiss(animated: true)
    }
    
    private func scrollToPage(page: Int) {
        var frame: CGRect = self.scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
    }
}

extension HowToUseCalculationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
