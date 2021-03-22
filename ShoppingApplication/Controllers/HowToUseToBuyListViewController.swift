
import UIKit

final class HowToUseToBuyListViewController: UIViewController {
    private enum ImageType {
        case firstPageImage
        case secondPageImage
        case thirdPageImage
        case fourthPageImage
        case fifthPageImage
        var name: String {
            switch self {
            case .firstPageImage: return "HowToUseToBuyListImage1"
            case .secondPageImage: return "HowToUseToBuyListImage2"
            case .thirdPageImage: return "HowToUseToBuyListImage3"
            case .fourthPageImage: return "HowToUseToBuyListImage4"
            case .fifthPageImage: return "HowToUseToBuyListImage5"
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
    private var firstPageNextButton: UIButton!
    private var secondPageNextButton: UIButton!
    private var thirdPageNextButton: UIButton!
    private var fourthPageNextButton: UIButton!
    private var fifthPageCloseButton: UIButton!
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
        pageControl.currentPageIndicatorTintColor = UIColor.black.themeColor
        self.view.addSubview(pageControl)
    }
    
    private func setupImage() {
        var imageHeight: CGFloat = 0
        if height > 800 {
            imageHeight = height - 130
        } else {
            imageHeight = height
        }
        let imageView1 = setImage(x: width*0, y: 0, width: width, height: imageHeight, imageType: .firstPageImage)
        let imageView2 = setImage(x: width*1, y: 0, width: width, height: imageHeight, imageType: .secondPageImage)
        let imageView3 = setImage(x: width*2, y: 0, width: width, height: imageHeight, imageType: .thirdPageImage)
        let imageView4 = setImage(x: width*3, y: 0, width: width, height: imageHeight, imageType: .fifthPageImage)
        let imageView5 = setImage(x: width*4, y: 0, width: width, height: imageHeight, imageType: .fifthPageImage)
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
        button.layer.cornerRadius = buttonSize/2
        scrollView.addSubview(button)
    }
    
    private func setupButtonAction() {
        let buttonSize: CGFloat = 50
        firstPageNextButton = UIButton(frame: CGRect(x: width*1 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: firstPageNextButton, buttonSize: buttonSize, buttonTextType: .next, page: 1)
        firstPageNextButton.addTarget(self, action: #selector(firstPageNextButtonDidTapped), for: .touchUpInside)
        
        secondPageNextButton = UIButton(frame: CGRect(x: width*2 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: secondPageNextButton, buttonSize: buttonSize, buttonTextType: .next, page: 2)
        secondPageNextButton.addTarget(self, action: #selector(secondPageNextButtonDidTapped), for: .touchUpInside)
        
        thirdPageNextButton = UIButton(frame: CGRect(x: width*3 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: thirdPageNextButton, buttonSize: buttonSize, buttonTextType: .next, page: 3)
        thirdPageNextButton.addTarget(self, action: #selector(thirdPageNextButtonDidTapped), for: .touchUpInside)
        
        fourthPageNextButton = UIButton(frame: CGRect(x: width*4 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: fourthPageNextButton, buttonSize: buttonSize, buttonTextType: .next, page: 4)
        fourthPageNextButton.addTarget(self, action: #selector(fourthPageNextButtonDidTapped), for: .touchUpInside)
        
        fifthPageCloseButton = UIButton(frame: CGRect(x: width*5 - 80, y: 30, width: buttonSize, height: buttonSize))
        setupButton(button: fifthPageCloseButton, buttonSize: buttonSize, buttonTextType: .close, page: 5)
        fifthPageCloseButton.addTarget(self, action: #selector(fifthPageNextButtonDidTapped), for: .touchUpInside)
    }

    @objc func firstPageNextButtonDidTapped() {
        scrollToPage(page: 1)
    }
    
    @objc func secondPageNextButtonDidTapped() {
        scrollToPage(page: 2)
    }
    
    @objc func thirdPageNextButtonDidTapped() {
        scrollToPage(page: 3)
    }
    
    @objc func fourthPageNextButtonDidTapped() {
        scrollToPage(page: 4)
    }
    
    @objc func fifthPageNextButtonDidTapped() {
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


