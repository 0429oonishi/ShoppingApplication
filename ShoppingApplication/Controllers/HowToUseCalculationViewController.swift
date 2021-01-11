
import UIKit

class HowToUseCalculationViewController: UIViewController {
    
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
        let imageView1 = setImage(x: width*0, y: 0, width: width, height: imageHeight, image: "HowToUseCalculationImage1")
        let imageView2 = setImage(x: width*1, y: 0, width: width, height: imageHeight, image: "HowToUseCalculationImage2")
        let imageView3 = setImage(x: width*2, y: 0, width: width, height: imageHeight, image: "HowToUseCalculationImage3")
        let imageView4 = setImage(x: width*3, y: 0, width: width, height: imageHeight, image: "HowToUseCalculationImage4")
        let imageView5 = setImage(x: width*4, y: 0, width: width, height: imageHeight, image: "HowToUseCalculationImage5")
        scrollView.addSubview(imageView1)
        scrollView.addSubview(imageView2)
        scrollView.addSubview(imageView3)
        scrollView.addSubview(imageView4)
        scrollView.addSubview(imageView5)
    }
    
    private func setImage(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named:  image)
        imageView.image = image
        return imageView
    }
    
    private func setupButton(_ button: UIButton, _ buttonSize: CGFloat, _ buttonTitle: String, _ page: Int) {
        button.setTitle(buttonTitle, for: .normal)
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
        setupButton(button1, CGFloat(buttonSize), "次へ", 1)
        button1.addTarget(self, action: #selector(tappedNextButton1), for: .touchUpInside)
        
        button2 = UIButton(frame: CGRect(x: width*2 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button2, CGFloat(buttonSize), "次へ", 1)
        button2.addTarget(self, action: #selector(tappedNextButton2), for: .touchUpInside)
        
        button3 = UIButton(frame: CGRect(x: width*3 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button3, CGFloat(buttonSize), "次へ", 1)
        button3.addTarget(self, action: #selector(tappedNextButton3), for: .touchUpInside)
        
        button4 = UIButton(frame: CGRect(x: width*4 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button4, CGFloat(buttonSize), "次へ", 1)
        button4.addTarget(self, action: #selector(tappedNextButton4), for: .touchUpInside)
        
        button5 = UIButton(frame: CGRect(x: width*5 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button5, CGFloat(buttonSize), "閉じる", 1)
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


